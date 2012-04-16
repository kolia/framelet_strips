function framelet_scores = make_framelet_scores(framelet_moments_reference,framelet_moments,RUNS,run_thresh)
% framelet_scores = make_framelet_scores(framelet_moments,framelet_moments_refrence,[RUNS,run_thresh])
%
% DESCRIPTION:
%   Find framelet coefficients which are significantly different at spike
%   times than at reference times, according to their first and second
%   order statistics.
%
% INPUT:
%   RUNS    Structure with cell spike times and framelet moments:
%               RUNS.run(r).sp      list of spike times for run r.
%               RUNS.run(r).rf      average        framelet coefficients.
%               RUNS.run(r).w2      average square framelet coefficients.
%   refRUN  Structure with framelet second moment at reference times:
%               refRUNS.w2          average square framelet coefficients.
%   run_thresh (optional) number of runs for which a framelet must be above
%                                   threshold to be deemed significant.
%
% OUTPUT:
%   framelet_scores.inds    indices   of framelets deemed significant.
%                  .ijs     addresses of framelets deemed significant.
%                  .run{r}.scores(:,1)  framelet index
%                  .run{r}.scores(:,2)  renormalized deviation in mean
%                  .run{r}.scores(:,3)  renormalized deviation in mean square
%                  .run{r}.scores(:,4)  total score (sum of squares of 2 & 3)

if nargin<4 , run_thresh = 3   ; end
if nargin<3 , RUNS       = 1:6 ; end

zero_framelet = dd_dwt(zeros(128,128)) ;
N_framelets  = length(flatten_cells(zero_framelet)) ; % Total number of wavelets
framelet_scores.run = cell(max(RUNS),1) ;
N_runs_above_threshold = zeros(N_framelets,1) ;

for r = RUNS
    W = flatten_cells(framelet_moments_reference.run(r).mean_square) ;  % Vector of reference mean squares
    N = framelet_moments.run(r).N ;      % Number of spikes to calculate moments
    M = flatten_cells(dd_dwt(framelet_moments.run(r).mean)) ;  % Framelet transform of STA
    V = flatten_cells(framelet_moments.run(r).mean_square)  ;  % Vector of spike time mean squares

    R = [(1:length(V))'  sqrt(N)*M./sqrt(W)  (sqrt(2*N*V./W)-sqrt(2*N-1))] ;
    score = R(:,2).^2 + (R(:,3)).^2 ;   % SCORE of significance (~chi2 distrib)

    framelet_scores.run{r}.scores = sortrows([R score],-4) ;
    framelet_scores.run{r}.threshold =  icdf('chi2',1 - 1./(100*N_framelets),2) ;
    N_above_thresh = sum( score > framelet_scores.run{r}.threshold ) ;
    
    framelet_scores.run{r}.scores = framelet_scores.run{r}.scores(1:N_above_thresh,:) ;

    for i=framelet_scores.run{r}.scores(:,1)
        N_runs_above_threshold(i) = N_runs_above_threshold(i) + 1 ;
    end
end

framelet_scores.N_runs_above_threshold = N_runs_above_threshold ;

IJS  = flattened_cell_inds(zero_framelet) ;  % Addresses of framelets
framelet_scores.inds = find(N_runs_above_threshold >= run_thresh) ;
framelet_scores.ijs  = IJS(framelet_scores.inds,:) ;
framelet_scores.spatial_domain = 50:177 ;

end