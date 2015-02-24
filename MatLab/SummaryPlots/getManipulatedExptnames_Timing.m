function [exptnames trials]  = getManipulatedExptnames_Timing(name)
exptnames = {};trials = {};
switch(lower(name))
    
    case 'biii_control'
        [exptnames trials]  =BIII_control(exptnames,trials);
   case 'biii_muscimol'
        [exptnames trials]  =BIII_muscimol(exptnames,trials);
        
        
end

function [exptnames trials] = BIII_control(exptnames,trials)
exptnames{end+1} = 'BIII_TAFCv07_box1_130919_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'BIII_TAFCv07_box1_130922_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'BIII_TAFCv07_box1_130924_SSAB_(I)1'; % crap performance
trials{end+1} = [];
exptnames{end+1} = 'BIII_TAFCv07_box1_130926_SSAB_(I)1'; % sudden injections
trials{end+1} = [];
exptnames{end+1} = 'BIII_TAFCv07_box1_130928_SSAB_(I)1'; %no infusion
trials{end+1} = [];
exptnames{end+1} = 'BIII_TAFCv07_box1_131002_SSAB_(I)1'; 
trials{end+1} = [];
exptnames{end+1} = 'BIII_TAFCv07_box1_131004_SSAB_(I)1'; 
trials{end+1} = [];
exptnames{end+1} = 'BIII_TAFCv07_box1_131007_SSAB_(I)1';  % no infusion
trials{end+1} = [];

function [exptnames trials] = BIII_muscimol(exptnames,trials)
exptnames{end+1} = 'BIII_TAFCv07_box1_130917_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'BIII_TAFCv07_box1_130920_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'BIII_TAFCv07_box1_130921_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'BIII_TAFCv07_box1_130923_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'BIII_TAFCv07_box1_130927_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'BIII_TAFCv07_box1_131001_SSAB_(I)1';
trials{end+1} = [];
exptnames{end+1} = 'BIII_TAFCv07_box1_131003_SSAB_(I)1';
trials{end+1} = [];


