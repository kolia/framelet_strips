function rlogr = make_infobound_NN(psth_spikes)

M = psth_spikes.sp(end) ;

range = [-1000 M+1000] ;
ref = rand(500000,1)*diff(range) - range(1) ;

rlogr = dkl_NN( psth_spikes.sp , ref) ;

end