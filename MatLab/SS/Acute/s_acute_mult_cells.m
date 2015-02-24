%load structs
% 
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
%     'BVA__2014-05-02_#234-cell#2-2650_1';...
%     'BVA__2014-05-02_#234-cell#2-2650_2';...
%     'BVA__2014-04-09_#468-field2_7';...
%     'BVA__2014-04-09_#468-field2_8';...
%     'BVA__2014-04-09_#468-field2_9'};
% 

rd = brigdefs();
path = rd.Dir.Acute;

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


struct_names = {'BVA__2014-04-09_#468-cell#7-3021_5';...
    'BVA__2014-04-16_#231-cell#2-2815_4';...
    'BVA__2014-04-16_#231-cell#6-2834_1';...
    'BVA__2014-04-16_#231-cell#8-2700_1';...
    'BVA__2014-04-09_#468-field2_7'};

for i=1:length(struct_names)
  structs.(['data' num2str(i)]) = loadAcuteStruct(struct_names{i});  
    
    
end

%%
cells = [1 1 1 2 2 2 2 3 3 3 3 4 4 4 5 5 5];
num_cells = length(unique(cells));
my_cell_color = lines(num_cells);
num_trials = size(data.raw_split,2);
trial_length = data.samp_rate*data.trial_dur;
samp_rate = data.samp_rate;

%% calculate spontaneous and evoked firing rates


for i = 1:length(struct_names)

data = structs.(['data' num2str(i)]);

pw(i) = data.pulse_width;  


spont = data.raster(1:data.offset*data.samp_rate-1,:);
spont_rate(i) = sum(spont(:))/(size(spont,1)*size(spont,2)/data.samp_rate);

evoked = data.raster(data.offset*data.samp_rate:(data.offset+3)*data.samp_rate,:);
evoked_rate(i) = sum(evoked(:))/(size(evoked,1)*size(evoked,2)/data.samp_rate);


end

%%

h = figure;
set(h, 'WindowStyle', 'docked');

