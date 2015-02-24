% what about decoding short vs long choices
%   IS there a bias

% decode error stimuli?
%  -- Probably more variance in error trials, But may not be a qualitative bias short or long when using files [2:4], 
% ADD data, change bin sizes
% look at trajectories (to see if can resolve by eye)

% decoding time stops when animal stops doing timing task.. but

% not strong qualitative d
savepath = 'C:\Users\Behave\Dropbox\PatonLab\Paton Lab\Data\TAFCmice\Ephys\InTask\Analysis\SertxChR2_179\DecodingTime';
savename = 'DecodingTimeCorrectErrorIntv';
h.fig = figure;
Interval = 6;
sweepf =  {'ChoiceCorrect',1};
code = createSpikeCountCode(sweepf,Interval);
plotoptions.boverlayplot = 0;
plotoptions.mycolor = 'g';
plotoptions.plottype = {'max'};
hl(1) = decodeSpikeCountCode(code,plotoptions);

sweepf =  {'ChoiceCorrect',0,'ChoiceLeft',0};
codeErrorLong = createSpikeCountCode(sweepf,Interval);
codeTest = code;
codeTest.pseudoTrial = codeErrorLong.pseudoTrial;
plotoptions.boverlayplot = 0;
plotoptions.mycolor = 'r';
plotoptions.plottype = {'max'};
hl(2) = decodeSpikeCountCode(codeTest,plotoptions);
title(['Interval ' num2str(Interval) ' ' plotoptions.plottype] );

savename = [savename plotoptions.plottype{:} 'Intv' num2str(Interval)];
saveall = fullfile(savepath,savename);
export_fig(h.fig,saveall,'-pdf')
saveas(h.fig,saveall)
disp([ 'saved to ' saveall])
