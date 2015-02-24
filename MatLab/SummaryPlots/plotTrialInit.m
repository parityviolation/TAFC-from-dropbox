function dpArray =  plotTrialInit(varargin)
rd = brigdefs();
bsave = 1;
bplotcumdis = 1;

nr = 2; nc = 1;
% if bplotcumdis, nr = 2; nc = 2; end

clear cond
icond = 1;
cond(icond).desc  = 'T-1 Stim Correct';
cond(icond).fldname  = 'timeToTrialInit';
cond(icond).fsweep = {'ChoiceCorrect',[0 1]};
cond(icond).fsweepTrial = {{-1,'stimulationOnCond',[1 2 3],'ChoiceCorrect',1}};
cond(icond).scolor = 'b';

icond = 2;
cond(icond).desc  = 'T-1 Correct';
cond(icond).fldname  = 'timeToTrialInit';
cond(icond).fsweep = {'ChoiceCorrect',[0 1]};
cond(icond).fsweepTrial = {{-1,'stimulationOnCond',[0],'ChoiceCorrect',1}};
cond(icond).scolor = 'k';

icond = 3;
cond(icond).desc  = 'T-1 Stim Error';
cond(icond).fldname  = 'timeToTrialInit';
cond(icond).fsweep = {'ChoiceCorrect',[0 1]};
cond(icond).fsweepTrial = {{-1,'stimulationOnCond',[1 2 3],'ChoiceCorrect',0}};
cond(icond).scolor = '--b';

icond = 4;
cond(icond).desc  = 'T-1 Error';
cond(icond).fldname  = 'timeToTrialInit';
cond(icond).fsweep = {'ChoiceCorrect',[0 1]};
cond(icond).fsweepTrial = {{-1,'stimulationOnCond',[0],'ChoiceCorrect',0}};
cond(icond).scolor = '--k';


% bplotDiff

sAnnot = '';
% % for each cell element

[dpArray condCell]= dpArrayInputHelper(varargin{:});
dpC =concdp(dpArray);


sAnnot =  [sAnnot dpC.collectiveDescriptor] ;
savefiledesc = [ sAnnot '_trialInitAfterStim' ];


clear pdf dist cumdist;
nbin = [8:1:30];

h.hfig = figure('Name',[sAnnot '_TrialInit'],'NumberTitle','off');
for icond = 1:length(cond)
    fldname = cond(icond).fldname;
    conddp(icond) = filtbdata(dpC,0,cond(icond).fsweep,cond(icond).fsweepTrial);
    dist{icond} = conddp(icond).(fldname);
            sleg{icond} = cond(icond).desc ;

    if bplotcumdis
        [a x] = hist(conddp(icond).(fldname)/1000,nbin);
        
        
        pdf(icond,:) = a/sum(a);
        A = cumsum(a);
        A = A/max(A);
        cumdist(icond,:) = A;
        
        %
        
        h.hAx(1) =  subplot(nr,nc,1);
        plot(x,pdf(icond,:),cond(icond).scolor); hold all
        
        h.hAx(2) = subplot(nr,nc,2);
        plot(x,A,cond(icond).scolor); hold all
    end
    
end


% set( h.hAx(1) ,'XScale','log')

h.hleg = legend(sleg);
defaultAxes(h.hAx);
defaultLegend(h.hleg,[],7);

[H, pValue, KSstatistic] = kstest2(dist{1}, dist{2});
[H2, pValue2, KSstatistic2] = kstest2(dist{3}, dist{4});
setTitle(h.hAx(1),[' p = ' num2str(pValue,'%1.2g') ' p = ' num2str(pValue2,'%1.2g') ]);
setXLabel(h.hAx(2),[fldname '(s)' ]);

plotAnn(sAnnot);


if bsave
    patht = fullfile(rd.Dir.SummaryFig,'TrialInit',dpC.Animal);
    parentfolder(patht,1)
    orient tall
    export_fig(h.hfig, fullfile(patht,[savefiledesc]),'-pdf','-transparent');
    saveas(h.hfig, fullfile(patht,[savefiledesc '.fig']));
end

