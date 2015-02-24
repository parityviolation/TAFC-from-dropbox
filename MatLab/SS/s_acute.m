%filename = 'C:\Users\Behave\Dropbox\PatonLab\Paton Lab\Data\TAFCmice\Ephys\Acute\#457\BVA__2014-04-01_#457-field3_8';

%clear all;
%close all;

rd = brigdefs();
path = rd.Dir.Acute;

 %
data.Animal = '#1025';
data.FileName = 'BVA__2014-09-18_#1025_cell2_45_1';
data.Fullpath = fullfile(path,data.Animal,data.FileName);
data.rawAll = daqread(fullfile([data.Fullpath '.daq']));
data.LEDCond = load(fullfile([data.Fullpath '_LEDCond']));
data.TrigCond = load(fullfile([data.Fullpath '_TrigCond']));


data.samp_rate = 32000; % in Hz
data.cutoff_h = 400;
data.cutoff_l = 200;
data.dt=1/data.samp_rate;
data.offset = 1; %in seconds
data.trial_dur = 4; %in sec
data.pulse_freq = 1; %in Hz
data.slice_field = 15;%in ms
data.field_start = 2;%in ms
data.baseline_dur_field = 3; %in ms

%TO CHANGE WITH EACH FILE!
data.pulse_width = 700;%in ms
data.thres = -0.09; %threshold for spiking
data.coeff_thresh = 0.05; %pc bound for sorting spikes
data.coeff_thresh2 = 0.04;


%saveBstruct(data)
%%

% struct_names = {'BVA__2014-04-09_#468-cell#7-3021_5';...
%     'BVA__2014-04-09_#468-cell#7-3021_6';...
%     'BVA__2014-04-09_#468-cell#7-3021_7';...
%     'BVA__2014-04-16_#231-cell#2-2815_1';...
%     'BVA__2014-04-16_#231-cell#2-2815_2';...
%     'BVA__2014-04-16_#231-cell#2-2815_3';...
%     'BVA__2014-04-16_#231-cell#2-2815_4';...
%     'BVA__2014-04-16_#231-cell#6-2834_1';...
%     'BVA__2014-04-16_#231-cell#6-2834_2';...
%     'BVA__2014-04-16_#231-cell#6-2834_3';...
%     'BVA__2014-04-16_#231-cell#6-2834_4';...
%     'BVA__2014-04-16_#231-cell#8-2700_1';...
%     'BVA__2014-04-16_#231-cell#8-2700_2';...
%     'BVA__2014-04-16_#231-cell#8-2700_3';...
%     'BVA__2014-04-09_#468-field2_7';...
%     'BVA__2014-04-09_#468-field2_8';...
%     'BVA__2014-04-09_#468-field2_9'};

% %or load
% 
% data = loadBstruct();



%for i=17:length(struct_names)
%   close all;
%   data = loadAcuteStruct(struct_names{i});  
%     


%%
samp_rate = data.samp_rate;
offset = data.offset; %in seconds
trial_dur = data.trial_dur; %in sec
pulse_width = data.pulse_width;%in ms
fullpath = data.Fullpath;
filename = data.FileName;
animal = data.Animal;
num_trials = length(find(~isnan(data.TrigCond.CondNum(1,:))))-1;
data.num_trials = num_trials;
trial_length = samp_rate*trial_dur;  % in samples

patht = fullfile(rd.Dir.Acute, 'SummaryFigs',data.Animal);
mkdir(patht);
%%
%Back up raw and high-pass filter data

high = 1;
low = 0;

data.raw = data.rawAll(:,10);
data.raw(find(isnan(data.raw)))=0;
data.filt_h = filterdata(data.raw,data.dt,data.cutoff_h,high);
data.filt_l = filterdata(data.raw,data.dt,data.cutoff_l,low);

%%
%Plot full session
h = figure;
set(h, 'WindowStyle', 'docked');


line([1:length(data.raw)]/samp_rate,data.raw,'Color',[0 0 0]);
% hold on;
% plot([1:length(data.filt_h)]/samp_rate,data.filt_h,'b');
% hold on;
% plot([1:length(data.filt_l)]/samp_rate,data.filt_l,'g');
axis tight
axis square
set(gca, 'TickDir', 'out','FontSize',14,'fontWeight','bold')
box off
savename_fig =  ['full session' num2str(data.pulse_width) 'ms'];
xlabel('time (s)','FontSize',14) 
ylabel('mvolts' ,'FontSize',14)
title(savename_fig) 
% legend('raw','high pass','low pass')


