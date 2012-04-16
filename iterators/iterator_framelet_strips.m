function data_iterator = iterator_framelet_strips( CellNum , RunNum , bins , SpikeHistoryCells , type , skip)
% SIGNATURE:
% data_iterator = iterator_isi_framelet_strips( CellNum , RunNum , N_isi , SpikeHistoryCells , type , skip)
%
% INPUTS:
% N_isi                 number os ISIs used to chracterize a cell's past
% SpikeHistoryCells     Cells for which spike histories are used
% type                  must be one of the strings: 'train', 'validate' or
%                       'test'
% skip                  controls how many spikes are skipped between train,
%                       validate
%                       and test sets. see code for details
%                       (complicated...) Values used for covariance
%                       analysis were 30, 100 and 300.
%
% OUTPUT:
% data_iterator         structure providing the following services
%   data_iterator.spikes.N
%                       number of spikes in data
%   data_iterator.spikes.history( data_iterator , i )
%                       returns past history at spike i
%   data_iterator.reference.N( data_iterator , desired_N )
%                       returns number of reference points
%                       argument desired_N can be taken into account or
%                       not depending on implementation
%   data_iterator.reference.T( data_iterator , desired_N )
%                       returns length of time window from which reference
%                       points were sampled
%   data_iterator.reference.history( data_iterator , i )
%                       returns past history at reference point i
%   data_iterator.display( data_iterator , params )
%                       plots a representation of the parameters


% fprintf('Cell %d , Run %d   ',CellNum,RunNum)

% load /Users/ksadeghi/Documents/projects/framelet_strips/Data2/wavelet2/data/refcell_old
load /kolia/ENCODING/DATA/strips/GoodCells/GoodCells_JustINDS
inds = GoodCells(CellNum).strips.good_wavelets.inds ;
% Analysis.refinds = find(ismember(refcell.good_wavelets.inds,inds) == 1) ;

N_cells = length(SpikeHistoryCells) ;

if length(bins) < 1
    SpikeHistoryExtractor = @(x,y) [] ;
    all_spike_times = [] ;
else
    SpikeHistoryExtractor = @(all_spike_times , times) BinnedExtractor(bins , all_spike_times , times) ;
    all_spike_times = cell(N_cells,1) ;
    for i=1:N_cells
        all_spike_times{i} = GoodCells(SpikeHistoryCells(i)).strips.random.run(RunNum).sp ;
    end
end

