function model = make_model_NL_kde(data , model , kde_bandwidth)

global indentation

if nargin<3
    kde_bandwidth = 'rot' ;    % 'local' is slower but better
end

n = length(model.dimensions) ;

fprintf('\n%sCalculating %d KDEs: ',indentation,n)
for i=1:n
    model.kde{i}.data      = kde((data.data*model.params(:,model.dimensions{i}))'           , kde_bandwidth) ;
    model.kde{i}.reference = kde((data.reference_data*model.params(:,model.dimensions{i}))' , kde_bandwidth) ;
    fprintf(' ~')
end

model.density.data  = @density_data ; % @(m,r,i) evaluate( m.kde{i}.data      , r' )' ;
model.density.ref   = @density_ref  ; % @(m,r,i) evaluate( m.kde{i}.reference , r' )' ;

model.log_ratio     = @kde_log_ratio ;

end

function log_ratio = kde_log_ratio(m,r,i)

log_ratio = log( m.density.data(m,r,i) ./ m.density.ref(m,r,i) ) ;

end

function d = density_data(m,r,i)

d = eval_kde( m.kde{i}.data      , r ) ;

end

function d = density_ref(m,r,i)

d = eval_kde( m.kde{i}.reference , r ) ;

end