function [exptnames trials]  = getStimulatedExptnames_Timing(name)
exptnames = {};trials = {};
switch(lower(name))
    case 'sert775aav29'
        [exptnames trials]  =sert775_AAV29(exptnames,trials);
    case 'sert775'
        [exptnames trials]  =sert775(exptnames,trials);
    case 'sert785'
        [exptnames trials]  =sert785(exptnames,trials);
    case 'sert179'
        [exptnames trials]  =sert179(exptnames,trials);
    case 'sert179_ephys'
        [exptnames trials]  =sert179_ephys(exptnames,trials);
    case 'sert1421stim'
        [exptnames trials]  =sert1421stim(exptnames,trials);
        [exptnames trials]  =sert1421stim35mW(exptnames,trials);
    case 'sert1422stim'
        [exptnames trials]  =sert1422stim(exptnames,trials);
        [exptnames trials]  =sert1422stim35mW(exptnames,trials);
    case 'sert1421stim35mw'
        [exptnames trials]  =sert1421stim35mW(exptnames,trials);
    case 'sert1422stim35mw'
        [exptnames trials]  =sert1422stim35mW(exptnames,trials);
    case 'sert1422base'
        [exptnames trials]  =sert1422base(exptnames,trials);
    case 'sert1421base'
        [exptnames trials]  =sert1421base(exptnames,trials);
        
     case 'sert502'
        [exptnames trials]  =sert502(exptnames,trials);
     case 'sert502hp'
        [exptnames trials]  =sert502HIGHPOWER(exptnames,trials);
     case 'sert504'
        [exptnames trials]  =sert504(exptnames,trials);
     case 'sert504ok'
        [exptnames trials]  =sert504ok(exptnames,trials);
        
       
    case 'sertold'
        [exptnames trials]  =sert864(exptnames,trials);
        [exptnames trials]  =sert867(exptnames,trials);
        [exptnames trials]  =sert868(exptnames,trials);
        
    case 'sert868'
        [exptnames trials]  =sert868(exptnames,trials);
    case 'sert868sub'
        [exptnames trials]  =sert868sub(exptnames,trials);
    case 'sert868_high'
        [exptnames trials]  =sert868high(exptnames,trials);
    case 'sert868_low'
        [exptnames trials]  =sert868low(exptnames,trials);
    case 'sert868_cl'
        [exptnames trials]  = sert868_CL(exptnames,trials);
    case 'sert868_lg'
        [exptnames trials]  = sert868_LG(exptnames,trials);
    case 'sert868_lgcl'
        [exptnames trials]  = sert868_LG(exptnames,trials);
        [exptnames trials]  = sert868_CL(exptnames,trials);
    case 'sert868_3freq'
        [exptnames trials]  = sert868_3freq(exptnames,trials);
    case 'sert868_since_retreat'
        [exptnames trials]  = sert868_1freq_after_retreat(exptnames,trials);
        [exptnames trials]  = sert868_3freq(exptnames,trials);
    case 'sert868_september'
        [exptnames trials]  = sert868_3freq_sept(exptnames,trials);
    case 'sert868_all'
        [exptnames trials]  = sert868_1freq_after_retreat(exptnames,trials);
        [exptnames trials]  = sert868_3freq(exptnames,trials);
        [exptnames trials]  = sert868_3freq_sept(exptnames,trials);
    case 'sert867'
        [exptnames trials]  = sert867(exptnames,trials);
    case 'sert867_12hz'
        [exptnames trials]  = sert867_12hz(exptnames,trials);
    case 'sert867_25hz'
        [exptnames trials]  = sert867_25hz(exptnames,trials);
    case 'sert867_cl'
        [exptnames trials]  = sert867_CL(exptnames,trials);
    case 'sert867_lg'
        [exptnames trials]  = sert867_LG(exptnames,trials);
    case 'sert867_lgcl'
        [exptnames trials]  = sert867_LG(exptnames,trials);
        [exptnames trials]  = sert867_CL(exptnames,trials);
    case 'sert867_3freq'
        [exptnames trials]  = sert867_3freq(exptnames,trials);
    case 'sert867_since_retreat'
        [exptnames trials]  = sert867_1freq_after_retreat(exptnames,trials);
        [exptnames trials]  = sert867_3freq(exptnames,trials);
    case 'sert867_all'
        [exptnames trials]  = sert867_1freq_after_retreat(exptnames,trials);
        [exptnames trials]  = sert867_3freq(exptnames,trials);
    case 'sert867_subset'
        [exptnames trials]  = sert867_subset(exptnames,trials);
        
    case 'sert864'
        [exptnames trials]  = sert864(exptnames,trials);
    case 'sert864sub'
        [exptnames trials]  = sert864sub(exptnames,trials);
    case 'sert864_12hz'
        [exptnames trials]  = sert864_12Hz(exptnames,trials);
    case 'sert864_25hz'
        [exptnames trials]  = sert864_25Hz(exptnames,trials);
    case 'sert864_cl'
        [exptnames trials]  = sert864_CL(exptnames,trials);
    case 'sert864_lg'
        [exptnames trials]  = sert864_LG(exptnames,trials);
    case 'sert864_lgcl'
        [exptnames trials]  = sert864_LG(exptnames,trials);
        [exptnames trials]  = sert864_CL(exptnames,trials);
    case 'sert864_3freq'
        [exptnames trials]  = sert864_3freq(exptnames,trials);
    case 'sert864_since_retreat'
        [exptnames trials]  = sert864_1freq_after_retreat(exptnames,trials);
        [exptnames trials]  = sert864_3freq(exptnames,trials);
    case 'sert864_september'
        [exptnames trials]  = sert864_3freq_sept(exptnames,trials);
    case 'sert864_all'
        [exptnames trials]  = sert864_1freq_after_retreat(exptnames,trials);
        [exptnames trials]  = sert864_3freq(exptnames,trials);
        [exptnames trials]  = sert864_3freq_sept(exptnames,trials);
        
    case 'fi12_1013_ramp'
        [exptnames trials]  = fi12_1013_ramp(exptnames,trials);
    case 'fi12_1013_7hz'
        [exptnames trials]  = fi12_1013_7hz(exptnames,trials);
    case 'fi12_1013_3freq'
        [exptnames trials]  = fi12_1013_3freq(exptnames,trials);
    case 'fi12_1013_3freq_2'
        [exptnames trials]  = fi12_1013_3freq_2(exptnames,trials);
    case 'fi12_1013_3freq_all'
        [exptnames trials]  = fi12_1013_3freq(exptnames,trials);
        [exptnames trials]  = fi12_1013_3freq_2(exptnames,trials);
    case 'fi12_1013_3freq_2_lastweek'
        [exptnames trials]  = fi12_1013_3freq_2_lastweek(exptnames,trials);
    case 'fi12_1013_september'
        [exptnames trials]  = fi12_1013_3freq_sept(exptnames,trials);
    case 'fi12_1013_control'
        [exptnames trials]  = fi12_1013_control(exptnames,trials);
    case 'fi12_1013_ind'
        [exptnames trials]  = fi12_1013_ind(exptnames,trials);
        
        
    case 'fi12_1020_3freq'
        [exptnames trials]  = fi12_1020_3freq(exptnames,trials);
    case 'fi12_1020_3freq_2'
        [exptnames trials]  = fi12_1020_3freq_2(exptnames,trials);
    case 'fi12_1020_3freq_all'
        [exptnames trials]  = fi12_1020_3freq(exptnames,trials);
        [exptnames trials]  = fi12_1020_3freq_2(exptnames,trials);
    case 'fi12_1020_3freq_2_lastweek'
        [exptnames trials]  = fi12_1020_3freq_2_lastweek(exptnames,trials);
    case 'fi12_1020_september'
        [exptnames trials]  = fi12_1020_3freq_sept(exptnames,trials);
    case 'fi12_1020_control'
        [exptnames trials]  = fi12_1020_control(exptnames,trials);
    case 'fi12_1020_ind'
        [exptnames trials]  = fi12_1020_ind(exptnames,trials);
        
    case 'fi1447_1020_september'
        [exptnames trials]  = fi12_1020_3freq_sept(exptnames,trials);
        
        
        
    case 'fi12_control'
        [exptnames trials]  = fi12_1013_control(exptnames,trials);
        [exptnames trials]  = fi12_1020_control(exptnames,trials);
        
        
        
    case 'fi12_3freq'
        [exptnames trials]  = fi12_1020_3freq(exptnames,trials);
        [exptnames trials]  = fi12_1013_3freq(exptnames,trials);
        [exptnames trials]  = fi12_1013_3freq_2(exptnames,trials);
        [exptnames trials]  = fi12_1020_3freq_2(exptnames,trials);
        
        
        
    case 'sert_lg'
        [exptnames trials]  = sert864_LG(exptnames,trials);
        [exptnames trials]  = sert867_LG(exptnames,trials);
        [exptnames trials]  = sert864_LG(exptnames,trials);
    case 'sert_cl'
        [exptnames trials]  = sert864_CL(exptnames,trials);
        [exptnames trials]  = sert867_CL(exptnames,trials);
        [exptnames trials]  = sert868_CL(exptnames,trials);
    case 'sert_lgcl'
        [exptnames trials]  = sert864_LG(exptnames,trials);
        [exptnames trials]  = sert867_LG(exptnames,trials);
        [exptnames trials]  = sert864_LG(exptnames,trials);
        [exptnames trials]  = sert864_CL(exptnames,trials);
        [exptnames trials]  = sert867_CL(exptnames,trials);
        [exptnames trials]  = sert868_CL(exptnames,trials);
        
    case 'sert_since_retreat'
        [exptnames trials]  = sert864_3freq(exptnames,trials);
        [exptnames trials]  = sert868_3freq(exptnames,trials);
        [exptnames trials]  = sert867_3freq(exptnames,trials);
        [exptnames trials]  = sert864_1freq_after_retreat(exptnames,trials);
        [exptnames trials]  = sert867_1freq_after_retreat(exptnames,trials);
        [exptnames trials]  = sert868_1freq_after_retreat(exptnames,trials);
        
    case 'sert_3freq'
        [exptnames trials]  = sert864_3freq(exptnames,trials);
        [exptnames trials]  = sert868_3freq(exptnames,trials);
        [exptnames trials]  = sert867_3freq(exptnames,trials);
        
        
    case 'fi12_24'
        [exptnames trials]  = fi12_24(exptnames,trials);
        
    case 'fi12_1109'
        [exptnames trials]  = fi12_1109(exptnames,trials);
        
    case 'fi12_653'
        [exptnames trials]  = fi12_653(exptnames,trials);
    case 'fi12_652_yellow'
        [exptnames trials]  = fi12_652_yellow(exptnames,trials);
        
    case 'fi12_652_green'
        [exptnames trials]  = fi12_652_green(exptnames,trials);
        
        
    case 'fi12xarch_1447'
        [exptnames trials]  = fi12xarch_1447(exptnames,trials);
    case 'fi12xarch_1447_control'
        [exptnames trials]  = fi12xarch_1447_control(exptnames,trials);
    case 'fi12xarch_115_control'
        [exptnames trials]  = fi12xarch_115_control(exptnames,trials);
    case 'fi12xarch_116_control'
        [exptnames trials]  = fi12xarch_116_control(exptnames,trials);
    case 'fi12xarch_117_control'
        [exptnames trials]  = fi12xarch_117_control(exptnames,trials);
    case 'fi12xarch_115'
        [exptnames trials]  = fi12xarch_115(exptnames,trials);
        
    case 'fi12xarch_116'
        [exptnames trials]  = fi12xarch_116(exptnames,trials);
        
    case 'fi12xarch_117'
        [exptnames trials]  = fi12xarch_117(exptnames,trials);
        
   
    
    
    case 'fi12_1444_arch_mystery'
        [exptnames trials]  = fi12_1444_arch_mystery(exptnames,trials);
        
    case 'fi12_1446_arch_mystery'
        [exptnames trials]  = fi12_1446_arch_mystery(exptnames,trials);
        
    case 'fi12_974_arch_mystery'
        [exptnames trials]  = fi12_974_arch_mystery(exptnames,trials);
        
    case 'fi12_1016_arch_mystery'
        [exptnames trials]  = fi12_1016_arch_mystery(exptnames,trials);
        
    case 'fi12_1085_arch_mystery'
        [exptnames trials]  = fi12_1085_arch_mystery(exptnames,trials);
   
    case 'fi12_1020_arch_mystery'
        [exptnames trials]  = fi12_1020_arch_mystery(exptnames,trials);
             
    case 'fi12_1013_arch_mystery'
        [exptnames trials]  = fi12_1013_arch_mystery(exptnames,trials);
               
        
        
        
        
        
        
    case 'fi12_1446_arch'
        [exptnames trials]  = fi12_1446_arch(exptnames,trials);
        
        
    case 'fi12_974_arch'
        [exptnames trials]  = fi12_974_arch(exptnames,trials);
        
        
        
        
    case 'fi12_1293_arch_highpower'
        [exptnames trials]  = fi12_1293_arch_highPower(exptnames,trials);
        
    case 'fi12_1293_arch_mediumpower'
        [exptnames trials]  = fi12_1293_arch_mediumPower(exptnames,trials);
        
        
    case 'fi12_1293_arch_lowpower'
        [exptnames trials]  = fi12_1293_arch_lowPower(exptnames,trials);
        
        
    case 'fi12_archvirus'
         [exptnames trials]  = fi12_1446_arch(exptnames,trials);
        [exptnames trials]  = fi12_974_arch(exptnames,trials);
           
        
    case 'fi12_all'
        [exptnames trials]  = fi12_1020_3freq(exptnames,trials);
        [exptnames trials]  = fi12_1013_3freq(exptnames,trials);
        [exptnames trials]  = fi12_1013_3freq_2(exptnames,trials);
        [exptnames trials]  = fi12_1020_3freq_2(exptnames,trials);
        [exptnames trials]  = fi12_24(exptnames,trials);
        [exptnames trials]  = fi12_653(exptnames,trials);
        
