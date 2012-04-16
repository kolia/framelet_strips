function [RF,Count] = make_rf_strips(spikes,source,folder,BinSize,N_bins)

add1 = @(r,a,t,tt) r + a ;
res = zeros(N_bins,200) ;

[RF,Count] = FoldStimStripsSteps(spikes,source,folder,add1,res,BinSize,N_bins) ;

RF = RF/sum(Count) ;

end