function spike_hist = make_spike_hist( framelet_data , GoodCells , CellNums , RunNum , powers , N_isi )

spike_hist.CellNums = CellNums ;
spike_hist.RunNum = RunNum ;
spike_hist.powers = powers ;
spike_hist.N_isi  = N_isi  ;

spike_hist.sp = framelet_data.spikes ;

N_cells = length(CellNums) ;
all_spike_times = cell(N_cells,1) ;
for i=1:N_cells
    all_spike_times{i} = GoodCells(CellNums(i)).strips.random.run(RunNum).sp ;
end

spike_hist.data           = exps( powers , ISIextractor(all_spike_times , framelet_data.spikes      , N_isi)) ;
spike_hist.reference_data = exps( powers , ISIextractor(all_spike_times , framelet_data.reference_times , N_isi)) ;

end


function res = exps(powers , X)

[N,M] = size(X) ;
K = length(powers) ;
res = zeros( N , M*K ) ;
for i=1:K
    res(:, (i-1)*M + (1:M) ) = exp(-X./powers(i)) ;
end

end