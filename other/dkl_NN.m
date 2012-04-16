function surp = dkl_NN(data , ref_data , bandwidth)

if nargin<3
    bandwidth = 'rot' ;
end

kde_ref  = kde( ref_data' , bandwidth) ;

if ~iscell(data)
    surp = surpNN_one( data , kde_ref , bandwidth) ;
else
    surp = cell(size(data)) ;
    for i=1:size(data,1)
        for j=1:size(data,2)
            surp{i,j} = surpNN_one( data{i,j} , kde_ref , bandwidth) ;
        end
    end
end

end

function surp = surpNN_one( data , kde_ref , bandwidth)

kde_data = kde( data' , bandwidth) ;
[N,D] = size(data) ;
M = getNpts(kde_ref) ;

[neighbors, data_dist] = knn(kde_data , data' ,2) ;
[neighbors,  ref_dist] = knn(kde_ref  , data' ,1) ;

inds = ref_dist>0 & data_dist>0 ;  % logarithms are nicer when they're finite.
data_dist = data_dist(inds) ;
ref_dist  = ref_dist(inds) ;

surp = (D*mean(log(ref_dist./data_dist)) + log(M/(N-1)))/log(2) ;

end