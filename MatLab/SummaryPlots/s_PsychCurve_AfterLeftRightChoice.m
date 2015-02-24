%% trial after Errors and correct on side
clear cond
cond.condGroup = {[1 2 3]}; % group Stimulations conditions accordingly
cond.condGroupDescr = '[1 2 3]';

options.savefileHeader = 'UPDATING_TrialAfterCorrectLongOrShort';
cond(1).filter = {'stimulationOnCond',0,'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
cond(1).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[0],'ChoiceCorrect', [ 1],'ChoiceLeft',1}};
cond(1).color = 'r';
cond(1).desc = 't-1 Correct Long';

cond(2).filter = {'stimulationOnCond',0,'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
cond(2).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[0],'ChoiceCorrect', [ 1],'ChoiceLeft',0}};
cond(2).color = 'g';
cond(2).desc = 't-1 Correct short';

plotMLEfit(thisAnimal,cond,fitFunction,free_parameters,options)

options.savefileHeader = 'UPDATING_TrialAfterErrorLongOrShort';
cond(1).filter = {'stimulationOnCond',0,'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
cond(1).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[0],'ChoiceCorrect', [ 0],'ChoiceLeft',1}};
cond(1).color = 'r';
cond(1).desc = 't-1 Error Long';

cond(2).filter = {'stimulationOnCond',0,'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
cond(2).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[0],'ChoiceCorrect', [ 0],'ChoiceLeft',0}};
cond(2).color = 'g';
cond(2).desc = 't-1 Error short';

plotMLEfit(thisAnimal,cond,fitFunction,free_parameters,options)
