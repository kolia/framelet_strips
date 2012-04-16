function res = foldi_cells(x,r,f)

res = aux(x,r,f,[]) ;

%================================
function r = aux(x,r,f,inds)

if iscell(x) 
    for i=1:length(x)
        r = aux(x{i},r,f,[inds i]) ;
    end
else
    r = f(inds,x,r) ;
end