function [exptnames trials]  = getStimulatedExptnames_Matching(name)
exptnames = {};trials = {};
switch(lower(name))
    case 'fi12_121'
        [exptnames trials]  =fi12_121(exptnames,trials);
    case 'sert866inter'
        [exptnames trials]  =sert866inter(exptnames,trials);
        [exptnames trials]  =sert866inter21(exptnames,trials);
    case 'sert866inter21'
        [exptnames trials]  =sert866inter21(exptnames,trials);
    case 'sert866'
        [exptnames trials]  =sert866(exptnames,trials);
    case 'sert866nostim'
        [exptnames trials]  =sert866nostim(exptnames,trials);
    case 'sert866_all'
        [exptnames trials]  =sert866inter(exptnames,trials);
        [exptnames trials]  =sert866inter21(exptnames,trials);
        [exptnames trials]  =sert866(exptnames,trials);
        
    case 'sert1481inter'
        [exptnames trials]  =sert1481inter(exptnames,trials);
    case 'sert1481rand_all'
        [exptnames trials]  =sert1481rand_all(exptnames,trials);
    case 'sert1481rand_50'
        [exptnames trials]  =sert1481rand_50(exptnames,trials);
    case 'sert1481rand_90'
        [exptnames trials]  =sert1481rand_90(exptnames,trials);
    case 'sert1485'
        [exptnames trials]  =sert1485(exptnames,trials);
    case 'sert1485inter'
        [exptnames trials]  =sert1485inter(exptnames,trials);
        [exptnames trials]  =sert1485inter21(exptnames,trials);
    case 'sert1485rand'
        [exptnames trials]  =sert1485rand(exptnames,trials);
    case 'sert1485inter21'
         [exptnames trials]  =sert1485inter21(exptnames,trials);
     case 'sert1485na'
         [exptnames trials]  =sert1485NA(exptnames,trials);
      
end
function [exptnames trials] = sert1485NA(exptnames,trials)
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131229_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131230_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131231_SSAB_(I)1';
trials{end+1} = [];
function [exptnames trials] = sert866inter(exptnames,trials)
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation_Blocks1_box3_131003_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation_Blocks1_box3_131004_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation_Blocks1_box3_131006_SSAB_(I)1'; % strong bias
trials{end+1} = [];
function [exptnames trials] = sert866inter21(exptnames,trials)
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation_Blocks1_box3_131007_SSAB_(I)1'; % blocksize 21
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation_Blocks1_box3_131008_SSAB_(I)1'; % blocksize 21
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation_Blocks1_box3_131009_SSAB_(I)1'; % blocksize 21
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation_Blocks1_box3_131014_SSAB_(I)1'; % blocksize 21
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation_Blocks1_box3_131015_SSAB_(I)1'; % blocksize 21
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation_Blocks1_box3_131016_SSAB_(I)1'; % blocksize 21
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation_Blocks1_box3_131017_SSAB_(I)1'; % blocksize 21
trials{end+1} = [];


function [exptnames trials] = sert1485inter(exptnames,trials)
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation_Blocks1_box3_131003_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation_Blocks1_box3_131004_SSAB_(I)1';
trials{end+1} = [];


function [exptnames trials] = sert1485(exptnames,trials)
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131001_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131002_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation_Blocks1_box3_131003_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation_Blocks1_box3_131004_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation_Blocks1_box3_131006_SSAB_(I)1';
trials{end+1} = [];
function [exptnames trials] = sert1485inter21(exptnames,trials)
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation_Blocks1_box3_131007_SSAB_(I)1'; % 11
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation_Blocks1_box3_131008_SSAB_(I)1'; % 
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation_Blocks1_box3_131009_SSAB_(I)1'; %  
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation_Blocks1_box3_131010_SSAB_(I)1'; %  
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation_Blocks1_box3_131011_SSAB_(I)1'; %  
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation_Blocks1_box3_131014_SSAB_(I)1'; %  
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation_Blocks1_box3_131015_SSAB_(I)1'; %  
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation_Blocks1_box3_131016_SSAB_(I)1'; %  
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation_Blocks1_box3_131017_SSAB_(I)1'; %  
trials{end+1} = [];

