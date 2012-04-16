function plot_index = make_plot_raster_psth(filename , predictions , psth_spikes , CellNum , sigma )

close all

times = predictions.range(1) + (0:predictions.range(2):predictions.range(3)) ;

% PSTH smoothing
PSTH = zeros(max(max(times),max(psth_spikes.sp))+predictions.range(2),1) ;
for i=1:length(psth_spikes.sp)
    PSTH(psth_spikes.sp(i)) = PSTH(psth_spikes.sp(i)) + 1 ;
end
PSTH = PSTH*10000/psth_spikes.N_runs ;

sig = ceil(sigma*10) ;

scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)/1.1 scrsz(3)/1.1 scrsz(4)/1.1])
t = [times(1) ; times(:) ; times(end)]/10 ; t = t-t(1) ;
smoothed = window_smooth(PSTH,sig) ;
smoothed = smoothed(times) ;

% raster plot
subplot(3,1,[1 2])
hold on
for r=1:20
    range_spikes = psth_spikes.repeats{r}( psth_spikes.repeats{r}>=times(1)) ;
    range_spikes = range_spikes( range_spikes<=times(end)) ;
    range_spikes = range_spikes - times(1) ;
    N_spikes = length(range_spikes) ;
    plot(range_spikes , r*ones(N_spikes,1) + 0.2*rand(N_spikes,1), 'k.','MarkerSize',15)
end
set(gca,'FontSize',24) ;
set(gca,'XTick',[])
ylim([0.5 20.5])
% set(gca,'Visible','off')
ylabel('repeat','FontSize',24)

% PSTH plot
subplot(3,1,3)
hold on
h = patch(t , [0 ; smoothed ; 0] , 'k') ;

% legend(h , 'PSTH' ,'FontSize',23) ;
set(gca,'FontSize',24) ;
xlabel('ms','FontSize',24) ;
ylabel('spikes / sec','FontSize',24) ;
title(sprintf('Cell %d :  spiking intensity  r(t)',CellNum),'FontSize',28) ;

hold off


saveas(gcf,filename)

prepare_plot_pdf(filename)

plot_index{1}.filename = filename ;

end


function smoothed = window_smooth(x , window_size)

kernel = ones(1,window_size)/window_size ;

smoothed = conv(x,kernel) ;
smoothed = smoothed(ceil(window_size/2)+(1:length(x))) ;

end