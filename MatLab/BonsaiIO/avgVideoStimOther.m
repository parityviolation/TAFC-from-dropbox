function avgVideoStimOther(dp,filedesc,stimulusField,stimulusValue,otherField,otherValue)
% function avgVideoStimOther(dp,filedesc,stimulusField,otherField,stimulusValue (opt),otherValue (opt))
% e.g. avgVideoStimOther(dp,'Interval','stimulationOnCond')
% e.g. avgVideoStimOther(dp,'Interval','stimulationOnCond',[0.42 0.56])
% e.g. avgVideoStimOther(dp,'Interval','ChoiceCorrect',[0.42 0.56],[0 1])
% same as 
% e.g. avgVideoStimOther(dp,'Interval','ChoiceCorrect',[0.42 0.56],[0 1])
%
% creates  an average video file for EACH of the value of Stimulus Field
% if stimulusValue is not sepecified will use all stimulusValues that exist
% in dp
% if otherValue is not specified will use the FIRST  TWO unique values of
% otherValue that exist (excluding nans)

field = 'pokeIn_fr';  % field with alignment frames

if isempty(stimulusValue)
    dp= filtbdata(dp,0,{stimulusField, @(x) ~isnan(x)});
    stimulusValue = unique(dp.(stimulusField));
end


if  isempty(otherValue)
    dp = filtbdata(dp,0,{otherField, @(x) ~isnan(x)});
    otherValue = unique(dp.(otherField));
    otherValue = otherValue(1:2);
end

% for iStim = 1:length(stimulusValue)
    filter1 = ['_' stimulusField(1:4) '_' num2str(stimulusValue,'%1.2f_')  '__' otherField '_' num2str(otherValue(1))];
    dp1 =  filtbdata(dp,0,{stimulusField,stimulusValue,otherField,otherValue(1)});
    % second filter
    filter2 = ['_' stimulusField(1:4) '_' num2str(stimulusValue,'%1.2f_')  '__' otherField '_' num2str(otherValue(2))];
    dp2=  filtbdata(dp,0,{stimulusField,stimulusValue,otherField,otherValue(2)});
    
% end

% warning('hack for bonsai not all trials are includeded')
% dp2 = filtbdata_trial(dp2,[1:dp1.ntrials]); % hack to avoid some stupid timestamp problem in bonsai


[~, averageFilename] = fileparts(dp.FileName);
bonsaiFileName = getBonsaiFileForAverages(dp1,dp2,averageFilename,field,[filedesc filter1],[filedesc filter2]);
createBatBonsaiFile(bonsaiFileName,1,1);

