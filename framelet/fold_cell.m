function r = fold_cell(x,r,f)

if iscell(x)
    for i=1:length(x)
        r = fold_cell(x{i},r,f) ;
    end
else
    r = f(x,r) ;
end  