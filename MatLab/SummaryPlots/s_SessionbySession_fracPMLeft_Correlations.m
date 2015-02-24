% compare frac PM Long vs predicted
%  Also plots frac PM stimulated vs unstimulated
reDrawfilter = 1;
bsave = 1;
 filter = {'reDraw',reDrawfilter,'ChoiceMiss', @(x) isnan(x)|x==0,'controlLoop', @(x) isnan(x)|x==0};
fig1_fldsToPlot = {'fracValid_ChoiceLeft','fracPM_PrematureLong','fracpredictPrematureLong'};
fig1_names = {'Valid Long','PMLong','PredPM',...
    'Ch. Miss','slope','bias'};
clear summ
for ifile = 1:length(thisAnimal);
    thisdp  = filtbdata(thisAnimal(ifile),0,filter);
    thisdp = getStats_dp(thisdp);
    
    summ(1).Date(ifile) = {[thisdp.Date(end-3:end-2) '.' thisdp.Date(end-1:end)]};
    summ(1).Animal(ifile) = {[' ' thisdp.Animal]};
    summ(1).scaling(ifile,1) = thisdp.Scaling(1);
    summ(1).datenum(ifile,1) = datenum(thisdp.Date,'yymmdd');
    
    summ(1).fracValid_ChoiceLeft(ifile) = thisdp.stats.fracValidUnStim_ChoiceLeft;
    summ(2).fracValid_ChoiceLeft(ifile) =  thisdp.stats.fracValidStim_ChoiceLeft;
    
    summ(1).fracPM_PrematureLong(ifile) = thisdp.stats.fracPMUnStim_PrematureLong;
    summ(2).fracPM_PrematureLong(ifile) =  thisdp.stats.fracPMStim_PrematureLong;
    
    summ(1).fracpredictPrematureLong(ifile) = thisdp.stats.fracPMStim_PrematureLong; % this is the measured
    summ(2).fracpredictPrematureLong(ifile) =  thisdp.stats.predict_fracPMUnStim_PrematureLong; % this is measured
    
    % %
    
    summ(1).fracChoiceLeft(ifile) = thisdp.stats.fracChoiceLeft_UnStim;
    summ(2).fracChoiceLeft(ifile) =  thisdp.stats.fracChoiceLeft_Stim;
    
    summ(1).fracPM(ifile) = thisdp.stats.fracPM_UnStim;
    summ(2).fracPM(ifile) =  thisdp.stats.fracPM_Stim;
    
    summ(1).fracCorrectAll(ifile) = thisdp.stats.frac.Correct;
    summ(1).fracErrorAll(ifile) = thisdp.stats.frac.Error;
    summ(1).fracpremTrialsAll(ifile) = thisdp.stats.frac.premTrials;
    summ(1).fracValid_ChoiceLeftAll(ifile) = thisdp.stats.fracValid_ChoiceLeft;
    
    
    % *** Parameters that need to be computed\
    
    %  median/ mean waiting time for impatient trials
    % delta median impatient trial
    tempfilter = {'Premature',1,'stimulationOnCond',0,'reDraw',1,'ChoiceMiss', @(x) isnan(x)|x==0,'controlLoop', @(x) isnan(x)|x==0};
    tempdp = filtbdata(thisdp,0,tempfilter);
    summ(1).meanPMTime(ifile) = nanmean(tempdp.firstSidePokeTime-tempdp.TrialInit)/1000;
    summ(1).medPMTime(ifile) = nanmedian(tempdp.firstSidePokeTime-tempdp.TrialInit)/1000;
    tempfilter = {'Premature',1,'stimulationOnCond',[1 2 3],'reDraw',1,'ChoiceMiss', @(x) isnan(x)|x==0,'controlLoop', @(x) isnan(x)|x==0};
    tempdp = filtbdata(thisdp,0,tempfilter);
    summ(2).meanPMTime(ifile) = nanmean(tempdp.firstSidePokeTime-tempdp.TrialInit)/1000;
    summ(2).medPMTime(ifile) = nanmedian(tempdp.firstSidePokeTime-tempdp.TrialInit)/1000;

    
    
end
sAnnot =  thisdp.collectiveDescriptor ;

