function timecourse = make_center_timecourse(model_STA , framelet_score)

FILT = ddwt_components(framelet_score.ijs,model_STA.params,[]) ;
FILT = - FILT{1} ;   % INVERTING SIGN !!!

space = crop(FILT) ;

if length(space)>1
    timecourse = mean( FILT(:,space(1):space(2)) , 2 ) ;
else
    timecourse = FILT(:,space) ;
end

end


function inds = crop(filter)

m = max(abs(filter(:))) ;
ind = find(abs(filter) == m) ;
ind = ind(1) ;
m = filter(ind) ;
x = sum(m*filter,1) ;
x = x ./ max(x) ;
inds = find(x == 1) ;
inds = inds(1) ;

end