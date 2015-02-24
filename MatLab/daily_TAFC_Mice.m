function dp = daily_TAFC_Mice(gendp,bsplitcond,bdock)
dp = [];
try
    if nargin<1
        dstruct.dataParsed = custom_parsedata();
    else
        dstruct.dataParsed = custom_parsedata(gendp);
    end
    
    if nargin<2
        bsplitcond = 1;
    end
    
    if nargin<3
        bdock = 1;
    end
    
    % dstruct.dataParsed  = filtbdata_trial(dstruct.dataParsed,[1:500]);
    if strcmp('TAFC',dstruct.dataParsed.Protocol)
        ss_daily_report(dstruct.dataParsed,bsplitcond,bdock);
    elseif strcmp('MATCHING',dstruct.dataParsed.Protocol)
        ss_daily_report_Match(dstruct.dataParsed,bsplitcond,bdock);
    elseif strcmp('SelfReinf01',dstruct.dataParsed.Protocol)
        ss_daily_report_SelfStim(dstruct.dataParsed,bsplitcond,bdock);
    elseif strcmp('SelfReinf01_water',dstruct.dataParsed.Protocol)
        ss_daily_report_SelfStim(dstruct.dataParsed,bsplitcond,bdock);
    elseif strcmp('TAFCl3',dstruct.dataParsed.Protocol)
        ss_daily_report_TAFCl3(dstruct.dataParsed,bsplitcond,bdock);
    elseif strcmp('TAFCl2',dstruct.dataParsed.Protocol)
        ss_daily_report_TAFCl2(dstruct.dataParsed,bsplitcond,bdock);
    end
    

catch ME
    getReport(ME)
end
try 
    
dp = dstruct.dataParsed;

end
