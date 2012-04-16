function predictions = make_model_prediction(model , dkl , framelet_repeat_data , firing_rate)

% Expecting first model dimensions to be [1], the STA.

global indentation

predictions.range = framelet_repeat_data.range ;

data_proj = framelet_repeat_data.data * model.params ;

[m,mi] = max( cell2mat(dkl.dkl(2:end)) ) ;
inds = [1 mi] ;

fprintf('\n%sCalculating predictions of 2 models: ',indentation)
for j=1:2
    i = inds(j) ;
    dims = model.dimensions{i} ;
    predictions.dimensions{j} = dims ;
    predictions.values{j} = firing_rate * exp(model.log_ratio( model , data_proj(:,dims) , i )) ;
    fprintf(' *')
end

end