function psth_spikes = make_psth_spikes(GoodCells,CellNum,RunNum,RecordStart,type)
% Calculate Brenner info  < r log r >
% using the nearest-neighbors estimator

sp = [] ;
psth_spikes.repeats = cell(20,1) ;
for r=1:20
    new_sp = GoodCells(CellNum).strips.repeats.run((RunNum-1)*20+r).sp - RecordStart((RunNum-1)*60+r) ;
    if strcmp(type,'jitter')
        new_sp = new_sp+rand(size(new_sp)) ;  % add randomness on the scale of timestep.
    end
    sp = [sp ; new_sp'] ;
    psth_spikes.repeats{r} = new_sp ;
end

psth_spikes.sp = sp ;
psth_spikes.N_runs = 20 ;

end