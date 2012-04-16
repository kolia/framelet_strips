load('/Users/kolia/Salamander/091106/DATA/first_strips_frametimes.mat')

load('/Users/kolia/Salamander/091106/DATA/first_strips_raster21.mat')

start_times  = [1 42688 193297 308136 420797 Inf] ;

DoubleFrames = [186375 186378 186381] ;

BitFileName  = '/Users/kolia/Salamander/091106/DATA/binarysource1000Mbits' ;

GoodCells    = find(Tagged) ;
Nsamples     = 128 ;
Npixels      = 200 ;
SuperSample  = 5 ;

% T = get_frame_interval(diff(StimTimes)) ;  % Time interval between frames.
STAs = cell(4,26) ;

for s=[2 4]
    for c=GoodCells
        fprintf('cell %d  run %d\n',c,s)
        
        rast      =  SpikeTimes{c} ;
        rast      =  rast( peak_times( start_times(s) ) < rast & rast < peak_times( start_times(s+1) ) ) ;
        StimTimes =  peak_times( start_times(s) : 2 : start_times(s+1)-1 ) ;
        
        STAs{s,c}.N   = 0 ;
        STAs{s,c}.STA = zeros(Nsamples,Npixels) ;
        STAs{s,c} = fold_stimulus(STAs{s,c},@get_STA,rast,StimTimes,Nsamples,SuperSample,Npixels,BitFileName) ;

        STA = STAs{s,c} ;
        
        save(sprintf('/Users/kolia/Salamander/091106/results/STA%d_cell%d',s,c),'STA')

%         h = myimage([0 199]*0.022,[1 6*128],(STAs{4,c}.STA+STAs{2,c}.STA)/(STAs{4,c}.N+STAs{2,c}.N) - 0.5) ;
        h = myimage([0 199]*0.022,[1 6*128],STAs{2,c}.STA/STAs{2,c}.N - 0.5) ;
        colorbar ;
        title(sprintf('Cell %d',c),'FontSize',26) ;
        set(gca,'FontSize',24) ;
        xlabel('mm','FontSize',24) ;
        ylabel('ms','FontSize',24) ;
        saveas(h,sprintf('~/Salamander/091106/plots/STA_cell%d',c),'png') ;
        
%         [RFs,NbSpk] = STAk({rast},StimTimes,5,1,[200 1],BitFileName) ;
    end
end


for s=[2 4]
    for c=GoodCells
        h = myimage([0 199]*0.022,[1 6*128],(STAs{4,c}.STA+STAs{2,c}.STA)/(STAs{4,c}.N+STAs{2,c}.N) - 0.5) ;
        colorbar ;
        title(sprintf('Cell %d',c),'FontSize',26) ;
        set(gca,'FontSize',24) ;
        xlabel('mm','FontSize',24) ;
        ylabel('ms','FontSize',24) ;
        saveas(h,sprintf('~/Salamander/091106/plots/STA_cell%d',c),'png') ;
        
    end
end