end

function      [exptnames trials]  =sert502HIGHPOWER(exptnames,trials)
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140711_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140712_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140713_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140714_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140715_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140716_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140717_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140722_SSAB_(I)1';
trials{end+1} = [];

function [exptnames trials] = sert502(exptnames,trials)
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140612_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140614_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140615_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140616_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140624_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140625_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140626_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140627_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140628_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140629_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140630_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140702_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140703_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140704_SSAB_(I)1';
trials{end+1} = [];    
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140705_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140706_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140707_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_502_TAFCv08_stimulation03_box6_140708_SSAB_(I)1';
trials{end+1} = [];

function [exptnames trials] = sert504ok(exptnames,trials)
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140626_SSAB_(I)1'; 
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140628_SSAB_(I)1'; 
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140630_SSAB_(I)1'; 
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140705_SSAB_(I)1'; 
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140708_SSAB_(I)1'; 
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140718_SSAB_(I)1'; 
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140722_SSAB_(I)1'; 

function [exptnames trials] = sert504(exptnames,trials)
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140616_SSAB_(I)1'; 
trials{end+1} = [];
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140625_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140626_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140627_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140628_SSAB_(I)1'; % 10mW
trials{end+1} = [];
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140629_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140630_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140702_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140703_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140704_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140705_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140706_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140707_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140708_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140709_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140710_SSAB_(I)1'; % 4mW
trials{end+1} = [];
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140718_SSAB_(I)1'; % 5mW
trials{end+1} = [];
exptnames{end+1} = 'Sert_504_TAFCv08_stimulation03_box5_140722_SSAB_(I)1'; % 1.5mW
trials{end+1} = [];
function [exptnames trials] = sert179(exptnames,trials)
% CHANGED.. LATER>>> NOT STIMULATING IN BLOCKS AND STIMULI DIFFERENT
% MESSES FIts UP
% exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140423_SSAB_(I)1';
% trials{end+1} = [];
% exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140421_SSAB_(I)1';
% trials{end+1} = [];
% exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140419_SSAB_(I)1';
% trials{end+1} = [];
% exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140416_SSAB_(I)1';
% trials{end+1} = [];
% exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140415_SSAB_(I)1';
% trials{end+1} = [];
% exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140414_SSAB_(I)1';
% trials{end+1} = [];
% exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140411_SSAB_(I)1';
% trials{end+1} = [];
% exptnames{end+1} =
% 'SertxChR2_179_TAFCv08_stimulation02_box2_140409_SSAB_(I)1'; % exclude
% poor performance
% trials{end+1} = [];
% exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140408_SSAB_(I)1';
% trials{end+1} = [];
% exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140407_SSAB_(I)1';
% trials{end+1} = [];
% 25Hz 28mW
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140228_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140227_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140226_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140225_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation03_box2_140603_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation03_box2_140602_SSAB_(I)2';
trials{end+1} = [];


