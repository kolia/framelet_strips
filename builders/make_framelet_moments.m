function framelet_moments = make_framelet_moments(GoodCells,CellNum,StimulusSource,RecordsFolder,BinSize,RUNS)

if nargin<6
    RUNS = 1:6 ;
end

framelet_moments.BinSize = BinSize ;
framelet_moments.N_bins  = 128  ;

for RunNum=RUNS
    
    spikes = GoodCells(CellNum).strips.random.run(RunNum).sp ;
    
    % Calculate STA.
    [rf,crf] = make_rf_strips(spikes,StimulusSource,RecordsFolder,BinSize,framelet_moments.N_bins) ;
    framelet_moments.run(RunNum).mean_full_width = rf ;
    
    % Use STA to calculate good spatial window of size 128.
    framelet_moments.horiz = 50:177 ;
    framelet_moments.run(RunNum).mean = framelet_moments.run(RunNum).mean_full_width(:,framelet_moments.horiz) ;
    framelet_moments.run(RunNum).N = sum(crf) ;
    
    % Calculate mean square framelet coeffs over window.
    [mean_square,c] = mean_sq_ddwt(spikes,framelet_moments.horiz,StimulusSource,RecordsFolder,BinSize,framelet_moments.N_bins) ;
    framelet_moments.run(RunNum).mean_square = mean_square ;
    framelet_moments.run(RunNum).N_mean_square = sum(c) ;
end 
end