function framelet_data = fix_framelet_data(framelet_data,StimulusSource,RecordsFolder,BinSize,varargin)

if ~isfield(framelet_data , 'sp')
    framelet_data.sp.data = ...
        make_framelet_data_sp(framelet_data.spikes,StimulusSource,RecordsFolder,BinSize) ;
    framelet_data.sp.reference = ...
        make_framelet_data_sp(framelet_data.reference_times,StimulusSource,RecordsFolder,BinSize) ;
end

end