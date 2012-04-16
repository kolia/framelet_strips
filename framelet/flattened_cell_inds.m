function res = flattened_cell_inds(w)

res = foldi_cells(w,[],@f) ;


%============================
function res = f(inds,x,r)

n = numel(x) ;
rr = [repmat(inds(:)',n,1) (1:n)'] ;
if size(rr,2) > size(r,2)
    r = [r zeros(size(r,1),size(rr,2)-size(rr,2))] ;
elseif size(r,2) > size(rr,2)
    rr = [rr zeros(size(rr,1),size(r,2)-size(rr,2))] ;
end
res = [r ; rr] ;