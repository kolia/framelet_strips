function [coeff,D,COVDATA,COVREF] = pca(data,ref)

COVDATA = cov(data) ;
COVREF  = cov(ref ) ;

dcov = COVDATA - COVREF ;

% used to normalize each dimension by its variance.
SD = sqrt(diag((COVDATA+COVREF)/2))+eps ; 

% for numerical stability, ignore dimensions with tiny variance.
G = find(SD>0.000001) ;


[coeff_G,D] = eig(dcov(G,G)./(SD(G)*SD(G)'),'nobalance') ;

coeff = zeros(size(data,2),length(G)) ;
coeff(G,:) = coeff_G ;