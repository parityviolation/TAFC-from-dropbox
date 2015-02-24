% A = {'Sert864_all','Sert867_all','Sert868_all','Sert179'};
%groupsavefile = 'sertAllData';
% A = {'fi12_1013_3freq_all'};
 
A = {'fi12_1293_arch_lowpower'};
r = brigdefs;
groupsavefile = 'fi12_1293_arch_lowpower';
%groupsavefile = fullfile(r.Dir.dropboxtemp,'Sert868sub')

% A = {'sert1421stim','sert1422stim'};
% groupsavefile = 'sertCtrlData';
bAcrossAnimals = 0; % set to 1 to get the average across animals
bloadFromdp =1;

condCell.condGroup = {[1 2 3]}; % group Stimulations conditions accordingly
condCell.condGroupDescr = '[1 2 3]';

s_loadMultipleHelper



 %%
fitFunction = 'logistic';
free_parameters = {'none','all','l','bias','l slope','bias slope'};

for ianimal = 1:length(dpAnimalCell)
    %thisAnimal = dpAnimal{ianimal} ;
    thisAnimal = A(ianimal);
    disp(dpAnimalArray(1).Animal);
    
%     plotsummprematureetc(thisAnimal,[],options);
%     
    plotMLEfit(A,'default',fitFunction,free_parameters)
%     s_prematuretrials               % premature psychometric function
    
%     if ~bAcrossAnimals
% %         s_Stim_AfterCorrectorError
%         
%         s_trialafterstimulation         % pschcurves on tril after stim
%     %    s_psychcurve_afterleftrightchoice % get pschcurves depended on the choice on the last trial
%         % s_twoinarow                    %% pschcurves after 2 or 3 stimulatino in a row %  s_threeinarow %correct
%         
%         s_reactiontime                  % reaction time stim vs ctrl
%         plottrialInit(thisAnimal);
%     end
    
    if 0% OLD functions
        plotupdating(thisAnimal);
        plothistorystimulation(thisAnimal);
    end
end



%% individual session based plots

for ianimal = 1:iAnimal
    
    for isession = 1:size(dpAnimalCell{iAnimal},2)
        
        dp = dpAnimalCell{iAnimal}(1,isession);
        
        %cond 1 = current trial
        cond(1).nameA = 'Premature';
        cond(1).nameAval = 1;
        cond(1).filter = {cond(1).nameA, cond(1).nameAval};
        
        %,'controlLoop',@(x) isnan(x)|x==0
        
        %cond 2 = relative trial
        cond(1).nameB = 'ChoiceCorrect';
        cond(1).nameBval = 1;
        
        %number of relative trials back or forward, (negative - back)
        cond(1).nameC = 'relativeTrialNumber';
        cond(1).nameCval = -1;
        cond(1).trialRelativeSweepfilter = {cond(1).nameCval,cond(1).nameB,cond(1).nameBval};
        
        totalTrials(isession) = dp.totalTrials;
        dp1 = filtbdata(dp,0,cond(1).filter);
        dp2 = filtbdata(dp,0,cond(1).filter,cond(1).trialRelativeSweepfilter);
        trials1(isession) = dp1.ntrials;
        trials2(isession) = dp2.ntrials;
        
        
        
        %cond 1 = current trial
        cond(2).nameA = 'Premature';
        cond(2).nameAval = 1;
        cond(2).filter = {cond(2).nameA, cond(2).nameAval};
        
        %,'controlLoop',@(x) isnan(x)|x==0
        
        %cond 2 = relative trial
        cond(2).nameB = 'ChoiceCorrect';
        cond(2).nameBval = 0;
        
        cond(2).nameC = 'relativeTrialNumber';
        cond(2).nameCval = -1;
        cond(2).trialRelativeSweepfilter = {cond(2).nameCval,cond(2).nameB,cond(2).nameBval};
        
        dp3 = filtbdata(dp,0,cond(2).filter);
        dp4 = filtbdata(dp,0,cond(2).filter,cond(2).trialRelativeSweepfilter);
        trials3(isession) = dp3.ntrials;
        trials4(isession) = dp4.ntrials;
        
        
    end
    
    
end

ppn = trials4./totalTrials;
ppp = trials2./totalTrials;

% hist(ppp)
% h = findobj(gca,'Type','patch');
% set(h,'FaceColor','r','EdgeColor','w')
% 
% hold on
%  hist(pp)

ppnmean = mean(ppn);
pppmean = mean(ppp); 


figure

plot(ppn,ppp,'.k','markersize',15)
xlim([0 1])
ylim([0 1])
axis square
hold on
hline = refline(1,0);
set(hline,'Color','r')
xlabel (['prob ' num2str(cond(1).nameAval) cond(1).nameA])
ylabel (['prob ' num2str(cond(1).nameAval) cond(1).nameA ' | ' num2str(cond(1).nameBval) cond(1).nameB ' on previous ' num2str(cond(1).nameCval) ' trial'])