function [exptnames trials] = sert179_ephys(exptnames,trials)
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140205_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140215_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140216_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140219_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140220_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140222_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140223_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140225_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140226_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140227_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140228_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140307_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140308_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140310_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140311_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140312_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140313_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140314_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation02_box2_140317_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation03_box2_140527_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation03_box2_140529_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation03_box2_140530_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation03_box2_140604_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation03_box2_140605_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_179_TAFCv08_stimulation03_box2_140606_SSAB_(I)1';
trials{end+1} = [];

function [exptnames trials] = sert775_AAV29(exptnames,trials)
exptnames{end+1} = 'SertxChR2_775_TAFCv08_stimulation03_box5_140715_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_775_TAFCv08_stimulation03_box5_140716_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_775_TAFCv08_stimulation03_box5_140717_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_775_TAFCv08_stimulation03_box5_140718_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_775_TAFCv08_stimulation03_box5_140719_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_775_TAFCv08_stimulation03_box5_140722_SSAB_(I)1';
trials{end+1} = [];

function [exptnames trials] = sert775(exptnames,trials)
exptnames{end+1} = 'SertxChR2_775_TAFCv08_stimulation03_box6_140612_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_775_TAFCv08_stimulation03_box6_140611_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_775_TAFCv08_stimulation03_box6_140606_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_775_TAFCv08_stimulation03_box6_140605_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_775_TAFCv08_stimulation03_box6_140604_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_775_TAFCv08_stimulation03_box6_140603_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_775_TAFCv08_stimulation03_box6_140602_SSAB_(I)1';
trials{end+1} = [];

function [exptnames trials] = sert785(exptnames,trials)
exptnames{end+1} = 'SertxChR2_785_TAFCv08_stimulation03_box6_140528_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_785_TAFCv08_stimulation03_box6_140529_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_785_TAFCv08_stimulation03_box6_140529_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_785_TAFCv08_stimulation03_box6_140601_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_785_TAFCv08_stimulation03_box6_140602_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_785_TAFCv08_stimulation03_box6_140603_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_785_TAFCv08_stimulation03_box6_140604_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_785_TAFCv08_stimulation03_box6_140605_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_785_TAFCv08_stimulation03_box6_140606_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_785_TAFCv08_stimulation03_box6_140611_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'SertxChR2_785_TAFCv08_stimulation03_box6_140613_SSAB_(I)1';
trials{end+1} = [];

