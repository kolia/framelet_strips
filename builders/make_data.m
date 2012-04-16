function data = make_data(type,past_type,varargin)

data.data = [] ;
data.reference_data = [] ;

data.spikes          = varargin{1}.spikes          ;
data.reference_times = varargin{1}.reference_times ;

switch past_type
    case 'stim'
        N = 1 ;
    otherwise
        N = length(varargin) ;
end

for i=1:N
    data.dimensions{i}  = size(varargin{i}.data,2) ;
    data.data           = [data.data            make_(type,varargin{i}.data)           ] ;
    data.reference_data = [data.reference_data  make_(type,varargin{i}.reference_data) ] ;
end

end


function data = make_(type,data)

N = size(data,1) ;
fifth = ceil((N-10)/5) ;

switch type
    case 'train'
        data = data(1:2*fifth,:) ;
    case 'valid'
        data = data(2*fifth+5:3*fifth,:) ;
    case 'test'
        data = data(3*fifth+5:end,:) ;
    otherwise
        fprintf('\nERROR make_data expects first arg ''type'' to be ''train'', ''valid'' or ''test''!')
end
end