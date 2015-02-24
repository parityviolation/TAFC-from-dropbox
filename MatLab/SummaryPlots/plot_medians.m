clear all
%dp_raw = loadBstruct('BII_TAFCv07_box3_130526_SSAB_bstruct');
%dp_raw = loadBstruct('FI12_1013_TAFCv08_stimulation02_box4_130529_SSAB_bstruct');
dp_raw = loadBstruct('FI12_1013_TAFCv08_stimulation03_box4_130605_SSAB_bstruct');


frame_rate = dp_raw.video.info.meanFrameRate;
scaling = dp_raw.Scaling;
ndx = getIndex_dp(dp_raw);
dp_valid =  filtbdata_trial(dp_raw,ndx.valid);

ind_46Corr = find(dp_valid.Interval == 0.46 & dp_valid.ChoiceCorrect == 1 & isnan(dp_valid.stimulationOnCond));
ind_46Inc = find(dp_valid.Interval == 0.46 & dp_valid.ChoiceCorrect == 0 & isnan(dp_valid.stimulationOnCond));


ind_54Corr = find(dp_valid.Interval == 0.54 & dp_valid.ChoiceCorrect == 1 & isnan(dp_valid.stimulationOnCond));
ind_54Inc = find(dp_valid.Interval == 0.54 & dp_valid.ChoiceCorrect == 0 & isnan(dp_valid.stimulationOnCond));

ind_Corr_Stim = find(dp_valid.ChoiceCorrect == 1 & dp_valid.stimulationOnCond == 1);
ind_Corr_NonStim = find(dp_valid.ChoiceCorrect == 1 & isnan(dp_valid.stimulationOnCond));

ind_Inc_Stim = find(dp_valid.ChoiceCorrect == 0 & dp_valid.stimulationOnCond == 1);
ind_Inc_NonStim = find(dp_valid.ChoiceCorrect == 0 & isnan(dp_valid.stimulationOnCond));


ind_CorrL_Stim = find(dp_valid.ChoiceCorrect == 1 & dp_valid.ChoiceLeft == 1 & dp_valid.stimulationOnCond == 1);
ind_CorrL_NonStim = find(dp_valid.ChoiceCorrect == 1 & dp_valid.ChoiceLeft == 1 &isnan(dp_valid.stimulationOnCond));

ind_CorrS_Stim = find(dp_valid.ChoiceCorrect == 1 & dp_valid.ChoiceLeft == 0 & dp_valid.stimulationOnCond == 1);
ind_CorrS_NonStim = find(dp_valid.ChoiceCorrect == 1 & dp_valid.ChoiceLeft == 0 &isnan(dp_valid.stimulationOnCond));

ind_IncL_Stim = find(dp_valid.ChoiceCorrect == 0 & dp_valid.ChoiceLeft == 1 & dp_valid.stimulationOnCond == 1);
ind_IncL_NonStim = find(dp_valid.ChoiceCorrect == 0 & dp_valid.ChoiceLeft == 1 &isnan(dp_valid.stimulationOnCond));

ind_IncS_Stim = find(dp_valid.ChoiceCorrect == 0 & dp_valid.ChoiceLeft == 0 & dp_valid.stimulationOnCond == 1);
ind_IncS_NonStim = find(dp_valid.ChoiceCorrect == 0 & dp_valid.ChoiceLeft == 0 &isnan(dp_valid.stimulationOnCond));



%frs = frame_rate*0.6;
frs = frame_rate*(scaling/1000);



xy_positionsParsed =  dp_valid.video.extremesTransf(:,1:frs,:);

xy_positionsParsed  = xy_positionsParsed*10/640*10; % convert to mm


frs = frame_rate*0.6;

xCorr_Stim = nanmean(squeeze(xy_positionsParsed(ind_Corr_Stim,1:frs,1)));
xCorr_Stims = nansem(squeeze(xy_positionsParsed(ind_Corr_Stim,1:frs,1)));

xCorr_NonStim = nanmean(squeeze(xy_positionsParsed(ind_Corr_NonStim,1:frs,1)));
xCorr_NonStims = nansem(squeeze(xy_positionsParsed(ind_Corr_NonStim,1:frs,1)));

xInc_Stim = nanmean(squeeze(xy_positionsParsed(ind_Inc_Stim,1:frs,1)));
xInc_Stims = nansem(squeeze(xy_positionsParsed(ind_Inc_Stim,1:frs,1)));

xInc_NonStim = nanmean(squeeze(xy_positionsParsed(ind_Inc_NonStim,1:frs,1)));
xInc_NonStims = nansem(squeeze(xy_positionsParsed(ind_Inc_NonStim,1:frs,1)));

