function plot_kde_ratio(data,ref,log_ratio)

m = min([data(:) ; ref(:)]) ;
M = max([data(:) ; ref(:)]) ;
bin_centers = m:(M-m)/30:M ;
n    = hist(data , bin_centers); n    = n(:)/sum(n) ;
nref = hist(ref , bin_centers) ; nref = nref(:)/sum(nref) ;

maxval = max([n(:) ; nref(:)]) ;

ratio = log_ratio(bin_centers) ;
% ratio = ratio*maxval/max(ratio(isfinite(ratio))) ;

maxratio = min(20,max(ratio)) ;

n    = n .* maxratio ./ maxval ;
nref = nref .* maxratio ./ maxval ;

hold on

x  = [ bin_centers(1) bin_centers bin_centers(end) ] ;
y1 = [ -1 ; n    ;  -1 ] ;
y2 = [ -1 ; nref ;  -1 ] ;

P1.x = x ;
P1.y = y1 ;
P2.x = x ;
P2.y = y2 ;
P3 = PolygonClip(P1,P2,1) ;
x3 = P3.x ;
y3 = P3.y ;

h2 = patch(x , y2 , [0 0 1]) ;
h1 = patch(x , y1 , [1 0 0],'EdgeColor',[1 0 0]) ;
patch(x3 , y3 , [0.5 0 0.5]) ;
% plot(x,y2,'Color',[0 0 1],'Linewidth',2)
% plot(x,y1,'Color',[0 1 0],'Linewidth',2)
% patch([bin_centers bin_centers(1)] , [min(n,nref) ; min(n(1),nref(1))] , [0 0.5 0.5]) ;

h3 = plot(bin_centers , ratio , 'LineWidth',2 , 'Color' , 'k') ; %, 'Parent',ax2) ;

set(gca,'FontSize',26)
set(gca,'YAxisLocation','right')
ylim([0 maxratio*1.05])
legend([h1 h2 h3],{'spike times' 'random times' 'ratio'},'Location','NorthWest','FontSize',24)
% title('Projection along filter','FontSize',36)
xlabel('projection along filter','FontSize',32)
ylabel('probability ratio','FontSize',32)

left   = bin_centers(min([find(n>0.001) ; find(nref>0.005)])) ;
right  = bin_centers(max([find(n>0.005) ; find(nref>0.005)])) ;
margin = (right-left)/10 ;
xlim( [left-margin right+margin] )

end