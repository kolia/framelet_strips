function plot_index = make_plot_framelet_scores(filename , framelet_scores)

close all

scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)/4 scrsz(3)/1.3 scrsz(4)/2])

thresh = sqrt(framelet_scores.run{end}.threshold) ;

hold on
plot(framelet_scores.run{end}.scores(:,2) , framelet_scores.run{end}.scores(:,3) , 'r.' , 'MarkerSize',2)
plot(0,0,'g.')
rectangle('Position',[-thresh,-thresh,2*thresh,2*thresh],'Curvature',[1,1],'FaceColor','g') ;
hold off

title('Transformed 1st and 2nd order moments of wavelet coefficients','FontSize',26)
h = gca ;
set(h,'FontSize',24)
% set(h,'DataAspectRatio',[1 2 1])
set(h,'PlotBoxAspectRatio',[2.88 1 1])
legend(h,'Informative coeffs','Non-informative coeffs','Location','North')
xlabel('Renormalized mean   (all units in std. deviations)','FontSize',24)
ylabel('Transformed mean square','FontSize',24)


prepare_plot_pdf(filename)
saveas(gcf,filename)

plot_index{1}.filename = filename ;

end