function [exptnames trials] = sert1421stim(exptnames,trials)
exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_140110_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_140108_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_140107_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_140106_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_140103_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_140102_SSAB_(I)1';
trials{end+1} = [];
function [exptnames trials] = sert1421stim35mW(exptnames,trials)
exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_140124_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_140125_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_140126_SSAB_(I)1';
trials{end+1} = [];
% exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_140127_SSAB_(I)1'; % performance a bit poorer
% trials{end+1} = [];
exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_140128_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_140129_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_140130_SSAB_(I)1';
trials{end+1} = [];
% exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_140203_SSAB_(I)1'; % performancepoorer
% trials{end+1} = [];
% exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_140204_SSAB_(I)1'; % performance poorer
% trials{end+1} = [];
exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_140205_SSAB_(I)1';
trials{end+1} = [];
% exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_140206_SSAB_(I)1';
% trials{end+1} = [];

function [exptnames trials] = sert1422stim35mW(exptnames,trials)
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_140124_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_140125_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_140126_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_140127_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_140128_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_140129_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_140130_SSAB_(I)1'; % performance a bit poorer
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_140203_SSAB_(I)1'; % performance a bit poorer
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_140204_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_140205_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_140206_SSAB_(I)1';
trials{end+1} = [];



function [exptnames trials] = sert1422stim(exptnames,trials)
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_140110_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_140109_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_140108_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_140107_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_140106_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_140104_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_140103_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_140102_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_131231_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_131230_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_131230_SSAB_(I)1';
trials{end+1} = [];


function [exptnames trials] = sert1421base(exptnames,trials)
exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_131209_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_131207_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_131206_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_131205_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_131204_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_131203_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_131202_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1421_TAFCv08_stimulation02_box1_131201_SSAB_(I)1';
trials{end+1} = [];

function [exptnames trials] = sert1422base(exptnames,trials)
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_131209_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_131207_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_131206_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_131205_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_131204_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_131203_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_131202_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_1422_TAFCv08_stimulation02_box1_131201_SSAB_(I)1';
trials{end+1} = [];

function [exptnames trials] = fi12_1013_ramp(exptnames,trials)
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation01_box4_130514_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation01_box4_130516_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation01_box4_130520_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box4_130523_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box4_130524_SSAB';
trials{end+1} = [];
% exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box4_130525_SSAB';
% trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box4_130526_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box4_130527_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box4_130529_SSAB';
trials{end+1} = [];

function [exptnames trials] = fi12_1013_7hz(exptnames,trials)
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box4_130613_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box4_130615_SSAB';
trials{end+1} = [];
% exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box4_130629_SSAB';
% trials{end+1} = []; %error - dp has one more trial on correction loop
% field
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box4_130630_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box4_130703_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box4_130707_SSAB';
trials{end+1} = [];

function [exptnames trials] = fi12_1013_control(exptnames,trials)
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130720_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130721_SSAB';
trials{end+1} = [];



function [exptnames trials] = fi12_1013_3freq(exptnames,trials)
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130710_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130713_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130715_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130717_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130718_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130719_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130722_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130723_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130724_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130725_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130726_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130728_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130729_SSAB_(I)1';
trials{end+1} = [];

function [exptnames trials] = fi12_1013_3freq_2(exptnames,trials)
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130731_SSAB_(I)1';
trials{end+1} = [];
% exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130801_SSAB_(I)1';
% trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130815_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130816_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130817_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130818_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130819_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130820_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130821_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130822_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130823_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130824_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130825_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130826_Zero_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130827_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130828_SSAB_(I)1';
trials{end+1} = [];


function [exptnames trials] = fi12_1013_3freq_2_lastweek(exptnames,trials)
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130916_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130917_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130918_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130919_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130920_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130921_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130922_SSAB_(I)1';
trials{end+1} = [];

function [exptnames trials] = fi12_1013_3freq_sept(exptnames,trials)
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130911_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130912_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130913_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130915_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130916_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130917_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130918_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130919_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130920_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130921_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130922_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130923_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130924_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130925_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130926_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130927_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130930_SSAB_(I)1';
trials{end+1} = [];


function [exptnames trials] = fi12_1013_ind(exptnames,trials)
exptnames{end+1} = 'FI12_1013_TAFCv08_stimulation02_box3_130729_SSAB_(I)1';
trials{end+1} = [];




function [exptnames trials] = fi12_1020_control(exptnames,trials)
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130719_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130720_SSAB';
trials{end+1} = [];



function [exptnames trials] = fi12_1020_3freq(exptnames,trials)
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130714_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130715_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130712_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130716_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130717_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130718_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130722_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130723_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130724_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130726_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130729_SSAB_(I)1';
trials{end+1} = [];


function [exptnames trials] = fi12_1020_3freq_2(exptnames,trials)
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130731_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130801_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130812_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130815_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130816_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130817_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130818_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130819_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130820_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130821_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130822_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130823_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130824_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130826_SSAB_(I)1';
trials{end+1} = [];

function [exptnames trials] = fi12_1020_3freq_2_lastweek(exptnames,trials)
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130916_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130917_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130918_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130919_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130920_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130921_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130922_SSAB_(I)1';
trials{end+1} = [];

function [exptnames trials] = fi12_1020_3freq_sept(exptnames,trials)
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130910_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130911_SSAB_(I)1';
trials{end+1} = [];
% exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130912_SSAB_(I)1';
% trials{end+1} = []; %very few trials
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130913_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130915_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130916_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130917_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130918_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130919_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130920_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130921_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130922_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130923_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130924_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130925_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130926_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130927_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130930_SSAB_(I)1';
trials{end+1} = [];


function [exptnames trials] = fi12_1020_ind(exptnames,trials)
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130715_SSAB';
trials{end+1} = [];


function [exptnames trials] = fi12xarch_115_control(exptnames,trials)
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140211_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140213_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140214_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140215_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140217_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140219_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140220_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140223_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140224_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140225_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140226_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140227_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140228_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140301_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140304_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140305_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140306_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140307_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140309_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140310_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140312_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140313_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140315_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140317_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140319_SSAB_(I)1';
trials{end+1} = [];

function [exptnames trials] = fi12xarch_116_control(exptnames,trials)
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140211_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140213_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140214_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140215_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140217_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140219_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140220_SSAB_(I)1';
trials{end+1} = [];
% exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140222_SSAB_(I)1'; % no stimulation
% trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140225_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140226_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140227_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140228_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140301_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140303_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140304_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140305_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140306_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140307_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140308_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140310_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140313_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140315_SSAB_(I)1';
trials{end+1} = [];



