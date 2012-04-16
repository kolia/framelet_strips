function [params , data_1D , ref_1D] = fit_dual(dual_func , data , ref , initial_params , tolfun)

if nargin<3
    initial_params = (mean(data)-mean(ref))' ;
end

if nargin<4
    tolfun = 0.00001 ;
end

% tic
opt = optimset('Display','off','TolFun',tolfun ,'GradObj','on', 'Hessian','on','MaxIter',10000,'MaxFunEvals',1000*size(data,2)) ;  % ,'DerivativeCheck','on') ;
params = fminunc(@(a) dual_func(a,data,ref) , initial_params , opt) ;
% clear old_a
% toc

if nargout>1
    data_1D = data * params ;
    ref_1D  = ref  * params ;
end

end