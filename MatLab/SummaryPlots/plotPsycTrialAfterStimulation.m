% analyze trials after stimulation
function dpArray = plotPsycTrialAfterStimulation(varargin)
% function plotsummPsycTrialAfterStimulation(getAnimalcellString)
ntrialBack = [1];

dpArray = dpArrayInputHelper(varargin{:});
sAnnot =  dpArray(1).collectiveDescriptor ;

dpC =concdp(dpArray);
ndx = getIndex_dp(dpC);

% savefiledesc = ['PsyTrialAfterStimulation_' dpC.Animal];
savefiledesc = [ sAnnot '_PsyTrialAfterStimulation' ];
%%

rd = brigdefs;
bsave = 1;
bplotfit = 1;
hfig = figure ('WindowStyle','docked','NumberTitle','off','Name',savefiledesc);
IntervalSet = dpC.IntervalSet;

hsleg = [];
sleg = {};
control_trials = [];
for iTB = 1:length(ntrialBack)
    control_trials = [control_trials ndx.stimulation+ntrialBack(iTB)];
end
dpControl_ExAfter=  filtbdata(dpC,0,{'TrialNumber',@(x) ~ismember(x,control_trials),'stimulationOnCond',0,'ChoiceCorrect', [0 1]});
[fit h] = ss_psycurve(dpControl_ExAfter,1,bplotfit,gca); hold on;
setColor(h, [0 0 0]);
sleg(end+1) = {['Control, n=' num2str(dpControl_ExAfter.ntrials)]};
hsleg(end+1) = h.hlraw;

dpStim=  filtbdata(dpC,0,{'stimulationOnCond',@(x) x~=0});
dpStimValid = filtbdata(dpStim,0,{'ChoiceCorrect', [0 1]});
[fit h] = ss_psycurve(dpStim,1,bplotfit,gca);

ciStim = nan(2,length(IntervalSet));

for s = 1:length(IntervalSet)
    s_index = dpStimValid.Interval==IntervalSet(s);
    ciStim(:,s) = bootci(1000,{@mean,dpStimValid.ChoiceLeft(s_index)},'alpha',0.05);
    hh = errorbar(IntervalSet(s),fit.psyc(s),ciStim(1,s)-fit.psyc(s),ciStim(2,s)-fit.psyc(s),'b');
end
%     hh = errorpatch(IntervalSet,fit.psyc,ciStim(1,:)-fit.psyc,ciStim(2,:)-fit.psyc); setColor(hh,'b');


setColor(h, [0 0 1]);
sleg(end+1) = {['stimTrial, n=' num2str(dpStimValid.ntrials)]};
hsleg(end+1) = h.hlraw;



ciAfter = nan(2,length(IntervalSet),length(ntrialBack));
mycolor = lines(length(ntrialBack));
for iTB = 1:length(ntrialBack)
    dpAfter=  filtbdata(dpC,0,{'TrialNumber',ndx.stimulation+ntrialBack(iTB),'stimulationOnCond',0});
    dpAfterValid = filtbdata(dpAfter,0,{'ChoiceCorrect', [0 1]});
    [fit h] = ss_psycurve(dpAfter,1,bplotfit,gca);
    setColor(h, mycolor(iTB,:));
    sleg(end+1) = {['stimTrial + ' num2str( ntrialBack(iTB)) ', n=' num2str(dpAfterValid.ntrials)]};
    hsleg(end+1) = h.hlraw;
    
    for s = 1:length(IntervalSet)
        s_index = dpAfterValid.Interval==IntervalSet(s);
        ciAfter(:,s,iTB) = bootci(1000,{@mean,dpAfterValid.ChoiceLeft(s_index)},'alpha',0.05);
        errorbar(IntervalSet(s),fit.psyc(s),ciAfter(1,s,iTB)-fit.psyc(s),ciAfter(2,s,iTB)-fit.psyc(s))
        
    end
    %             hh = errorpatch(IntervalSet,fit.psyc,ciAfter(1,:,:)-fit.psyc,ciAfter(2,:,:)-fit.psyc); 
end


legend(hsleg,sleg,'Location','SouthEast','Fontsize',7);
if ~bplotfit
    set( hsleg,'LineStyle','-')
end

plotAnn(sAnnot,gcf)

set(gca,'TickDir','out')
xlabel('Norm Interval')
ylabel('P(long)')
set(gca,'XTick',dpC.IntervalSet,'XTickLabel',dpC.IntervalSet)
set(gca,'YTick',[0 1])

%
if bsave
    patht = fullfile(rd.Dir.SummaryFig,'PsychTrialAfter');
    parentfolder(patht,1)
    saveas(hfig, fullfile(patht,[savefiledesc '.pdf']));
    saveas(hfig, fullfile(patht,[savefiledesc '.fig']));
end


