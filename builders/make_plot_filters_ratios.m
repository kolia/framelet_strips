function plot_index = make_plot_filters_ratios( filename , model , framelet_score , data , dkls , PastType , powers )

Positions.StimulusFilter            = [0.26 0.52  0.6   0.38 ] ;
Positions.StimulusFilterColorbar    = [0.88 0.52  0.03  0.38 ] ;
Positions.SpaceComponent            = [0.26 0.36  0.6   0.07 ] ;
Positions.TemporalComponent         = [0.03 0.52  0.12  0.38 ] ;
Positions.ProjectionDensity         = [0.13 0.099 0.5   0.2  ] ;
Positions.ProjectionDensityLegend   = [0.71 0.13  0.2   0.15 ] ;
Positions.figure = [100 100 660 800] ;

if strcmp( PastType , 'stim_isi' ) && nargin>6
    data.powers = powers ;
%     fields = fieldnames(Positions) ;
%     for i=1:length(fields)
%             Positions.(fields{i})(4) = Positions.(fields{i})(4) * 8/11 ;
%             Positions.(fields{i})(2) = Positions.(fields{i})(2) * 8/11 ;
%     end
    Positions.StimulusFilter            = [0.26 0.42  0.6   0.28 ] ;
    Positions.StimulusFilterColorbar    = [0.88 0.42  0.03  0.28 ] ;
    Positions.SpaceComponent            = [0.26 0.26  0.6   0.07 ] ;
    Positions.TemporalComponent         = [0.03 0.42  0.12  0.28 ] ;
    Positions.ProjectionDensity         = [0.13 0.099 0.5   0.14 ] ;
    Positions.ProjectionDensityLegend   = [0.71 0.09   0.2  0.15 ] ;
    Positions.figure = [100 100 660 1100] ;
    Positions.ISI_filters = [0.26 0.74 0.65 0.1] ;
end

Positions.BoundingBox = [0.01 0.01  0.98 1] ;
Positions.TitleSTA = [0.2  0.95] ;
Positions.TitleCOV = [0.1  0.95] ;
Positions.TitleDKL = [0.5  0.95] ;

plot_index = plot_filters_ratios( filename , model , framelet_score , data , dkls , Positions ) ;

end


function plot_index = plot_filters_ratios( filename , model , framelet_score , data , dkls , Positions )

N_filters = length(dkls.dkl) ;

if length(data.dimensions)>1
    N            = data.dimensions{1} ;
    N_spike_hist = data.dimensions{2} ;
    isi_filters = make_isi_powers_filters(data.powers , model.params(N+1:N+N_spike_hist,:),10,100) ;
    stim_params = model.params(1:N,:) ;
else
    stim_params = model.params ;
end

for i=1:N_filters
    close all
    FILT = ddwt_components(framelet_score.ijs,stim_params(:,i),[]) ;

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
    end
    
        timecourse   = F( :  , xindy ) ;
        spaceprofile = F( xindx , : ) ;
    
    figure('Position',Positions.figure)
    
    % BOUNDING BOX
    axes('Position',Positions.BoundingBox,'Visible','off') ;
%     rectangle('LineWidth',2)
    text(0,0,'.','FontSize',0.01)

    
    % TITLE
    if i<2
        if size(data.data,2) == size(model.params,1)-1  % GLM case
            text(Positions.TitleSTA(1),Positions.TitleSTA(2),sprintf('GLM'),'FontSize',38)
        else
            text(Positions.TitleSTA(1),Positions.TitleSTA(2),sprintf('STA'),'FontSize',38)
        end
    else
        text(Positions.TitleCOV(1),Positions.TitleCOV(2),sprintf('COV Filter %d',i-1),'FontSize',38)
    end
    text(Positions.TitleDKL(1),Positions.TitleDKL(2),sprintf('     %.2f   bits/spike',dkls.dkl{i}),...
            'FontSize',28,'FontAngle','italic')
%     if length(data.dimensions)>1
%         text(0.35,0.89,'Spike History filters','FontSize',24)
%     end

    
    % Deal with GLM case
    if size(data.data,2) == size(model.params,1)-1
        model.params = model.params(1:end-1,:) ;
