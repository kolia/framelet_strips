function result = gather_cells_runs(R,varargin)

N = length(varargin) ;
[n,m] = size(R) ;

% R
% R{15,5}

result.values = zeros(n,m,N) ;
% inds   = zeros(25,6) ;
for i=1:N
%     varargin{i}
    result.accessors{i} = varargin{i} ;
    for c=n:-1:1
        for r=m:-1:1
            try
%                 R{c,r}
                result.values(c,r,i) = feval(varargin{i},R{c,r}) ;
            end
        end
        %         if prod(double(isfinite(result(c,r,:))))
        %             inds(c,r) = 1 ;
        %         end
    end
end

% result = result(inds,:) ;

end