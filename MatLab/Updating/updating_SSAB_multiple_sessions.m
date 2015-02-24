
% STRUCTURE OF THE UPDATING MATRIX
% (:,1,1) = (numtrials,stimVector,ongoing trials)
% (:,2,1) = (numtrials,choiceCorr,ongoing trials)
% (:,4,1) = (numtrials,SRD,ongoing trials)
% (:,5,1) = (numtrials,stimOn,ongoing trials)
%
% (:,:,2) = same as dimension 1 but with data from the previous trial
% close all;clear all;
function plotUpdating(getAnimalcellString,bstimulation)
% function plotUpdating(getAnimalcellString,bstimulation)
if nargin < 2
    bstimulation = 1;
end
bsave = 1;
rd = brigdefs;

% A = {};
% 
% % A(end+1) = {'Sert_864'};
% % A(end+1) = {'Sert_867'};
% % A(end+1) = {'Sert_868'};
% A(end+1) = {'fi12_1013_3freq'};
A{1} = getAnimalcellString;

stext = ''; nAnimal = {};

for ianimal =1:length(A)
    
    [exptnames trials] = getStimulatedExptnames(A{ianimal});
    dpArray = constructDataParsedArray(exptnames, trials);
    
end

stimSet = dpArray(1).IntervalSet;

trials_pre_stim = [];
trials_pre_nostim = [];
for s = 1:length(stimSet)
    trials_pre_s{s} = [];
    trials_pre_sc{s}= [];
    trials_pre_si{s}= [];
    trials_pre_s_stim{s} = [];
    trials_pre_sc_stim{s}= [];
    trials_pre_si_stim{s}= [];
    trials_pre_s_nostim{s} = [];
    trials_pre_sc_nostim{s}= [];
    trials_pre_si_nostim{s}= [];
    
end

for idpArray =1:length(dpArray)
    
    clear matrix_upd;
    
    stimVector = dpArray(idpArray).Interval;
    choiceLong = dpArray(idpArray).ChoiceLeft;
    choiceCorr = dpArray(idpArray).ChoiceCorrect;
    SRD = dpArray(idpArray).StimRwdDelay;
    prem = dpArray(idpArray).Premature;
    premLong = dpArray(idpArray).PrematureLong;
    
    
    matrix_upd = nan(dpArray(idpArray).ntrials,4,2);
    matrix_upd(:,1,1) = stimVector';
    matrix_upd(:,2,1) = choiceLong';
    matrix_upd(:,3,1) = choiceCorr';
    matrix_upd(:,4,1) = SRD';
    
    if bstimulation
        stimOn = dpArray(idpArray).stimulationOnCond;
        matrix_upd(:,5,1) = stimOn';
    end
    
    matrix_upd(2:end,:,2)= matrix_upd(1:end-1,:,1);
    matrix_upd = matrix_upd(2:end,:,:);
    
    
    if bstimulation
        trials_pre_stim = vertcat(trials_pre_stim, matrix_upd(matrix_upd(:,5,2)==1,:,1));
        trials_pre_nostim = vertcat(trials_pre_nostim, matrix_upd(matrix_upd(:,5,2)==0,:,1));
        
    end
    
    
    for s = 1:length(stimSet)
        
        %filters trials preceded by conditions
        trials_pre_s{s} = vertcat(trials_pre_s{s}, matrix_upd(matrix_upd(:,1,2)==stimSet(s),:,1));   % Filters trials preceded by stimulus 's'
        trials_pre_sc{s} = vertcat(trials_pre_sc{s}, matrix_upd(matrix_upd(:,1,2)==stimSet(s) & matrix_upd(:,3,2)==1,:,:));  % Filters trials preceded by stimulus 's' that were correct
        trials_pre_si{s} = vertcat(trials_pre_si{s}, matrix_upd(matrix_upd(:,1,2)==stimSet(s) & matrix_upd(:,3,2)==0,:,:));  % Filters trials preceded by stimulus 's' that were incorrect
        if bstimulation
            
            trials_pre_s_stim{s} = vertcat(trials_pre_s_stim{s}, matrix_upd(matrix_upd(:,1,2)==stimSet(s)& matrix_upd(:,5,2)==1,:,1));   % Filters trials preceded by stimulus 's' and bstimulation on
            trials_pre_sc_stim{s} = vertcat(trials_pre_sc_stim{s}, matrix_upd(matrix_upd(:,1,2)==stimSet(s) & matrix_upd(:,3,2)==1 & matrix_upd(:,5,2)==1,:,:));  % Filters trials preceded by stimulus 's' that were correct and bstimulation on
            trials_pre_si_stim{s} = vertcat(trials_pre_si_stim{s}, matrix_upd(matrix_upd(:,1,2)==stimSet(s) & matrix_upd(:,3,2)==0 & matrix_upd(:,5,2)==1,:,:));  % Filters trials preceded by stimulus 's' that were incorrect and bstimulation on
            
            trials_pre_s_nostim{s} = vertcat(trials_pre_s_nostim{s}, matrix_upd(matrix_upd(:,1,2)==stimSet(s)& matrix_upd(:,5,2)==0,:,1));   % Filters trials preceded by stimulus 's' and bstimulation off
            trials_pre_sc_nostim{s} = vertcat(trials_pre_sc_nostim{s}, matrix_upd(matrix_upd(:,1,2)==stimSet(s) & matrix_upd(:,3,2)==1 & matrix_upd(:,5,2)==0,:,:));  % Filters trials preceded by stimulus 's' that were correct and bstimulation off
            trials_pre_si_nostim{s} = vertcat(trials_pre_si_nostim{s}, matrix_upd(matrix_upd(:,1,2)==stimSet(s) & matrix_upd(:,3,2)==0 & matrix_upd(:,5,2)==0,:,:));  % Filters trials preceded by stimulus 's' that were incorrect and bstimulation off
            
        end
        
    end
    