%%
nr =4;
nc = 4;
my_color = ['r','b','g','k'];
h.hfig = figure(99);
set(h.hfig,'Position',[34          39        1233         958])
subplot(nr,nc,1)
line(summ(1).fracPM,summ(2).fracPM,'LineStyle','none','MarkerSize',2,'Marker','o','Color',my_color(ianimal)); hold all;
line(nanmean(summ(1).fracPM),nanmean(summ(2).fracPM),'LineStyle','none','Marker','+','Markersize',15,'Color',my_color(ianimal));

title ('Probability of Premature')
xlabel('Control')
ylabel('Photo-activation')

% defaultAxes(gca)
axis equal
xlim([0 1])
ylim([0 1])
line([0 1],[0 1],'color','k')

subplot(nr,nc,2)
h.hline(ianimal) = line(summ(1).fracValid_ChoiceLeft,summ(2).fracValid_ChoiceLeft,'LineStyle','none','MarkerSize',2,'Marker','o','Color',my_color(ianimal)); hold all;
line(nanmean(summ(1).fracValid_ChoiceLeft),nanmean(summ(2).fracValid_ChoiceLeft),'LineStyle','none','Marker','+','Markersize',15,'Color',my_color(ianimal))

title ('Probablity of Valid Long Choice ')
xlabel('Control')
ylabel('Photo-activation')

% defaultAxes(gca)

axis equal
xlim([0 1])
ylim([0 1])
line([0 1],[0 1],'color','k')


subplot(nr,nc,3)
h.hline(ianimal) = line(summ(1).medPMTime,summ(2).medPMTime,'LineStyle','none','MarkerSize',2,'Marker','o','Color',my_color(ianimal)); hold all;
line(nanmean(summ(1).medPMTime),nanmean(summ(2).medPMTime),'LineStyle','none','Marker','+','Markersize',15,'Color',my_color(ianimal))
hold on;
if ianimal==last
    axis tight
    axis equal
    xl = xlim; yl = ylim;
    xlim([ min([xl(1),yl(1)]) max([xl(2),yl(2)])]);
    ylim([ min([xl(1),yl(1)]) max([xl(2),yl(2)])]);
    xl = xlim;line(xl,xl,'color','k'); % line at unity
    title ('Waiting Time (WT) ')
    xlabel('Control')
    ylabel('Photo-activation')
end


indNonNaN = ~isnan(summ(1).fracValid_ChoiceLeft)&~isnan(summ(2).fracValid_ChoiceLeft)&~isnan(summ(1).medPMTime)&~isnan(summ(2).medPMTime);
deltaChoiceLong =  (summ(1).fracValid_ChoiceLeft(indNonNaN))-(summ(2).fracValid_ChoiceLeft(indNonNaN)) ;
deltaPMWaiting = summ(1).medPMTime(indNonNaN) - summ(2).medPMTime(indNonNaN);

delta(1).data = deltaChoiceLong;
delta(1).name =  'valid P(Long|Ctrl) - P(Long|Stim)';
delta(2).data = deltaPMWaiting;
delta(2).name =  'WT(Ctrl) - WT(Stim)';

subplot(nr,nc,4)
h.hline(ianimal) = line(delta(1).data,delta(2).data,'LineStyle','none','MarkerSize',2,'Marker','o','Color',my_color(ianimal)); hold all;
[R,m,b] = regression(delta(1).data,delta(2).data,'one');
x = [min(delta(1).data) max(delta(1).data)];
line(x,m*x+b,'Color',my_color(ianimal));
[R p] = corrcoef(delta(1).data,delta(2).data);
R =R(1,2); p = p(1,2);

title ('Corr Long \DeltaWaiting Time ')
xlabel(delta(1).name)
ylabel(delta(2).name)
axis square
sleg1{ianimal} = [thisAnimal(1).Animal ' r = ' num2str(R,'%1.2f') ' p = ' num2str(p,'%1.1g')];

if ianimal==last
    hleg1 = legend(h.hline,sleg1);
  %  defaultLegend(hleg1,'SouthWest',6);
end

% %
indNonNaN = ~isnan(summ(1).fracValid_ChoiceLeft)&~isnan(summ(2).fracValid_ChoiceLeft)&~isnan(summ(1).fracPM)&~isnan(summ(2).fracPM);
deltaChoiceLong =  (summ(1).fracValid_ChoiceLeft(indNonNaN))-(summ(2).fracValid_ChoiceLeft(indNonNaN)) ;
deltafracPM = summ(1).fracPM(indNonNaN) - summ(2).fracPM(indNonNaN);

