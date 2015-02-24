exptnames ={};
trials ={};
% exptnames{end+1} = 'BIII_TAFCv06_8stim_longerTimeout_box4_130314_SSAB';
% trials{end+1} = [];
% bonsaiParams(length(exptnames)).ThresholdType = 'BinaryInv';
% bonsaiParams(length(exptnames)).ThresholdValue = '130';
% bonsaiParams(length(exptnames)).SubtractionMethod = 'Bright';
% exptnames{end+1} = 'BIII_TAFCv06_8stim_longerTimeout_box4_130319_SSAB';
% trials{end+1} = [];
% bonsaiParams(length(exptnames)).ThresholdType = 'Binary';
% bonsaiParams(length(exptnames)).ThresholdValue = '130';
% bonsaiParams(length(exptnames)).SubtractionMethod = 'Dark';
% exptnames{end+1} = 'BIII_TAFCv06_8stim_longerTimeout_box4_130321_SSAB';
% trials{end+1} = [];
% bonsaiParams(length(exptnames)).ThresholdType = 'BinaryInv';
% bonsaiParams(length(exptnames)).ThresholdValue = '100';
% bonsaiParams(length(exptnames)).SubtractionMethod = 'Bright';
% exptnames{end+1} = 'BIII_TAFCv06_8stim_longerTimeout_box4_130322_SSAB';
% trials{end+1} = [];
% bonsaiParams(length(exptnames)).ThresholdType = 'Binary';
% bonsaiParams(length(exptnames)).ThresholdValue = '150';
% bonsaiParams(length(exptnames)).SubtractionMethod = 'Dark';
% exptnames{end+1} = 'BIII_TAFCv06_8stim_longerTimeout_box4_130324_SSAB';
% trials{end+1} = [];
% bonsaiParams(length(exptnames)).ThresholdType = 'Binary';
% bonsaiParams(length(exptnames)).ThresholdValue = '150';
% bonsaiParams(length(exptnames)).SubtractionMethod = 'Dark';
exptnames{end+1} = 'BIII_TAFCv06_8stim_longerTimeout_box4_130325_SSAB'; % NOT FINISHED
trials{end+1} = [];
bonsaiParams(length(exptnames)).ThresholdType = 'Binary';
bonsaiParams(length(exptnames)).ThresholdValue = '150';
bonsaiParams(length(exptnames)).SubtractionMethod = 'Dark';
% exptnames{end+1} = 'BIII_TAFCv06_8stim_longerTimeout_box4_130318_SSAB'; % DONE
% trials{end+1} = [];
% bonsaiParams(length(exptnames)).ThresholdType = 'Binary';
% bonsaiParams(length(exptnames)).ThresholdValue = '150';
% bonsaiParams(length(exptnames)).SubtractionMethod = 'Dark';

%% B2 REMEMBER to rest the location of the videos in getBonsaiExtremes

exptnames ={};
trials ={};
exptnames{end+1} = 'BII_TAFCv06_box3_130227_SSAB';
trials{end+1} = [];
bonsaiParams(length(exptnames)).ThresholdType = 'Binary';
bonsaiParams(length(exptnames)).ThresholdValue = '100';
bonsaiParams(length(exptnames)).SubtractionMethod = 'Dark';
exptnames{end+1} = 'BII_TAFCv07_box3_130314_SSAB';
trials{end+1} = [];
bonsaiParams(length(exptnames)).ThresholdType = 'Binary';
bonsaiParams(length(exptnames)).ThresholdValue = '100';
bonsaiParams(length(exptnames)).SubtractionMethod = 'Dark';
exptnames{end+1} = 'BII_TAFCv07_box3_130318_SSAB';
trials{end+1} = [];
bonsaiParams(length(exptnames)).ThresholdType = 'Binary';
bonsaiParams(length(exptnames)).ThresholdValue = '100';
bonsaiParams(length(exptnames)).SubtractionMethod = 'Dark';
exptnames{end+1} = 'BII_TAFCv07_box3_130327_SSAB';
trials{end+1} = [];
bonsaiParams(length(exptnames)).ThresholdType = 'Binary';
bonsaiParams(length(exptnames)).ThresholdValue = '150';
bonsaiParams(length(exptnames)).SubtractionMethod = 'Dark';
exptnames{end+1} = 'BII_TAFCv07_box3_130319_SSAB';
trials{end+1} = [];
bonsaiParams(length(exptnames)).ThresholdType = 'Binary';
bonsaiParams(length(exptnames)).ThresholdValue = '150';
bonsaiParams(length(exptnames)).SubtractionMethod = 'Dark';
exptnames{end+1} = 'BII_TAFCv07_box3_130322_SSAB';
trials{end+1} = [];
bonsaiParams(length(exptnames)).ThresholdType = 'Binary';
bonsaiParams(length(exptnames)).ThresholdValue = '150';
bonsaiParams(length(exptnames)).SubtractionMethod = 'Dark';
exptnames{end+1} = 'BII_TAFCv07_box3_130321_SSAB';
trials{end+1} = [];
bonsaiParams(length(exptnames)).ThresholdType = 'BinaryInv';
bonsaiParams(length(exptnames)).ThresholdValue = '160';
bonsaiParams(length(exptnames)).SubtractionMethod = 'Bright';

%%


dpArray = constructDataParsedArray(exptnames, trials,1,1);

%%
getBonsaiExtremes2(dpArray(end:-1:1),bonsaiParams)%%( bstruct,bonsaiFileName)

