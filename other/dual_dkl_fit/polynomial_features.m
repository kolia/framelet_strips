function [y,index,uniq,uniD] = polynomial_features(x,n)
% function y = polynomial_features(x,n)
%
% DESCRIPTION:
%   For data x, where each of N rows is one data point of dimension D,
%   returns N-by-L matrix, where L is large, of monomials 1, x_i , 
%   x_i*x_j , x_i*x_j*x_k , ... etc, up to degree n.
%   Care is taken to avoid duplicate monomials, as would arise with a naive
%   algorithm.

%   Trick: use first D prime numbers to as tags of each dimension, to
%   calculate the unicity of each monomial.

[N,D] = size(x) ;

if n < 1
    y    = ones(N,1) ;
    uniD = primes(D^2+10) ;
    uniD = uniD(1:D) ;
    uniq = uniD(1) ;
    index = 1 ;
else
    [y,old_index,uniq,uniD]  = polynomial_features(x , n-1) ;
    L = length(uniq) ;
    uniq = kron(uniD,uniq) ;
    [uniq,index] = unique(uniq) ;
    yn = zeros(N,D*L) ;
    y1 = y(:,end-L+1:end) ;
    for i=1:D
        yn(:,1+(i-1)*L:i*L) = y1.*repmat(x(:,i),1,L) ;
    end
    yn = yn(:,index) ;
    y = [y yn] ;
end

end