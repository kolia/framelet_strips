function dkl = make_dkl_mean_log_ratio(data , model)

dkl.type = 'direct mean log ratio' ;
dkl.dimensions = model.dimensions ;
data_proj = data.data*model.params ;

for i=1:length(dkl.dimensions)
    dims = dkl.dimensions{i} ;
    dkl.dkl{i} = mean( ...
        model.log_ratio(model,data_proj(:,dims),i)) ;
end

end