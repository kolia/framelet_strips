function framelet_data = make_framelet_data(GoodCells,CellNum,RunNum,framelet_scores,StimulusSource,RecordsFolder,BinSize)

framelet_data = framelet_scores ;

framelet_data.spikes = GoodCells(CellNum).strips.random.run(RunNum).sp  ;
framelet_data.data  = make_framelet_coef_data(framelet_data.spikes,framelet_data.ijs,framelet_data.spatial_domain,StimulusSource,RecordsFolder,BinSize) ;

mintime = min(framelet_data.spikes)+10000*rand ;
maxtime = max(framelet_data.spikes)-10000*rand ;
framelet_data.reference_times =  ceil(mintime:(maxtime-mintime)/(20000-10*rand):maxtime) ;
framelet_data.reference_data  = make_framelet_coef_data(framelet_data.reference_times,framelet_data.ijs,framelet_data.spatial_domain,StimulusSource,RecordsFolder,BinSize) ;

framelet_data.CellNum = CellNum ;
framelet_data.RunNum  = RunNum ;

end