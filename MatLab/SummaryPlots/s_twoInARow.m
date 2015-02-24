clear cond
% test whether the is a learning effect that require stimulation on the
% current trial
% i.e. the animal learns that to go Short in the Presence of light.
bCorrectTrialsBefore = 1;

cond.condGroup = {[1 2 3]}; % group Stimulations conditions accordingly
cond.condGroupDescr = '[1 2 3]';
free_parameters = {'none','all','u','bias'};
options.savefileHeader = 'StimAfterCorrectStimShort';
cond(1).filter = {'stimulationOnCond',[1 2 3],'ChoiceCorrect', [0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
cond(1).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[0],'ChoiceLeft',0,'ChoiceCorrect', [bCorrectTrialsBefore]}};
cond(1).color = 'k';
cond(1).desc = 't-1, nostim Short';

cond(2).filter = {'stimulationOnCond',[1 2 3],'ChoiceCorrect', [0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
cond(2).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[1 2 3],'ChoiceLeft',0,'ChoiceCorrect', [ bCorrectTrialsBefore]}};
cond(2).color = 'b';
cond(2).desc = 't-1, stim Short';

plotMLEfit(thisAnimal,cond,'logistic',free_parameters,options)

options.savefileHeader = 'StimAfterCorrectStimLong';

cond(1).filter = {'stimulationOnCond',[1 2 3],'ChoiceCorrect', [0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
cond(1).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[0],'ChoiceLeft',1,'ChoiceCorrect', [ bCorrectTrialsBefore]}};
cond(1).color = 'k';
cond(1).desc = 't-1, nostim Long';

cond(2).filter = {'stimulationOnCond',[1 2 3],'ChoiceCorrect', [0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
cond(2).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[1 2 3],'ChoiceLeft',1,'ChoiceCorrect', [ bCorrectTrialsBefore]}};
cond(2).color = 'b';
cond(2).desc = 't-1, stim Long';
plotMLEfit(thisAnimal,cond,'logistic',free_parameters,options);