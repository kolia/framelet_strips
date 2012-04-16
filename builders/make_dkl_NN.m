function dkl = make_dkl_NN(data , model , bandwidth)

if nargin<3
    bandwidth = 'rot' ;
end

global indentation

dkl.type = sprintf('Nearest-neighbor based estimate, with %s bandwidth',bandwidth) ;

if isfield(model,'dimensions')
    dkl.dimensions = model.dimensions ;
else
    dkl.dimensions{1} = 1:size(model.params,2) ;
end

% fprintf('\nbefore correction:')
% size(data.data)
% size(data.reference_data)
% size(model.params)

if size(model.params,1) == size(data.data,2)+1       % Add constant (for GLM models)
    data.data           = [data.data            ones(size(data.data),1)           ] ;
    data.reference_data = [data.reference_data  ones(size(data.reference_data),1) ] ;
end

% fprintf('\nafter  correction:')
% size(data.data)
% size(data.reference_data)
% size(model.params)

data_proj = data.data           * model.params ;
ref_proj  = data.reference_data * model.params ;

fprintf('\n%sCalculating %d DKLs: ',indentation,length(dkl.dimensions))
for i=1:length(dkl.dimensions)
    dims = dkl.dimensions{i} ;
    data = data_proj(:,dims) ;
    ref  =  ref_proj(:,dims) ;
    if isfield(model,'log_ratio')
        data = model.log_ratio( model , data , i ) ;
        ref  = model.log_ratio( model , ref  , i ) ;
    end
    dkl.dkl{i} = dkl_NN(data , ref , bandwidth) ;
    fprintf(' *')
end

end