end

i = length(stimSet)/2;
bias_dif = nan(i,length(stimSet));
bias_difc = bias_dif;
bias_difi = bias_dif;


if bstimulation
    
    bias_dif_stim(:,1) = calculateBias(dpArray,1,trials_pre_nostim);
    bias_dif_stim(:,2) = calculateBias(dpArray,1,trials_pre_stim);
    
end


for s = 1:length(stimSet)
    
    %calculate biases short/long
    bias_dif(:,s) = calculateBias(dpArray,1,trials_pre_s{s});
    bias_difc(:,s) = calculateBias(dpArray,1,trials_pre_sc{s});
    bias_difi(:,s) = calculateBias(dpArray,1,trials_pre_si{s});
    
    [bias_dif_all_stim(:,s), numTrials_pre_s_stim(s)] = calculateBias(dpArray,0,trials_pre_s_stim{s});
    [bias_dif_all_nostim(:,s), numTrials_pre_s_nostim(s)] = calculateBias(dpArray,0,trials_pre_s_nostim{s});

    [bias_difc_stim(:,s), numTrials_pre_sc_stim(s)] = calculateBias(dpArray,0,trials_pre_sc_stim{s});
    [bias_difc_nostim(:,s), numTrials_pre_sc_nostim(s)] = calculateBias(dpArray,0,trials_pre_sc_nostim{s});
    
    [bias_difi_stim(:,s), numTrials_pre_si_stim(s)] = calculateBias(dpArray,0,trials_pre_si_stim{s});
    [bias_difi_nostim(:,s), numTrials_pre_si_nostim(s)] = calculateBias(dpArray,0,trials_pre_si_nostim{s});

    
end

numTrials_pre_s_stim = sum(numTrials_pre_s_stim);
numTrials_pre_s_nostim = sum(numTrials_pre_s_nostim);

numTrials_pre_sc_stim = sum(numTrials_pre_sc_stim);
numTrials_pre_sc_nostim = sum(numTrials_pre_sc_nostim);


numTrials_pre_si_stim = sum(numTrials_pre_si_stim);
numTrials_pre_si_nostim = sum(numTrials_pre_si_nostim);




