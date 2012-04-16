function firing_rate = make_repeats_firing_rate(psth_spikes)

firing_rate = length(psth_spikes.sp)*10000/(psth_spikes.N_runs*max(psth_spikes.sp)) ;

end