function raw_data = make_raw_data(GoodCells,CellNum,RunNum,StimulusSource,RecordsFolder,BinSize,start,Nbins,spatial)

raw_data.spikes = GoodCells(CellNum).strips.random.run(RunNum).sp  ;
raw_data.data = make_raw(raw_data.spikes,StimulusSource,RecordsFolder,BinSize,start,Nbins,spatial) ;

mintime = min(raw_data.spikes)+10000*rand ;
maxtime = max(raw_data.spikes)-10000*rand ;
raw_data.reference_times =  ceil(mintime:(maxtime-mintime)/(20000-10*rand):maxtime) ;
raw_data.reference_data = make_raw(raw_data.reference_times,StimulusSource,RecordsFolder,BinSize,start,Nbins,spatial) ;

raw_data.CellNum = CellNum ;
raw_data.RunNum  = RunNum  ;

end

function res = make_raw(times,StimulusSource,RecordsFolder,BinSize,start,Nbins,spatial)

n = spatial(end)-spatial(1)+1 ;
m = length(times) ;

fff = @(r,a,t) ff(r,a,spatial) ;

r{1} = zeros(m,n*Nbins) ;
r{2} = 1 ;
r = FoldStimStripsSteps(times,StimulusSource,RecordsFolder,fff,r,BinSize,Nbins,start) ;

res = r{1}(1:r{2}-1,:) ;

end


function r = ff(r,a,horiz)

r{1}(r{2},:) = reshape(a(:,horiz),[],1) ;
r{2} = r{2} + 1 ;

end