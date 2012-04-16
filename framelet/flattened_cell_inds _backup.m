function res = flattened_cell_inds(w)

res = foldi_cells(w,[],@f) ;


%============================
function res = f(inds,x,r)

n = prod(size(x)) ;
m = length(inds) + 1 ;
rr = zeros(n,4) ;
for i=1:length(inds)
    for j=1:n
        rr(j,i) = inds(i) ;
    end
end
for i=1:n
    rr(i,m) = i ;
end

res = [r ; rr] ;