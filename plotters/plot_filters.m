function h_cell = plot_filters(filters , framelet_score)

N_filters = size(filters,2) ;
h_cell = cell(N_filters,1) ;

for i=1:N_filters
    FILT = ddwt_components(framelet_score.ijs,filters(:,i),[]) ;
    
    if i<2
        space = crop(FILT{1},1,0.05) ; space = space(1):space(2) ;
        time  = crop(FILT{1},2,0.05) ; time  = 1:time(2) ;
    end
    F = 100*FILT{1}(time,space) ;  % x 100 !!!
    if i<2
        [maxfilt,xindy] = max( abs( F ) ,[],2) ;
        [maxfilt,xindx] = max( abs( F( time' + (xindy-1)*time(end) ) ) ) ;
        xindy = xindy(xindx) ;
        maxindx = xindx*4 ;
        maxindy = xindy*0.022 ;
        
        STAtimecourse   = F( :  , xindy ) ;
        STAspaceprofile = F( xindx , : ) ;
    end
    
        timecourse   = F( :  , xindy ) ;
        spaceprofile = F( xindx , : ) ;
    
    figure
    
    %
    subplot(10,10,[34:39 44:49 54:59 64:69 74:79 84:89 94:99]) ;
    
    % KEEP THIS , comment out other %s
    hold on    
    myimage( [space(1) space(end)]*0.022, [1 time(end)*4] , F ) ;
    clim = get(gca,'Clim') ; cmap = colormap ;
    plot(space*0.022        , maxindx*ones(length(space),1) ,'k-.','LineWidth',2)
    plot((space(1)+xindy-1)*0.022*ones(length(time),1), time*4 ,'k-.','LineWidth',2)
    xlim([space(1) space(end)]*0.022)
    ylim([1 time(end)]*4)
    set(gca,'Visible','off','YDir','reverse')
    hold off

    %
    subplot(10,10,[14:19 24:29]) ;
    hold on
    plot(space*0.022 , spaceprofile , 'LineWidth',2 ) ;
    plot(space*0.022 , 0*space*0.022 )
    hold off
    xlim([space(1) space(end)]*0.022)
    ylimit = max(10.5,1.05*max(abs(spaceprofile))) ;
    ylimit = ylimit*[-1 1] ;
    ylim(ylimit)
    set(gca,'YTick',fix(ylimit))
    xlabel('space (mm)','FontSize',24)
    set(gca,'FontSize',22,'XAxisLocation','top','YAxisLocation','right')
    
    %
    subplot(10,10,[32 33 42 43 52 53 62 63 72 73 82 83 92 93]) ;
    hold on
    plot(  timecourse , time*4    , 'LineWidth',2 ) ;
    plot(0*timecourse , time*4 )
    hold off
    ylim([1 time(end)*4])
    xlimit = max(10.5,1.05*max(abs(timecourse))) ;
    xlimit = xlimit*[-1 1] ;
    xlim(xlimit)
    set(gca,'XTick',fix(xlimit))
    set(gca,'XDir','reverse')
    ylabel('time (ms)','FontSize',24)
    set(gca,'FontSize',22,'YDir','reverse')
    
    %
    subplot(10,10,[40 50 60 70 80 90 100]) ;
    set(gca,'Visible','off') ;
    set(gca,'Clim',clim) ; colormap(cmap) ;
    colorbar('FontSize',22,'location','West') ;
    
    
    subplot(10,10,[1:3 11:13 21:23])
    set(gca,'Visible','off')
    if i<2
        text(0,0.7,'STA','FontSize',34)
    else
        text(0,0.9,'COV','FontSize',34)
        text(-0.06,0.4,sprintf('Filter %d',i-1) , 'FontSize',30)
    end
    
    h_cell{i} = gcf ;
end

end

function inds = crop(filter,dim,tol)

x = sum(abs(filter),dim) ;
x = x ./ max(x) ;
x = find(x>tol) ;
inds = [min(x) max(x)] ;

end

% function h = plot_filt(spatial_domain , FILT)
% 
% h = RF_myimage(spatial_domain, FILT ) ;
%         
% XTick = 5:5:50 ;
% YTick = 5:5:24 ;
% set(gca,'YTick',YTick)
% set(gca,'XTick',XTick)
% 
% XTickLabel = ['5' sprintf('|%d',10:5:50)] ;
% YTickLabel = ['50' sprintf('|%d',10*(10:5:24))] ;
% set(gca,'YTickLabel',YTickLabel)
% set(gca,'XTickLabel',XTickLabel)
% 
% ah = gca ;
% set(ah,'FontSize',34)
% colorbar('FontSize',34) ;
% xlabel('space (\mum)','FontSize',36)
% ylabel('time (ms)','FontSize',36)
% 
% end