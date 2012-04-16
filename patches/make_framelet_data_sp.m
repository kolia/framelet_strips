function sp = make_framelet_data_sp(times,StimulusSource,RecordsFolder,BinSize)

fff = @(r,a,t) r ;
[r,counts] = FoldStimStripsSteps(times,StimulusSource,RecordsFolder,fff,[],BinSize,128) ;
sp.times = times(counts>0) ;
sp.counts = counts ;

end