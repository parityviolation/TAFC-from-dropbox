bin_size = 1; %in ms
bin_size = bin_size/1000*samp_rate; %in samples(1ms)
edges = [1:bin_size:trial_length];
psth = zeros(1,length(edges)); 
begin = 0;

for j = 1:num_trials
last = trial_length*j;
spikes(j).times = data.spikes_sorted(find(data.spikes_sorted>begin & data.spikes_sorted<=last));

begin = last;

psth = psth+histc(spikes(j).times,edges);
num_spikes = sum(psth);
end

h = figure;
set(h, 'WindowStyle', 'docked');

bar(edges,psth); 
xlabel('Time (msec)'); 
ylabel('# of spikes');
