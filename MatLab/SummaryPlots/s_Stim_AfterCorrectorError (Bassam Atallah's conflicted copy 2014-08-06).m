% test stimulation on CURRENT TRIAL effect after last is left/ right correct
 %%% Trial AFter Correct short/long

options.savefileHeader = 'StimnONTrial_AfterCorrectShort';
cond(1).filter = {'stimulationOnCond',0,'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
cond(1).trialRelativeSweepfilter = {{-1,'ChoiceCorrect', [ 1],'ChoiceLeft',0}};
cond(1).color = 'k';
cond(1).desc = 'ctrl';

cond(2).filter = {'stimulationOnCond',[1 2 3],'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
cond(2).trialRelativeSweepfilter = {{-1,'ChoiceCorrect', [ 1],'ChoiceLeft',0}};
cond(2).color = 'b';
cond(2).desc = 'stim t-1';

plotMLEfit(thisAnimal,cond,fitFunction,free_parameters,options)

options.savefileHeader = 'StimnONTrial_AfterCorrectLong';
cond(1).filter = {'stimulationOnCond',0,'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
cond(1).trialRelativeSweepfilter = {{-1,'ChoiceCorrect', [ 1],'ChoiceLeft',1}};
cond(1).color = 'k';
cond(1).desc = 'ctrl';

cond(2).filter = {'stimulationOnCond',[1 2 3],'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
cond(2).trialRelativeSweepfilter = {{-1,'ChoiceCorrect', [ 1],'ChoiceLeft',1}};
cond(2).color = 'b';
cond(2).desc = 'stim t-1';

plotMLEfit(thisAnimal,cond,fitFunction,free_parameters,options)

 %%% Trial AFter ERROR short/long

options.savefileHeader = 'StimnONTrial_AfterErrorShort';
cond(1).filter = {'stimulationOnCond',0,'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
cond(1).trialRelativeSweepfilter = {{-1,'ChoiceCorrect', [ 0],'ChoiceLeft',0}};
cond(1).color = 'k';
cond(1).desc = 'ctrl';

cond(2).filter = {'stimulationOnCond',[1 2 3],'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
cond(2).trialRelativeSweepfilter = {{-1,'ChoiceCorrect', [0],'ChoiceLeft',0}};
cond(2).color = 'b';
cond(2).desc = 'stim t-1';

plotMLEfit(thisAnimal,cond,fitFunction,free_parameters,options)

options.savefileHeader = 'StimnONTrial_AfterErrorLong';
cond(1).filter = {'stimulationOnCond',0,'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
cond(1).trialRelativeSweepfilter = {{-1,'ChoiceCorrect', [ 0],'ChoiceLeft',1}};
cond(1).color = 'k';
cond(1).desc = 'ctrl';

cond(2).filter = {'stimulationOnCond',[1 2 3],'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
cond(2).trialRelativeSweepfilter = {{-1,'ChoiceCorrect', [ 0],'ChoiceLeft',1}};
cond(2).color = 'b';
cond(2).desc = 'stim t-1';

plotMLEfit(thisAnimal,cond,fitFunction,free_parameters,options)