function [exptnames trials] = fi12xarch_117_control(exptnames,trials)
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140211_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140214_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140215_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140217_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140219_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140220_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140221_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140224_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140225_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140227_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140228_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140301_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140303_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140305_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140307_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140308_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140310_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140311_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140312_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140313_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140314_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140317_SSAB_(I)1';
trials{end+1} = [];

function [exptnames trials] = fi12xarch_1447_control(exptnames,trials)
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_140211_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_140212_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_140214_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_140215_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_140217_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_140219_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_140224_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_140225_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_140226_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_140227_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_140228_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_140301_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_140303_SSAB_(I)1';
trials{end+1} = [];

function [exptnames trials] = fi12xarch_1447_1freq(exptnames,trials)
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box4_131024_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box4_131025_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box4_131026_SSAB_(I)1';
trials{end+1} = [];
% exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box4_131027_SSAB_(I)1'; %bad performance
% trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box4_131028_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box4_131029_SSAB_(I)1';
trials{end+1} = [];




function [exptnames trials] = sert867(exptnames,trials)
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box3_130602_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box3_130603_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box3_130604_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box3_130605_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box3_130606_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box3_130608_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box3_130610_SSAB';  % 10mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box3_130611_SSAB';  % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box3_130612_SSAB';  % 10mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box3_130613_SSAB';  % 5mW 12Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box3_130615_SSAB';  % 5mW 12Hz
trials{end+1} = [];




function [exptnames trials] = sert868(exptnames,trials)
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box3_130615_SSAB';  % 10mW
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box3_130614_SSAB';  % 10mW
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box3_130613_SSAB';  % 10mW
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box3_130612_SSAB';  % 8mW  % poor performance
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box3_130611_SSAB';  % 8mW
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box3_130610_SSAB';  % 10mW
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box3_130608_SSAB';  % started blocks
trials{end+1} = [];
% exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box3_130521_SSAB';  % poor performance
% trials{end+1} = [];
% exptnames{end+1} = 'Sert_868_TAFCv08_stimulation01_box3_130520_SSAB';  % 8 stimuli weighted
% trials{end+1} = [1:500];
% exptnames{end+1} = 'Sert_868_TAFCv08_stimulation01_box3_130516_SSAB';    % 8 stimuli weighted
% trials{end+1} = [];
% exptnames{end+1} = 'Sert_868_TAFCv08_stimulation01_box3_130514_SSAB';   % 8 stimuli weighted
% trials{end+1} = [];
% exptnames{end+1} = 'Sert_868_TAFCv08_stimulation01_box3_130513_SSAB'; % 8 stimuli (weighted) reward not equal
% trials{end+1} = [];
% exptnames{end+1} = 'Sert_868_TAFCv08_stimulation01_box3_130512_SSAB'; %  8 stimuli (weighted)reward not equal
% trials{end+1} = [];
% exptnames{end+1} = 'Sert_868_TAFCv08_stimulation01_box3_130511_SSAB'; %  8 stimuli (weighted) reward not equal
% trials{end+1} = [];
%
exptnames = exptnames(end:-1:1);
trials = trials(end:-1:1);
function [exptnames trials] = sert868high(exptnames,trials)
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box3_130615_SSAB';  % 10mW
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box3_130614_SSAB';  % 10mW
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box3_130613_SSAB';  % 10mW
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box3_130612_SSAB';  % 8mW
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box3_130611_SSAB';  % 8mW
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box3_130610_SSAB';  % 10mW
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box3_130608_SSAB';  % started blocks
trials{end+1} = [];
exptnames = exptnames(end:-1:1);
trials = trials(end:-1:1);

function [exptnames trials] = sert868low(exptnames,trials)
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box3_130521_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation01_box3_130520_SSAB';
trials{end+1} = [1:500];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation01_box3_130516_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation01_box3_130514_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation01_box3_130513_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation01_box3_130512_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation01_box3_130511_SSAB';
trials{end+1} = [];

exptnames = exptnames(end:-1:1);
trials = trials(end:-1:1);

function [exptnames trials]  =sert868sub(exptnames,trials)
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130721_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130719_SSAB';
trials{end+1} = [1:500];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130718_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130716_SSAB';
trials{end+1} = [];

function [exptnames trials] = sert864sub(exptnames,trials)
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130724_SSAB_(I)1'; % different protocol (8 stimuli weighted (performance inc lurase)
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130723_SSAB_(I)1'; % different protocol (8 stimuli weighted (performance inc lurase)
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130713_SSAB'; % different protocol (8 stimuli weighted (performance inc lurase)
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130711_SSAB'; % different protocol (8 stimuli weighted (performance inc lurase)
trials{end+1} = [];
% exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box3_130707_SSAB'; % different protocol (8 stimuli weighted (performance inc lurase)
% trials{end+1} = [];
% exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box3_130708_SSAB'; % different protocol (8 stimuli weighted (performance inc lurase)
trials{end+1} = [];


function [exptnames trials] = sert864(exptnames,trials)
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130520_SSAB'; % different protocol (8 stimuli weighted (performance inc lurase)
trials{end+1} = [];
% exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130521_SSAB';   % poor performance
% trials{end+1} = [];
% exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130602_SSAB'; % poor performance
% trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130603_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130604_SSAB';
trials{end+1} = [];
% exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130605_SSAB'; %% poor performance excluded
% trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130611_SSAB';   % 10mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130612_SSAB';   % 8mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130613_SSAB';   % 5mW 12Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130614_SSAB';   % 5mW 12Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130628_SSAB';   % 5mW 12Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box3_130701_SSAB';   % 5mW 12Hz
trials{end+1} = [];

function [exptnames trials] = sert864_12Hz(exptnames,trials)
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130613_SSAB';   % 5mW 12Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130614_SSAB';   % 5mW 12Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130628_SSAB';   % 5mW 12Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box3_130701_SSAB';   % 5mW 12Hz
trials{end+1} = [];

function [exptnames trials] = sert864_25Hz(exptnames,trials)
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130603_SSAB'; % non block
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130604_SSAB'; % non block
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130605_SSAB'; % non block
trials{end+1} = [];

function [exptnames trials] = sert864_CL(exptnames,trials) % Crystal Laser
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box3_130702_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box3_130703_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box3_130704_SSAB';   % 5mW 25Hz
trials{end+1} = [];


function [exptnames trials] = sert864_LG(exptnames,trials) % LaserGlow
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box3_130706_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box3_130707_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box3_130708_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130711_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130713_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130715_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130716_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130717_SSAB';   % 5mW 25Hz
trials{end+1} = [];



