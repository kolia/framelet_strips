function model = make_model_dkl_exp_polynomial(data,model,order)

global indentation

model.order = order ;

data_proj = data.data*model.params ;
ref_proj  = data.reference_data*model.params ;

n = length(model.dimensions) ;

fprintf('\n%sCalculating %d GAUS discriminators: ',indentation,n)
for i=1:n
    data_dim       = data_proj(:,model.dimensions{i}) ;
    reference_data =  ref_proj(:,model.dimensions{i}) ;
    model.NL_params{i} = fit_NL_params(data_dim,reference_data,order) ;
    fprintf(' #')
end

model.log_ratio = @exp_log_ratio ;

end

function NL_params = fit_NL_params(data,ref,order)

data_poly = polynomial_features(data,order) ;
ref_poly  = polynomial_features(ref ,order) ;

param = (mean(data_poly)-mean(ref_poly))' ;

NL_params = fit_dual( @dual_exp , data_poly , ref_poly , param , 0.00001) ;

end

function log_ratio = exp_log_ratio(m,r,i)

log_ratio = polynomial_features(r,m.order) * m.NL_params{i} ;

end