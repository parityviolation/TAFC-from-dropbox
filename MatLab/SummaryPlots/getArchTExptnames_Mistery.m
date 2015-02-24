function [exptnames trials]  = getArchTExptnames_Mistery(name)
exptnames = {};trials = {};
switch(lower(name))
    
    
    
    %BEFORE SURGERY
    
    
    case 'fi12_1016_before_surgery'
        [exptnames trials]  =fi12_1016_before_surgery(exptnames,trials);
        
    case 'fi12_1446_before_surgery'
        [exptnames trials]  =fi12_1146_before_surgery(exptnames,trials);
              
    case 'fi12_1293_before_surgery'
        [exptnames trials]  =fi12_1293_before_surgery(exptnames,trials);
               
    case 'fi12_974_before_surgery'
        [exptnames trials]  =fi12_974_before_surgery(exptnames,trials);
        
        
        
        
        
    %AFTER SURGERY    
        
        
    case 'fi12_1016_after_surgery'
        [exptnames trials]  =fi12_1016_after_surgery(exptnames,trials);
        
    case 'fi12_1142_after_surgery'
        [exptnames trials]  =fi12_1142_after_surgery(exptnames,trials);
        
    case 'fi12_1018_after_surgery'
        [exptnames trials]  =fi12_1018_after_surgery(exptnames,trials);
        
        
        
        
        
    %STIM ON    
        
    
    case 'fi12_1446_stim'
        [exptnames trials]  = fi12_1446_stim(exptnames,trials);
        
    case 'fi12_974_stim'
        [exptnames trials]  = fi12_974_stim(exptnames,trials);
   
    case 'fi12_1293_stim'
        [exptnames trials]  = fi12_1293_stim(exptnames,trials);
             
        
        
        
end



%BEFORE SURGERY


function [exptnames trials]  = fi12_1016_before_surgery(exptnames,trials)
exptnames{end+1} = 'FI12_1016_TAFCv08_stimulationREV03_box1_141111_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1016_TAFCv08_stimulationREV03_box1_141112_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1016_TAFCv08_stimulationREV03_box1_141113_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1016_TAFCv08_stimulationREV03_box1_141114_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1016_TAFCv08_stimulationREV03_box1_141115_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1016_TAFCv08_stimulationREV03_box1_141117_SSAB_(I)1';
trials{end+1} = [];



function [exptnames trials]  = fi12_1146_before_surgery(exptnames,trials)
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141023_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141024_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141025_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141026_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141027_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141028_SSAB_(I)1';
trials{end+1} = [];


function [exptnames trials]  = fi12_1293_before_surgery(exptnames,trials)
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box5_141111_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box5_141112_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box5_141113_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box5_141114_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box5_141117_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box5_141118_SSAB_(I)1';
trials{end+1} = [];


function [exptnames trials]  = fi12_974_before_surgery(exptnames,trials)
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box1_141022_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box1_141023_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box1_141024_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box1_141025_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box1_141026_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box1_141027_SSAB_(I)1';
trials{end+1} = [];



%AFTER SURGERY    


function [exptnames trials]  = fi12_1016_after_surgery(exptnames,trials)
exptnames{end+1} = 'FI12_1016_TAFCv08_stimulationREV03_box1_141123_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1016_TAFCv08_stimulationREV03_box1_141124_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1016_TAFCv08_stimulationREV03_box1_141125_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1016_TAFCv08_stimulationREV03_box1_141126_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1016_TAFCv08_stimulationREV03_box1_141127_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1016_TAFCv08_stimulationREV03_box1_141128_SSAB_(I)1';
trials{end+1} = [];


function [exptnames trials]  = fi12_1142_after_surgery(exptnames,trials)
exptnames{end+1} = 'FI12_1142_TAFCv08_stimulationREV03_box2_140908_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1142_TAFCv08_stimulationREV03_box2_140909_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1142_TAFCv08_stimulationREV03_box2_140910_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1142_TAFCv08_stimulationREV03_box2_140911_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1142_TAFCv08_stimulationREV03_box2_140912_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1142_TAFCv08_stimulationREV03_box2_140913_SSAB_(I)1';
trials{end+1} = [];


function [exptnames trials]  = fi12_1018_after_surgery(exptnames,trials)
exptnames{end+1} = 'FI12_1018_TAFCv08_stimulationREV03_box2_140909_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1018_TAFCv08_stimulationREV03_box2_140910_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1018_TAFCv08_stimulationREV03_box2_140911_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1018_TAFCv08_stimulationREV03_box2_140912_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1018_TAFCv08_stimulationREV03_box2_140913_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1018_TAFCv08_stimulationREV03_box2_140915_SSAB_(I)1';
trials{end+1} = [];



%STIM ON

function [exptnames trials]  = fi12_1446_stim(exptnames,trials)
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141114_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141115_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141116_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141117_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141118_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141119_SSAB_(I)1';
trials{end+1} = [];


function [exptnames trials]  = fi12_974_stim(exptnames,trials)
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141110_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141112_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141113_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141117_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141201_SSAB_(I)1';
trials{end+1} = [];


function [exptnames trials]  = fi12_1293_stim(exptnames,trials)
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_141205_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_141207_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_141208_SSAB_(I)1';
trials{end+1} = [];


