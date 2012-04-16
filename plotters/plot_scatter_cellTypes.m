function plot_scatter_cellTypes(x,y,cellTypes,type)

if nargin<3
    type = 'scatter' ;
end

inds = intersect(find(abs(x)>0),find(abs(y)>0)) ;
xxx = x(inds) ;
yyy = y(inds) ;

M = max([xxx ; yyy]) ;

xmin = min(0,min(xxx)) ;
ymin = min(0,min(yyy)) ;

m = min(xmin,ymin) ;

figure('Position',[1 500 600 500])

hold on

types = fieldnames(cellTypes) ;
legends = cell(length(types),1) ;
for i=1:length(types)
    xx = x( cellTypes.(types{i}).cells , : , : ) ;
    yy = y( cellTypes.(types{i}).cells , : , : ) ;

    inds = intersect(find(abs(xx)>0),find(abs(yy)>0)) ;
    xx = xx(inds) ; xx = xx(:) ;
    yy = yy(inds) ; yy = yy(:) ;

    plot(xx,yy,'.','MarkerEdgeColor',cellTypes.(types{i}).color,'MarkerFaceColor',cellTypes.(types{i}).color,'MarkerSize',18) ;
    legends{i} = cellTypes.(types{i}).legend ;
end

if strcmp(type,'comparison')
    plot([m M],[m M],'LineWidth',2)
end
xlim([xmin max(xxx)])
ylim([ymin max(yyy)])
% title('Information in bits','FontSize',36)

legend(legends , 'FontSize',20,'Location','NorthEastOutside')

set(gca,'FontSize',30)
hold off

end