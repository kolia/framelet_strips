function model = make_GLM_old( filename , train_data , valid_data , nonlinearity , aleph , initial)
% SIGNATURE:
% params = GLMfit( filename , train_data , valid_data , nonlinearity , reguralization_params , initial_param )
%
% DESCRIPTION: fit Generalized Linear Model prameters to data
%
% INPUTS:
%
% nonlinearity          structure providing the following services
%   nonlinearity.f( x )
%                       returns value of nonlinear function at x
%   nonlinearity.df( x )
%                       returns derivative of nonlinear function at x
%
% OUTPUTS:              params, the estimated GLM parameters

factor = 1.5 ;

model.regularization_param = aleph ;

i = 0 ;
if nargin>5
    use_STA = 0 ;
    if isfield(initial,'regularized')
        fprintf('\ninitializing with previous model...\n')
        i = length(initial.regularized) ;
        param = initial.regularized{i}.params ;
        model = initial ; 
    else
        fprintf('\ninitializing with initial_param...\n')
        param = initial ;
    end
else
    use_STA = 1 ;
end

fprintf('starting GLM optimization:\n')
options = optimset('Display','testing','GradObj','on','LargeScale','off', ...
                    'TolX',1e-8, 'MaxFunEval',  25000000, 'MaxIter', 2000) ;

% Run optimization
while 1
    if i>0
        [alpha,best_i] = test_validation(model,factor) ;
        model.best_i = best_i ;
        if alpha == 0  || i>9
            break
        end
        if model.regularized{i}.penalty > 1e8
            use_STA = 1 ;
            alpha = max(alpha , 0.2) ;
        end
    else
        alpha = 320 ;
    end
    i = i+1 ;

    if use_STA == 1   % Use STA as parameter initialization
        param = zeros(1+length(data_iterator.spikes.history(data_iterator,1)),1) ;
        STA = get_STA(data_iterator) ;
        param(1:length(STA)) = STA ;    % last param is constant offset
    end


    model.regularized{i}.alpha = alpha ;

    regularizer = make_regularizer(data_iterator , L , [alpha aleph]) ;

%     real(param(:)')
%     FFF = @(params) GLM_likelihood( params , data_iterator , nonlinearity , regularizer , alpha) ;
%     checkgrad(FFF, param, 1e-4) ;
%     [param, LL] = minimize(param, FFF , -5000) ;

    fprintf('\nMax Likelihood for Cell %d Run %d with i=%d (alpha = %f)\n\n',...
                data_iterator.info.CellNum,data_iterator.info.RunNum,i,alpha)

    param = real(param) ;
    param = fminunc_kolia(...
        @(params) GLM_likelihood( params , data_iterator , nonlinearity , regularizer , 1) , param, options) ;

    model.regularized{i}.params = param ;

    model.regularized{i}.LL = GLM_likelihood( param , data_iterator , nonlinearity , regularizer , 0 ) ;
    regscore = regularizer(param) ;
    model.regularized{i}.penalty = regscore ;
    model.regularized{i}.valid_LL = GLM_likelihood(param,valid_iterator,nonlinearity) ;
    
    fprintf('\nRegularizer score: %f\nValidation LL: %f\n',regscore,model.regularized{i}.valid_LL)
    
    fprintf(sprintf('\nsaving %s\n\n',filename))
    save(filename,'model')
    
    use_STA = 0 ;

end

end


function STA = get_STA(iterator)

fprintf('\ncalculating STA...\n')

N_spikes = iterator.spikes.N ;
STA = iterator.spikes.history(iterator,1) ;
power = 0 ;
for i=2:N_spikes
    h     = iterator.spikes.history(iterator,i) ;
    STA   = STA   + h ;
    power = power + dot( h , h ) ;
end
STA = STA/power ;
end

function [alpha,best_ind] = test_validation(model,factor)

N = length(model.regularized) ;
valid = zeros(N,2) ;
for i=1:N
    valid(i,1) = model.regularized{i}.valid_LL ;
    valid(i,2) = model.regularized{i}.alpha ;
end

valids = sortrows(valid,1) ;
alpha  = valids(1,2) ;

best_ind = find( valid(:,1) == valids(1,1) ) ;
best_ind = best_ind(1) ;

done = 0 ;

small_alpha = valids(valids(:,2) < valids(1,2) , 2) ;
if ~isempty(small_alpha)
    if small_alpha(1) < alpha/factor
        done = 1 ;
    end
else
    done = 1 ;
end

large_alpha = valids(valids(:,2) > valids(1,2) , 2) ;
if ~isempty(large_alpha)
    if large_alpha(1) > alpha*factor
        done = 2 ;
    end
else
    done = 2 ;
end

switch done
    case 1
        alpha = alpha / factor ;
    case 2
        alpha = alpha * factor ;
    otherwise
        alpha = 0 ;
end

fprintf('Termination status: %d\n\n' , done)

end