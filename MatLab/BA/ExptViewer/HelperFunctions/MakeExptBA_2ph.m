
function expt = MakeExptBA_2ph(ExptTable)
% expt = MakeExpt(ExptTable)
% 
% INPUT:
%   ExptTable(optional): Table with details of experiment. This table is
%   used to fill in specific fields in the expt struct.
%
% OUTPUT:
%   expt: expt struct

% Created:  3/25/10 - SRO
% Modified: 4/9/10 - SRO
% Modified: 4/19/10 - BA support TDT too
% Modified: 5/22/10 - SRO: Updated structversion to 2.0. Added fields
% info.location, info.time, info.anesthesia, info.stimulus.stimcode, and
% expt.unit (for completed units). Modified info.transgene. Added fields to
% .probe for storing site depths. Removed field info.recording.
% Condsider making expt.files a multidimensional array.
% Modified: 7/15/10 - SRO: Pulled out blocks of code and made into
% separate functions. This makes it easier to see where specific
% information is added to the expt struct, and also to add user-specific
% modifications (e.g. in the .info struct). Made .probe a substruct of
% expt as opposed to expt.info. 


% Set rig defaults
rigdef = RigDefs;

% If experiment table is not supplied then use dialog to get one
if nargin < 1 || isempty(ExptTable)
    % Load experiment table
    [FileName,PathName] = uigetfile([rigdef.Dir.Data '*_ExptTable*']);
    if FileName ~= 0
        ExptTable = loadvar(fullfile(PathName,FileName));
    else
        return
    end 
end

% Define fields
expt.name = [];         % Experiment name
expt.info = [];         % Details about mouse and experiment
expt.probe = [];        % Probe configuration, channel order, etc.
expt.files = [];        % Information about each raw data file
expt.stimulus = [];     % Stimulus paramters for each file
expt.sweeps = [];       % Information about every sweep in experiment
expt.sort = [];         % Spike sorting 
expt.analysis = [];     % Info for running analysis and storing results
expt.unit = [];         % Completed units

% Set experiment name
expt.name = getFromExptTable(ExptTable,'Experiment name');

% Add .info struct
expt = addInfo(expt,ExptTable);

% Add .probe struct
expt = addProbe(expt,ExptTable);

% Add .files struct
expt = addFiles(expt);

% Add .stimulus struct
expt = addStimParams(expt);

% Add .files.stimType
expt = addStimType(expt);

% Add .analysis struct
expt = addAnalysisBA(expt);

bLEDexists = 1;
% Add .sweeps struct
if ~isempty(expt.files.names)
    expt = addSweeps(expt);
    % Add stimulus conditions (expt.sweeps.stimcond)
    expt = addStimCond(expt);
    % Add LED conditions to sweeps struct (expt.sweeps.led)
    if ~isTDTexpt(expt)
        if bLEDexists
            LEDChn = cell2mat(rigdef.led.AIChan);
            expt = addLEDCond(expt,LEDChn);
            % fix LED to be binary
            expt.sweeps.bled = expt.sweeps.led>0.01; % make led binary
            display('********* LED > 0.01V  is ON ***********')
        else
            expt.sweeps.led = zeros(size(expt.sweeps.trials ));
            expt.sweeps.bled = expt.sweeps.led>0.01; % make led binary
            display('********* No LED sweeps.led set to 0 ***********')
            
        end
    else
        nameTTL = 'Light';
        expt = addTTLCond(expt,nameTTL);                           %BA
    end
end

% Add .sort struct
expt.sort.manualThresh  = [];
expt = addTrodeSortfromProbe(expt);

% add defaults for showclutesrtuning

expt.sort.defaults = [];

% Add frameTimes of movies
% TO DO quantify variablity of frametimes (currently only using frametime
% of first sweep in each movie and assuming minimal variablity
expt = addSTAframeTimes(expt); 



% Set file name for saving
FileName = [rigdef.Dir.Expt expt.name '_expt'];

% Prevent overwriting existing expt by accident
if isempty(dir([FileName '.*']))    
    choice = 'Yes';
else
    [f p] = getFilename(FileName);
    disp('Expt already exists:')
    disp([p f])
    qstring = 'Do you want to overwrite existing expt file?'; pause(0.05)
    choice = questdlg(qstring,'Overwrite?','Yes','No','No');
end

% Save expt struct
switch choice
    case 'Yes'
        save(FileName,'expt');
        % Assign in base workspace
        assignin('base','expt',expt);
    case {'No',''}
        disp('Expt was not saved')
end


%%% --  Preprocess  channels for all files in experment

disp(' **** -- Prefiltering all chns for extracting Spikes -- ****')
filtparam = rigdef.SS.spike_filtparam;

chns = [];
for itrode = 1:length(expt.sort.trode) % get list of all channels
    chns = [chns expt.sort.trode(itrode).channels];
end
chns = unique(chns);
% matlabpool open
for fileInd = 1:length(expt.files.names)
    STF.filename = expt.files.names{fileInd};
    preprocessDAQ([],STF,chns+1,filtparam);
end
% matlabpool close

% --- Subfunctions --- %

function expt = addStimType(expt)

for i = 1:length(expt.files.names)
    % Get stimType from .stimulus struct
    stimulus = expt.stimulus(i);
    if isfield(stimulus.params,'stimType')
        expt.files.stimType(i) = stimulus.params.stimType;
    elseif isfield(stimulus.params,'StimulusName')
        temp = stimulus.params.StimulusName;
        if strcmp(temp,'Drift Gratings')
            expt.files.stimType{i} = 'Drifting gratings';
        else
            expt.files.stimType{i} = temp;
        end
    end
end




