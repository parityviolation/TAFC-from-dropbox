
A = {'fi12_1016_before_surgery','fi12_1446_before_surgery','fi12_1293_before_surgery','fi12_974_before_surgery'};

r = brigdefs;
groupsavefile = 'before_surgery';
%groupsavefile = fullfile(r.Dir.dropboxtemp,'Sert868sub')

% A = {'sert1421stim','sert1422stim'};
% groupsavefile = 'sertCtrlData';
bAcrossAnimals = 0; % set to 1 to get the average across animals
bloadFromdp =1;

condCell.condGroup = {[1 2 3]}; % group Stimulations conditions accordingly
condCell.condGroupDescr = '[1 2 3]';

s_loadMultipleHelper


[performance_before_surgery, mean_performance_before_surgery] = getGroupPerformance(dpAnimalCell);


%%

A = {'fi12_1016_after_surgery','fi12_1142_after_surgery','fi12_1018_after_surgery'};
r = brigdefs;
groupsavefile = 'after_surgery';
%groupsavefile = fullfile(r.Dir.dropboxtemp,'Sert868sub')

% A = {'sert1421stim','sert1422stim'};
% groupsavefile = 'sertCtrlData';
bAcrossAnimals = 0; % set to 1 to get the average across animals
bloadFromdp =1;

condCell.condGroup = {[1 2 3]}; % group Stimulations conditions accordingly
condCell.condGroupDescr = '[1 2 3]';

s_loadMultipleHelper



[performance_after_surgery, mean_performance_after_surgery] = getGroupPerformance(dpAnimalCell);


%%

A = {'fi12_1446_stim','fi12_974_stim','fi12_1293_stim'};
r = brigdefs;
groupsavefile = 'stim_on';
%groupsavefile = fullfile(r.Dir.dropboxtemp,'Sert868sub')

% A = {'sert1421stim','sert1422stim'};
% groupsavefile = 'sertCtrlData';
bAcrossAnimals = 0; % set to 1 to get the average across animals
bloadFromdp =1;

condCell.condGroup = {[1 2 3]}; % group Stimulations conditions accordingly
condCell.condGroupDescr = '[1 2 3]';

s_loadMultipleHelper



[performance_stim_on, mean_performance_stim_on]= getGroupPerformance(dpAnimalCell);

 
        
%%


h = figure
set(h, 'WindowStyle', 'docked');


plot([1:6],mean_performance_before_surgery,'o-k','linewidth',3)

hold on

plot([1:6],mean_performance_after_surgery,'o-g','linewidth',3)

hold on

plot([1:6],mean_performance_stim_on,'o-r','linewidth',3)
hold on

plot([1,6], [0.5,0.5],'--b','linewidth',2)


set(gca, 'TickDir', 'out','FontSize',14)
axis square

xlim([1 length(mean_performance_stim_on)])
xlabel('number sessions','FontSize',14); 
ylabel('performance', 'FontSize',14);
set(gca,'XTickLabel',['1';' ';'2';' ';'3';' ';'4';' ';'5';' ';'6'])

title('ArchT mystery') 

legend('Before Surgery','After surgery','Stim on')
       
        
        