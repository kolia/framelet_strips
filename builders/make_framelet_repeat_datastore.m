function framelet_datastore = make_framelet_repeat_datastore(all_framelet_score , StimulusSource , RecordsFolder , range , BinSize)

ijs  = flattened_cell_inds(dd_dwt(zeros(128,128))) ;  % Addresses of framelets
N_wavelets = size(ijs,1) ;
framelet_index = zeros(N_wavelets,1) ;

[N_cells , N_runs] = size(all_framelet_score) ;
for c=1:N_cells
    for r=1:N_runs
        if isa(all_framelet_score{c,r},'struct') && isfield(all_framelet_score{c,r},'framelet_score')
            framelet_index(all_framelet_score{c,r}.framelet_score.inds) = 1 ;
            spatial_domain = all_framelet_score{c,r}.framelet_score.spatial_domain ;
        end
    end
end
ijs  = ijs(framelet_index>0,:) ;

framelet_datastore.inds  = find(framelet_index>0) ;
framelet_datastore.range = range ;
times = range(1) + (0:range(2):range(3)) ;

framelet_datastore.data = zeros(length(times),length(framelet_datastore.inds)) ;
for i=0:floor(length(times)/1000)
    inds = (1:1000)+i*1000 ;
    inds = inds(inds<=length(times)) ;
    t = times(inds) ;
    framelet_datastore.data(inds,:) = ...
        make_framelet_coef_data(t,ijs,spatial_domain,StimulusSource,RecordsFolder,BinSize) ;

end