function [x,dx,d2x] = dual_exp(a,data,ref)

% persistent old_a

[N,D] = size(data) ;
% M = size(ref ,1) ;

gQ = exp(ref*a) ;
inds = gQ<1e10 ;
gQ = gQ(inds) ;
M = sum(double(inds)) ;
ref = ref(inds,:) ;

s  = sum(data)  ;

x = sum(gQ)/M - s*a/N ;

if ~isfinite(x)
    [N M]
    gQ'
    s
end

if nargout>1
    dx = (ref'*gQ)/M - s'/N ;
end

if nargout>2
    d2x = (ref'*(ref .* repmat(gQ,1,D)))/M ;
end

% if isempty(old_a) || norm(a - old_a)>0.00001
%     old_a = a ;
%     
%     data_1D = data*a ;
%     ref_1D  = ref *a ;
%     
%     dkl_NN   = surpNN( data_1D , ref_1D ) ;
%     dkl_temp = 1-x ;
%     
%     fprintf('\tdkl = %.2f %.2f',dkl_NN , dkl_temp)
% end

end