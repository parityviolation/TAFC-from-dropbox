
    A = {'fi12_1013_3freq'};    
    [exptnames trials] = getStimulatedExptnames(A{1});
    dpArray = constructDataParsedArray(exptnames, trials);
    dpArray(1).collectiveDescriptor = A{1} ;
   

    sAnnot =  dpArray(1).collectiveDescriptor ;
    
    dp =concdp(dpArray);

    dpCond = getdpCond(dp,1,0);
    %%

bsave = 1;

for i = 1:length(dpCond)

cond(i).color = dpCond(i).plotparam.color;

cond(i).desc = ['stimCond = ' num2str(unique(dpCond(i).stimulationOnCond))];

cond(i).val = unique(dpCond(i).stimulationOnCond);

end

IntervalSet = dpArray(1).IntervalSet;

r = brigdefs();
%%
savename = [sAnnot '_Stimulation_PsyAcrossDays'];

fld_fit = {'psyc','nvalidtrials','nchoiceLong'};
fld_dp = {'ReactionTime'};
clear summ dsumm;
for ifile = 1:length(dpArray);
    
    for icond = 1:length(dpCond) % collect the data from each condition and file into a matrix
        for iIntv = 1:length(IntervalSet)
            ind = find(dpArray(ifile).analysis.psy.fit(icond).x==IntervalSet(iIntv));
            if ~isempty(ind)
                for ifld = 1:length(fld_fit)
                    summ(icond).(fld_fit{ifld})(ifile,iIntv) = dpArray(ifile).analysis.psy.fit(icond).(fld_fit{ifld})(ind);
                end
                
                thisdp = filtbdata(dpArray(ifile),0,{'Interval',IntervalSet(iIntv),...
                    'stimulationOnCond',cond(icond).val});
                for ifld = 1:length(fld_dp)
                    summ(icond).(fld_dp{ifld})(ifile,iIntv) = NaN;
                    summ(icond).([fld_dp{ifld} '_sem'])(ifile,iIntv)  = NaN;
                    thisdp = filtbdata(thisdp,0,{'ChoiceCorrect',1}); % only RT for correct choices
                    if ~isempty(thisdp.(fld_dp{ifld})) & thisdp.ntrials>1
                        summ(icond).(fld_dp{ifld})(ifile,iIntv) = nanmean(thisdp.(fld_dp{ifld}));
                        summ(icond).([fld_dp{ifld} '_sem'])(ifile,iIntv) = nansem(thisdp.(fld_dp{ifld}));
                    end
                end
            end
            
        end
    end
end


% remove cases wheree there is no valid trials
fld_fit = {'psyc','nchoiceLong'};
for ifile = 1:length(dpArray);
    for icond = 1:length(dpCond) % collect the data from each condition and file into a matrix
        for ifld = 1:length(fld_fit)
            ind = find(summ(icond).nvalidtrials(ifile,:)==0);
            for icond = 1:length(dpCond)
                summ(icond2).(fld_fit{ifld})(ifile,ind) = nan; % remove from both conditions
            end
        end
    end
end

%% Plotting
% % Performance averaged
hf = figure(1000); clf
hfig = figure ('WindowStyle','docked','NumberTitle','off','Name',savename);
plotAnn(sAnnot)

nc = 4;
nr = 2;
plot_increment = 4;
plotdesc.fld = {};
plotdesc.fld{end+1} = 'psyc';
plotdesc.fld{end+1} = 'ReactionTime';
plotdesc.scalar = {};
plotdesc.scalar{end+1} = 1;
plotdesc.scalar{end+1} = 1/1000;
plotdesc.title = {};
plotdesc.ylabel1 = {};
plotdesc.ylabel2= {};
plotdesc.title{end+1} = 'Performance';
plotdesc.ylabel1{end+1} = 'P(long)';
plotdesc.ylabel2{end+1} = '\DeltaP(long)';
plotdesc.title{end+1} = 'Reaction Time';
plotdesc.ylabel1{end+1} = 'sec';
plotdesc.ylabel2{end+1} = '\Delta sec';

hfig.hAx = [];