indsort = [inds (1:length(inds))'] ;
indsort = sortrows(indsort,1) ;

% Analysis.good_wavelets  = GoodCells(CellNum).strips.good_wavelets ;
% Analysis.spatial_domain = GoodCells(CellNum).strips.spatial_domain ;

cel = load(sprintf('/kolia/ENCODING/DATA/strips/wavelet_transformed/spike_times/Data_Cell_%d_Run_%d.mat',CellNum,RunNum)) ;
data = cel.data(:,indsort(:,2)) ;
clear cel

spike_times = GoodCells(CellNum).strips.random.run(RunNum).sp ;
data_iterator.info.spike_times = spike_times ;

if length(spike_times) ~= size(data,1)
    fprintf('The number of spike_times should match the number of data points!\nFATAL ERROR')
    return
end
    
if nargin<3
    type = 'train' ;
end

if nargin<4
    skip = 30 ;  % otherwise 100 or 300
end

N = size(data,1) ;


if strcmp(type , 'train')
    refdata = [] ; reftimes = [] ;
    for rrr=1:6
        if rrr ~= RunNum
            load(sprintf('/kolia/ENCODING/DATA/strips/wavelet_transformed/reference_times/Metronome_refcell_%d_Run_%d.mat',CellNum,rrr)) ;
            refdata = [refdata ; refcell.data] ;
            reftimes = [reftimes refcell.times] ;
        end
    end
    refcell.data = refdata ;
    refcell.times = sort(reftimes) ;
%     load(sprintf('/kolia/ENCODING/DATA/strips/wavelet_transformed/reference_times/Metronome_refcell_%d_Run_%d.mat',CellNum,RunNum)) ;
    chosen_data_index = find(mod(1:N,80+20+12+skip)<=80) ;
elseif strcmp(type , 'validate')
    refdata = [] ; reftimes = [] ;
    for rrr=1:6
        if rrr ~= RunNum
            load(sprintf('/kolia/ENCODING/DATA/strips/wavelet_transformed/reference_times/Metronome2_refcell_%d_Run_%d.mat',CellNum,rrr)) ;
            refdata = [refdata ; refcell.data] ;
            reftimes = [reftimes refcell.times] ;
        end
    end
    refcell.data = refdata ;
    refcell.times = sort(reftimes) ;
%     load(sprintf('/kolia/ENCODING/DATA/strips/wavelet_transformed/reference_times/Metronome2_refcell_%d_Run_%d.mat',CellNum,RunNum)) ;
    chosen_data_index = find(mod(1:N,80+20+12+skip)> 80+4 & mod(1:N,80+20+12+skip)<=80+4+20 ) ;
elseif strcmp(type , 'test')
    refdata = [] ; reftimes = [] ;
    for rrr=1:6
        load(sprintf('/kolia/ENCODING/DATA/strips/wavelet_transformed/reference_times/Metronome3_refcell_%d_Run_%d.mat',CellNum,rrr)) ;
        refdata = [refdata ; refcell.data] ;
        reftimes = [reftimes refcell.times] ;
    end
    refcell.data = refdata ;
    refcell.times = sort(reftimes) ;
    %     load(sprintf('/kolia/ENCODING/DATA/strips/wavelet_transformed/reference_times/Metronome3_refcell_%d_Run_%d.mat',CellNum,RunNum)) ;
    chosen_data_index = find(mod(1:N,80+20+12+skip)> 80+4+20+4 & mod(1:N,80+20+12+skip)<=80+4+20+4+skip ) ;
else
    fprintf('third argument to iterator_framelet_strips must be either ''train'', ''validate'' or ''test''!')
end
spike_times = spike_times(chosen_data_index) ;
data = data(chosen_data_index,:) ;

data_iterator.reference = refcell ;
data_iterator.reference.data = data_iterator.reference.data(:,indsort(:,2)) ;

% size_ref_times = size(data_iterator.reference.times)
% size_ref_data = size(data_iterator.reference.data)

reference_histories = SpikeHistoryExtractor(all_spike_times , data_iterator.reference.times) ;

data_iterator.reference.data = [data_iterator.reference.data  reference_histories] ;
clear refcell

spike_histories = SpikeHistoryExtractor(all_spike_times,spike_times) ;
data_iterator.spikes.data = [data spike_histories] ;

% fprintf('\nSpike History size')
% size(spike_histories)

data_iterator.info.N_cells = N_cells ;
data_iterator.info.spike_history_dimension = size(spike_histories,2) ;
data_iterator.info.used_spike_index = chosen_data_index ;
data_iterator.info.CellNum = CellNum ;
data_iterator.info.RunNum  = RunNum  ;
data_iterator.info.cell_info = GoodCells(CellNum).info ;
data_iterator.info.goodwavelets = GoodCells(CellNum).strips.good_wavelets ;
data_iterator.info.goodwavelets.indsort = indsort ;
data_iterator.info.spatial_domain = GoodCells(CellNum).strips.spatial_domain ;
data_iterator.spikes.N = size(data,1) ;
data_iterator.spikes.history = @(iterator , i) iterator_history( iterator.spikes.data , i ) ;


data_iterator.reference.N    = @(iterator , desired_N) size(iterator.reference.data,1)    ;
data_iterator.reference.T    = @(iterator , desired_N) (max(iterator.reference.times) - min(iterator.reference.times))/10000 ;
data_iterator.reference.history = @(iterator, i) iterator_history( iterator.reference.data , i ) ;
data_iterator.display = @(iterator , params) plot_linear_filter(iterator , params) ;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = iterator_history( data , i )
if nargin>1
    result = data(i,:) ;
else
    result = data ;
end
end