delta(1).data = deltaChoiceLong;
delta(1).name =  'valid P(Long|Control) - P(Long|Stim)';
delta(2).data = deltafracPM;
delta(2).name =  'Imp(Control) - Imp(Stim)';

subplot(nr,nc,8)
h.hline(ianimal) = line(delta(1).data,delta(2).data,'LineStyle','none','MarkerSize',2,'Marker','o','Color',my_color(ianimal)); hold all;
[R,m,b] = regression(delta(1).data,delta(2).data,'one');
x = [min(delta(1).data) max(delta(1).data)];
line(x,m*x+b,'Color',my_color(ianimal));
[R p] = corrcoef(delta(1).data,delta(2).data);
R =R(1,2); p = p(1,2);

title ('Corr Long Imp ')
xlabel(delta(1).name)
ylabel(delta(2).name)
axis square
sleg1{ianimal} = [thisAnimal(1).Animal ' r = ' num2str(R,'%1.2f') ' p = ' num2str(p,'%1.1g')];

if ianimal==last
    hleg1 = legend(h.hline,sleg1);
    defaultLegend(hleg1,'Best',6);
end




subplot(nr,nc,5)
indNonNaNtemp = ~isnan(summ(1).fracValid_ChoiceLeftAll) & ~isnan(summ(1).fracpremTrialsAll);
h.hline(ianimal) = line(summ(1).fracValid_ChoiceLeftAll(indNonNaNtemp),summ(1).fracpremTrialsAll(indNonNaNtemp),'LineStyle','none','MarkerSize',2,'Marker','o','Color',my_color(ianimal)); hold all;
[R,m,b] = regression(summ(1).fracValid_ChoiceLeftAll(indNonNaNtemp),summ(1).fracpremTrialsAll(indNonNaNtemp),'one');
x = [min(summ(1).fracValid_ChoiceLeftAll(indNonNaNtemp)) max(summ(1).fracpremTrialsAll(indNonNaNtemp))];
line(x,m*x+b,'Color',my_color(ianimal));
[R p] = corrcoef(summ(1).fracValid_ChoiceLeftAll(indNonNaNtemp),summ(1).fracpremTrialsAll(indNonNaNtemp));
R =R(1,2); p = p(1,2);

title ('All')
xlabel('fracValid_ChoiceLeft')
ylabel('fracpremTrials')
axis square
sleg2{ianimal} = [thisAnimal(1).Animal ' r = ' num2str(R,'%1.2f') ' p = ' num2str(p,'%1.1g')];
if ianimal==last
    hleg1 = legend(h.hline,sleg2);
 %   defaultLegend(hleg1,'Best',6);
end

indNonNaNtemp = ~isnan(summ(1).fracValid_ChoiceLeft) & ~isnan(summ(1).fracPM);

subplot(nr,nc,6)
h.hline(ianimal) = line(summ(1).fracValid_ChoiceLeft(indNonNaNtemp),summ(1).fracPM(indNonNaNtemp),'LineStyle','none','MarkerSize',2,'Marker','o','Color',my_color(ianimal)); hold all;
[R,m,b] = regression(summ(1).fracValid_ChoiceLeft(indNonNaNtemp),summ(1).fracPM(indNonNaNtemp),'one');
x = [min(summ(1).fracValid_ChoiceLeft(indNonNaNtemp)) max(summ(1).fracValid_ChoiceLeft(indNonNaNtemp))];
line(x,m*x+b,'Color',my_color(ianimal));
[R p] = corrcoef(summ(1).fracValid_ChoiceLeft(indNonNaNtemp),summ(1).fracPM(indNonNaNtemp));
R =R(1,2); p = p(1,2);

title ('Control')
xlabel('fracChoiceLeft')
ylabel('fracpremTrials')
axis square
sleg3{ianimal} = [thisAnimal(1).Animal ' r = ' num2str(R,'%1.2f') ' p = ' num2str(p,'%1.1g')];

if ianimal==last
    hleg1 = legend(h.hline,sleg3);
 %   defaultLegend(hleg1,'Best',6);
end

indNonNaNtemp = ~isnan(summ(2).fracValid_ChoiceLeft) & ~isnan(summ(2).fracPM);

