function model = make_model_dimensions( model , dimensions , hint_mode )

if isfield(model,'hints') && ~( nargin>2 && strcmp(hint_mode,'no hint') )
    dimensions = add_hint_indices(model.hints , dimensions) ;
end

N = size(model.params,2) ;
model.dimensions = {} ;
n = 0 ;
for i=1:length(dimensions)
    if max(dimensions{i}) <= N
        n = n+1 ;
        model.dimensions{n} = dimensions{i} ;
    end
end

end