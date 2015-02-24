function dpArray = constructDataParsedArray(expt_names, trials,bDoNotLoadVideoData,brecompute)
% function dpArray = constructDataParsedArray(expt_names, trials)
if ~exist('bDoNotLoadVideoData')
    bDoNotLoadVideoData = 1;
end

r = brigdefs();


if(nargin < 2)
    trials = [];
end

if(nargin < 4)
    brecompute = 0;
end

dpArray = [];
numExpts    = length(expt_names);
for exptIdx = 1:numExpts
    % load Bstruct
    [FileName FilePath nAnimal] = getBfileparts(expt_names{exptIdx} );
    fp = fullfile(r.Dir.DataBehav,nAnimal,[FileName '.txt']);
    if bDoNotLoadVideoData
        thisExpt = builddp(brecompute,bDoNotLoadVideoData,fp );
    else
        thisExpt = loadBstruct(fp);
    end
    if ~isempty(trials)
        if ~isempty(trials{exptIdx});
            thisExpt = filtbdata_trial(thisExpt,trials{exptIdx});
        end
    end
    if isempty(dpArray)
        dpArray = thisExpt;
    else
        dpArray = mergeUnitArrays(0, thisExpt,dpArray); %% this code takes care of cases where they dont' have the same fileds
        
    end
    
     
 end
   