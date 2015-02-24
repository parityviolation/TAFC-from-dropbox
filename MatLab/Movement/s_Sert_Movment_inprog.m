% list of dp
% do analysis on all of them
% LOOK AT 864 DATA
     % plot individula trials for CM
% try another animal.. is it consisten


% TO DO fix other videos
          % goncalo's script
% IMPORTANT OUTSTANDING
%        IS the alignment video to behavior correct (if not the parsing of
%        stimulated vs not is wrong..)
%        How noicy is the CM meausurement
A = {'sert864sub'}
groupsavefile = fullfile(r.Dir.dropboxtemp,'sert864sub');


bAcrossAnimals = 0; % set to 1 to get the average across animals
bloadFromdp =0

condCell.condGroup = {[1 2 3]}; % group Stimulations conditions accordingly
condCell.condGroupDescr = '[1 2 3]';


s_loadMultipleHelper

%thisAnimal = dpAnimal{1};

% correct
options.bIntervalGTX = 1;
plot_CMByInterval_CorrectVsError(thisAnimal,condCell,'ExtremeNosex',1,options)
options.bIntervalGTX = 1;
plot_CMByInterval(thisAnimal,'x',1,options)
options.bIntervalGTX = 1;
plot_CMByInterval(thisAnimal,'speed',1,options)

% error
options.bIntervalGTX = 0;
plot_CMByInterval(thisAnimal,'y',0,options)
options.bIntervalGTX = 0;
plot_CMByInterval(thisAnimal,'x',0,options)
options.bIntervalGTX = 0;
plot_CMByInterval(thisAnimal,'speed',0,options)


%% On individual sessions

DP = {'Sert_868_TAFCv08_stimulation02_box4_130716_SSAB',...
    'Sert_868_TAFCv08_stimulation02_box4_130718_SSAB',...
    'Sert_868_TAFCv08_stimulation02_box4_130719_SSAB',...
    'Sert_868_TAFCv08_stimulation02_box4_130721_SSAB'}

DP = {'Sert_864_TAFCv08_stimulation02_box4_130724_SSAB_(I)1',...
    'Sert_864_TAFCv08_stimulation02_box4_130723_SSAB_(I)1',...
    'Sert_864_TAFCv08_stimulation02_box4_130713_SSAB',...
    'Sert_864_TAFCv08_stimulation02_box4_130711_SSAB'}
clear options
for idp = 2:4
    
    
    dp = builddp(0,0,DP{idp});
    
    plot_CMByInterval_CorrectVsError(dp,[],'ExtremeNosespeed',options)

    % correct
    options.bIntervalGTX = 1;
    plot_CMByInterval(dp,'y',1,options)
    options.bIntervalGTX = 1;
    plot_CMByInterval(dp,'x',1,options)
    options.bIntervalGTX = 1;
    plot_CMByInterval(dp,'speed',1,options)
    
    % error
    options.bIntervalGTX = 0;
    plot_CMByInterval(dp,'y',0,options)
    options.bIntervalGTX = 0;
    plot_CMByInterval(dp,'x',0,options)
    options.bIntervalGTX = 0;
    plot_CMByInterval(dp,'speed',0,options)
    

end


% 23 in X
% 24 in Y