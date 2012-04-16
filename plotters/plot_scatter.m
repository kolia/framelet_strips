function plot_scatter(x,y,type)

if nargin<3
    type = 'scatter' ;
end

inds = intersect(find(abs(x)>0),find(abs(y)>0)) ;
x = x(inds) ; x = x(:) ;
y = y(inds) ; y = y(:) ;

M = max([x ; y]) ;

xmin = min(0,min(x)) ;
ymin = min(0,min(y)) ;

m = min(xmin,ymin) ;

figure('Position',[1 500 600 500])

hold on
plot(x,y,'r.','MarkerSize',18) ;
if strcmp(type,'comparison')
    plot([m M],[m M],'LineWidth',2)
end
xlim([xmin max(x)])
ylim([ymin max(y)])
% title('Information in bits','FontSize',36)
set(gca,'FontSize',30)
hold off

end