frs = frame_rate*1.62;

xCorrL_Stim = nanmean(squeeze(xy_positionsParsed(ind_CorrL_Stim,1:frs,1)));
xCorrL_Stims = nansem(squeeze(xy_positionsParsed(ind_CorrL_Stim,1:frs,1)));

xCorrL_NonStim = nanmean(squeeze(xy_positionsParsed(ind_CorrL_NonStim,1:frs,1)));
xCorrL_NonStims = nansem(squeeze(xy_positionsParsed(ind_CorrL_NonStim,1:frs,1)));

xIncL_Stim = nanmean(squeeze(xy_positionsParsed(ind_IncL_Stim,1:frs,1)));
xIncL_Stims = nansem(squeeze(xy_positionsParsed(ind_IncL_Stim,1:frs,1)));

xIncL_NonStim = nanmean(squeeze(xy_positionsParsed(ind_IncL_NonStim,1:frs,1)));
xIncL_NonStims = nansem(squeeze(xy_positionsParsed(ind_IncL_NonStim,1:frs,1)));

frs = frame_rate*0.6;

xCorrS_Stim = nanmean(squeeze(xy_positionsParsed(ind_CorrS_Stim,1:frs,1)));
xCorrS_Stims = nansem(squeeze(xy_positionsParsed(ind_CorrS_Stim,1:frs,1)));

xCorrS_NonStim = nanmean(squeeze(xy_positionsParsed(ind_CorrS_NonStim,1:frs,1)));
xCorrS_NonStims = nansem(squeeze(xy_positionsParsed(ind_CorrS_NonStim,1:frs,1)));

xIncS_Stim = nanmean(squeeze(xy_positionsParsed(ind_IncS_Stim,1:frs,1)));
xIncS_Stims = nansem(squeeze(xy_positionsParsed(ind_IncS_Stim,1:frs,1)));

xIncS_NonStim = nanmean(squeeze(xy_positionsParsed(ind_IncS_NonStim,1:frs,1)));
xIncS_NonStims = nansem(squeeze(xy_positionsParsed(ind_IncS_NonStim,1:frs,1)));


