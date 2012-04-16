function model = make_model_NL_factorized(model)

dimensions = {} ;
dims = [] ;
for i=1:length(model.dimensions)
    if ~isempty(intersect(model.dimensions{i},dims))
        fprintf('\n\nWARNING: factorized model requires disjoint sets of dimensions!\n\n')
    end
    dims = [dims model.dimensions{i}(:)] ;
    dimensions = [dimensions dims] ;
end

model.factor_dimensions = model.dimensions ;
model.factor_log_ratio = model.log_ratio ;
model.dimensions = dimensions ;

model.log_ratio  = @factorized_log_ratio ;

end

function log_ratio = factorized_log_ratio(m,r,n)

log_ratio = 0 ;
for i=1:n
    dims = m.factor_dimensions{i} ;
    log_ratio = log_ratio + m.factor_log_ratio(m,r(:,dims),i) ;
end

end