function framelet_moments_reference = ...
    make_framelet_moments_reference(GoodCells,StimulusSource,RecordsFolder,BinSize,RUNS)

if nargin<5
    RUNS = 1:6 ;
end

framelet_moments_reference.BinSize = BinSize ;
framelet_moments_reference.N_bins  = 128  ;

horiz = 50:177 ;

for r=RUNS
    mintime = Inf ; maxtime = 0 ;
    for c=1:length(GoodCells)
        mintime = min(mintime,min(GoodCells(c).strips.random.run(r).sp)) ;
        maxtime = max(mintime,max(GoodCells(c).strips.random.run(r).sp)) ;
    end
    times = ceil(mintime:(maxtime-mintime)/(20000-1):maxtime) ;
    % Calculate mean square framelet coeffs over window.
    [mean_square,c] = ...
        mean_sq_ddwt(times,horiz,StimulusSource,RecordsFolder,BinSize,framelet_moments_reference.N_bins) ;
    framelet_moments_reference.run(r).mean_square = mean_square ;
    framelet_moments_reference.run(r).N = sum(c) ;
end

end