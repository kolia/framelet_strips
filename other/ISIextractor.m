function isi = ISIextractor( all_spike_times , times , N )

N_cells = length(all_spike_times) ;
N_times = length(times) ;

isi = zeros( N_times , N*N_cells ) ;

for c=1:N_cells
    spike_times = all_spike_times{c} ;
    spike_times = spike_times(:) ;
    for i=N_times:-1:1
        [isis , spike_times] = extract_isi( N , spike_times , times(i) ) ;
        isi(i,(c-1)*N + (1:N)) = isis ;
    end
end

end

%%%%%%%%%%%%%%%%%%
function [isis , spike_times] = extract_isi( N , spike_times , t )

spike_times = munch_right( spike_times , t ) ;
spikes_temp = spike_times(max(1,length(spike_times)-N+1):end) ;
isis = diff([ Inf*ones(N-length(spikes_temp),1) ; spikes_temp ; t]) ;

isis(find(isis<=0)) = Inf ;

end

%%%%%%%%%%%%%%%%%%%%
function list = munch_right(list , t)

i = length(list) ;

while (list(i)>=t && i>1)
    i = i-1 ;
end

list = list(1:i) ;

end