function [exptnames trials] = sert868_LG(exptnames,trials)
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box3_130702_SSAB'; % non block
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box3_130703_SSAB'; % non block
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box3_130704_SSAB'; % non block
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130712_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130714_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130715_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130718_SSAB';   % 5mW 25Hz
trials{end+1} = [];


function [exptnames trials] = sert868_CL(exptnames,trials) % Crystal Laser
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130706_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box3_130708_SSAB';   % 5mW 25Hz
trials{end+1} = [];


function [exptnames trials] = sert864_1freq_after_retreat(exptnames,trials) %
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box3_130702_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box3_130703_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box3_130704_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box3_130706_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box3_130707_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box3_130708_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130711_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130713_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130715_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130716_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130717_SSAB';   % 5mW 25Hz
trials{end+1} = [];

function [exptnames trials] = sert864_3freq(exptnames,trials) % from July 19 2013 on we started using 3 frequencies
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130719_SSAB';   %
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130720_SSAB';   %
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130722_SSAB';   %
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130723_SSAB_(I)1';   %
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130724_SSAB_(I)1';   %
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130726_SSAB_(I)1';   %
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130823_SSAB_(I)1';   %
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130824_SSAB_(I)1';   %
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130826_SSAB_(I)1';   %
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130828_SSAB_(I)1';   %
trials{end+1} = [];

function [exptnames trials] = sert864_3freq_sept(exptnames,trials)
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130910_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130911_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130912_SSAB_(I)1';
trials{end+1} = [];
% exptnames{end+1} =
% 'Sert_864_TAFCv08_stimulation02_box4_130913_SSAB_(I)1'; % stimulated every trial
% trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130915_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130916_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130917_SSAB_(I)1';
trials{end+1} = [];
% exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130918_SSAB_(I)1';
% trials{end+1} = []; %bad behavior, flat
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130919_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130920_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130921_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130922_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130923_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130924_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130925_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130926_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130927_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130928_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_864_TAFCv08_stimulation02_box4_130930_SSAB_(I)1';
trials{end+1} = [];

function [exptnames trials] = sert867_25hz(exptnames,trials)
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box3_130606_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box3_130608_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box3_130610_SSAB';  % 10mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box3_130611_SSAB';  % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box3_130612_SSAB';  % 10mW 25Hz
trials{end+1} = [];


function [exptnames trials] = sert867_12hz(exptnames,trials)
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box3_130613_SSAB';  % 5mW 12Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box3_130615_SSAB';  % 5mW 12Hz
trials{end+1} = [];


%
% function [exptnames trials] = sert867_CL(exptnames,trials) % Crystal Laser
% exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130701_SSAB';   % 5mW 25Hz
% trials{end+1} = [];
% exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130702_SSAB';   % 5mW 25Hz
% trials{end+1} = [];
% exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130703_SSAB';   % 5mW 25Hz
% trials{end+1} = [];
% exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130704_SSAB';   % 5mW 25Hz
% trials{end+1} = [];
%
%
% function [exptnames trials] = sert867_LG(exptnames,trials) % LaserGlow
% % exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box3_130705_SSAB';   % (box3)5mW 25Hz
% % trials{end+1} = []; THIS DAY HAS BAD TRAJECTORIES
% exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box3_130706_SSAB';   % (box3)5mW 25Hz
% trials{end+1} = [];
% exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130707_SSAB';   % (box4)5mW 25Hz
% trials{end+1} = [];
% exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130708_SSAB';   % (box4)5mW 25Hz
% trials{end+1} = [];
% exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130715_SSAB';   % (box4)5mW 25Hz
% trials{end+1} = [];


function [exptnames trials] = sert867_1freq_after_retreat(exptnames,trials) %
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130701_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130702_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130703_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130704_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box3_130706_SSAB';   % (box3)5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130707_SSAB';   % (box4)5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130708_SSAB';   % (box4)5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130715_SSAB';   % (box4)5mW 25Hz
trials{end+1} = [];


function [exptnames trials] = sert867_3freq(exptnames,trials)
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130723_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130725_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130729_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130731_SSAB_(I)1';
trials{end+1} = [];
% exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130812_SSAB_(I)1';
% trials{end+1} = []; % a hack, error on this file
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130817_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130819_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130820_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130821_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130823_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130825_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130826_SSAB_(I)1';
trials{end+1} = [];
% exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130910_SSAB_(I)1';
% trials{end+1} = [];
% exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130911_SSAB_(I)1';
% trials{end+1} = [];
% exptnames{end+1} = 'Sert_867_TAFCv08_stimulation02_box4_130912_SSAB_(I)1';
% trials{end+1} = [];


function [exptnames trials] = sert868_1freq_after_retreat(exptnames,trials) %
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130706_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box3_130708_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130712_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130714_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130715_SSAB';   % 5mW 25Hz
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130718_SSAB';   % 5mW 25Hz
trials{end+1} = [];


function [exptnames trials] = sert868_3freq(exptnames,trials) % starting July 21 2013
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130721_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130722_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130724_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130726_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130729_SSAB_(I)2';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130731_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130801_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130812_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130815_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130816_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130818_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130819_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130820_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130821_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130822_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130824_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130826_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130828_SSAB_(I)1';
trials{end+1} = [];

function [exptnames trials] = sert868_3freq_sept(exptnames,trials)
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130910_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130911_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130912_SSAB_(I)1';
trials{end+1} = [];
% exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130913_SSAB_(I)1';
% trials{end+1} = []; %stimulated every single trial
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130915_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130916_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130917_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130918_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130919_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130920_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130921_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130922_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130923_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130924_SSAB_(I)1';
trials{end+1} = [];
% exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130925_SSAB_(I)1';
% trials{end+1} = []; %%file may have a problm
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130928_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'Sert_868_TAFCv08_stimulation02_box4_130930_SSAB_(I)1';
trials{end+1} = [];


function [exptnames trials]  = fi12_24(exptnames,trials)
exptnames{end+1} = 'FI12_24_TAFCv08_stimulation02_box4_131203_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_24_TAFCv08_stimulation02_box4_131204_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_24_TAFCv08_stimulation02_box4_131211_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_24_TAFCv08_stimulation02_box4_131212_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_24_TAFCv08_stimulation02_box4_131213_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_24_TAFCv08_stimulation02_box4_131215_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_24_TAFCv08_stimulation02_box4_131217_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_24_TAFCv08_stimulation02_box4_131218_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_24_TAFCv08_stimulation02_box4_131219_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_24_TAFCv08_stimulation02_box4_131219_SSAB_(I)2';
trials{end+1} = [];





