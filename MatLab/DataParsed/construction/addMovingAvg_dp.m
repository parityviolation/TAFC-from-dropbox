function dp = addMovingAvg_dp(dp,options)
% BA 05 2014
bAddTodp = 0;
filterlength = 7;
filttype = 'gaussian';
if nargin>1
    filterlength = options.filterlength;
    filttype = options.filttype;
    if isfield(options,'bAddTodp')
        bAddTodp = options.bAddTodp;
    end
end

kernel = getFilterFun(filterlength,filttype);

y = dp.stimulationOnCond;
% All stimulation types are treated the as stimulation in this moving
% average
y(y~=0 & ~isnan(y))= 1;
dp.movingAvg.stimulationOnCond =  nanconv(y,kernel,'edge','1d') ;


y = dp.ChoiceCorrect; % this is the same as Performance
dp.movingAvg.ChoiceCorrect =  nanconv(y,kernel,'edge','1d') ;
dp.movingAvg.ChoiceCorrectNaN =  nanconv(y,kernel,'edge','nanout','1d') ;
y = dp.Premature;
dp.movingAvg.Premature =  nanconv(y,kernel,'edge','1d') ;
dp.movingAvg.PrematureNaN =  nanconv(y,kernel,'edge','nanout','1d') ;

y = dp.ChoiceLeft; % this is the same as Bias Long
dp.movingAvg.ChoiceLeft =  nanconv(y,kernel,'edge','1d') ;
dp.movingAvg.ChoiceLeftNaN =  nanconv(y,kernel,'edge','nanout','1d') ;

[~,dpPM]= prematurePsycurvHelper(dp);
y = dp.ChoiceLeft;
y(dpPM.absolute_trial) = dpPM.ChoiceLeft; % include Premature Left choices
dp.movingAvg.ChoiceLeftIncludingPM =  nanconv(y,kernel,'edge','1d') ;
dp.movingAvg.ChoiceLeftIncludingPMNaN =  nanconv(y,kernel,'edge','nanout','1d') ;


y = double(dp.Interval>0.5); % this only includes ValidTrials
dp.movingAvg.Interval =  nanconv(y,kernel,'edge','1d') ;

y = (double(dp.Interval>0.5) - dp.ChoiceLeft +1)/2; % choices Left above minus stimuli Left
dp.movingAvg.biasLeft = nanconv(y,kernel,'edge','1d') ;

dp.movingAvg.reDraw =  nanconv(dp.reDraw,kernel,'edge','1d') ;
dp.movingAvg.controlLoop =  nanconv(dp.controlLoop,kernel,'edge','1d') ;
dp.movingAvg.timeToTrialInit =  nanconv(dp.timeToTrialInit,kernel,'edge','1d') ;

dp.movingAvg.filttype = filttype;
dp.movingAvg.filterlength = filterlength;

if bAddTodp % sometimes this is more convienent 
    fldn = fieldnames(dp.movingAvg);
    for ifld = 1:length(fldn)
       dp.(['movingAvg_' fldn{ifld}]) =  dp.movingAvg.(fldn{ifld});
    end
    dp = rmfield(dp,'movingAvg');
end
