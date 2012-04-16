function [positive_score,negative_score] = gauss_score(data,refdata)

C = cov(data)^(-1) ;
m = mean(data,1) ;
Cref = cov(refdata)^(-1) ;
mref = mean(refdata,1) ;

positive_score = score(data,m,C,mref,Cref) ;
negative_score = score(refdata,m,C,mref,Cref) ;

%==============================
function S = score(data,m,C,mref,Cref)

n = size(data,1) ;
mdata = data - repmat(m,[n 1]) ;
mrefdata = data - repmat(mref,[n 1]) ;
S = zeros(n,1) ;
for i=1:n
    S(i) = mdata(i,:)*C*mdata(i,:)' - mrefdata(i,:)*Cref*mrefdata(i,:)' ;
end

S = -0.5*( S - log(det(C)) + log(det(Cref)) )./log(2) ;