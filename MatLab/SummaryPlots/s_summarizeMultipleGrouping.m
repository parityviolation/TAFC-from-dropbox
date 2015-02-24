
A = {'sert867_3freq'};
spower = '10mW'
% A = {'sert864_3freq'};
% spower = '7mW'
%  A = {'sert868_3freq'};
%  spower = '6mW';

%%
% cond.condGroup = {1 2 3}; % group Stimulations conditions accordingly
% cond.condGroupDescr = [spower ' 12 25 40Hz'];
% % changes in basic parameters evoked by stimulation
% dpArray = plotSimplePsycAcrDays(A,cond);
% 
% cond.condGroup = {[1 2] 3}; % group Stimulations conditions accordingly
% cond.condGroupDescr = [spower ' [12 25] 40Hz'];
% % changes in basic parameters evoked by stimulation
% dpArray = plotSimplePsycAcrDays(A,cond);
% 
% cond.condGroup = {1 [2 3]}; % group Stimulations conditions accordingly
% cond.condGroupDescr =  [spower '12 [25 40]Hz'];
% % changes in basic parameters evoked by stimulation
% dpArray = plotSimplePsycAcrDays(A,cond);

cond.condGroup = {[1 2 3]}; % group Stimulations conditions accordingly
cond.condGroupDescr =  [spower '[12 25 40]Hz'];
% changes in basic parameters evoked by stimulation
dpArray = plotSimplePsycAcrDays(A,cond);
plotPsycAcrDays(dpArray)
plotsummPreMatureEtc(dpArray);
% plotPsycTrialAfterStimulation(dpArray); % NOT WORKNING>
% plotUpdating(dpArray);

%%
% todo:
% Average (all sessions) 

% FACTS
% initially variable effect
% consistent effect
% lost of effect?

% Analysis

correlect effect with performance
pick first half last half of session.

do block triggered average


