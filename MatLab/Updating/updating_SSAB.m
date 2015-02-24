function updating_SSAB(varargin,stim)
% 

% STRUCTURE OF THE UPDATING MATRIX
% (:,1,1) = (numtrials,stimVector,ongoing trials)
% (:,2,1) = (numtrials,choiceCorr,ongoing trials)
% (:,4,1) = (numtrials,SRD,ongoing trials)
% (:,5,1) = (numtrials,stimOn,ongoing trials)
% 
% (:,:,2) = same as dimension 1 but with data from the previous trial


dataParsed = varargin{1};
%dataParsed = dstruct.dataParsed;

clear matrix_upd;

stimVector = dataParsed.Interval;
stimSet = dataParsed.IntervalSet;
choiceLong = dataParsed.ChoiceLeft;
choiceCorr = dataParsed.ChoiceCorrect;
SRD = dataParsed.StimRwdDelay;
stimOn = dataParsed.stimulationOnCond;
prem = dataParsed.Premature;
premLong = dataParsed.PrematureLong;

matrix_upd = nan(dataParsed.ntrials,4,2);
matrix_upd(:,1,1) = stimVector';
matrix_upd(:,2,1) = choiceLong';
matrix_upd(:,3,1) = choiceCorr';
matrix_upd(:,4,1) = SRD';
matrix_upd(:,5,1) = stimOn';

matrix_upd(2:end,:,2)= matrix_upd(1:end-1,:,1);
matrix_upd = matrix_upd(2:end,:,:);

i = length(stimSet)/2;
bias_dif = nan(i,length(stimSet));
bias_difc = bias_dif;
bias_difi = bias_dif;
bias_dif_stim = nan(i,2);

trials_pre_stim = matrix_upd(matrix_upd(:,5,2)==1,:,:);
trials_pre_nostim = matrix_upd(isnan(matrix_upd(:,5,2)),:,:);


for a = 1:i
    
data_dif_stim = trials_pre_nostim(trials_pre_nostim(:,1,1)==stimSet(a)|trials_pre_nostim(:,1,1)==stimSet(end-a+1),:);  
data_dif_stim_short = length(data_dif_stim(data_dif_stim(:,1,1)==stimSet(a) & data_dif_stim(:,3,1)==0))/length(data_dif_stim(data_dif_stim(:,1,1)==stimSet(a))); % Fraction of errors to one side
data_dif_stim_long = length(data_dif_stim(data_dif_stim(:,1,1)==stimSet(end-a+1) & data_dif_stim(:,3,1)==0))/length(data_dif_stim(data_dif_stim(:,1,1)==stimSet(end-a+1))); % Fraction of errors to one side
bias_dif_stim(a,1) =  data_dif_stim_long - data_dif_stim_short; % Bias on trials preceded by stim s, for stimuli in pairs of different difficulties
end  

for a = 1:i
    
data_dif_stim = trials_pre_stim(trials_pre_stim(:,1,1)==stimSet(a)|trials_pre_stim(:,1,1)==stimSet(end-a+1),:);  
data_dif_stim_short = length(data_dif_stim(data_dif_stim(:,1,1)==stimSet(a) & data_dif_stim(:,3,1)==0))/length(data_dif_stim(data_dif_stim(:,1,1)==stimSet(a))); % Fraction of errors to one side
data_dif_stim_long = length(data_dif_stim(data_dif_stim(:,1,1)==stimSet(end-a+1) & data_dif_stim(:,3,1)==0))/length(data_dif_stim(data_dif_stim(:,1,1)==stimSet(end-a+1))); % Fraction of errors to one side
bias_dif_stim(a,2) =  data_dif_stim_long - data_dif_stim_short; % Bias on trials preceded by stim s, for stimuli in pairs of different difficulties
end    


