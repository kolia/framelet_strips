function [sqw,c] = mean_sq_ddwt(times,horiz,source,folder,BinSize,N_bins)

sqw = dd_dwt(zeros(128,128));

add_sq = @(r,w) r + w.^2;
add2 = @(r,a,t) fold_cells(r,dd_dwt(a(:,horiz)),add_sq) ;
[sqw,c] = FoldStimStripsSteps(times,source,folder,add2,sqw,BinSize,N_bins) ;

scal = @(r,w) r/sum(c) ;
sqw = fold_cells(sqw,sqw,scal) ;

end