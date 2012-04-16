function res = ddwt_components(indz,coeffs,si)

if size(si) > 0
    w = dd_dwt(zeros(si(1),si(2))) ;
else
    w = dd_dwt(zeros(128,128)) ;
end

for i=1:size(indz,1)
    inds = squeeze(indz(i,:)) ;
    if iscell(w{inds(1)}{inds(2)})
        [n,m] = size(w{inds(1)}{inds(2)}{inds(3)}) ;
        if length(inds) == 5
            w{inds(1)}{inds(2)}{inds(3)}{inds(4)}(inds(5)) = coeffs(i) ;
        elseif length(inds) == 4
            w{inds(1)}{inds(2)}{inds(3)}(inds(4)) = coeffs(i) ;
        else
            w{inds(1)}{inds(2)}{inds(3)}(n/2,m/2) = 1 ;
        end
    else
        [n,m] = size(w{inds(1)}{inds(2)}) ;
        if length(inds)>3
            w{inds(1)}{inds(2)}(inds(3)) = coeffs(i) ;
        else
            w{inds(1)}{inds(2)}(n/2,m/2) = 1 ;
        end
    end
end
    
res{1} = reconst_ddwt(w) ;
% m = min(min(find(sum(abs(res{1}),1)>0.001)),min(find(sum(abs(res{1}),2)>0.001))) ;
% M = max(max(find(sum(abs(res{1}),1)>0.001)),max(find(sum(abs(res{1}),2)>0.001))) ;
% res{2} = res{1}(m:M,m:M) ;