subplot(nr,nc,7)
h.hline(ianimal) = line(summ(2).fracValid_ChoiceLeft(indNonNaNtemp),summ(2).fracPM(indNonNaNtemp),'LineStyle','none','MarkerSize',2,'Marker','o','Color',my_color(ianimal)); hold all;
[R,m,b] = regression(summ(2).fracValid_ChoiceLeft(indNonNaNtemp),summ(2).fracPM(indNonNaNtemp),'one');
x = [min(summ(2).fracValid_ChoiceLeft(indNonNaNtemp)) max(summ(2).fracValid_ChoiceLeft(indNonNaNtemp))];
line(x,m*x+b,'Color',my_color(ianimal));
[R p] = corrcoef(summ(2).fracValid_ChoiceLeft(indNonNaNtemp),summ(2).fracPM(indNonNaNtemp));
R =R(1,2); p = p(1,2);

title ('Stimulated')
xlabel('fracChoiceLeft')
ylabel('fracpremTrials')
axis square
sleg4{ianimal} = [thisAnimal(1).Animal ' r = ' num2str(R,'%1.2f') ' p = ' num2str(p,'%1.1g')];

if ianimal==last
    hleg1 = legend(h.hline,sleg4);
    defaultLegend(hleg1,'Best',6);
end


flds = {'fracCorrectAll','fracErrorAll','fracpremTrialsAll','fracValid_ChoiceLeftAll'};
% correlate fields with deltaChoiceShort and
iplot = 0; 
for idelta = 1:2
    for ifld = 1:length(flds)
        iplot = iplot +1;
        thisAx = subplot(nr,nc,8+iplot);
        line(summ(1).(flds{ifld})(indNonNaN),delta(idelta).data,'LineStyle','none','MarkerSize',2,'Marker','o','Color',my_color(ianimal)); hold all;
        [R,m,b] = regression(summ(1).(flds{ifld})(indNonNaN),delta(idelta).data,'one');
        x = [min(summ(1).(flds{ifld})(indNonNaN)) max(summ(1).(flds{ifld})(indNonNaN))];
        line(x,m*x+b,'Color',my_color(ianimal));
        [R p] = corrcoef(summ(1).(flds{ifld})(indNonNaN),delta(idelta).data);
        R = R(1,2); p = p(1,2);
        
%         setXLabel(thisAx,flds{ifld})
        setYLabel(thisAx,delta(idelta).name)

        title(flds{ifld},'Interpreter','none')
        axis equal
        sleg{idelta,ifld,ianimal} = [thisAnimal(1).Animal ' r = ' num2str(R,'%1.2f') ' p = ' num2str(p,'%1.1g')];
        
        if ianimal==last
            hleg = legend(sleg{idelta,ifld,:} );
            defaultLegend(hleg,'Best',6);
        end
    end
    
end


[p f] = fileparts(groupsavefile);
savename_fig1 = f;
savename_fig1 = ['PreMatureANDChoiceLongWaitingTime_StimvsUnStimMORE_' savename_fig1];

r = brigdefs;
sAnnot =  thisdp.collectiveDescriptor ;
if ianimal==last
    if ~isempty(h.hfig)
        %         savename = [strtrim(cell2mat(nAnimal)) savename_fig1];
        patht = fullfile(r.Dir.SummaryFig, 'PreMatureEtc');
        parentfolder(patht,1)
        savefiledesc = [ savename_fig1];
        export_fig(h.hfig, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
        saveas(h.hfig, fullfile(patht,[savefiledesc '.fig']));
        plotAnn(sAnnot,h.hfig);
    end
end


savename_fig1 = 'PredictedPreMature';

if 0 % plot Prediected premature.
    h.hfig = summaryPlot_twoPoint(summ,fig1_fldsToPlot,fig1_names);
    ylim([0 1])
    
    if bsave
        if ~isempty(h.hfig)
            %         savename = [strtrim(cell2mat(nAnimal)) savename_fig1];
            patht = fullfile(r.Dir.SummaryFig, 'PreMatureEtc',thisdp.Animal);
            parentfolder(patht,1)
            savefiledesc = [sAnnot savename_fig1];
            export_fig(h.hfig, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
            saveas(h.hfig, fullfile(patht,[savefiledesc '.fig']));
            plotAnn(sAnnot,h.hfig);
        end
    end
end