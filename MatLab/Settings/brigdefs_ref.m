
function r = brigdefs()


r.Dir.DataBehav = 'C:\Users\User\Dropbox\PatonLab\Paton Lab\Data\TAFCmice\Behavior';
r.Dir.DataBonsai = 'C:\Users\User\Dropbox\PatonLab\Paton Lab\Data\TAFCmice\Bonsai';
r.Dir.DataBonsaiVideo = 'C:\Users\User\Dropbox\PatonLab\Paton Lab\Data\TAFCmice\Bonsai';
r.Dir.BStruct = 'C:\Users\User\Dropbox\PatonLab\Paton Lab\Data\TAFCmice\Matlab\BehaviorStruct';
r.Dir.DailyFig = 'C:\Users\User\Dropbox\PatonLab\Paton Lab\Data\TAFCmice\Behavior\DailyFigs';
r.Dir.CodeArduinoProtocols = 'C:\Users\User\Dropbox\TAFCmice\Code\Arduino';
r.Dir.ArduinoPath = 'C:\Users\User\Documents\arduino-1.5.2';
r.Dir.DataVideo = 'D:\TAFCmiceWaiting';
r.Dir.BatFile = 'C:\Temp';
r.Dir.BonsaiEditor86 = 'C:\Software\Bonsai.Packages\Externals\Bonsai\Bonsai.Editor\bin\x86\Release';
r.Dir.BonsaiEditor64 = 'C:\Software\Bonsai.Packages\Externals\Bonsai\Bonsai.Editor\bin\x64\Release';
r.Dir.PythonScripts = 'C:\Users\User\Dropbox\TAFCmice\Code\Python';
r.Dir.CodeArduinoLogAnimals = 'C:\Users\User\Dropbox\TAFCmice\Code\Arduino\LogFiles\Animals';
r.Dir.CodeArduinoLogBoxes = 'C:\Users\User\Dropbox\TAFCmice\Code\Arduino\LogFiles\Boxes';
r.Dir.DataLogs = 'C:\Users\User\Dropbox\PatonLab\Paton Lab\Data\TAFCmice\Logs';
r.Dir.LedOpenField = 'C:\Users\User\Dropbox\TAFCmice\OpenField';
r.Dir.SummaryFig = 'C:\Users\User\Dropbox\PatonLab\Paton Lab\Data\TAFCmice\Behavior\SummaryFigs';
r.Dir.BonsaiCode = 'C:\Users\User\Dropbox\TAFCmice\Code\Bonsai';
r.Dir.CM = 'C:\Users\User\Dropbox\PatonLab\Paton Lab\Data\TAFCmice\Matlab\CMAnalysis';
r.Dir.Extremum = 'C:\Users\User\Dropbox\PatonLab\Paton Lab\Data\TAFCmice\Matlab\Extremum';
r.Dir.Extremum = 'C:\Users\User\Dropbox\PatonLab\Paton Lab\Data\TAFCmice\Matlab\Extremum';
r.Dir.RigSettings = 'C:\Users\User\Dropbox\TAFCmice\Settings\Rig\MouseRig1\';
r.Dir.AnimalSettings = 'C:\Users\User\Dropbox\TAFCmice\Settings\Animal\';
r.Dir.temp = 'C:\Temp';

r.Dir.EphysData = 'E:\Bass\ephys';
r.Dir.EphysDataFilt = 'E:\Bass\ephys\filt';
r.Dir.CereLib = 'C:\Users\User\Dropbox\TAFCmice\Code\MatLab\BA\CerebusIO\RequiredResources\nsNEVLibrary64.dll';
r.Dir.Spikes = 'E:\Bass\ephys\spikes\';
r.FullPath.animalLog = fullfile(r.Dir.DataLogs,'allAnimalLog.mat');

r.bbox.COM = {'COM6'; 'COM5'; 'COM4';'COM3'; 'COM9'; 'COM7';'COM10'};
r.bbox.experimenterList = {'Zero'; 'SSAB'; 'User 2'; 'User 3'; 'User 4'};
r.bbox.mouseList = {'Zero';'Sert_1422';'SertxChR2_190';'SertxChR2_227';'FI12_1109';'SertxChR2_181';'SertxChR2_185';...
    'Sert_1421';'SertxChR2_179';'SertxChR2_1485';'FI12_24';...
    'FI12xArch_115';'FI12xArch_117';'FI12xArch_116';'FI12xArch_1447';...
    'FI12_648';'FI12_651';'FI12_652';'FI12_653';'FI12_655';'FI12C_267'};

r.SS.label_categories = {'in process', 'good unit', 'FS good unit', 'dirty unit', 'multi-unit', 'FS multi-unit', 'garbage'};
r.SS.label_colors = [ .7 .7 .7; .3 .8 .3; .3 .3 .8;  .7 .5 .5; .6 .8 .6; .6 .6 .8; .5 .5 .5];

% 
%  %%for mac
% r.Dir.DataBehav = '/Users/Sofia/Dropbox/PatonLab/Paton Lab/Data/TAFCmice/Behavior';
% r.Dir.DataBonsai = '/Users/Sofia/Dropbox/PatonLab/Paton Lab/Data/TAFCmice/Bonsai';
% r.Dir.DataBonsaiVideo = '/Users/Sofia/Dropbox/PatonLab/Paton Lab/Data/TAFCmice/Bonsai';
% r.Dir.BStruct = '/Users/Sofia/Dropbox/PatonLab/Paton Lab/Data/TAFCmice/Matlab/BehaviorStruct';
% r.Dir.DailyFig = '/Users/Sofia/Dropbox/PatonLab/Paton Lab/Data/TAFCmice/Behavior/DailyFigs';
% r.Dir.CodeArduinoProtocols = '/Users/Sofia/Dropbox/TAFCmice/Code/Arduino';