function [exptnames trials] = sert1481inter(exptnames,trials)
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation_Blocks1_box4_131003_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation_Blocks1_box4_131004_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation_Blocks1_box4_131006_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation_Blocks1_box4_131007_SSAB_(I)1'; % strong bias
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation_Blocks1_box4_131009_SSAB_(I)1'; % strong bias
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation_Blocks1_box4_131010_SSAB_(I)1'; % strong bias
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation_Blocks1_box4_131011_SSAB_(I)1'; % strong bias
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation_Blocks1_box4_131014_SSAB_(I)1'; % strong bias
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation_Blocks1_box4_131015_SSAB_(I)1'; % strong bias
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation_Blocks1_box4_131016_SSAB_(I)1'; % strong bias
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation_Blocks1_box4_131017_SSAB_(I)1'; % strong bias
trials{end+1} = [];

function [exptnames trials] = sert1481rand_all(exptnames,trials)
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131027_SSAB_(I)1';% check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131028_SSAB_(I)1';% check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131029_SSAB_(I)1';% check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131030_SSAB_(I)1';% check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131031_SSAB_(I)1';% check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131101_SSAB_(I)1';% 10/90
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131102_SSAB_(I)1';% 10/90
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131104_User 2_(I)1';% 10/90
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131105_User 2_(I)1';% 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131106_User 2_(I)1';% 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131107_User 2_(I)1';% 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131108_User 2_(I)1';% 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131120_User 2_(I)1';% 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131121_User 2_(I)1';% 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131122_User 2_(I)1';% 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131125_SSAB_(I)1';% 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131126_SSAB_(I)1';% 10/50
trials{end+1} = [];

function [exptnames trials] = sert1481rand_90(exptnames,trials)
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131027_SSAB_(I)1';% check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131028_SSAB_(I)1';% check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131029_SSAB_(I)1';% check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131030_SSAB_(I)1';% check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131031_SSAB_(I)1';% check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131101_SSAB_(I)1';% 10/90
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131102_SSAB_(I)1';% 10/90
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131104_User 2_(I)1';% 10/90
trials{end+1} = [];


function [exptnames trials] = sert1481rand_50(exptnames,trials)
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131105_User 2_(I)1';% 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131106_User 2_(I)1';% 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131107_User 2_(I)1';% 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131108_User 2_(I)1';% 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131120_User 2_(I)1';% 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131121_User 2_(I)1';% 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131122_User 2_(I)1';% 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131125_SSAB_(I)1';% 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1481_MATCHINGvFix02_Stimulation1_box3_131126_SSAB_(I)1';% 10/50
trials{end+1} = [];


function [exptnames trials] = sert1485rand(exptnames,trials)
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131025_SSAB_(I)1';% check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131026_SSAB_(I)1';% check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131027_SSAB_(I)1';% check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131028_SSAB_(I)1';% check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131029_SSAB_(I)1';% check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131030_SSAB_(I)1'; % check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131101_SSAB_(I)1'; % check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131102_SSAB_(I)1'; % check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131104_User 2_(I)1'; % check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131105_User 2_(I)1'; % check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131106_User 2_(I)1'; % check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131113_User 2_(I)1'; % check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131114_User 2_(I)1'; % check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131115_User 2_(I)1'; % check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131118_User 2_(I)1'; % check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131120_User 2_(I)1'; % check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131121_User 2_(I)1'; % check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131122_User 2_(I)1'; % check if 10/90 or 10/50
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_1485_MATCHINGvFix02_Stimulation1_box3_131126_SSAB_(I)1'; % check if 10/90 or 10/50
trials{end+1} = [];




function [exptnames trials] = sert866(exptnames,trials)
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box4_130917_SSAB_(I)1'; % could exclude
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box4_130918_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box4_130919_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box4_130920_SSAB_(I)1'; % could exclude
trials{end+1} = [];

% exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box4_130921_SSAB_(I)1'; % few trials more biased than normal
% trials{end+1} = [];


function [exptnames trials] = sert866nostim(exptnames,trials)
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box4_130916_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box1_130915_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box1_130913_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box1_130911_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box1_130910_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box1_130828_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box1_130826_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box1_130825_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box1_130824_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box1_130823_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box1_130822_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box1_130821_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box1_130820_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box1_130819_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box1_130818_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box1_130817_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box1_130816_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box1_130815_SSAB_(I)1';
trials{end+1} = [];
% exptnames{end+1} = 'Sert_866_MATCHINGvFix02_Stimulation1_box4_130921_SSAB_(I)1'; % few trials more biased than normal
% trials{end+1} = [];

function [exptnames trials] = fi12_121(exptnames,trials)
exptnames{end+1} = 'FI12xArch_121_MATCHINGvFix02_Stimulation1_box3_131224_SSAB_(I)1'; % could exclude
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_121_MATCHINGvFix02_Stimulation1_box3_131223_SSAB_(I)1'; % could exclude
trials{end+1} = [];

