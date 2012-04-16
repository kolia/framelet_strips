function model = make_model_dSTA(data , framelet_score)

wavelet_STA = mean(data.data)' ;
STA  = ddwt_components(framelet_score.ijs,wavelet_STA,[]) ;
STA = STA{1} ;

model.params = zeros(size(wavelet_STA,1),2) ;
model.params(:,1) = wavelet_STA ;

negative = zeros(128,128) ;
positive = 10*STA ;
negative(2:end,:) = 10*STA(1:end-1,:) ;
model.params(:,2) = make_wavelet_coeffs(positive - negative , framelet_score.ijs) ;
reconstructed = ddwt_components(framelet_score.ijs,model.params(:,2),[]) ;
model.angle = subspace( reconstructed{1}(:) , positive(:) - negative(:)) ;
end


function rr = make_wavelet_coeffs(a,ijs)

w = dd_dwt(a) ;
n = size(ijs,1) ;
rr= zeros(1,n) ;
for i=1:n
    if ijs(i,4) > 0
        rr(i) = w{ijs(i,1)}{ijs(i,2)}{ijs(i,3)}(ijs(i,4)) ;
    elseif ijs(i,3)>0
        rr(i) = w{ijs(i,1)}{ijs(i,2)}(ijs(i,3)) ;
    else
        rr(i) = w{ijs(i,1)}(ijs(i,2)) ;
    end
end

end