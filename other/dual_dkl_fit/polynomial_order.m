function new_p = polynomial_order(p,D,n)

p = p(:)' ;

N = length(p) ;
L = length(polynomial_features(1:D,n)) ;

if N>=L
    new_p = p(1:L) ;
else
    new_p = zeros(L,1) ;
    new_p(1:N) = p ;
end

end