function [exptnames trials]  = fi12_1109(exptnames,trials)
exptnames{end+1} = 'FI12_1109_TAFCv08_Fixation_stimulation02_box4_131202_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1109_TAFCv08_Fixation_stimulation02_box4_131203_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1109_TAFCv08_Fixation_stimulation02_box4_131210_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1109_TAFCv08_Fixation_stimulation02_box4_131211_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1109_TAFCv08_Fixation_stimulation02_box4_131212_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1109_TAFCv08_Fixation_stimulation02_box4_131219_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1109_TAFCv08_Fixation_stimulation02_box4_131220_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1109_TAFCv08_Fixation_stimulation02_box4_131223_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1109_TAFCv08_Fixation_stimulation02_box4_131227_SSAB_(I)1';
trials{end+1} = [];

function [exptnames trials]  = fi12_653(exptnames,trials)
exptnames{end+1} = 'FI12_653_TAFCv08_stimulation02_box1_140405_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_653_TAFCv08_stimulation02_box1_140406_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_653_TAFCv08_stimulation02_box1_140407_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_653_TAFCv08_stimulation02_box1_140408_SSAB_(I)2';
trials{end+1} = [];
exptnames{end+1} = 'FI12_653_TAFCv08_stimulation02_box1_140409_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_653_TAFCv08_stimulation02_box1_140411_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_653_TAFCv08_stimulation02_box1_140413_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_653_TAFCv08_stimulation02_box1_140415_SSAB_(I)1';
trials{end+1} = [];


function [exptnames trials]  = fi12_652_yellow(exptnames,trials)
exptnames{end+1} = 'FI12_652_TAFCv08_stimulation02_box3_140405_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_652_TAFCv08_stimulation02_box3_140406_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_652_TAFCv08_stimulation02_box3_140407_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_652_TAFCv08_stimulation02_box3_140408_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_652_TAFCv08_stimulation02_box3_140409_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_652_TAFCv08_stimulation02_box3_140410_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_652_TAFCv08_stimulation02_box3_140411_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_652_TAFCv08_stimulation02_box3_140413_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_652_TAFCv08_stimulation02_box3_140414_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_652_TAFCv08_stimulation02_box3_140423_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_652_TAFCv08_stimulation02_box3_140424_SSAB_(I)1';
trials{end+1} = [];

%  exptnames{end+1} = 'FI12_652_TAFCv08_stimulation02_box3_140426_SSAB_(I)1';
%  trials{end+1} = [];
%  exptnames{end+1} = 'FI12_652_TAFCv08_stimulation02_box3_140428_SSAB_(I)1';
%  trials{end+1} = [];
%  exptnames{end+1} = 'FI12_652_TAFCv08_stimulation02_box3_140429_SSAB_(I)1';
%  trials{end+1} = [];
%   exptnames{end+1} = 'FI12_652_TAFCv08_stimulation02_box3_140430_SSAB_(I)1';
%  trials{end+1} = [];
%   exptnames{end+1} = 'FI12_652_TAFCv08_stimulation02_box3_140501_SSAB_(I)1';
%  trials{end+1} = [];

function [exptnames trials]  = fi12_652_green(exptnames,trials)
exptnames{end+1} = 'FI12_652_TAFCv08_stimulation03_box3_140628_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_652_TAFCv08_stimulation03_box3_140629_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_652_TAFCv08_stimulation03_box3_140702_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_652_TAFCv08_stimulation03_box3_140703_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_652_TAFCv08_stimulation03_box3_140704_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_652_TAFCv08_stimulation03_box3_140705_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_652_TAFCv08_stimulation03_box3_140706_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_652_TAFCv08_stimulation03_box3_140707_SSAB_(I)1';
trials{end+1} = [];
 
 
function [exptnames trials]  = fi12xarch_1447(exptnames,trials)
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_131209_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_131210_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_131211_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_131211_SSAB_(I)2';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_131212_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_131213_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_131219_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_131220_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_131221_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_131223_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_1447_TAFCv08_stimulation02_box2_131224_SSAB_(I)1';
trials{end+1} = [];



function [exptnames trials]  = fi12xarch_115(exptnames,trials)
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140124_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140125_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140126_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140128_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140129_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140130_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140203_SSAB_(I)1'; % poor performance (doesn't seem to make a difference if included or not)
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140204_SSAB_(I)1'; % poor performance (doesn't seem to  make a difference if included or not)
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140205_SSAB_(I)1'; % bit poor performance
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_115_TAFCv08_stimulation02_box4_140206_SSAB_(I)1'; % bit poor performance
trials{end+1} = [];

function [exptnames trials]  = fi12xarch_116(exptnames,trials)
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140124_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140126_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140128_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140129_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140130_SSAB_(I)1'; % bit poorer performance
trials{end+1} = [];
% exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140203_SSAB_(I)1'; %crap performance
% trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140204_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140205_SSAB_(I)1';
trials{end+1} = [];
% exptnames{end+1} = 'FI12xArch_116_TAFCv08_stimulation02_box4_140206_SSAB_(I)1'; %crap performance
% trials{end+1} = [];



function [exptnames trials]  = fi12xarch_117(exptnames,trials)
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140123_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140124_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140125_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140126_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140127_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140128_SSAB_(I)1';
trials{end+1} = [];
% exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140129_SSAB_(I)1'; % biased long
% trials{end+1} = [];
% exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140130_SSAB_(I)1'; % poor performance
% trials{end+1} = [];
% exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140204_SSAB_(I)1'; % bit bias long
% trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140205_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12xArch_117_TAFCv08_stimulation02_box4_140206_SSAB_(I)1';
trials{end+1} = [];



function [exptnames trials]  = fi12_1444_arch_mystery(exptnames,trials)
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box2_141024_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box2_141025_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box2_141026_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box2_141027_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box2_141028_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box2_141106_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box2_141107_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141108_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141109_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141110_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141111_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141112_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141113_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141114_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141115_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141116_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141117_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141118_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141119_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141120_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141121_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141124_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141125_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141126_SSAB_(I)2';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141128_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141201_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141202_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141203_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141204_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1144_TAFCv08_stimulation03_box4_141205_SSAB_(I)1';
trials{end+1} = [];



function [exptnames trials]  = fi12_1446_arch_mystery(exptnames,trials)
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
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141106_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141107_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141108_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141109_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141110_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141111_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141112_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141113_SSAB_(I)1';
trials{end+1} = [];
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
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141120_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141121_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141122_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141123_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141124_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141125_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141127_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141128_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141201_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141202_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141203_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141204_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141205_SSAB_(I)1';
trials{end+1} = [];


