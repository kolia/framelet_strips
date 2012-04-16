function model = make_GLM( filename , regularizer , train_data , valid_data )
% SIGNATURE:
% params = GLMfit( filename , train_data , valid_data , PastType , powers , CellNums , N_isi , timestep , timesteps )
%
% DESCRIPTION: fit Generalized Linear Model prameters to data
%
% INPUTS:
%
% OUTPUTS: model containing params, the estimated GLM parameters

model.log_ratio = @(m,r,i) exp( m.params * [r ones(size(r,1))] ) ;

initial_alpha = 6*ones(1,length(train_data.dimensions)) ;
options = optimset('Display','off', 'LargeScale','off', 'TolX',1e-2, 'MaxFunEval', 10 , ...
                   'MaxIter', 200 , 'TypicalX'  , initial_alpha*8000000 ) ;

reg_filename = sprintf('%s_buffer',filename) ;

train_data = add_data_ones(train_data) ;  % Add ones for offset
valid_data = add_data_ones(valid_data) ;

alpha = fminunc(...
    @(alpha) make_GLM_regularized( reg_filename , train_data , valid_data , regularizer , exp(alpha) ) , ...
    initial_alpha , options ) ;
load(reg_filename)

N = length(model.regularized) ;
valid_LLs = zeros(N,1) ;
for i=1:N
    valid_LLs(i) = model.regularized{i}.valid_LL ;
end
[best_v,best_i] = max(valid_LLs) ;
model = model.regularized{best_i} ;
model.alpha = exp(alpha) ;

end


function best_in_run = make_GLM_regularized( filename , train_data , valid_data , regularizer , alpha )

fprintf('\nstarting GLM optimization for alpha ')
fprintf('%f ',alpha)
fprintf(':\n')
%     checkgrad(FFF, param, 1e-4) ;
%     [param, LL] = minimize(param, FFF , -5000) ;

param = (mean(train_data.data) - mean(train_data.reference_data))' ;
try
    load(filename)
    i = length(model.regularized) + 1 ;
%     param = model.regularized{get_closest_params(model , alpha)}.params ;
%     fprintf('\nloaded %s\n',filename)
catch
    i = 1 ;
    model.best_valid_LL = Inf ;
    fprintf('\ninitializing with STA\n')
end
best_in_run = Inf ;

options = optimset('Display','off','GradObj','on','LargeScale','off', ... %'DerivativeCheck' , 'on' , ...
                    'TolX',1e-7, 'TolFun' , 1e-10 , 'MaxFunEval',  250000, 'MaxIter', 50) ;

for j=i:i+200-1
    param = fminunc( @(params) GLM_likelihood( params , train_data , regularizer , alpha) , param, options ) ;
    valid_LL = GLM_likelihood(param , valid_data , regularizer ,zeros(size(alpha)) ) ;
    if model.best_valid_LL > valid_LL
        model.best_i = j ;
        model.best_valid_LL = valid_LL ;
    end
    if best_in_run > valid_LL
        improved = 1 ;
        best_in_run   = valid_LL ;
        model.regularized{j}.params = param ;
        model.regularized{j}.alpha  = alpha ;
        model.regularized{j}.LL = GLM_likelihood( param , train_data , regularizer , zeros(size(alpha)) ) ;
        model.regularized{j}.penalty = regularizer(param,alpha) ;
        model.regularized{j}.valid_LL = valid_LL ;
        fprintf('Penalty %6.0f   Valid %5.5f   Train %4.2f   Best Valid %5.5f\n',...
            model.regularized{j}.penalty, log(model.regularized{j}.valid_LL),...
            log(model.regularized{j}.LL), log(model.best_valid_LL))
    else
        improved = 0 ;
    end
    dummy_file = [filename '_dummy'] ;
    mkdir(dummy_file)
    try
        rmdir(dummy_file)
    end
    save(filename,'model')
%     fprintf(sprintf('\nsaved %s\n\n',filename))
    if ~improved
        break
    end
end

end


function [L,dL] = GLM_likelihood( params , data , regularizer , alpha)

T = (max(data.reference_times) - min(data.reference_times))/10 ;  % in milliseconds

scores      =      data.data           * params   ;
ref_scores  = exp( data.reference_data * params ) ;
L             = sum(scores) ;
normalization = mean(ref_scores) ;

[p,dp] = regularizer(params,alpha) ;
% p = 0 ; dp = zeros(size(data.data,2)-1,1) ;

L  =  real( normalization*T - L ) + p ;

if nargout>1
    Dnormalization = real( data.reference_data .* repmat( ref_scores , 1 , size(data.reference_data,2) )) ;
    dL             = real( mean(Dnormalization,1)*T - sum(data.data,1) )' + [dp ; 0] ;
end

end


function data = add_data_ones(data)
data.data           = [data.data            ones(size(data.data           , 1) , 1) ] ;
data.reference_data = [data.reference_data  ones(size(data.reference_data , 1) , 1) ] ;
end


function closest_i = get_closest_params(model , alpha)

N = length(model.regularized) ;
alpha_distances = zeros(N,1) ;

for i=1:N
    alpha_distances(i) = norm(model.regularized{i}.alpha - alpha) ;
end
[a , closest_i] = min(alpha_distances) ;

end