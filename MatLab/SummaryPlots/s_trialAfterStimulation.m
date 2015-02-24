fitFunction = 'logistic';
clear cond
cond.condGroup = {[1 2 3]}; % group Stimulations conditions accordingly
cond.condGroupDescr = '[1 2 3]';

options.savefileHeader = 'TrialAfterStim';
cond(1).filter = {'stimulationOnCond',0,'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
cond(1).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[0]}};
cond(1).color = 'k';
cond(1).desc = 'ctrl';

cond(2).filter = {'stimulationOnCond',0,'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
cond(2).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[1 2 3]}};
cond(2).color = [0.5 0.5 0.5];
cond(2).desc = 'stim t-1';

% cond(3).filter = {'stimulationOnCond',[1 2 3],'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
% cond(3).trialRelativeSweepfilter = {};
% cond(3).color = 'c';
% cond(3).desc = 'stim';

plotMLEfit(thisAnimal,cond,fitFunction,free_parameters,options)

if 0
    %%% Trial AFter Correct short/long
    
    options.savefileHeader = 'TrialAfterStimAndCorrectShort';
    cond(1).filter = {'stimulationOnCond',0,'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
    cond(1).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[0],'ChoiceCorrect', [ 1],'ChoiceLeft',0}};
    cond(1).color = 'k';
    cond(1).desc = 'ctrl';
    
    cond(2).filter = {'stimulationOnCond',0,'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
    cond(2).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[1 2 3],'ChoiceCorrect', [ 1],'ChoiceLeft',0}};
    cond(2).color = 'b';
    cond(2).desc = 'stim t-1';
    
    plotMLEfit(thisAnimal,cond,fitFunction,free_parameters,options)
    
    options.savefileHeader = 'TrialAfterStimAndCorrectLong';
    cond(1).filter = {'stimulationOnCond',0,'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
    cond(1).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[0],'ChoiceCorrect', [ 1],'ChoiceLeft',1}};
    cond(1).color = 'k';
    cond(1).desc = 'ctrl';
    
    cond(2).filter = {'stimulationOnCond',0,'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
    cond(2).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[1 2 3],'ChoiceCorrect', [ 1],'ChoiceLeft',1}};
    cond(2).color = 'b';
    cond(2).desc = 'stim t-1';
    
    plotMLEfit(thisAnimal,cond,fitFunction,free_parameters,options)
    
    %%% Trial AFter ERROR short/long
    
    options.savefileHeader = 'TrialAfterStimAndErrorShort';
    cond(1).filter = {'stimulationOnCond',0,'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
    cond(1).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[0],'ChoiceCorrect', [ 0],'ChoiceLeft',0}};
    cond(1).color = 'k';
    cond(1).desc = 'ctrl';
    
    cond(2).filter = {'stimulationOnCond',0,'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
    cond(2).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[1 2 3],'ChoiceCorrect', [0],'ChoiceLeft',0}};
    cond(2).color = 'b';
    cond(2).desc = 'stim t-1';
    
    plotMLEfit(thisAnimal,cond,fitFunction,free_parameters,options)
    
    options.savefileHeader = 'TrialAfterStimAndErrorLong';
    cond(1).filter = {'stimulationOnCond',0,'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
    cond(1).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[0],'ChoiceCorrect', [ 0],'ChoiceLeft',1}};
    cond(1).color = 'k';
    cond(1).desc = 'ctrl';
    
    cond(2).filter = {'stimulationOnCond',0,'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
    cond(2).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[1 2 3],'ChoiceCorrect', [ 0],'ChoiceLeft',1}};
    cond(2).color = 'b';
    cond(2).desc = 'stim t-1';
    
    plotMLEfit(thisAnimal,cond,fitFunction,free_parameters,options)
    
end