function [exptnames trials]  = fi12_1446_arch(exptnames,trials)
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
exptnames{end+1} = 'FI12_1146_TAFCv08_stimulation03_box4_141120_SSAB_(I)1';
trials{end+1} = [];



function [exptnames trials]  = fi12_974_arch_mystery(exptnames,trials) 
% exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box1_141014_SSAB_(I)1';
% trials{end+1} = [];
% exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box1_141015_SSAB_(I)1';
% trials{end+1} = [];
% exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box1_141016_SSAB_(I)1';
% trials{end+1} = [];
% exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box1_141017_SSAB_(I)1';
% trials{end+1} = [];
% exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box1_141018_SSAB_(I)1';
% trials{end+1} = [];
% exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box1_141020_SSAB_(I)1';
% trials{end+1} = [];
% exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box1_141021_SSAB_(I)1';
% trials{end+1} = [];
% exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box1_141022_SSAB_(I)1';
% trials{end+1} = [];
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
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box1_141028_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box1_141106_SSAB_(I)2';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box1_141107_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141108_SSAB_(I)2';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141109_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141110_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141112_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141113_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141114_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141115_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141117_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141119_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141120_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141121_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141124_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141125_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141126_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141128_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141130_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141201_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141202_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141203_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141204_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141205_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141207_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141209_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141210_SSAB_(I)1';
trials{end+1} = [];



function [exptnames trials]  = fi12_974_arch(exptnames,trials) 
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141110_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141112_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141113_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141201_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141209_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_974_TAFCv08_stimulation03_box4_141210_SSAB_(I)1';
trials{end+1} = [];





function [exptnames trials]  = fi12_1293_arch_highPower(exptnames,trials)
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_141205_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_141207_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_141208_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_141209_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_141210_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_141212_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_141213_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_141215_SSAB_(I)1';
trials{end+1} = [];



function [exptnames trials]  = fi12_1293_arch_mediumPower(exptnames,trials)
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_141216_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_141217_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_141219_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_141230_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_150102_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_150103_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_150105_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_150106_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_150108_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_150109_SSAB_(I)1';
trials{end+1} = [];



function [exptnames trials]  = fi12_1293_arch_lowPower(exptnames,trials)
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_150115_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_150116_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_150117_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1293_TAFCv08_stimulation03_box4_150118_SSAB_(I)1';
trials{end+1} = [];



function [exptnames trials]  = fi12_1016_arch_mystery(exptnames,trials)
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
exptnames{end+1} = 'FI12_1016_TAFCv08_stimulationREV03_box1_141121_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1016_TAFCv08_stimulationREV03_box1_141121_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1016_TAFCv08_stimulationREV03_box1_141122_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1016_TAFCv08_stimulationREV03_box1_141123_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1016_TAFCv08_stimulationREV03_box1_141124_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1016_TAFCv08_stimulationREV03_box1_141125_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1016_TAFCv08_stimulationREV03_box1_141125_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1016_TAFCv08_stimulationREV03_box1_141126_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1016_TAFCv08_stimulationREV03_box1_141127_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1016_TAFCv08_stimulationREV03_box1_141128_SSAB_(I)1';
trials{end+1} = [];



function [exptnames trials]  = fi12_1085_arch_mystery(exptnames,trials)
exptnames{end+1} = 'FI12_1085_TAFCv08_stimulationREV03_box4_141215_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1085_TAFCv08_stimulationREV03_box4_141216_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1085_TAFCv08_stimulationREV03_box4_141217_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1085_TAFCv08_stimulationREV03_box4_141219_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1085_TAFCv08_stimulationREV03_box4_141222_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1085_TAFCv08_stimulationREV03_box4_150101_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1085_TAFCv08_stimulationREV03_box4_150102_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1085_TAFCv08_stimulationREV03_box4_150103_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1085_TAFCv08_stimulationREV03_box4_150105_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1085_TAFCv08_stimulationREV03_box4_150106_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1085_TAFCv08_stimulationREV03_box4_150107_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1085_TAFCv08_stimulationREV03_box4_150108_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1085_TAFCv08_stimulationREV03_box4_150109_SSAB_(I)1';
trials{end+1} = [];




function [exptnames trials] = fi12_1020_3freq(exptnames,trials)
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130714_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130715_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130712_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130716_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130717_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130718_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130722_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130723_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130724_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130726_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130729_SSAB_(I)1';
trials{end+1} = [];


function [exptnames trials] = fi12_1020_arch_mystery(exptnames,trials)
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box2_130521_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130523_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box1_130524_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box4_130525_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box1_130526_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box1_130531_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box1_130601_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box1_130602_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv06_8stim_box1_130603_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box1_130605_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv06_8stim_box4_130606_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box1_130607_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box1_130608_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv06_8stim_box1_130610_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box1_130611_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box1_130613_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box2_130614_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box4_130627_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box4_130628_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box4_130702_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130711_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130712_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130714_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130715_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130712_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130716_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130717_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130718_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130722_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130723_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130724_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1020_TAFCv08_stimulation02_box3_130726_SSAB_(I)1';
trials{end+1} = [];



function [exptnames trials] = fi12_1013_arch_mystery(exptnames,trials)

exptnames{end+1} = 'FI12_1013_TAFCv06_6stim_130308_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_6stim_130309_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_130310_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_130311_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_130312_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_130317_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_130318_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_130319_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_130320_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_130321_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_130322_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_130324_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_box1_130325_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_box1_130326_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_box3_130327_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_box4_130328_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_box1_130329_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_longerTimeout_box2_130330_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_4stim_box3_130331_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_longerTimeout_box4_130401_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_longerTimeout_box3_130402_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_longerTimeout_box4_130403_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_longerTimeout_box1_130404_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_longerTimeout_box2_130405_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_box3_130406_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_box4_130408_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_box1_130409_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_longerTimeout_box2_130410_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_longerTimeout_box3_130411_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_longerTimeout_box4_130412_SSAB';
trials{end+1} = [];
exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_longerTimeout_box1_130414_SSAB';
trials{end+1} = [];
% exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_longerTimeout_box4_130415_SSAB';
% trials{end+1} = [];
% exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_longerTimeout_box4_130416_SSAB';
% trials{end+1} = [];
% exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_longerTimeout_box1_130417_SSAB';
% trials{end+1} = [];
% exptnames{end+1} = 'FI12_1013_TAFCv06_8stim_longerTimeout_box3_130418_SSAB';
% trials{end+1} = [];

