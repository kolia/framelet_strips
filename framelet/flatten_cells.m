function res = flatten_cells(x)

n = fold_cell(x,0,@acc_size) ;

r{1} = zeros(n,1) ;
r{2} = 1 ;
r = fold_cell(x,r,@acc) ;
res = r{1} ;

%===============================
function res = acc_flat(x,r)

res = [r ; reshape(x,[],1)] ;


%===============================
function r = acc(x,r)

n = r{2} + prod(size(x)) ;
r{1}(r{2}:(n-1),1) = reshape(x,[],1) ;
r{2} = n ;

%===============================
function r = acc_size(x,r)

r =  r + prod(size(x)) ;