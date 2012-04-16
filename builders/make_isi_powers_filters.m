function filters = make_isi_powers_filters( powers , params , timestep , timesteps )

N_powers = length(powers) ;

M = repmat( 1:timestep:timesteps*timestep , N_powers , 1 ) ;
M = exp(-diag(1./powers)*M)' ;

N_filters = size(params,2) ;

params = reshape( params , N_powers , [] ) ;

filters = M*params ;

filters = reshape( filters , timesteps , N_filters , [] ) ;

end