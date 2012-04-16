function m = get_max(c , inds)

n = length(c(:)) ;
inds = inds(inds<=n) ;
m = max(cell2mat(c(inds))) ;

end