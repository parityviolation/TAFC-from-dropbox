 r = brigdefs;

%  A = {'fi12xarch_115_control','fi12xarch_116_control','fi12xarch_117_control','fi12xarch_1447_control'};
% groupsavefile = 'fi12xarchControl';
% 
% % Prematures  all animals
%  A = {'fi12_653','fi12_24','fi12_1013_3freq_all','fi12_1020_3freq_all'};
% groupsavefile = fullfile(r.Dir.dropboxtemp,'fi12x4Animals');

A = {'Sert864_all','Sert867_all','Sert868_all','Sert179'};
groupsavefile = 'sertAllData';
% groupsavefile = fullfile(r.Dir.dropboxtemp,'sertAllData');
% 
% % groupsavefile = fullfile(r.Dir.dropboxtemp,'4sert4fi12');
%  A = {'Sert775'};
%  groupsavefile = 'Sert775' ; %fullfile(r.Dir.dropboxtemp,A{1}) ;
%  A = {'Sert785'};
%  groupsavefile = 'Sert785' ; %fullfile(r.Dir.dropboxtemp,A{1}) ;
%  A = {'Sert179'};
%  groupsavefile = 'Sert179' ; %fullfile(r.Dir.dropboxtemp,A{1}) ;
%  A = {'Sert179','Sert785','Sert775'};
%  groupsavefile = 'Sert179_775_785' ; %fullfile(r.Dir.dropboxtemp,A{1}) ;
A = {'sert502','sert504'};
groupsavefile = 'sert5' ; %fullfile(r.Dir.dropboxtemp,A{1}) ;

%  A = {'fi12_24'};
% r = brigdefs;
%groupsavefile = fullfile(r.Dir.dropboxtemp,'fi12_24');
%groupsavefile = fullfile(r.Dir.dropboxtemp,'Sert868sub')

% A = {'fi12_652'};
% r = brigdefs;
% groupsavefile = 'fi12_652';
% groupsavefile = fullfile(r.Dir.dropboxtemp,groupsavefile)

% A = {'sert1421stim','sert1422stim'};
% groupsavefile = 'sertCtrlData';
bAcrossAnimals = 0; % set to 1 to get the average across animals
bloadFromdp =0;

condCell.condGroup = {[1 2 3]}; % group Stimulations conditions accordingly
condCell.condGroupDescr = '[1 2 3]';


s_loadMultipleHelper

% Average ACross animals
clear options dpAnimal;
options.bplotOversession = 0;
if bAcrossAnimals,   dpAnimal{1} = dpAnimalArray;
    options.mycolor  = colormap(hsv(length(dpAnimalArray)+1)); 
    options.bplotOversession = 0;
else dpAnimal = dpAnimalCell; options = []; options.bplotOversession = 0;end
%%
fitFunction = 'logistic';
free_parameters = {'none','all','l','bias','l slope','bias slope'};

%free_parameters = {'bias'};
clear fit
last = min(3,length(dpAnimal));
for ianimal =  1 :last%length(dpAnimal)
    thisAnimal = dpAnimal{ianimal} ;
    

    disp(thisAnimal(1).Animal);

    s_SessionbySession_fracPMLeft_Correlations
%** Do correlation with other metrics (like median premature time. YES (
%but weak)

%      s_InProgress_movingAveragePremature
%     s_AverageSession
%     plotsummprematureetc(thisAnimal,[],options);
      s_PrematureAnalysis_inProg % distribution  % latency to be Premature ON Premature trials ( is a robust metric can we use it)
                                               % number of premature trial
                                               % is not, probably not even
                                               % significant!
    
%     
     plotmlefit(thisAnimal,'default',fitFunction,free_parameters);
%     s_prematuretrials               % premature psychometric function
    
%     if ~bAcrossAnimals
%         s_Stim_AfterCorrectorError
%         
%        s_trialafterstimulation         % pschcurves on tril after stim
%        s_psychcurve_afterleftrightchoice % get pschcurves depended on the choice on the last trial
%         s_twoinarow                    %% pschcurves after 2 or 3 stimulatino in a row %  s_threeinarow %correct
%         
%         s_reactiontime                  % reaction time stim vs ctrl
%         plottrialInit(thisAnimal);
%     end
%     

%     s_StaySwitch

if 1% OLD functions
    %         plotupdating(thisAnimal);
%             plothistorystimulation(thisAnimal);
%     thidAnimaltemp = filtbdata(thisAnimal,0,{'reDraw',1});
%     plotBlockStimulation(thisAnimal);
end
end

%%
[p f] = fileparts(groupsavefile)
       savename_fig1 = f;

    s_DifferenceBetweenPsychCurves
