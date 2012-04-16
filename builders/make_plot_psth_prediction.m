function plot_index = make_plot_psth_prediction(filename , predictions , psth_spikes , CellNum , sigma , model_inds)

close all

if nargin<6
    model_inds = 1:length(predictions.values) ;
else
    model_inds = intersect(model_inds , 1:length(predictions.values)) ;
end

times = predictions.range(1) + (0:predictions.range(2):predictions.range(3)) ;

PSTH = zeros(max(max(times),max(psth_spikes.sp))+predictions.range(2),1) ;
for i=1:length(psth_spikes.sp)
    PSTH(psth_spikes.sp(i)) = PSTH(psth_spikes.sp(i)) + 1 ;
end
PSTH = PSTH*10000/psth_spikes.N_runs ;

sig = ceil(sigma*10) ;

scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)/2 scrsz(3)/1.3 scrsz(4)/2])
t = [times(1) ; times(:) ; times(end)]/10 ; t = t-t(1) ;
smoothed = window_smooth(PSTH,sig) ;
smoothed = smoothed(times) ;

hs = zeros(length(model_inds) , 1) ;

hold on
hs(1) = patch(t , [0 ; smoothed ; 0] , 'k') ;

sig = ceil(sigma*10/predictions.range(2)) ;
colors = {'b' 'r' 'g'} ;
for i=1:length(model_inds)
    smoothed = window_smooth(predictions.values{i},sig) ;
%     smoothed = smoothed(times) ;
%     fprintf('\nplotting dimensions:')
%     predictions.dimensions{i}
    if i==1
        hs(i+1) = plot(t , [0 ; smoothed ; 0], 'Color', colors{i},'LineWidth',4) ;
    else
        hs(i+1) = plot(t , [0 ; smoothed ; 0], 'Color', colors{i},'LineStyle','--','LineWidth',4) ;
    end
end

legend(hs , { 'PSTH' ; 'STA model' ; 'COV model'} ,'FontSize',23) ;
set(gca,'FontSize',24) ;
xlabel('ms','FontSize',24) ;
ylabel('spikes / sec','FontSize',24) ;
title(sprintf('Cell %d    PSTH  vs.  model predictions',CellNum),'FontSize',28) ;

hold off


% legend('PSTH','GLM','COV','FontSize',24)

saveas(gcf,filename)

prepare_plot_pdf(filename)

plot_index{1}.dimensions = predictions.dimensions ;
plot_index{1}.filename = filename ;

end


function smoothed = window_smooth(x , window_size)

kernel = ones(1,window_size)/window_size ;

smoothed = conv(x,kernel) ;
smoothed = smoothed(ceil(window_size/2)+(1:length(x))) ;

end