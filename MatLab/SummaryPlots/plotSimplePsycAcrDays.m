function dpArray =  plotSimplePsycAcrDays(varargin)
rd = brigdefs();
bsave = 1;
bPMPsyc =1;
bforfigure = 1;
% bplotDiff

[dpArray condCell]= dpArrayInputHelper(varargin{:});
sAnnot =  dpArray(1).collectiveDescriptor ;


dpC =concdp(dpArray);
ndx = getIndex_dp(dpC);

%%
% [dpCond,dpPMCond] = getdpCond(dpC,bsplitStimCond,bsplitAllStimCond);
[dpCond,dpPMCond] = getdpCond(dpC,condCell);
hfig = figure('Position',[837   137   419   778],'WindowStyle','docked','Name',[sAnnot '_SSum']);

nr = 1;
nc = 1;


if bPMPsyc
    nr = 3;
    hAx(3) = subplot(nr,nc,3);
    title('Premature')
end

myxtick = [0 .33 .5 .67 1];
myxticklabel = myxtick * dpC.Scaling(end) / 1000;
myxticklabel([1 2 4 5]) = round(myxticklabel([1 2 4 5]));



dpC =concdp(dpArray);
ndx = getIndex_dp(dpC);

% savefiledesc = ['PsyTrialAfterStimulation_' dpC.Animal];
savefiledesc = [ sAnnot '__Simple_Stimulation_PsyAcrossDays' ];

string = '';
hAx(1) = subplot(nr,nc,1);
for icond = 1:length(dpCond)
    if dpCond(icond).ntrials
        thisdp = filtbdata(dpCond(icond),0,{'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)});
        clear options
        options.bplot = 1;
        options.hAx = hAx(1);
        [~, ~, h]=  plotMLEfit(thisdp,[],'logistic',{'all'},options);
        string = sprintf('%sn = %d\n',string,dpCond(icond).ntrials);
        axis square
        text(0.8,0.1+icond/20,string,'color',dpCond(icond).plotparam.color);
        string = '';
        
        setColor(h,dpCond(icond).plotparam.color);
        delete(h.htext);
        delete(h.hleg);
        if bPMPsyc
            dpPM = prematurePsycurvHelper(dpPMCond(icond));
            if dpPM.ntrials
                clear options
                options.bplot = 1;
                options.hAx = hAx(3);
                [~, ~, h]=  plotMLEfit(dpPM,[],'logistic',{'all'},options);
                setColor(h,dpCond(icond).plotparam.color );
                %                 set(h.hl,'Linestyle','--');
                %                 set(h.hlraw,'MarkerSize',5 );
                set(hAx(3),'box','off','xtick',myxtick,'xticklabel',myxticklabel,'tickdir','out', 'color',[1 1 1])
                ylabel 'P(long choice)'
                delete(h.hleg);
            end
        end
        set(hAx(hAx~=0),'nextplot','add')

    end
   
end
%  
%  axis square
%  text(0.8,0.1,string,'color',dpCond(icond).plotparam.color);


set(hAx(1),'box','off','xtick',myxtick,'xticklabel',myxticklabel,'tickdir','out', 'color',[1 1 1])
ylabel 'P(long choice)'

hAx(2) = subplot(nr,nc,2); hold on

for icond = 1:length(dpCond)
    if dpCond(icond).ntrials
        % trick to make points not overlap
        dpCond(icond).IntervalSet = dpCond(icond).IntervalSet+(icond-1)*0.01        ;
        dpCond(icond).Interval = dpCond(icond).Interval+(icond-1)*0.01;
        
        [rtdata h] = ss_reactime(filtbdata(dpCond(icond),0,{'ChoiceCorrect',1}),true,hAx(2),0);
        setColor(h,dpCond(icond).plotparam.color );
        if bforfigure
            if isfield(h,'hp')
                delete(h.hp(1))
            end
        end
        
    end
    
end
set(hAx(2),'box','off','tickdir','out','xtick',myxtick,'xticklabel',myxticklabel, 'color',[1 1 1])
%        set(hAx,'box','off','tickdir','out','xtick',myxtick,'xticklabel',myxticklabel,'ytick',round(linspace(max(min(min(rtdata.rt))-200,0), max(max(rtdata.rt))+200, 3)), 'color',[1 1 1])
xlabel 'Interval duration (s)'; ylabel 'Reaction time (ms)'
defaultAxes(hAx(2));
axis tight
set(hAx(2),'xlim',get(hAx(1),'xlim')); 
axis square
yl = ylim;
ylim([0 yl(2)]);

plotAnn(sAnnot);


if bsave
    patht = fullfile(rd.Dir.SummaryFig,dpC.Animal);
    parentfolder(patht,1)
    orient tall
    saveas(hfig, fullfile(patht,[savefiledesc '.pdf']));
    saveas(hfig, fullfile(patht,[savefiledesc '.fig']));
end
