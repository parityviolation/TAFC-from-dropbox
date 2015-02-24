function [dpCond,dpPMCond] = getdpCond(dataParsed,varargin)
% function [dpCond,dpPMCond] = getdpCond(dataParsed,bsplitStimCond,bsplitAllStimCond OR condCell)
% condCell = {0,[1 2],3};
splitType = 'none';
if ~isempty(varargin)
    if iscell(varargin{1})
        condCell =varargin{1};
        splitType = 'custom';
    else
        if ischar(varargin{1})
            if strfind(varargin{1},'all')
                splitType = 'splitAllCond';
            else
                splitType = 'joinAllCond';
            end
        elseif length( varargin)==2% backward compatibility
            if varargin{1}
                splitType = 'joinAllCond';
            end
            if varargin{2}
                splitType = 'splitAllCond';
            end
        end
        
    end
    
    
end

switch (splitType)
    
    case 'custom'
        
        helper();
        if any(cellfun(@(x) ismember(0,x),condCell))
            error('condCell must not contain the control condition i.e. cond value = 0')
        end
        mycolor =  linspace(0.5,1,length(condCell)); % remove cell that has 
        for icond = 1:length(condCell)
            thisCond = filtbdata(dataParsed,0,{'stimulationOnCond',condCell{icond},'ChoiceCorrect',[1 0], 'controlLoop', @(x) isnan(x)|x==0,'TrialInit', @(x) ~isnan(x)});
            thisCond.plotparam.color  = [0 0 1].*mycolor(icond);
            dpCond = mergeUnitArrays(0, thisCond,dpCond);
            thisCond = filtbdata(dataParsed,0,{'stimulationOnCond',condCell{icond},'Premature',1, 'controlLoop', @(x) isnan(x)|x==0,'TrialInit', @(x) ~isnan(x)});
            thisCond.plotparam.color  = [0 0 1].*mycolor(icond);
            dpPMCond = mergeUnitArrays(0, thisCond,dpPMCond);
        end
    case 'splitAllCond'
        helper();
        % TODO Add description string to arduino output
        mycolor =  linspace(0.5,1,length(ncond));
        
        for icond = 1:length(ncond)
            thisCond = filtbdata(dataParsed,0,{'stimulationOnCond',ncond(icond),'ChoiceCorrect',[1 0], 'controlLoop', @(x) isnan(x)|x==0,'TrialInit', @(x) ~isnan(x)});
            thisCond.plotparam.color  = [0 0 1].*mycolor(icond);
            dpCond = mergeUnitArrays(0, thisCond,dpCond);
            thisCond = filtbdata(dataParsed,0,{'stimulationOnCond',ncond(icond),'Premature',1, 'controlLoop', @(x) isnan(x)|x==0,'TrialInit', @(x) ~isnan(x)});
            thisCond.plotparam.color  = [0 0 1].*mycolor(icond);
            dpPMCond = mergeUnitArrays(0, thisCond,dpPMCond);
        end
        
    case 'joinAllCond'
        helper();
        thisCond = filtbdata(dataParsed,0,{'stimulationOnCond',ncond,'ChoiceCorrect',[1 0], 'TrialInit', @(x) ~isnan(x)});
        thisCond.plotparam.color = [0 0 1];
        dpCond = mergeUnitArrays(0, thisCond,dpCond);
        thisCond = filtbdata(dataParsed,0,{'stimulationOnCond',ncond,'Premature',1, 'controlLoop', @(x) isnan(x)|x==0, 'TrialInit', @(x) ~isnan(x)});
        thisCond.plotparam.color = [0 0 1];
        dpPMCond = mergeUnitArrays(0, thisCond,dpPMCond);
        
    case 'none'
        dpCond(1) = filtbdata(dataParsed,0,{'ChoiceCorrect',[1 0], 'controlLoop', @(x) isnan(x)|x==0,'TrialInit', @(x) ~isnan(x)});
        dpCond(1).plotparam.color = 'k';
        dpPMCond(1) = filtbdata(dataParsed,0,{'Premature',1, 'controlLoop', @(x) isnan(x)|x==0,'TrialInit', @(x) ~isnan(x)});
        dpPMCond(1).plotparam.color = 'k';
end

    function helper()
        % no stimulation, valid, no correction loop
        dpCond(1) = filtbdata(dataParsed,0,{'stimulationOnCond',0,'ChoiceCorrect',[1 0], 'controlLoop', @(x) isnan(x)|x==0,'TrialInit', @(x) ~isnan(x)});
        dpCond(1).plotparam.color = 'k';
        dpPMCond(1) = filtbdata(dataParsed,0,{'stimulationOnCond',0,'Premature',1, 'controlLoop', @(x) isnan(x)|x==0,'TrialInit', @(x) ~isnan(x)});
        dpPMCond(1).plotparam.color = 'k';
        
        ncond = unique(dataParsed.stimulationOnCond);
        ncond = ncond(ncond>0);
    end
end
