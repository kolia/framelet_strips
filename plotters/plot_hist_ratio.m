function plot_hist_ratio(data,ref)

m = min([data(:) ; ref(:)]) ;
M = max([data(:) ; ref(:)]) ;
bin_centers = m:(M-m)/30:M ;
n    = hist(data , bin_centers); n    = n(:)/sum(n) ;
nref = hist(ref , bin_centers) ; nref = nref(:)/sum(nref) ;

maxval = max([n(:) ; nref(:)]) ;

ratio = n ./ nref ;
ratio = ratio*maxval/max(ratio(isfinite(ratio))) ;

hold on
plot(bin_centers , n     , 'LineWidth',2 , 'Color' , 'b')
plot(bin_centers , nref  , 'LineWidth',2 , 'Color' , 'g')
plot(bin_centers , ratio , 'LineWidth',2 , 'Color' , 'r')

legend({'data' 'reference' 'ratio'},'Location','NorthWest')

left   = bin_centers(min([find(n>0.001) ; find(nref>0.005)])) ;
right  = bin_centers(max([find(n>0.005) ; find(nref>0.005)])) ;
margin = (right-left)/10 ;
xlim( [left-margin right+margin] )
ylim( [0 maxval] )

end