for s = 1:length(stimSet)
    %filters trials preceded by conditions    
    trials_pre_s = matrix_upd(matrix_upd(:,1,2)==stimSet(s),:,:);   % Filters trials preceded by stimulus 's'
    trials_pre_sc = matrix_upd(matrix_upd(:,1,2)==stimSet(s) & matrix_upd(:,3,2)==1,:,:);  % Filters trials preceded by stimulus 's' that were correct
    trials_pre_si = matrix_upd(matrix_upd(:,1,2)==stimSet(s) & matrix_upd(:,3,2)==0,:,:);  % Filters trials preceded by stimulus 's' that were incorrect
    
    for a = 1:i %runs this loop for i pairs of stimulus difficulty
   
    %filters trials by dificulty    
    data_dif = trials_pre_s(trials_pre_s(:,1,1)==stimSet(a)|trials_pre_s(:,1,1)==stimSet(end-a+1),:);     % Filters trials_pre_s by dificulty in pairs
    data_difc = trials_pre_sc(trials_pre_sc(:,1,1)==stimSet(a)|trials_pre_sc(:,1,1)==stimSet(end-a+1),:);     % Filters trials_pre_sc by dificulty in pairs
    data_difi = trials_pre_si(trials_pre_si(:,1,1)==stimSet(a)|trials_pre_si(:,1,1)==stimSet(end-a+1),:);     % Filters trials_pre_si by dificulty in pairs    
    
    %calculate biases short/long
    
    data_dif_short = length(data_dif(data_dif(:,1,1)==stimSet(a) & data_dif(:,3,1)==0))/length(data_dif(data_dif(:,1,1)==stimSet(a))); % Fraction of errors to one side
    data_dif_long = length(data_dif(data_dif(:,1,1)==stimSet(end-a+1) & data_dif(:,3,1)==0))/length(data_dif(data_dif(:,1,1)==stimSet(end-a+1))); % Fraction of errors to another side
    bias_dif(a,s) = data_dif_long - data_dif_short; % Bias on trials preceded by stim s, for stimuli in pairs of different difficulties
    
    data_difc_short = length(data_difc(data_difc(:,1,1)==stimSet(a) & data_difc(:,3,1)==0))/length(data_difc(data_difc(:,1,1)==stimSet(a))); % Fraction of errors to one side
    data_difc_long = length(data_difc(data_difc(:,1,1)==stimSet(end-a+1) & data_difc(:,3,1)==0))/length(data_difc(data_difc(:,1,1)==stimSet(end-a+1))); % Fraction of errors to another side
    bias_difc(a,s) = data_difc_long - data_difc_short; % Bias on trials preceded by stim s, for stimuli in pairs of different difficulties
    
    data_difi_short = length(data_difi(data_difi(:,1,1)==stimSet(a) & data_difi(:,3,1)==0))/length(data_difi(data_difi(:,1,1)==stimSet(a))); % Fraction of errors to one side
    data_difi_long = length(data_difi(data_difi(:,1,1)==stimSet(end-a+1) & data_difi(:,3,1)==0))/length(data_difi(data_difi(:,1,1)==stimSet(end-a+1))); % Fraction of errors to another side
    bias_difi(a,s) = data_difi_long - data_difi_short; % Bias on trials preceded by stim s, for stimuli in pairs of different difficulties
    
    
    end
end


%Effect of previous trial on choice
  color = copper(i);
    h = figure;
    hold on
    for a = 1:i
        plot(stimSet,(bias_dif(a,:)-nanmean(bias_dif(a,:))),'color',color(a,:),'MarkerSize',20,'LineWidth',3)
        %         plot(stimSet,bias(i,:),'color',color(i,:),'MarkerSize',20,'LineWidth',3)
    end
    axis([0 1 -1 1]), % set(h,'Name',['Rat ' smatrix{1,1} ', under ' smatrix{1,4} ' on ' smatrix{1,3}]),title(get(h,'Name'));
    xlabel('Stim duration at previous trial (S_t_-_1)')
    ylabel('Bias')
    legend 'very easy' 'easy' 'difficult' 'very difficult'
    legend boxoff
    title('Effect of previous trial on choice')
    
    clear h

%Effect of previous correct trial on choice

    color = copper(i);
    h = figure;
    hold on
    for a = 1:i
        plot(stimSet,(bias_difc(a,:)-nanmean(bias_difc(a,:))),'color',color(a,:),'MarkerSize',20,'LineWidth',3)
        %         plot(stimSet,bias(i,:),'color',color(i,:),'MarkerSize',20,'LineWidth',3)
    end
    axis([0 1 -1 1]), % set(h,'Name',['Rat ' smatrix{1,1} ', under ' smatrix{1,4} ' on ' smatrix{1,3}]),title(get(h,'Name'));
    xlabel('Stim duration at previous correct trial (S_t_-_1)')
    ylabel('Bias')
    legend 'very easy' 'easy' 'difficult' 'very difficult'
    legend boxoff
    title('Effect of previous correct trial on choice')
    
    clear h

%Effect of previous incorrect trial on choice

    color = copper(i);
    h = figure;
    hold on
    for a = 1:i
        plot(stimSet,(bias_difi(a,:)-nanmean(bias_difi(a,:))),'color',color(a,:),'MarkerSize',20,'LineWidth',3)
        %         plot(stimSet,bias(i,:),'color',color(i,:),'MarkerSize',20,'LineWidth',3)
    end
    axis([0 1 -1 1]), % set(h,'Name',['Rat ' smatrix{1,1} ', under ' smatrix{1,4} ' on ' smatrix{1,3}]),title(get(h,'Name'));
    xlabel('Stim duration at previous incorrect trial (S_t_-_1)')
    ylabel('Bias')
    legend 'very easy' 'easy' 'difficult' 'very difficult'
    legend boxoff
    title('Effect of previous incorrect trial on choice')
    
    clear h

%Effect of previous stimulated trial on choice

    color = copper(i);
    h = figure;
    hold on
    for a = 1:i
        plot([0 1],(bias_dif_stim(a,:)-nanmean(bias_dif_stim(a,:))),'color',color(a,:),'MarkerSize',20,'LineWidth',3)
        %         plot(stimSet,bias(i,:),'color',color(i,:),'MarkerSize',20,'LineWidth',3)
    end
    axis([0 1 -1 1]), % set(h,'Name',['Rat ' smatrix{1,1} ', under ' smatrix{1,4} ' on ' smatrix{1,3}]),title(get(h,'Name'));
    xlabel('Non stimulated(0) or stimulated(1) trial (S_t_-_1)')
    ylabel('Bias')
    legend 'very easy' 'easy' 'difficult' 'very difficult'
    legend boxoff
    title('Effect of previous stimulated trial on choice')
    
    clear h




end