% A = {'Sert864_lgcl'};
% A = {'Sert867_lgcl'};
% %   A = {'Sert868_lgcl'};
% A= {'sert_3freq'};
%  A= {'fi12_1020_3freq_all'};
 A= {'fi12_1013_3freq_all'};
%A= {'sert864_since_retreat'};
cond.condGroup = {[1 2 3]}; % group Stimulations conditions accordingly
cond.condGroupDescr = '[1 2 3]';
%A= {'sert868_3freq'};
% % A= {'sert_lgcl'}
% changes in basic parameters evoked by stimulation
%  dpArray = plotSimplePsycAcrDays(A,cond);
% dpArray = plotPsycAcrDays(A,cond);
% dpArray = plotRankOrder(A);
% dpArray = plotPsycAcrDays(A);
%dpArray = plotRankOr der(A,cond);

%%
dpArray = plotsummPreMatureEtc(A,cond);
plotPsycTrialAfterStimulation(dpArray);
% plotUpdating(dpArray);
free_parameters = {'none','all','slope','bias'};
plotMLEfit(dpArray,[],'logistic',free_parameters)
plotLogisticReg(dpArray);
% plotMLEfit(dpArray)
plotHistoryStimulation(dpArray);