%% --------------------------------------Ploting--------------------------------------------------------
saveFigPath = fullfile(rd.Dir.SummaryFig ,'Updating', dpArray(1).Animal);
mkdir(saveFigPath);

%Effect of previous trial on choice
color = copper(i);
h = figure;
set(h,'NumberTitle','off','Name',['Updating ' num2str(dpArray(1).Animal)]);
subplot(2,2,1)
hold on
for a = 1:i
    plot(stimSet,(bias_dif(a,:)-nanmean(bias_dif(a,:))),'color',color(a,:),'MarkerSize',20,'LineWidth',3)
    %         plot(stimSet,bias(i,:),'color',color(i,:),'MarkerSize',20,'LineWidth',3)
end
axis([0 1 -1 1]), % set(h,'Name',['Rat ' smatrix{1,1} ', under ' smatrix{1,4} ' on ' smatrix{1,3}]),title(get(h,'Name'));
xlabel('Stim duration at previous trial (S_t_-_1)')
ylabel('Bias')
% legend 'very easy' 'easy' 'difficult' 'very difficult'
% legend boxoff
title('Effect of previous trial on choice')

%Effect of previous correct trial on choice

color = copper(i);
subplot(2,2,2)
hold on
for a = 1:i
    plot(stimSet,(bias_difc(a,:)-nanmean(bias_difc(a,:))),'color',color(a,:),'MarkerSize',20,'LineWidth',3)
    %         plot(stimSet,bias(i,:),'color',color(i,:),'MarkerSize',20,'LineWidth',3)
end
axis([0 1 -1 1]), % set(h,'Name',['Rat ' smatrix{1,1} ', under ' smatrix{1,4} ' on ' smatrix{1,3}]),title(get(h,'Name'));
xlabel('Stim duration at previous correct trial (S_t_-_1)')
ylabel('Bias')
% legend 'very easy' 'easy' 'difficult' 'very difficult'
% legend boxoff
title('Effect of previous CORRECT trial on choice')

%Effect of previous incorrect trial on choice

color = copper(i);
subplot(2,2,3)
hold on
for a = 1:i
    plot(stimSet,(bias_difi(a,:)-nanmean(bias_difi(a,:))),'color',color(a,:),'MarkerSize',20,'LineWidth',3)
    %         plot(stimSet,bias(i,:),'color',color(i,:),'MarkerSize',20,'LineWidth',3)
end
axis([0 1 -1 1]), % set(h,'Name',['Rat ' smatrix{1,1} ', under ' smatrix{1,4} ' on ' smatrix{1,3}]),title(get(h,'Name'));
xlabel('Stim duration at previous error trial (S_t_-_1)')
ylabel('Bias')
legend 'very easy' 'easy' 'difficult' 'very difficult'
legend boxoff
title('Effect of previous ERROR trial on choice')

plotAnn(A{1});

if bsave
    savename = 'Effect of previous trial on choice';
    
    saveas(h, fullfile(saveFigPath, [A{1} '-' savename '.fig']));
    saveas(h, fullfile(saveFigPath, [A{1} '-' savename '.pdf']));
end

clear h


