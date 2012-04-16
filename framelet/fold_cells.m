function res = fold_cells(x,y,f)

if iscell(x) 
    if iscell(y)
        for i=1:length(x)
            res{i} = fold_cells(x{i},y{i},f) ;
        end
    else
        for i=1:length(x)
            res{i} = fold_cells(x{i},y,f) ;
        end
    end
elseif iscell(y)
    for i=1:length(y)
        res{i} = fold_cells(x,y{i},f) ;
    end
else
    res = f(x,y) ;
end