for ifld = 1:length(plotdesc.fld)
    hAx = subplot(nc,nr,1+(ifld-1)*plot_increment);
        hfig.hAx(1+(ifld-1)*plot_increment) = hAx;
    set(hAx,'NextPlot','add');
    ylabel(plotdesc.ylabel1{ifld} )
    
    clear y semy
    for icond = 1:length(dpCond)
        summ(icond).(plotdesc.fld{ifld}) = summ(icond).(plotdesc.fld{ifld})*plotdesc.scalar{ifld};
        y= nanmean(summ(icond).(plotdesc.fld{ifld}));
        y(isnan(y)) = 0;
        semy = nansem((summ(icond).(plotdesc.fld{ifld})));
        semy(~y) = NaN;
        y(~y) = NaN;
        
        hl = errorbar(hAx,IntervalSet',y',semy','color',cond(icond).color)
        %     [hl hp] = errorPatch(IntervalSet',psy(icond,:)',sempsy(icond,:)',hAx);
        %     setColor(hp,cond(icond).color);
        
    end
    title(plotdesc.title{ifld} )
    
    clear stat;
    yl = max(get(hAx,'ylim'));
    for iInt = 1:length(IntervalSet)
        ctrl = summ(1).(plotdesc.fld{ifld})(:,iInt);
        stim = summ(2).(plotdesc.fld{ifld})(:,iInt);
        if all(~isnan(ctrl))
            [stat.h(iInt) stat.p(iInt) stat.ci(:,iInt)] =   ttest2(ctrl,stim);
            if ~isnan(stat.h(iInt))
                if stat.h(iInt)
                    line(IntervalSet(iInt),1.05*yl,'Marker','*','MarkerSize',3,'Color','k','Parent',hAx);
                end
            end
        end
    end
    
    % %  (Difference)
    clear dsumm
    for ifile = 1:length(dpArray);
        dsumm.( plotdesc.fld{ifld})(ifile,:) =summ(2).( plotdesc.fld{ifld})(ifile,:)-summ(1).( plotdesc.fld{ifld})(ifile,:);
    end
    
    hAx  = subplot(nc,nr,2+(ifld-1)*plot_increment);
     hfig.hAx(2+(ifld-1)*plot_increment) = hAx;
   set(hAx,'NextPlot','add');
    title('difference')
    ylabel(plotdesc.ylabel2{ifld} )
    
    dif = nanmean(dsumm.(plotdesc.fld{ifld}));
    semdif = nansem(dsumm.(plotdesc.fld{ifld}));
    dif(isnan(dif)) = 0;
    semdif(~dif) = NaN;
    dif(~dif) = NaN;
    
    hl = errorbar(hAx,IntervalSet',dif,semdif,'k');
    axis tight;
    clear stat
    yl = max(get(hAx,'ylim'));
    for iInt = 1:length(IntervalSet)
        d = dsumm.( plotdesc.fld{ifld})(:,iInt);
        if all(~isnan(d))
            [stat.h(iInt) stat.p(iInt) stat.ci(:,iInt)] =   ttest(d);
            if ~isnan(stat.h(iInt))
                if stat.h(iInt)
                    line(IntervalSet(iInt),1.05*yl,'Marker','*','MarkerSize',3,'Color','k','Parent',hAx);
                end
            end
        end
    end
    axis tight;
    
    
    % % Performance Individual
    
    hAx = subplot(nc,nr,3+(ifld-1)*plot_increment);
    hfig.hAx(3+(ifld-1)*plot_increment) = hAx;
    set(hAx,'NextPlot','add');
    
   for icond = 1:length(dpCond)
        data = summ(icond).(plotdesc.fld{ifld});
        hl = line(repmat(IntervalSet,size(data,1),1)',data','linewidth',1,'markersize',1,'color',cond(icond).color,'Parent',hAx);
        
    end
    ylabel(plotdesc.ylabel1{ifld})
    
    %
    hAx = subplot(nc,nr,4+(ifld-1)*plot_increment);
    hfig.hAx(4+(ifld-1)*plot_increment) = hAx;
    set(hAx,'NextPlot','add');
    data = summ(2).(plotdesc.fld{ifld})-summ(1).(plotdesc.fld{ifld});
    hl = line(repmat(IntervalSet,size(data,1),1)',data','linewidth',1,'markersize',1,'color','k','Parent',hAx);
    axis tight;
    ylabel(plotdesc.ylabel2{ifld} )
    
end


  set(hfig.hAx(:),'Xlim',[0 1])
  set(hfig.hAx(1),'Ylim',[0 1])
  
  setXLabel( hfig.hAx(end-1:end),'Norm Interval');

  set(hfig.hAx(:),'Box','off','TickDir','Out')


plotAnn(sAnnot,gcf)


% % SaVing
% average with no regard for n perInterval within a session
if bsave
    orient tall
    saveas(hf, fullfile(r.Dir.SummaryFig, [savename '.pdf']));
end