%parentfolder(patht,1) %not working for mac?
savefiledesc = [data.FileName '_' savename_fig];
export_fig(h, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
saveas(h, fullfile(patht,[savefiledesc '.fig']));


% in progress 
% plot_raw_filt(data.raw,data.filt_h,samp_rate,2); %plot raw and high pass filtered data
% 
% plot_raw_filt(data.raw,data.filt_l,samp_rate,1); %plot raw and low pass filtered data
% 


%% Plot full session raw and high pass
h = figure;
set(h, 'WindowStyle', 'docked');
window_start = (offset+0.095)*samp_rate;
window_end = window_start + (0.025*samp_rate);

plot([1:length(data.raw(window_start:window_end))]/samp_rate,data.raw(window_start:window_end),'k','linewidth',2);
 
savename_fig =  ['small window raw ' num2str(data.pulse_width) 'ms'];
xlabel('time (s)','FontSize',14) 
ylabel('mvolts','FontSize',14)
title(savename_fig) 
legend('raw')
axis tight
axis square
set(gca, 'TickDir', 'out','FontSize',14,'fontWeight','bold')
box off

%parentfolder(patht,1) %not working for mac?
savefiledesc = [data.FileName '_' savename_fig];
export_fig(h, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
saveas(h, fullfile(patht,[savefiledesc '.fig']));



h = figure;
set(h, 'WindowStyle', 'docked');
window_start = (offset+0.095)*samp_rate;
window_end = window_start + (0.025*samp_rate);

plot([1:length(data.raw(window_start:window_end))]/samp_rate,data.raw(window_start:window_end),'k','linewidth',2);
 hold on;
 plot([1:length(data.filt_h(window_start:window_end)*samp_rate)]/samp_rate,data.filt_h(window_start:window_end),'b','linewidth',2);

savename_fig =  ['small window raw and high pass' num2str(data.pulse_width) 'ms'];
xlabel('time (s)','FontSize',14) 
ylabel('mvolts','FontSize',14)
title(savename_fig) 
legend('raw','high pass')
axis tight
axis square
set(gca, 'TickDir', 'out','FontSize',14,'fontWeight','bold')
box off

%parentfolder(patht,1) %not working for mac?
savefiledesc = [data.FileName '_' savename_fig];
export_fig(h, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
saveas(h, fullfile(patht,[savefiledesc '.fig']));


h = figure;
set(h, 'WindowStyle', 'docked');


plot([1:length(data.raw(window_start:window_end))]/samp_rate,data.raw(window_start:window_end),'k','linewidth',2);
 hold on;
 plot([1:length(data.filt_l(window_start:window_end)*samp_rate)]/samp_rate,data.filt_l(window_start:window_end),'g','linewidth',2);


savename_fig =  ['small window raw and low pass' num2str(data.pulse_width) 'ms'];
xlabel('time (s)','FontSize',14) 
ylabel('mvolts','FontSize',14)
title(savename_fig) 
legend('raw','low pass')
axis tight
axis square
set(gca, 'TickDir', 'out','FontSize',14,'fontWeight','bold')
box off

%parentfolder(patht,1) %not working for mac?
savefiledesc = [data.FileName '_' savename_fig];
export_fig(h, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
saveas(h, fullfile(patht,[savefiledesc '.fig']));

h = figure;
set(h, 'WindowStyle', 'docked');


plot([1:length(data.raw(window_start:window_end))]/samp_rate,data.raw(window_start:window_end),'k','linewidth',2);
hold on;
plot([1:length(data.filt_h(window_start:window_end)*samp_rate)]/samp_rate,data.filt_h(window_start:window_end),'b','linewidth',2);
hold on;
plot([1:length(data.filt_l(window_start:window_end)*samp_rate)]/samp_rate,data.filt_l(window_start:window_end),'g','linewidth',2);


savename_fig =  ['small window raw ,high and low pass' num2str(data.pulse_width) 'ms'];
xlabel('time (s)', 'FontSize',14) 
ylabel('mvolts','FontSize',14)
title(savename_fig) 
legend('raw','high pass','low pass')
axis tight
axis square
set(gca, 'TickDir', 'out','FontSize',14,'fontWeight','bold')
box off

%parentfolder(patht,1) %not working for mac?
savefiledesc = [data.FileName '_' savename_fig];
export_fig(h, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
saveas(h, fullfile(patht,[savefiledesc '.fig']));


%%
%Split data per trials


data.raw_split = reshape(data.raw(1:trial_length*(num_trials)),trial_length,num_trials);
data.filt_h_split = reshape(data.filt_h(1:trial_length*(num_trials)),trial_length,num_trials);
data.filt_l_split = reshape(data.filt_l(1:trial_length*(num_trials)),trial_length,num_trials);
data.filt_l_split_mean = mean(data.filt_l_split');


% what i was using before for window for slope
%  window_end = find(diff(data.filt_l_split_mean(samp_rate*offset+100:end))>=0)+samp_rate*offset+100; 
%  window_end = window_end(1); 

baseline_start = samp_rate*offset-data.baseline_dur_field/1000*samp_rate; %in smaples
baseline_end = baseline_start+(data.baseline_dur_field/1000*samp_rate); %in samples

if isfield(data,'field_start')==0
    
    data.field_start = 0;
end

field_start = data.field_start;
field_slice = offset*samp_rate+data.slice_field/1000*samp_rate;
window_end = field_slice;

for i = 1:size(data.filt_l_split,2)
    
    
    
    field_slice = find(data.filt_l_split(offset*samp_rate:offset*samp_rate+data.slice_field/1000*samp_rate,i)==min(data.filt_l_split(offset*samp_rate:offset*samp_rate+data.slice_field/1000*samp_rate,i)))+offset*samp_rate-1;
    window_end = field_slice;
    
    
    baseline(i) = median(data.filt_l_split(baseline_start:baseline_end,i));
    slice_field(i) = data.filt_l_split(field_slice,i);
    
 
    
    p(i,:) = polyfit(((offset+field_start/1000)*samp_rate:window_end)',data.filt_l_split((offset+field_start/1000)*samp_rate:window_end,i),1);
    
    fit = ((offset+field_start/1000)*samp_rate:window_end)*p(i,1) + p(i,2);
    if i==10
        h = figure;
        set(h, 'WindowStyle', 'docked');
        
        plot([1:length(data.filt_l_split)]/samp_rate*1000,data.filt_l_split(:,i),'k','linewidth',2);
        hold on;
        plot(((offset+field_start/1000)*samp_rate:window_end)/samp_rate*1000,fit,'g','linewidth',2);
        hold on;
        
        xlim([offset*1000-10 offset+1000+data.pulse_width+10]);
        axis square
        set(gca, 'TickDir', 'out','FontSize',14,'fontWeight','bold')
        box off
        
        savename_fig =  ['single trial low pass' num2str(data.pulse_width) 'ms'];
        xlabel('time (ms)','FontSize',14)
        ylabel('mvolts','FontSize',14)
        title(savename_fig)
        legend('sinfle trial', 'linear fit')
        
        
        %parentfolder(patht,1) %not working for mac?
        savefiledesc = [data.FileName '_' savename_fig];
        export_fig(h, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
        saveas(h, fullfile(patht,[savefiledesc '.fig']));


        
    end

end

data.field_amp = slice_field-baseline;
data.field_slopes = p(:,1);

h = figure;
set(h, 'WindowStyle', 'docked');
plot([1:length(data.filt_l_split_mean)]/samp_rate*1000,data.filt_l_split_mean,'g','linewidth',2);
axis tight
axis square
set(gca, 'TickDir', 'out','FontSize',14,'fontWeight','bold')
box off

savename_fig =  ['average low pass filt' num2str(data.pulse_width) 'ms'];
xlabel('time (ms)','FontSize',14) 
ylabel('mvolts', 'FontSize',14)
title(savename_fig) 
legend('average low pass')


%parentfolder(patht,1) %not working for mac?
savefiledesc = [data.FileName '_' savename_fig];
export_fig(h, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
saveas(h, fullfile(patht,[savefiledesc '.fig']));


h = figure;
set(h, 'WindowStyle', 'docked');

hist(p(:,1),15)

savename_fig =  ['hist-slopes-field' num2str(data.pulse_width) 'ms'];
xlabel('slope') 
ylabel('trials')
title(savename_fig) 
text(0.02,0.95,['Median = ',num2str(nanmedian(p(:,1)))], 'Units','normalized')
text(0.02,0.85,['25percentile = ',num2str(prctile(p(:,1),25))], 'Units','normalized')
text(0.02,0.82,['75percentile = ',num2str(prctile(p(:,1),75))], 'Units','normalized')

h = findobj(gca,'Type','patch');
set(h,'FaceColor','k','EdgeColor','w')

axis tight
axis square
set(gca, 'TickDir', 'out','FontSize',14,'fontWeight','bold')
box off


patht = fullfile(rd.Dir.Acute, 'SummaryFigs',data.Animal);
%parentfolder(patht,1) %not working for mac?
savefiledesc = [data.FileName '_' savename_fig];
export_fig(h, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
saveas(h, fullfile(patht,[savefiledesc '.fig']));


h = figure;
set(h, 'WindowStyle', 'docked');

hist(data.field_amp,15)

savename_fig =  ['hist-field-amp' num2str(data.pulse_width) 'mvolts'];
xlabel('field amp') 
ylabel('trials')
title(savename_fig) 
text(0.02,0.95,['Median = ',num2str(nanmedian(data.field_amp))], 'Units','normalized')
text(0.02,0.85,['25percentile = ',num2str(prctile(data.field_amp,25))], 'Units','normalized')
text(0.02,0.82,['75percentile = ',num2str(prctile(data.field_amp,75))], 'Units','normalized')

h = findobj(gca,'Type','patch');
set(h,'FaceColor','k','EdgeColor','w')

axis tight
axis square
set(gca, 'TickDir', 'out','FontSize',14,'fontWeight','bold')
box off

patht = fullfile(rd.Dir.Acute, 'SummaryFigs',data.Animal);
%parentfolder(patht,1) %not working for mac?
savefiledesc = [data.FileName '_' savename_fig];
export_fig(h, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
saveas(h, fullfile(patht,[savefiledesc '.fig']));





%%
%plot overlay all trials raw
h = figure;
set(h, 'WindowStyle', 'docked');
colors = copper(num_trials);
%clf
for i = 1:num_trials
%     if 1
        plot([1:size(data.raw_split,1)]/samp_rate*1000, data.raw_split(:,i),'color',colors(i,:))
        hold on
end


axis tight
axis square
set(gca, 'TickDir', 'out','FontSize',14,'fontWeight','bold')
box off

savename_fig =  ['overlay all trials raw' num2str(data.pulse_width) 'ms'];
xlabel('time (ms)','FontSize',14) 
ylabel('mvolts','FontSize',14)
title(savename_fig) 


%parentfolder(patht,1) %not working for mac?
savefiledesc = [data.FileName '_' savename_fig];
export_fig(h, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
saveas(h, fullfile(patht,[savefiledesc '.fig']));




%%

%plot overlay all trials filt
h = figure;
set(h, 'WindowStyle', 'docked');
colors = copper(num_trials);
%clf
for i = 1:num_trials

        plot([1:size(data.filt_h_split,1)]/samp_rate*1000, data.filt_h_split(:,i),'color',colors(i,:))
        hold on
end

savename_fig = ['overlay all trials high pass filt' num2str(data.pulse_width) 'ms'];
xlabel('time (ms)','FontSize',14) 
ylabel('mvolts','FontSize',14)

title(savename_fig) 

axis tight
axis square
set(gca, 'TickDir', 'out','FontSize',14,'fontWeight','bold')
box off

%parentfolder(patht,1) %not working for mac?
savefiledesc = [data.FileName '_' savename_fig];
export_fig(h, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
saveas(h, fullfile(patht,[savefiledesc '.fig']));



%%
%filter full session data

%for visualizing thresholded waveforms
before = 1; %in ms
after = 2;%in ms
lockout = 0.5;
%data.thres = max(raw_data-(median(raw_data)))/2+(median(raw_data)); %

binary_data=data.filt_h<=data.thres;
fall = find(diff(binary_data)==1);
isi = diff(fall);
idx = isi>lockout/1000*data.samp_rate;
idx = [1 idx];
fall = fall(idx>0);


rise = find(diff(binary_data)==-1);

n_spikes = length(fall);

window_before = samp_rate*(before/1000); %in samples (sample rate*time in s)

window_after = samp_rate*(after/1000); %in sampes (sample rate*time in s)


%%
%Plot aligned thresholded putative spikes

h = figure;
set(h, 'WindowStyle', 'docked');
colors = copper(n_spikes)*0;
data.spikes_wav = [];
for i = 1:n_spikes

data.spikes_wav(:,i) = data.filt_h(fall(i)-window_before:fall(i)+window_after);

plot([1:size(data.spikes_wav,1)]/samp_rate*1000, data.spikes_wav(:,i),'color',colors(i,:))

hold on

end


savename_fig = ['aligned thres putative spikes' num2str(data.pulse_width) 'ms'];
xlabel('time (ms)','FontSize',14) 
ylabel('mvolts','FontSize',14)
set(gca, 'TickDir', 'out','FontSize',14,'fontWeight','bold')

title(savename_fig) 

axis tight
axis square

box off
%parentfolder(patht,1) %not working for mac?
savefiledesc = [data.FileName '_' savename_fig];
export_fig(h, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
saveas(h, fullfile(patht,[savefiledesc '.fig']));


%%
%plot pc
%[coeff score] = pca(data.spikes_wav,'Algorithm','EIG');
[data.coeff data.score] = princomp(data.spikes_wav);

h = figure;
set(h, 'WindowStyle', 'docked');
plot(data.coeff(:,1),data.coeff(:,2),'.','markersize',7)

savename_fig = ['PCA' num2str(data.pulse_width) 'ms'];
xlabel('PC1','FontSize',14) 
ylabel('PC2','FontSize',14)
title(savename_fig) 
axis tight
axis square

set(gca, 'TickDir', 'out','FontSize',14,'fontWeight','bold')

box off

%parentfolder(patht,1) %not working for mac?
savefiledesc = [data.FileName '_' savename_fig];
export_fig(h, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
saveas(h, fullfile(patht,[savefiledesc '.fig']));



%%
%select spike


data.spikes_sorted = fall(find(data.coeff(:,1)>data.coeff_thresh & data.coeff(:,2)<data.coeff_thresh2));
n_spikes_sorted = length(data.spikes_sorted);
data.n_spikes_sorted = n_spikes_sorted;

data.raster = zeros(size(data.filt_h));
data.raster(data.spikes_sorted) = 1;

data.raster = reshape(data.raster(1:trial_length*(num_trials)),trial_length,num_trials);


%%
%plot sorted spikes

h = figure; 
set(h, 'WindowStyle', 'docked');
colors = copper(n_spikes_sorted)*0;
data.spikes_sorted_wav=[];
for i = 1:n_spikes_sorted
    
data.spikes_sorted_wav(:,i) = data.filt_h(data.spikes_sorted(i)-window_before:data.spikes_sorted(i)+window_after);

plot([1:size(data.spikes_sorted_wav,1)]/samp_rate*1000, data.spikes_sorted_wav(:,i),'color',colors(i,:))

hold on

end


savename_fig = ['aligned thres sorted spikes' num2str(data.pulse_width) 'ms'];

title(savename_fig) 

axis tight
axis square
xlabel('time (ms)','FontSize',14) 
ylabel('mvolts','FontSize',14)
set(gca, 'TickDir', 'out','FontSize',14,'fontWeight','bold')

box off

%parentfolder(patht,1) %not working for mac?
savefiledesc = [data.FileName '_' savename_fig];
export_fig(h, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
saveas(h, fullfile(patht,[savefiledesc '.fig']));


%% Calculate ISI distributions

data.isi = diff(data.spikes_sorted)/data.samp_rate*1000;

h = figure;
set(h,'WindowStyle', 'docked')
hist(data.isi(data.isi<20),20)
%hist(Isi(Isi<20),20)

h = findobj(gca,'Type','patch');
set(h,'FaceColor','k','EdgeColor','w')

savename_fig = ['Isi' num2str(data.pulse_width) 'ms'];

title(savename_fig) 

xlabel('time (ms)','FontSize',14) 
ylabel('mvolts','FontSize',14)
set(gca, 'TickDir', 'out','FontSize',14,'fontWeight','bold')


%parentfolder(patht,1) %not working for mac?
savefiledesc = [data.FileName '_' savename_fig];
export_fig(h, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
saveas(h, fullfile(patht,[savefiledesc '.fig']));
 




%%
%Make raster


before = offset; %in s
after = trial_dur;%in s
window_before = samp_rate*(before); %in samples (sample rate*time in s)
window_after = samp_rate*(after); %in sampes (sample rate*time in s)
raster = nan(size(data.filt_h,1),size(data.filt_h,2));

raster(data.spikes_sorted)=1;
raster_split = reshape(raster(1:trial_length*(num_trials)),trial_length,num_trials);


h = figure;
set(h, 'WindowStyle', 'docked');
xymark(1,:)=[0 0];	% a baton
xymark(2,:)=[-0.5 0.5];

for i = 1:num_trials
    
%plot([1:size(raster_split,1)]/samp_rate*1000, raster_split(:,i)*i)

linecustommarker([1:size(raster_split,1)]/samp_rate*1000, raster_split(:,i)*i,xymark,[]);

hold on

end


savename_fig = ['raster' num2str(data.pulse_width) 'ms'];
xlabel('time (ms)','FontSize',14) 
ylabel('trials','FontSize',14)
title(savename_fig) 
axis tight
axis square
set(gca, 'TickDir', 'out','FontSize',14)
box off

%parentfolder(patht,1) %not working for mac?
savefiledesc = [data.FileName '_' savename_fig];
export_fig(h, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
saveas(h, fullfile(patht,[savefiledesc '.fig']));


%% PSTH
bin_size = 1; %in ms
bin_size = bin_size/1000*samp_rate; %in samples(1ms)
edges = [1:bin_size:trial_length];
psth = zeros(1,length(edges)); 
begin = 0;

for j = 1:num_trials
last = trial_length*j;
spikes(j).times = data.spikes_sorted(find(data.spikes_sorted>begin & data.spikes_sorted<=last))-begin;

begin = last;

psth = psth+histc(spikes(j).times,edges);
sum_psth = sum(psth);

end

%norm psth

psth = psth/num_trials*1000; %convert to Hz

%convolve
sd = 10;
kernel = normpdf([-3*sd:3*sd],0,sd);
kernel = kernel/sum(kernel);

h = figure;
set(h, 'WindowStyle', 'docked');
plot([-3*sd:3*sd],kernel)

smooth_psth2 = conv(psth,kernel,'same');
data.psth = psth;
data.smooth_psth = smooth_psth2;

h = figure;
set(h, 'WindowStyle', 'docked');
plot(1:length(edges),psth); 

savename_fig = ['PSTH' num2str(data.pulse_width) 'ms'];
xlabel('Time (ms)','FontSize',14); 
ylabel('Firing rate (Hz)', 'FontSize',14);

title(savename_fig) 
axis tight
axis square
set(gca, 'TickDir', 'out','FontSize',14)
box off


title(savename_fig) 
savefiledesc = [data.FileName '_' savename_fig];
%export_fig(h, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
saveas(h, fullfile(patht,[savefiledesc '.fig']));


h = figure;
set(h, 'WindowStyle', 'docked');

plot(1:length(edges),smooth_psth2); 

savename_fig = ['PSTH smoothed with a ' num2str(sd) 'sd kernel ' num2str(data.pulse_width) 'ms'];
xlabel('Time (ms)','FontSize',14); 
ylabel('Firing rate (Hz)', 'FontSize',14);

title(savename_fig) 
axis tight
axis square
set(gca, 'TickDir', 'out','FontSize',14)
box off

savefiledesc = [data.FileName '_' savename_fig];
%export_fig(h, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
saveas(h, fullfile(patht,[savefiledesc '.fig']));


%% Calculate Pulse triggered average

clear idx;
clear stim;
last = 0;
before = 0.02; %in s
after = 0.05;%in s
window_before = samp_rate*(before); %in samples (sample rate*time in s)
window_after = samp_rate*(after); %in sampes (sample rate*time in s)

stim = nan(size(data.filt_h_split,1),1);

idx(1,:) = [data.samp_rate*data.offset:1/data.pulse_freq*data.samp_rate:data.samp_rate*data.offset+3*data.samp_rate];
idx(2,:) = idx(1,:)+data.pulse_width/1000*data.samp_rate-1;
idx = idx(:,1:end-1);

idx_full_sess = repmat(idx(1,:),num_trials,1)+repmat([0:num_trials-1]'*trial_length,1,size(idx,2));

data.pulse_stim = idx_full_sess;

%convolve
sd = 0.5/1000*samp_rate;
kernel = normpdf([-3*sd:3*sd],0,sd);
kernel = kernel/sum(kernel);
% h = figure;
% set(h, 'WindowStyle', 'docked');
% plot([-3*sd:3*sd],kernel)
% 


pulses = [1 size(idx_full_sess,2)];
mycolor = lines(length(pulses));


h = figure;
set(h, 'WindowStyle', 'docked');
i_color = 0;

for i_pulse=pulses

    i_color = i_color+1;
[a b] = getWOI(data.raster',idx_full_sess(:,i_pulse),[window_before window_after]);


pta = mean(a)'*samp_rate;
smooth_pta = conv(pta,kernel,'same');

%plot([1:length(pta)]/data.samp_rate*1000-before*1000,pta,'k')
%hold on
plot([1:length(smooth_pta)]/data.samp_rate*1000-before*1000,smooth_pta,'color',mycolor(i_color,:),'linewidth',2);
hold on
sleg{i_color}=['pulse number ' num2str(i_pulse)];

end

data.smooth_pta = smooth_pta;
data.pta = pta;

savename_fig = ['Pulse trigg avg' num2str(data.pulse_width) 'ms'];
 
xlabel('Time (ms)','FontSize',14); 
ylabel('Firing rate (Hz)', 'FontSize',14);
hleg = legend(sleg);
%defaultLegend(hleg)

title(savename_fig) 
axis tight
axis square
set(gca, 'TickDir', 'out','FontSize',14)
box off

%parentfolder(patht,1) %not working for mac?
savefiledesc = [data.FileName '_' savename_fig];
%export_fig(h, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
saveas(h, fullfile(patht,[savefiledesc '.fig']));





%%
%calculate latency distributions from the first spike in response to the
%first light pulse of each trial

light_on = [samp_rate*offset:samp_rate*trial_dur:length(data.raw)];
light_on = light_on(1:num_trials);
data.failure = nan(1,num_trials);

for i=1:num_trials

    first_spikes_ind(i) = find(data.spikes_sorted > light_on(i), 1, 'first');
    
    if data.spikes_sorted(first_spikes_ind(i))> light_on(i)+1/data.pulse_freq*samp_rate
        
        data.failure(i) = first_spikes_ind(i);
        
       % first_spikes_ind(i) = [ ];
    end
    
end

first_spikes_t = data.spikes_sorted(first_spikes_ind);

first_spikes_latency = (first_spikes_t-light_on)/samp_rate*1000; %in ms

data.spikes_sorted_1st_latency = first_spikes_latency;

first_spikes_latency(first_spikes_latency > 1/data.pulse_freq*1000)=nan;

h = figure;
set(h, 'WindowStyle', 'docked');

hist(first_spikes_latency,30)

h = findobj(gca,'Type','patch');
set(h,'FaceColor','k','EdgeColor','w')


text(0.02,0.9,['Median = ',num2str(nanmedian(first_spikes_latency))], 'Units','normalized')
text(0.02,0.8,['25percentile = ',num2str(prctile(first_spikes_latency,25))], 'Units','normalized')
text(0.02,0.75,['75percentile = ',num2str(prctile(first_spikes_latency,75))], 'Units','normalized')

savename_fig = ['spike latency from first pulse' num2str(data.pulse_width) 'ms'];
 
xlabel('latency (ms)','FontSize',14); 
ylabel('spikes', 'FontSize',14);

title(savename_fig) 
axis tight
axis square
set(gca, 'TickDir', 'out','FontSize',14)
box off

%parentfolder(patht,1) %not working for mac?
savefiledesc = [data.FileName '_' savename_fig];
%export_fig(h, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
saveas(h, fullfile(patht,[savefiledesc '.fig']));

saveBstruct(data)
%end

%%