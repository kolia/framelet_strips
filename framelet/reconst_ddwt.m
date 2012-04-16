function im = reconst_ddwt(w)

[Faf, Fsf] = FSdoubledualfilt;
[af, sf] = doubledualfilt;
J = 5;

im = doubledualtree_i2D(w,J,Fsf,sf);