%         data.data = [data.data ones(size(data.data,1),1)] ;
%         data.reference_data = [data.reference_data ones(size(data.reference_data,1),1)] ;
        model.log_ratio = @(m,r,i)r ;
        isGLM = 1 ;
    else
        isGLM = 0 ;
    end

    
    % STIMULUS FILTER
    axes('Position',Positions.StimulusFilter,'Visible','off','YDir','reverse')
    hold on
    myimage( [space(1) space(end)]*0.022, [1 time(end)*4] , F ) ;
    clim = get(gca,'Clim') ; cmap = colormap ;
    plot(space*0.022        , maxindx*ones(length(space),1) ,'k-.','LineWidth',2)
    plot((space(1)+xindy-1)*0.022*ones(length(time),1), time*4 ,'k-.','LineWidth',2)
    xlim([space(1) space(end)]*0.022)
    ylim([1 time(end)]*4)
    hold off
    
    % COLORBAR
    colormap(cmap) ;
    colorbar('FontSize',22,'Clim',clim,'Position',Positions.StimulusFilterColorbar) ;

    % SPACE
    axes('Position',Positions.SpaceComponent,'FontSize',23,'XAxisLocation','top')
    hold on
    plot(space*0.022 , spaceprofile , 'LineWidth',2 ) ;
    plot(space*0.022 , 0*space*0.022 )
    hold off
    xlim([space(1) space(end)]*0.022)
    ylimit = 1.05*max(abs(spaceprofile)) ;
    ylim(ylimit*[-1 1])
    ylimtick = get_plot_tick(ylimit) ;
    set(gca,'YTick',ylimtick*[-1 1])
    
    xlabel('space (mm)','FontSize',23)
    set(gca,'FontSize',23)
    
    % TIME
    axes('Position',Positions.TemporalComponent,'FontSize',23,...
         'YDir','reverse','XDir','reverse','YAxisLocation','right')
    hold on
    time = time/100 ;
    plot(  timecourse , time*4    , 'LineWidth',2 ) ;
    plot(0*timecourse , time*4 )
    hold off
    ylim([0 time(end)*4])
    xlimit = 1.05*max(abs(timecourse)) ;
    xlim(xlimit*[-1 1])
    xlimtick = get_plot_tick(xlimit) ;
    set(gca,'XTick',xlimtick*[-1 1])
    ylabel('time (1/10th sec)','FontSize',23)
       
    % DENSITY RATIO
    d = data.data*model.params(:,i) ;
    r = data.reference_data*model.params(:,i) ;

    axes('Position',Positions.ProjectionDensity,'FontSize',23)
    h = plot_ratio(d,r, @(x)exp(model.log_ratio(model,x(:),i))) ;
    xlabel('projection along filter','FontSize',23)
    if isGLM
    ylabel('nonlinearity','FontSize',23)
    legend([h{1} h{2} h{3}],{'spike times' 'random times' 'nonlinearity'},'Position',...
                Positions.ProjectionDensityLegend,'FontSize',20)
    else        
    ylabel('prob. ratio','FontSize',23)
    legend([h{1} h{2} h{3}],{'spike times' 'random times' 'ratio'},'Position',...
                Positions.ProjectionDensityLegend,'FontSize',20)
    end

    % SPIKE HISTORY FILTERS
    if length(data.dimensions)>1
        axes('Position',Positions.ISI_filters,'FontSize',22)
        plot( squeeze( isi_filters(:,i,:) ) , 'LineWidth' , 2 ) ;
        set(gca,'FontSize',20,'XAxisLocation','top')
        xlabel('time (ms)','FontSize',22)
        ylabel({'spike' 'history' 'filters'})
        mm = min(isi_filters(:)) ;
        MM = max(isi_filters(:)) ;
%         margin = (MM-mm)*1.01 ;
        ylim([mm MM])
        
%         hold on
%         ColorOrder = get(gca,'ColorOrder') ;
%         for c=1:size(isi_filters,2)
%             if c == CellNum , LineSize = 10 ; else LineSize = 4 ; end
%             CO = ColorOrder(mod(c-1,7)+1,:) ;
%             h = plot( support/10 , spike_filters(:,c) , 'LineWidth',LineSize) ;
%             set(h,'Color',CO)
%         end
%         set(gca,'FontSize',36)
%         xlabel('time since last spike (ms)','FontSize',36)

    end
    
    % SAVE and RETURN
    this_filename = sprintf('%s_%d',filename,i) ;
    
    prepare_plot_pdf(this_filename)
    saveas(gcf,this_filename)
    
    plot_index.plot{i,1}.filename = this_filename ;
    plot_index.plot{i,1}.filename_suffix = sprintf('_%d',i) ;
    plot_index.plot{i,1}.filter_i = i ;
end

end


function h = plot_ratio(data,ref,log_ratio)

m = min([data(:) ; ref(:)]) ;
M = max([data(:) ; ref(:)]) ;
bin_centers = m:(M-m)/30:M ;
n    = hist(data , bin_centers); n    = n(:)/sum(n) ;
nref = hist(ref , bin_centers) ; nref = nref(:)/sum(nref) ;

maxval = max([n(:) ; nref(:)]) ;
ratio = log_ratio(bin_centers) ;

maxratio = min(20,max(ratio)) ;

n    = n .* maxratio ./ maxval ;
nref = nref .* maxratio ./ maxval ;

hold on

x  = [ bin_centers(1) bin_centers bin_centers(end) ] ;
y1 = [ -0.01 ; n    ;  -0.01 ] ;
y2 = [ -0.01 ; nref ;  -0.01 ] ;

P1.x = x ;
P1.y = y1 ;
P2.x = x ;
P2.y = y2 ;
P3 = PolygonClip(P1,P2,1) ;
x3 = P3.x ;
y3 = P3.y ;

h{2} = patch(x , y2 , [0 0 1]) ;
h{1} = patch(x , y1 , [1 0 0],'EdgeColor',[1 0 0]) ;
patch(x3 , y3 , [0.5 0 0.5]) ;

h{3} = plot(bin_centers , ratio , 'LineWidth',2 , 'Color' , 'k') ; %, 'Parent',ax2) ;

set(gca,'FontSize',26)
% set(gca,'YAxisLocation','right')
ylim([0 maxratio*1.05])

maxmax = max(max(n),max(nref)) ;

left   = bin_centers(min([find(n/maxmax>0.005) ; find(nref/maxmax>0.005)])) ;
right  = bin_centers(max([find(n/maxmax>0.005) ; find(nref/maxmax>0.005)])) ;
margin = (right-left)/10 ;

xlim( [left-margin right+margin] )

end

function tick = get_plot_tick(x)

x = abs(x) ;
d = floor(log(x)/log(10)) ;
l = max(1 , floor(x/10^d)) ;
tick = l*10^d ;

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