savepath = 'C:\Users\Behave\Dropbox\PatonLab\Paton Lab\Data\TAFCmice\Ephys\InTask\Analysis\SertxChR2_179\DecodingTime';
savename = 'DecodingChoice';
h.fig = figure;
selcLabel = [0 1];
labelType = 'side';
sweepf =  {'ChoiceCorrect',1};
code = createSpikeCountCode(sweepf,selcLabel,labelType);
plotoptions.boverlayplot = 0;
plotoptions.mycolor = 'g';
plotoptions.plottype = {'max'};
hl(1) = decodeSpikeCountCode(code,plotoptions);
