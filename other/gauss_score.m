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

S = 0.5*( log(det(C)) - log(det(Cref)) - mdata*C*mdata' + mrefdata*Cref*mrefdata' ) ./ log(2) ;