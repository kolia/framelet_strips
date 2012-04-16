function density = eval_kde(kde , at , varargin)

N = size(at,1) ;
density = zeros(N,1) ;
M = 50 ;
for i=1:ceil(N/M)
    range = (i-1)*M+(1:M) ;
    range = range(range<=N) ;
    density(range) = evaluate(kde , at(range,:)' , varargin) ;
end

end