hist(spont_rate',15)

f = findobj(gca,'Type','patch');
set(f,'FaceColor','k','EdgeColor','w')
hold on

hist(evoked_rate',15)

f = findobj(gca,'Type','patch');
set(f,'EdgeColor','w')


savename_fig =  ['spont and evoked firing rates'];
xlabel('firing rate (Hz)') 
ylabel('Num recordings')
title(savename_fig) 
legend('Spontaneous', 'Evoked')

axis tight
axis square
set(gca, 'TickDir', 'out','FontSize',14,'fontWeight','bold')
box off


patht = fullfile(rd.Dir.Acute, 'SummaryFigs','All_cells');
parentfolder(patht,1); %not working for mac?
savefiledesc = ['Allcells ' savename_fig];
%export_fig(h, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
saveas(h, fullfile(patht,[savefiledesc '.fig']));


%% evoked firing rates vs pulsewidth 


h = figure;
set(h, 'WindowStyle', 'docked');

[pw_sorted, pw_indx] = sort(pw);
cells_sorted = cells(pw_indx);
evoked_rate_sorted = evoked_rate(pw_indx);
spont_rate_sorted = spont_rate(pw_indx);

for c=1:num_cells

indx = find(cells_sorted==c);
plot(pw_sorted(indx),evoked_rate_sorted(indx),'-','color',my_cell_color(c,:),'markersize',15,'linewidth',2)
hold on

sleg{c}=['cell ' num2str(c)];

end
hleg = legend(sleg);

for c=1:num_cells

indx = find(cells_sorted==c);
plot(pw_sorted(indx),spont_rate_sorted(indx),'--','color',my_cell_color(c,:),'markersize',15,'linewidth',1)

hold on


end



savename_fig =  ['evoked firing rate vs pulse width'];
xlabel('pulse width (ms)') 
ylabel('Firing rate (Hz)')
title(savename_fig) 
hleg = legend(sleg);

axis tight
%xlim([min(pw) max(pw)])
axis square
set(gca, 'TickDir', 'out','FontSize',14,'fontWeight','bold')
box off


patht = fullfile(rd.Dir.Acute, 'SummaryFigs','All_cells');
parentfolder(patht,1); %not working for mac?
savefiledesc = ['Allcells ' savename_fig];
%export_fig(h, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
saveas(h, fullfile(patht,[savefiledesc '.fig']));




%%
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


% h = figure;
% set(h, 'WindowStyle', 'docked');


for i = 1:length(struct_names)
    i_color = 0;

    data = structs.(['data' num2str(i)]);
    data.pulses=pulses;
    
    for i_pulse=pulses
        
        i_color = i_color+1;
        [a b] = getWOI(data.raster',idx_full_sess(:,i_pulse),[window_before window_after]);
        
        
        pta(:,i_color) = mean(a)'*samp_rate;
        smooth_pta(:,i_color) = conv(pta(:,i_color),kernel,'same');
        
%         %plot([1:length(pta)]/data.samp_rate*1000-before*1000,pta,'k')
%         %hold on
%         plot([1:length(smooth_pta(:,i_color))]/data.samp_rate*1000-before*1000,smooth_pta(:,i_color),'color',mycolor(i_color,:),'linewidth',2);
%         hold on
%         sleg{i_color}=['trial number ' num2str(i_pulse)];
%         
        integral(i_color) = sum(smooth_pta(:,i_color));
        
        
    end
    
    frac(i) = integral(end)/integral(1);
    
    data.smooth_pta = smooth_pta;
    data.pta = pta;
    
    
end


h = figure;
set(h, 'WindowStyle', 'docked');

frac_sorted = frac(pw_indx);


for c=1:num_cells

indx = find(cells_sorted==c);
plot(pw_sorted(indx),frac_sorted(indx),'-','color',my_cell_color(c,:),'markersize',15,'linewidth',2)
hold on

sleg{c}=['cell ' num2str(c)];

end
hleg = legend(sleg);


savename_fig = ['Frac of integral of pta last/first pulse vs pw'];
 
xlabel('Pulse width (ms)','FontSize',14); 
ylabel('Ratio last/first pulse response', 'FontSize',14);
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
% structs = [];
% 
% for i = 1:4
% structs(i) = loadBstruct();
% 
% end

%%


% max_num_trials = 100;
% latencies_2ms = nan(length(structs(i)),max_num_trials);
% field_slopes_2ms = nan(length(structs(i)),max_num_trials);
% field_amp_2ms = nan(length(structs(i)),max_num_trials);
% 
% latencies_10ms = nan(length(structs(i)),max_num_trials);
% field_slopes_10ms = nan(length(structs(i)),max_num_trials);
% field_amp_10ms = nan(length(structs(i)),max_num_trials);
% 
% 
% last2 = 0;
% last10 = 0;
% 
% for i = 1:length(structs)
%    data=structs(i);
%    
%     if data.pulse_width==2
%         latencies_2ms(last2+1,1:length(data.spikes_sorted_1st_latency)) = data.spikes_sorted_1st_latency;
%         field_slopes_2ms(last2+1,1:length(data.field_slopes')) = data.field_slopes';
%         field_amp_2ms(last2+1,1:length(data.field_amp)) = data.field_amp;
%         last2 = last2 + 1;
%         
%         idx_nan = find(latencies_2ms(last2,:)>=(1/data.pulse_freq*1000));
%         latencies_2ms(last2,idx_nan) = nan;
%         field_slopes_2ms(last2,idx_nan) = nan;
%         field_amp_2ms(last2,idx_nan) = nan;
%         
%         
%     elseif data.pulse_width==10
%         latencies_10ms(last10+1,1:length(data.spikes_sorted_1st_latency)) = data.spikes_sorted_1st_latency;
%         field_slopes_10ms(last10+1,1:length(data.field_slopes')) = data.field_slopes';
%         field_amp_10ms(last10+1,1:length(data.field_amp)) = data.field_amp;
%         last10 = last10 + 1;
%         
%         idx_nan = find(latencies_10ms(last10,:)>=(1/data.pulse_freq*1000));
%         latencies_10ms(last10,idx_nan) = nan;
%         field_slopes_10ms(last10,idx_nan) = nan;
%         field_amp_10ms(last10,idx_nan) = nan;
%      
%         
%     end
% end
% 
% 
% h = figure; 
% set(h, 'WindowStyle', 'docked');
% 
% plot(latencies_2ms(1,:),field_amp_2ms(1,:),'.b','markersize',10)
% hold on
% 
% plot(latencies_10ms(2,:),field_amp_10ms(2,:),'.r','markersize',10)
% hold on
% 
% plot([0:13],[0:13],'-k','markersize',10)
% 
% xlabel('latency(ms)') 
% ylabel('field amp')
% legend('2ms pulse width','10ms pulse width')
% 
% 
% xlim ([0 13])
% ylim ([0 13])
% axis square;
% 
% h = figure; 
% set(h, 'WindowStyle', 'docked');
% 
% plot(nanmean(latencies_2ms(1,:)),nanmean(latencies_10ms(1,:)),'.b','markersize',10)
% hold on
% 
% plot(nanmean(latencies_2ms(2,:)),nanmean(latencies_10ms(2,:)),'.r','markersize',10)
% hold on
% 
% plot([0:13],[0:13],'-k','markersize',10)
% 
% xlabel('mean latency(ms) 2ms pulse') 
% ylabel('mean latency(ms) 10ms pulse')
% 
% xlim ([0 13])
% ylim ([0 13])
% axis square;
% 
% 
% h = figure; 
% set(h, 'WindowStyle', 'docked');
% 
% plot(nanmean(latencies_2ms(1,:)),nanmean(field_amp_2ms(1,:)),'.b','markersize',10)
% hold on
% 
% plot(nanmean(latencies_10ms(1,:)),nanmean(field_amp_10ms(1,:)),'.r','markersize',10)
% hold on
% 
% plot(nanmean(latencies_2ms(2,:)),nanmean(field_amp_2ms(2,:)),'*b','markersize',10)
% hold on
% 
% plot(nanmean(latencies_10ms(2,:)),nanmean(field_amp_10ms(2,:)),'r','markersize',10)
% hold on
% 
% 
% plot([0:13],[0:13],'-k','markersize',10)
% 
% xlabel('latency(ms)') 
% ylabel('field amp')
% legend('2ms pulse width','10ms pulse width')
% 
% 
% xlim ([0 13])
% ylim ([-0.5 0])
% axis square;
% 
% axis tight



