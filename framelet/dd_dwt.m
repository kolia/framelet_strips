function w = dd_dwt(x)


if prod(size(x)) > 0
    [Faf, Fsf] = FSdoubledualfilt;
    [af, sf] = doubledualfilt;
    J = 5;
    w = doubledualtree_f2D(x,J,Faf,af);
else
    w = x ;
end

%[af,sf]=filters1;
%w = double_f2D(x,5,af);