if bstimulation
    % %         Effect of previous stimulated trial on choice
    
    %         color = copper(i);
    %         h = figure;
    %         hold on
    %         for a = 1:i
    %             plot([0 1],(bias_dif_stim(a,:)-nanmean(bias_dif_stim(a,:))),'color',color(a,:),'MarkerSize',20,'LineWidth',3)
    %             %         plot(stimSet,bias(i,:),'color',color(i,:),'MarkerSize',20,'LineWidth',3)
    %         end
    %         axis([0 1 -1 1]), % set(h,'Name',['Rat ' smatrix{1,1} ', under ' smatrix{1,4} ' on ' smatrix{1,3}]),title(get(h,'Name'));
    %         xlabel('Non stimulated(0) or stimulated(1) trial (S_t_-_1)')
    %         ylabel('Bias')
    %         legend 'very easy' 'easy' 'difficult' 'very difficult'
    %         legend boxoff
    %         title('Effect of previous stimulated trial on choice')
    %
    %         savename = 'Effect of previous stimulated trial on choice';
    %
    %         saveas(h, fullfile(saveFigPath, [dpArray(1).Animal '-' savename '.fig']));
    %         saveas(h, fullfile(saveFigPath, [dpArray(1).Animal '-' savename '.pdf']));
    %
    %
    %         clear h
    %
    
    
    %Effect of previous correct trial on choice (stim vs. nostim)
    h = figure;
    set(h,'NumberTitle','off','Name',['Updating bstimulation' num2str(dpArray(1).Animal)]);

    hAx(1) = subplot(2,2,1);
    hold on
    
    hl(1) = line(stimSet,(bias_dif_all_stim(:)-nanmean(bias_dif_all_stim(:))),'color','b','MarkerSize',20,'LineWidth',3);
    hl(2) = line(stimSet,(bias_dif_all_nostim(:)-nanmean(bias_dif_all_nostim(:))),'color','k','MarkerSize',20,'LineWidth',3);
    sleg(1) = {sprintf('bstimulation = %d',numTrials_pre_s_stim ) };
    sleg(2) = {sprintf('no bstimulation = %d',numTrials_pre_s_nostim )};
    
    axis([0 1 -1 1]), % set(h,'Name',['Rat ' smatrix{1,1} ', under ' smatrix{1,4} ' on ' smatrix{1,3}]),title(get(h,'Name'));
    xlabel('Stim duration at previous  trial (S_t_-_1)')
    ylabel('Bias')
%     legend (hl,sleg)
%     legend boxoff
    title('Effect of previous trial on choice')
    
        subplot(2,2,2)
    hold on
    
    hl(1) = line(stimSet,(bias_difc_stim(:)-nanmean(bias_difc_stim(:))),'color','b','MarkerSize',20,'LineWidth',3);
    hl(2) = line(stimSet,(bias_difc_nostim(:)-nanmean(bias_difc_nostim(:))),'color','k','MarkerSize',20,'LineWidth',3);
    sleg(1) = {sprintf('bstimulation = %d',numTrials_pre_sc_stim ) };
    sleg(2) = {sprintf('no bstimulation = %d',numTrials_pre_sc_nostim )};
    
    axis([0 1 -1 1]), % set(h,'Name',['Rat ' smatrix{1,1} ', under ' smatrix{1,4} ' on ' smatrix{1,3}]),title(get(h,'Name'));
    xlabel('Stim duration at previous correct trial (S_t_-_1)')
    ylabel('Bias')
%     legend (hl,sleg)
%     legend boxoff
    title('Effect of previous CORRECT trial on choice')
    
    
        subplot(2,2,3)
    hold on
    
    hl(1) = line(stimSet,(bias_difi_stim(:)-nanmean(bias_difi_stim(:))),'color','b','MarkerSize',20,'LineWidth',3);
    hl(2) = line(stimSet,(bias_difi_nostim(:)-nanmean(bias_difi_nostim(:))),'color','k','MarkerSize',20,'LineWidth',3);
    sleg(1) = {sprintf('bstimulation = %d',numTrials_pre_si_stim ) };
    sleg(2) = {sprintf('no bstimulation = %d',numTrials_pre_si_nostim )};
    
    axis([0 1 -1 1]), % set(h,'Name',['Rat ' smatrix{1,1} ', under ' smatrix{1,4} ' on ' smatrix{1,3}]),title(get(h,'Name'));
    xlabel('Stim duration at previous error trial (S_t_-_1)')
    ylabel('Bias')
    legend (hl,sleg)
    legend boxoff
    title('Effect of previous ERROR trial on choice')
    
    
    
    plotAnn(A{1});
    
    if bsave
        savename = 'Effect of previous  trial on choice (stim vs no stim)';
        
        saveas(h, fullfile(saveFigPath, [A{1} '-' savename '.fig']));
        saveas(h, fullfile(saveFigPath, [A{1} '-' savename '.pdf']));
    end
    clear h

    
    
end