x46inc = nanmedian(squeeze(xy_positionsParsed(ind_46Inc,:,1))',2);
y46inc = nanmedian(squeeze(xy_positionsParsed(ind_46Inc,:,2))',2);

x46corr = nanmedian(squeeze(xy_positionsParsed(ind_46Corr,:,1))',2);
y46corr = nanmedian(squeeze(xy_positionsParsed(ind_46Corr,:,2))',2);

x46inc = nanmean(squeeze(xy_positionsParsed(ind_46Inc,:,1)));
x46incs = nansem(squeeze(xy_positionsParsed(ind_46Inc,:,1)));
% y46inc = nanmean(squeeze(xy_positionsParsed(ind_46Inc,:,1)));
% y46incs = nansem(squeeze(xy_positionsParsed(ind_46Inc,:,1)));

x46corr = nanmean(squeeze(xy_positionsParsed(ind_46Corr,:,1)));
x46corrs = nansem(squeeze(xy_positionsParsed(ind_46Corr,:,1)));
% y46corr = nanmean(squeeze(xy_positionsParsed(ind_46Corr,:,1)));
% y46corrs = nansem(squeeze(xy_positionsParsed(ind_46Corr,:,1)));

x54corr = nanmean(squeeze(xy_positionsParsed(ind_54Corr,:,1)));
x54corrs = nansem(squeeze(xy_positionsParsed(ind_54Corr,:,1)));

x54inc = nanmean(squeeze(xy_positionsParsed(ind_54Inc,:,1)));
x54incs = nansem(squeeze(xy_positionsParsed(ind_54Inc,:,1)));

tone_2 = 0.2*dp_raw.Scaling;
tone_35 = 0.35*dp_raw.Scaling;
tone_42 = 0.42*dp_raw.Scaling;
tone_46 = 0.46*dp_raw.Scaling;
tone_54 = 0.54*dp_raw.Scaling;
tone_58 = 0.58*dp_raw.Scaling;
tone_65 = 0.65*dp_raw.Scaling;
tone_8 = 0.8*dp_raw.Scaling;
bound = 0.5*dp_raw.Scaling;



xtime = [1:size(xy_positionsParsed,2)]/frame_rate*1000;


figure;
subplot(1,1,1);
[hl hp] = errorpatch(xtime',x46inc',x46incs');
setColor(hl,'r');setColor(hp,'r');

[hl hp] =errorpatch(xtime',x46corr',x46corrs')
setColor(hl,'g');setColor(hp,'g');
line([1 1]*tone_46,get(gca,'ylim'))
line([1 1]*tone_54,get(gca,'ylim'))
title('x46Corr-NonStim and x46Inc-NonStim')

%%
figure;
subplot(1,1,1);
[hl hp] = errorpatch(xtime',x46inc',x46incs');
setColor(hl,'r');setColor(hp,'r');

[hl hp] =errorpatch(xtime',x54corr',x54corrs')
setColor(hl,'g');setColor(hp,'g');
line([1 1]*tone_46,get(gca,'ylim'))
line([1 1]*tone_54,get(gca,'ylim'))
title('x46Inc-NonStim and x54Corr-NonStim')

figure;
subplot(1,1,1);
[hl hp] = errorpatch(xtime',x54inc',x54incs');
setColor(hl,'r');setColor(hp,'r');

[hl hp] =errorpatch(xtime',x54corr',x54corrs')
setColor(hl,'g');setColor(hp,'g');
line([1 1]*tone_46,get(gca,'ylim'))
line([1 1]*tone_54,get(gca,'ylim'))
title('x54Corr-NonStim and x54Inc-NonStim')



%SOFIA


xtime = [1:size(xCorr_NonStim,2)]/frame_rate*1000;

figure;

subplot(1,1,1);
[hl hp] = errorpatch(xtime',xCorr_NonStim',xCorr_NonStims');
setColor(hl,'k');setColor(hp,'k');

[hl hp] =errorpatch(xtime',xCorr_Stim',xCorr_Stims')
setColor(hl,'b');setColor(hp,'b');
%ylim([25 55])

line([1 1]*tone_2,get(gca,'ylim'))
line([1 1]*bound,get(gca,'ylim'))
title('xCorr-NonStim and xCorr-Stim')


xtime = [1:size(xInc_NonStim,2)]/frame_rate*1000;

figure;

subplot(1,1,1);
[hl hp] = errorpatch(xtime',xInc_NonStim',xInc_NonStims');
setColor(hl,'k');setColor(hp,'k');

[hl hp] =errorpatch(xtime',xInc_Stim',xInc_Stims')
setColor(hl,'b');setColor(hp,'b');
%ylim([25 55])

line([1 1]*tone_2,get(gca,'ylim'))
line([1 1]*bound,get(gca,'ylim'))
title('xInc-NonStim and xInc-Stim')


xtime = [1:size(xCorrL_NonStim,2)]/frame_rate*1000;


figure;

subplot(1,1,1);
[hl hp] = errorpatch(xtime',xCorrL_NonStim',xCorrL_NonStims');
setColor(hl,'k');setColor(hp,'k');

[hl hp] =errorpatch(xtime',xCorrL_Stim',xCorrL_Stims')
setColor(hl,'b');setColor(hp,'b');

line([1 1]*tone_54,get(gca,'ylim'))
line([1 1]*bound,get(gca,'ylim'))
title('xCorrLong-NonStim and xCorrLong-Stim')


xtime = [1:size(xCorrS_NonStim,2)]/frame_rate*1000;

figure;

subplot(1,1,1);
[hl hp] = errorpatch(xtime',xCorrS_NonStim',xCorrS_NonStims');
setColor(hl,'k');setColor(hp,'k');

[hl hp] =errorpatch(xtime',xCorrS_Stim',xCorrS_Stims')
setColor(hl,'b');setColor(hp,'b');

%ylim([25 55])
line([1 1]*tone_2,get(gca,'ylim'))
line([1 1]*bound,get(gca,'ylim'))
title('xCorrShort-NonStim and xCorrShort-Stim')


xtime = [1:size(xIncL_NonStim,2)]/frame_rate*1000;


figure;

subplot(1,1,1);
[hl hp] = errorpatch(xtime',xIncL_NonStim',xIncL_NonStims');
setColor(hl,'k');setColor(hp,'k');

[hl hp] =errorpatch(xtime',xIncL_Stim',xIncL_Stims')
setColor(hl,'b');setColor(hp,'b');

line([1 1]*tone_54,get(gca,'ylim'))
line([1 1]*bound,get(gca,'ylim'))
title('xIncLong-NonStim and xIncLong-Stim')


xtime = [1:size(xIncS_NonStim,2)]/frame_rate*1000;

figure;

subplot(1,1,1);
[hl hp] = errorpatch(xtime',xIncS_NonStim',xIncS_NonStims');
setColor(hl,'k');setColor(hp,'k');

[hl hp] = errorpatch(xtime',xIncS_Stim',xIncS_Stims');
setColor(hl,'b');setColor(hp,'b');

%ylim([25 55])
line([1 1]*tone_2,get(gca,'ylim'))
line([1 1]*bound,get(gca,'ylim'))
title('xIncShort-NonStim and xIncShort-Stim')





    