% compare frac PM Long vs predicted
%  Also plots frac PM stimulated vs unstimulated

fig1_fldsToPlot = {'fracValid_ChoiceLeft','fracPM_PrematureLong','fracpredictPrematureLong'};
fig1_names = {'Valid Long','PMLong','PredPM',...
    'Ch. Miss','slope','bias'};
 clear summ
for ifile = 1:length(thisAnimal);
    thisAnimal(ifile) = getStats_dp(thisAnimal(ifile));
    
    summ(1).Date(ifile) = {[thisAnimal(ifile).Date(end-3:end-2) '.' thisAnimal(ifile).Date(end-1:end)]};
    summ(1).Animal(ifile) = {[' ' thisAnimal(ifile).Animal]};
    summ(1).scaling(ifile,1) = thisAnimal(ifile).Scaling(1);
    summ(1).datenum(ifile,1) = datenum(thisAnimal(ifile).Date,'yymmdd');

    summ(1).fracValid_ChoiceLeft(ifile) = thisAnimal(ifile).stats.fracValidUnStim_ChoiceLeft;
    summ(2).fracValid_ChoiceLeft(ifile) =  thisAnimal(ifile).stats.fracValidStim_ChoiceLeft;
    
    summ(1).fracPM_PrematureLong(ifile) = thisAnimal(ifile).stats.fracPMUnStim_PrematureLong;
    summ(2).fracPM_PrematureLong(ifile) =  thisAnimal(ifile).stats.fracPMStim_PrematureLong;
    
    summ(1).fracpredictPrematureLong(ifile) = thisAnimal(ifile).stats.fracPMStim_PrematureLong; % this is the measured
    summ(2).fracpredictPrematureLong(ifile) =  thisAnimal(ifile).stats.predict_fracPMUnStim_PrematureLong; % this is measured
    

% % 

  summ(1).fracChoiceLeft(ifile) = thisAnimal(ifile).stats.fracChoiceLeft_UnStim;
    summ(2).fracChoiceLeft(ifile) =  thisAnimal(ifile).stats.fracChoiceLeft_Stim;
    
    summ(1).fracPM(ifile) = thisAnimal(ifile).stats.fracPM_UnStim;
    summ(2).fracPM(ifile) =  thisAnimal(ifile).stats.fracPM_Stim;
    



end
    sAnnot =  thisAnimal(ifile).collectiveDescriptor ;


my_color = ['r','b','g','k'];
h.hfig = figure(99); 

subplot(1,2,1)
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

subplot(1,2,2)
h.hline(ianimal) = line(summ(1).fracChoiceLeft,summ(2).fracChoiceLeft,'LineStyle','none','MarkerSize',2,'Marker','o','Color',my_color(ianimal)); hold all;
line(nanmean(summ(1).fracChoiceLeft),nanmean(summ(2).fracChoiceLeft),'LineStyle','none','Marker','+','Markersize',15,'Color',my_color(ianimal))

title ('Probablity of Long Choice ')
xlabel('Control')
ylabel('Photo-activation')

% defaultAxes(gca)

axis equal
xlim([0 1])
ylim([0 1])
line([0 1],[0 1],'color','k')

sleg{ianimal} = thisAnimal(1).Animal;

if ianimal==length(dpAnimal)
    hleg = legend(h.hline,sleg);
    defaultLegend(hleg,'SouthEast',6);
end

savename_fig1 = 'PreMatureANDChoiceLongStimvsUnStim';

sAnnot =  thisAnimal(ifile).collectiveDescriptor ;
if bsave
    if ~isempty(h.hfig)
        %         savename = [strtrim(cell2mat(nAnimal)) savename_fig1];
        patht = fullfile(r.Dir.SummaryFig, 'PreMatureEtc');
        parentfolder(patht,1)
        savefiledesc = [sAnnot savename_fig1];
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
            patht = fullfile(r.Dir.SummaryFig, 'PreMatureEtc',thisAnimal(ifile).Animal);
            parentfolder(patht,1)
            savefiledesc = [sAnnot savename_fig1];
            export_fig(h.hfig, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
            saveas(h.hfig, fullfile(patht,[savefiledesc '.fig']));
            plotAnn(sAnnot,h.hfig);
        end
    end
end