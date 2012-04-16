function model = fix_model_NL_kde(model,varargin)

model.density.data  = @(m,r,i) evaluate( m.kde{i}.data      , r' )' ;
model.density.ref   = @(m,r,i) evaluate( m.kde{i}.reference , r' )' ;

model.log_ratio     = @kde_log_ratio ;

end

function log_ratio = kde_log_ratio(m,r,i)

log_ratio = log( m.density.data(m,r,i) ./ m.density.ref(m,r,i) ) ;

end