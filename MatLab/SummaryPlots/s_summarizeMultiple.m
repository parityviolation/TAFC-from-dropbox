% A = {'Sert864_all','Sert867_all','Sert868_all','Sert179'};
%groupsavefile = 'sertAllData';
 A = {'fi12_1013_3freq_all'};
 r = brigdefs;
groupsavefile = 'fi12_1013_3freq_all';
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

for ianimal = 1:length(dpAnimal)
    thisAnimal = dpAnimal{ianimal} ;
    disp(thisAnimal(1).Animal);
    
%     plotsummprematureetc(thisAnimal,[],options);
%     
    plotmlefit(thisAnimal,'default',fitFunction,free_parameters)
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
