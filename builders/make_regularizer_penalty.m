function regularizer = make_regularizer_penalty( PastType , powers , CellNums , N_isi , timestep , timesteps )


switch PastType
    case 'stim_isi'
        
        N_powers = length(powers) ;
        M = repmat( 1:timestep:timesteps*timestep , N_powers , 1 ) ;
        M = exp(-diag(1./powers)*M)' ;

        N_spike_hist = N_powers * length(CellNums) * N_isi ;
        regularizer  = @(params,alphas) penalty_L12(params(1:end-1),N_powers,N_spike_hist,M,alphas) ;
    otherwise
        regularizer  = @(params,alphas) penalty_L2_stim(params(1:end-1),alphas) ;
end

end


function [p,dp] = penalty_L12(param,N_powers,N_spike_hist,M,alphas)

isi_params = reshape( param(end-N_spike_hist+1:end) , N_powers , [] ) ;

temp  = sqrt(1e-09 + sum((( M * isi_params ).^2),1)) ;

pL1   = real(sum(temp)) ;

dpL1  = real( (M' * M * isi_params ) ./ repmat(temp , size( isi_params , 1 ) , 1 )) ;

% dpL1  = reshape(dpL1,N_powers,[])' ;

stim_params = param(1:end-N_spike_hist) ;

[pL2 , dpL2] = penalty_L2_stim( stim_params , 1) ;

p  = alphas(:)' * [pL2 ; pL1] ;

dp = [ alphas(1)*dpL2 ; alphas(2)*dpL1(:) ] ;

% fprintf('\n%f ',p)

end

function [p,dp] = penalty_L2_stim(params,alpha)

p  = alpha * real(sum(params .^ 2)) ;
dp = 2 * alpha * params ;
% fprintf('\n%f ',p)

end