function model = make_model_COV_hint( train , valid , hint_model )
% SIGNATURE:
% Analysis = make_model_COV( train_data , valid_data , hint )
%
% DESCRIPTION: covariance analysis on data , projecting ou hint

hints = hint_model.params ;
model.hints = 1:size(hints,2) ;

train_spike = project_out( train.data           , hints ) ;
train_ref   = project_out( train.reference_data , hints ) ;
valid_spike = project_out( valid.data           , hints ) ;
valid_ref   = project_out( valid.reference_data , hints ) ;

[params,dkl]  = covar_( train_spike , train_ref , valid_spike , valid_ref , hints) ;

model.dkl_1D = dkl ;
model.params = [hint_model.params params] ;

end

function [params,dkl] = covar_( train_data , train_refdata , validate_data , validate_refdata , hints)

para = [15 30] ;
    
[coeff,D,cov,covref] = pca(train_data,train_refdata) ;

A.PCA.coeff = coeff ;
A.PCA.D = diag(D) ;
A.PCA.cov = cov ;
A.PCA.covref = covref ;

n = size(D,1) ;
if n>sum(para)
    FilterNums = [1:para(1) n-para(2)+1:n] ;
else
    FilterNums = 1:size(D,1) ;
end
A.PCA.FilterNums = FilterNums ;
coeff = zeros(size(coeff,1),length(FilterNums)) ;
dkl = zeros(length(FilterNums),1) ;
for i = 1:length(FilterNums)
    FilterNum = FilterNums(i) ;
    
    filter = project_out( A.PCA.coeff(:,FilterNum)' , hints )' ;
%     filter = A.PCA.coeff(:,FilterNum)  -  kron(hint' , A.PCA.coeff(:,FilterNum)' * hint)' ;
    coeff(:,i) = filter ;
    
    proj_data     = validate_data    * filter ;
    proj_ref_data = validate_refdata * filter ;

%     A.PCA.gauss_score(i) = mean(gauss_score(proj_data , proj_ref_data)) ;
    gs = gauss_score(proj_data , proj_ref_data) ;
    dkl(i) = mean(gs(:)) ;
%     dkl(i) = dkl_NN(proj_data , proj_ref_data , 'rot') ;
end

N_good_filters = length(find(dkl > 0.02)) ;

temp = [dkl (1:length(dkl))'] ;
temp = sortrows(temp , -1) ;

% temp(1:N_good_filters,:)'

params = real(coeff(:,temp(1:N_good_filters,2))) ;

end


function x  = project_out(x , hints)

for i=1:size(hints,2)     % project out hints
    hint = hints(:,i) ;
    hint = hint ./ norm(hint) ; hint = hint(:) ;
    x = x - kron(hint' , x*hint) ;
end

end
