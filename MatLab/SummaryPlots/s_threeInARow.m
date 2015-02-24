clear cond
cond.condGroup = {[1 2 3]}; % group Stimulations conditions accordingly
cond.condGroupDescr = '[1 2 3]';
free_parameters = {'none','all','u','bias'};
options.savefileHeader = 'Stim3TrialsInARowShort';
cond(1).filter = {'stimulationOnCond',[1 2 3],'ChoiceCorrect', [0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
cond(1).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[0],'ChoiceLeft',0,'ChoiceCorrect', [1]},{-2,'stimulationOnCond',0,'ChoiceLeft',0,'ChoiceCorrect', [1]}};
cond(1).color = 'k';
cond(1).desc = 't-1,t-2 nostim Short';

cond(2).filter = {'stimulationOnCond',[1 2 3],'ChoiceCorrect', [0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
cond(2).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[1 2 3],'ChoiceLeft',0,'ChoiceCorrect', [1]},{-2,'stimulationOnCond',[1 2 3],'ChoiceLeft',0,'ChoiceCorrect', [1]}};
cond(2).color = 'b';
cond(2).desc = 't-1,t-2 stim Short';

plotMLEfit(dpArray,cond,'logistic',free_parameters,options)

options.savefileHeader = 'Stim3TrialsInARowLong';

cond(1).filter = {'stimulationOnCond',[1 2 3],'ChoiceCorrect', [0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
cond(1).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[0],'ChoiceLeft',1,'ChoiceCorrect', [1]},{-2,'stimulationOnCond',0,'ChoiceLeft',0,'ChoiceCorrect', [1]}};
cond(1).color = 'k';
cond(1).desc = 't-1,t-2 nostim Long';

cond(2).filter = {'stimulationOnCond',[1 2 3],'ChoiceCorrect', [0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
cond(2).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[1 2 3],'ChoiceLeft',1,'ChoiceCorrect', [ 1]},{-2,'stimulationOnCond',[1 2 3],'ChoiceLeft',0,'ChoiceCorrect', [1]}};
cond(2).color = 'b';
cond(2).desc = 't-1,t-2 stim Long';
plotMLEfit(dpArray,cond,'logistic',free_parameters,options);