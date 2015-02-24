clc; clear all; close all

%% Path in Chaos
 default_path = ['C:\Users\Behave\Dropbox\PatonLab\Paton Lab\Data\TAFCmice\Behavior', '\'];
% Path in Lab-PC
% default_path = ['C:\Users\User\Desktop\Dropbox\# Paton lab\Data\Matching\Behavior', '\'];
% Path in HP
% default_path= ['C:\Users\Rui\Dropbox\# Paton lab\Data\Matching\Behavior', '\'];

folder = 'Sert_866'; 
file_name = 'Sert_866_MATCHINGvFix02_box2_130710_SSAB';

file = [default_path, folder, '\', file_name, '.txt']; 

%% Figure
fig = figure('WindowStyle','docked');

%% Read file
data = ss_parsedata(file);

%% Delete last trial; Reward and choice computations

%% Reward and choice computations
rewarded = data.Rewarded(1:end-1) == 1;
unrewarded = data.Rewarded(1:end-1) == 0;
rwd_miss = isnan(data.Rewarded(1:end-1)); 

rewarded_ind = find(rewarded == 1);
unrewarded_ind = find(unrewarded == 1);
rwd_miss_ind = find(rwd_miss == 1); 

choice_left = data.ChoiceLeft(1:end-1) == 1; 
choice_right = data.ChoiceLeft(1:end-1) == 0;

left_rewarded = choice_left & rewarded;
right_rewarded = choice_right & rewarded;

%% Plots of animal's choice and probability of reward
subplot(3,4,[1, 4]), hold on
axis([1, length(choice_left), 0, 1])
plot(rewarded_ind,choice_left(rewarded_ind),'og','markersize',3)
plot(unrewarded_ind,choice_left(unrewarded_ind),'or','markersize',3)
plot(rwd_miss_ind, 0.5*rwd_miss(rwd_miss_ind),'ok','markersize',3)
ax(1) = gca;
set(ax(1),'box','off','tickdir','out','ytick',[0, 0.5, 1],'yticklabel',{'Right','Miss', 'Left'}); % 'FontSize', 11, 'FontWeight', 'bold' )
xlabel ('Trial number', 'FontSize', 10, 'FontWeight', 'bold' ); 
ylabel ('Choice', 'FontSize', 10, 'FontWeight', 'bold' )
title(['\', file_name]);

%% Running average of choice and reward
windowSize = 10;
avg_left = filter(ones(1,windowSize)/windowSize,1,choice_left);
avg_right = filter(ones(1,windowSize)/windowSize,1,choice_right);
p_rwd_left = data.ProbRwdLeft/100;
p_rwd_right = data.ProbRwdRight/100;

ax(2) = axes('Position',get(ax(1),'Position'),'YAxisLocation','right', 'tickdir','out','xtick',[],'ytick', 0:0.2:1,'color','none','YColor','b');
ylabel ('Probability fraction(left)', 'FontSize', 10, 'FontWeight', 'bold')

line([1:length(p_rwd_left)], p_rwd_left/sum(unique([unique(p_rwd_left) unique(p_rwd_right)])),'LineStyle',':', 'LineWidth',1,'color','b','Parent',ax(1))
line([1:length(avg_left)], avg_left,'LineWidth',1,'color','k','Parent',ax(1));
%line([1:length(p_rwd_right)], p_rwd_right,'LineWidth',1,'color',[0.8 0.8 0.0078],'Parent',ax(1));
%line([1:length(avg_right)], avg_right,'LineWidth',2,'color',[0.8 0.8 0.0078],'Parent',ax(1));
hold off


%% Trial number as a function of time
subplot(3,4,5), hold on
trial_init = data.TrialInit(1:end-1)/60000;
plot(trial_init(unrewarded_ind), unrewarded_ind,'or', 'MarkerSize', 3);
plot(trial_init(rewarded_ind), rewarded_ind,'og', 'MarkerSize', 3);
plot(trial_init(rwd_miss_ind), rwd_miss_ind,'ok', 'MarkerSize', 3);
set(gca,'box','off','tickdir','out')
ylabel('Trial number', 'FontSize', 10, 'FontWeight', 'bold' )
xlabel('Time (min)', 'FontSize', 10, 'FontWeight', 'bold' )
axis tight

%% Counts of rewards, no-rewards and missed rewards
subplot(3,4,6)
n_rewarded = length(rewarded_ind);
n_unrewarded = length(unrewarded_ind);
n_rwd_miss = length(rwd_miss_ind);
n_trials = n_rewarded + n_unrewarded + n_rwd_miss;
rewarded_perc = 100 * n_rewarded/n_trials;
y = [n_rwd_miss, n_rewarded, n_unrewarded; 0, 0, 0]/ (n_trials);
bar( y, 'stack');
set(gca,'xtick',[], 'xlim', [0.4, 4], 'box','off','tickdir','out')

ylabel('Reward fraction', 'FontSize', 10, 'FontWeight', 'bold' )
text(1.7,0.9,['N. of trials = ', num2str(n_trials)], 'FontSize', 8)
text(1.7,0.7,['N. of rewards = ', num2str(n_rewarded)], 'FontSize', 8)
text(1.7,0.5,['N. of Rew.Misses = ', num2str(n_rwd_miss)], 'FontSize', 8)
text(1.7,0.3,['Rewarded = ', num2str(rewarded_perc,2), '%'], 'FontSize', 8)


%% Initiation time distribution

it = ( data.TrialInit(1:length(data.TrialAvail(1:end-1))) - data.TrialAvail(1:end-1) )/1000;
subplot(3,4,7)
n_bins = 500;
hist(it, n_bins)
xlabel ('Initiation time (s)', 'FontSize', 10, 'FontWeight', 'bold' ) 
ylabel ('Counts', 'FontSize', 10, 'FontWeight', 'bold' )
set(gca,'box','off','tickdir','out')
axis tight
it_prctile = prctile(it,[0, 95]);
xlim(it_prctile)

%% Reaction time distribution
c = data.ReactionTime/1000;
subplot(3,4,8)
n_bins = 100;
hist(c, n_bins)
xlabel ('Reaction time (s)', 'FontSize', 10, 'FontWeight', 'bold' ) 
ylabel ('Counts', 'FontSize', 10, 'FontWeight', 'bold' )
set(gca,'box','off','tickdir','out')
axis tight
c_prctile = prctile(c,[0, 95]);
xlim(c_prctile)

%% Cumulative distributions of choice 
subplot(3,4,9), hold on
plot(1:length(choice_left), cumsum(choice_left), '.c', 'MarkerSize', 5)
plot(1:length(choice_right), cumsum(choice_right), '.m', 'MarkerSize', 5)
xlabel('Trial number', 'FontSize', 10, 'FontWeight', 'bold' )
ylabel('Choice number', 'FontSize', 10, 'FontWeight', 'bold' )
hold off
leg = legend('Left', 'Right', 'Location', 'Best');
set(leg, 'Box', 'off', 'Fontsize', 8)
axis tight


%% Choice ratio vs income ratio
income_ratio = p_rwd_left./p_rwd_right;

low_inc_ind = find(income_ratio  == min(unique(income_ratio)) );
high_inc_ind = find(income_ratio == max(unique(income_ratio)) );
low_inc_ind = low_inc_ind(low_inc_ind<length(choice_left));
high_inc_ind = high_inc_ind(high_inc_ind<length(choice_left));

left_choices_low_inc = choice_left(low_inc_ind);
right_choices_low_inc = choice_right(low_inc_ind);
left_choices_high_inc = choice_left(high_inc_ind);
right_choices_high_inc = choice_right(high_inc_ind);

choice_ratio_low_inc = mean(left_choices_low_inc)/mean(right_choices_low_inc);
choice_ratio_high_inc = mean(left_choices_high_inc)/mean(right_choices_high_inc);

subplot(3,4,10), hold on
plot(unique(income_ratio), [choice_ratio_low_inc, choice_ratio_high_inc], '-o', 'LineWidth',2)
xlabel('Income ratio', 'FontSize', 10, 'FontWeight', 'bold' )
ylabel('Choice ratio', 'FontSize', 10, 'FontWeight', 'bold' )
%set(gca,'box','off','tickdir','out','xtick',unique(income_ratio),'xticklabel',{num2str(min(unique(income_ratio))),num2str(max(unique(income_ratio)))}, 'ytick',[choice_ratio_low_inc, choice_ratio_high_inc],'yticklabel',{num2str(choice_ratio_low_inc),num2str(choice_ratio_high_inc)}); % 'FontSize', 11, 'FontWeight', 'bold' )


%% Save figure into matlab fig file
saveas(fig, file(1:end-4), 'fig') 

%%
return;

%%








%%
col = winter(10*10);
col_i = col(9*10,:);

%% Choice ratio vs income ratio
left_p = data(:,5)/100;
right_p = data(:,6)/100;

income_ratio = left_p./right_p;

low_inc_ind = find(income_ratio  == min(unique(income_ratio)) );
high_inc_ind = find(income_ratio == max(unique(income_ratio)) );

left_choices_low_inc = choice_left(low_inc_ind);
right_choices_low_inc = choice_right(low_inc_ind);
left_choices_high_inc = choice_left(high_inc_ind);
right_choices_high_inc = choice_right(high_inc_ind);

choice_ratio_low_inc = mean(left_choices_low_inc)/mean(right_choices_low_inc);
choice_ratio_high_inc = mean(left_choices_high_inc)/mean(right_choices_high_inc);



figure, hold on
plot(unique(income_ratio), [choice_ratio_low_inc, choice_ratio_high_inc], '-o', 'LineWidth',3, 'color', col_i)
xlabel('Income ratio', 'FontSize', 20, 'FontWeight', 'bold' )
ylabel('Choice ratio', 'FontSize', 20, 'FontWeight', 'bold' )
% set(gca,'box','off','tickdir','out','xtick',[0, ,'xticklabel',{0, '%.3f'),num2str(max(unique(income_ratio)))}, 'ytick',[choice_ratio_low_inc, choice_ratio_high_inc],'yticklabel',{num2str(choice_ratio_low_inc,  '%.3f'),num2str(choice_ratio_high_inc, '%.3f')}, 'FontSize', 15, 'FontWeight', 'bold' )
xlim([-1.5, max(unique(income_ratio)) + 1])
ylim([-1.5, max(unique(income_ratio)) + 2])
return


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Matching behavior: reward income ratio and choice ratio
choice_ratio = cumsum(choice_left)./cumsum(choice_right);
left_income = cumsum(left_rewarded);
right_income = cumsum(right_rewarded);
income_ratio = left_income./right_income;
subplot(3,4,10), hold on
plot(1:length(choice_ratio) , choice_ratio, '.b')
plot(1:length(income_ratio) , income_ratio, '.g')
xlabel('Trial number', 'FontSize', 10, 'FontWeight', 'bold' )
ylabel('Left / Right', 'FontSize', 10, 'FontWeight', 'bold' )

ax(1) = gca;
set(ax(1),'box','off','tickdir','out')
line([1:length(true_left)], true_left,'LineStyle',':', 'LineWidth',1,'color','b','Parent',ax(1))
hold off
leg = legend('choice ratio', 'income ratio', 'Location', 'NorthEast');
set(leg, 'Box', 'off', 'Fontsize', 8)

%% Matching behavior: instantaneous choice and income ratios
figure, hold on
%% Running average of choice and reward
windowSize = 9;
avg_left = filter(ones(1,windowSize)/windowSize,1,choice_left);
avg_right = filter(ones(1,windowSize)/windowSize,1,choice_right);
avg_left_rw = filter(ones(1,windowSize)/windowSize,1,left_rewarded);
avg_right_rw = filter(ones(1,windowSize)/windowSize,1,right_rewarded);
true_left = data(:,5)/100;
true_right = data(:,6)/100;
choice_ratio = avg_left./avg_right;
choice_ratio_atan = atand(choice_ratio);
income_ratio = avg_left_rw./avg_right_rw;
income_ratio_atan = atand(income_ratio);
true_choice_ratio = true_left./true_right;
true_choice_ratio_atan = atand(true_choice_ratio);

line([1:length(true_choice_ratio_atan)], true_choice_ratio_atan,'LineStyle',':', 'LineWidth',2,'color','k')
line([1:length(choice_ratio_atan)], choice_ratio_atan,'LineWidth',2,'color','g');
line([1:length(income_ratio_atan)], income_ratio_atan,'LineWidth',2,'color','b');
% leg = legend('strict matching', 'choice ratio', 'income ratio', 'Location', 'NorthEast');
% set(leg, 'Box', 'off', 'Fontsize', 8)
hold off
axis tight
xlabel('Trial number', 'FontSize', 20, 'FontWeight', 'bold' )
ylabel('arctan (Left / Right) (º) ', 'FontSize', 20, 'FontWeight', 'bold' )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure, hold on
axis([1 length(data) 0 1])
plot(rewarded_ind,choices(rewarded_ind),'og','markersize',3)
plot(nonrewarded_ind,choices(nonrewarded_ind),'or','markersize',3)
ax(1) = gca;
set(ax(1),'box','off','tickdir','out','ytick',[0, 1],'yticklabel',{'Right','Left'}, 'FontSize', 15, 'FontWeight', 'bold' )
xlabel ('Trial number', 'FontSize', 20, 'FontWeight', 'bold' ); 
ylabel ('Choice', 'FontSize', 20, 'FontWeight', 'bold' )
%title(['\', file_name]);

%% Running average of choice and reward
[f_left, x_left] = ksdensity(choice_left, 'npoints', 5 , 'width', 1);
[f_right, x_ri] = ksdensity(choice_left, 'npoints', 5 , 'width', 1);


plot(x_left, f_left)
windowSize = 5;
avg_left = filter(ones(1,windowSize)/windowSize,1,choice_left);
avg_right = filter(ones(1,windowSize)/windowSize,1,choice_right);
avg_left_rw = filter(ones(1,windowSize)/windowSize,1,left_rewarded);
avg_right_rw = filter(ones(1,windowSize)/windowSize,1,right_rewarded);
true_left = data(:,5)/100;
true_right = data(:,6)/100;

ax(2) = axes('Position',get(ax(1),'Position'),'YAxisLocation','right', 'tickdir','out','xtick',[],'ytick', 0:0.2:1,'color','none','YColor','b', 'FontSize', 15, 'FontWeight', 'bold');
ylabel ('P(left)', 'FontSize', 20, 'FontWeight', 'bold')
hold on
line([1:length(true_left)], true_left,'LineStyle',':', 'LineWidth',1,'color','b','Parent',ax(1))
line([1:length(avg_left)], avg_left,'LineWidth',1,'color','k','Parent',ax(1));
%line([1:length(true_right)], true_right,'LineWidth',1,'color',[0.8 0.8 0.0078],'Parent',ax(1));
%line([1:length(avg_right)], avg_right,'LineWidth',2,'color',[0.8 0.8 0.0078],'Parent',ax(1));
hold off



