function dpArray =  plotSimplePsycAcrDays_entiresessionManipulation(dpcontrol,dpmanipulated)
rd = brigdefs();
bsave = 1;
bPMPsyc = 1;
bforfigure = 1;
% bplotDiff

[dpArray condCell]= dpArrayInputHelper(dpcontrol);
for idp = 1:length(dpArray)
    dpArray(idp).stimulationOnCond(:) = 0;
end
dpC1 =concdp(dpArray);
sAnnot =  dpArray(1).collectiveDescriptor ;

[dpArray2 condCell]= dpArrayInputHelper(dpmanipulated);
for idp = 1:length(dpArray2)
    dpArray2(idp).stimulationOnCond(:) = 1;
end
dpC2 =concdp(dpArray2);

dpC = concdp(dpC1,dpC2);
ndx = getIndex_dp(dpC);
sAnnot =  [sAnnot ' ' dpArray2(1).collectiveDescriptor] ;

dpArray(end+1:end+length(dpArray2)) = dpArray2;
%%
% [dpCond,dpPMCond] = getdpCond(dpC,bsplitStimCond,bsplitAllStimCond);
[dpCond,dpPMCond] = getdpCond(dpC,condCell);
hfig = figure('Position',[837   137   419   778]);

nr = 2;
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





ci = nan(2,length(dpCond(1).IntervalSet));
for icond = 1:length(dpCond)
    
for s = 1:length(dpCond(1).IntervalSet)
    s_index = dpCond(icond).Interval==dpCond(1).IntervalSet(s);
    ci(:,s) = bootci(1000,{@mean,dpCond(icond).ChoiceLeft(s_index)},'alpha',0.05);
    
end
    dpCond(icond).ci=ci;
end
string = '';
hAx(1) = subplot(nr,nc,1);
for icond = 1:length(dpCond)
    if dpCond(icond).ntrials
        [fit h] = ss_psycurve(dpCond(icond),1,1,hAx(1));
        for s = 1:length(dpCond(1).IntervalSet)
        hh = errorbar(dpCond(1).IntervalSet(s),fit.psyc(s),dpCond(icond).ci(1,s)-fit.psyc(s),dpCond(icond).ci(2,s)-fit.psyc(s),'color',dpCond(icond).plotparam.color );
        
        end
        string = sprintf('%sn = %d',string,dpCond(icond).ntrials);
        
        setColor(h,dpCond(icond).plotparam.color); 
        if bPMPsyc
            
            dpPM = prematurePsycurvHelper(dpPMCond(icond));
            if dpPM.ntrials
                [fit h] = ss_psycurve(dpPM,1,1,hAx(3));
                setColor(h,dpCond(icond).plotparam.color );
                %                 set(h.hl,'Linestyle','--');
                %                 set(h.hlraw,'MarkerSize',5 );
                set(hAx(3),'box','off','xtick',myxtick,'xticklabel',myxticklabel,'tickdir','out', 'color',[1 1 1])
                ylabel 'P(long choice)'
                
            end
        end
    end
end
 text(dpCond(1).IntervalSet(end),0,string);



set(hAx(1),'box','off','xtick',myxtick,'xticklabel',myxticklabel,'tickdir','out', 'color',[1 1 1])
ylabel 'P(long choice)'

hAx(2) = subplot(nr,nc,2); hold on

for icond = 1:length(dpCond)
    if dpCond(icond).ntrials
        [rtdata h] = ss_reactime(filtbdata(dpCond(icond),0,{'ChoiceCorrect',1}),true,hAx(2));
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

set(hAx(2),'xlim',get(hAx(1),'xlim'));
plotAnn(sAnnot);


if bsave
    patht = fullfile(rd.Dir.SummaryFig);
    parentfolder(patht,1)
    orient tall
    saveas(hfig, fullfile(patht,[savefiledesc '.pdf']));
    saveas(hfig, fullfile(patht,[savefiledesc '.fig']));
end
