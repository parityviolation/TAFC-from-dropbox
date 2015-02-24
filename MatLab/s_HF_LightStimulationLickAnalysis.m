clear options cond;


Choice = [0 1]
% 
 calignEvent = {'timeOdorOn','TrialInit','timeOutcome'};
 cWOI  = {[-2 12]*1000
    [-1 10]*1000 + 5*1000
    [-5 5]*1000 };

% 
% calignEvent = {'TrialInit','timeStimulationOff'};
% cWOI  = { [-1 15]*1000 + 5*1000; [-10 5]*1000 };
% 



% ctypes = {'go','wait','nogo'};
ctypes = {'go','wait','nogo'};

Electrode = 0; % this is for picking Licks
UnitID = 0; % this is for picking Licks

options.bsave = 0;
options.bootstrap = 0;
options.binsize = 10;
options.nsmooth =round(50/ options.binsize);
options.dpFieldsToPlot = {'firstLickAfterResponseAvailable'};
options.bootstrap = 0;

figparam.matpos = [0 0 1 1];
figparam.figmargin = [0.03 0.03  0.025  0 ];  % [ LEFT RIGHT TOP BOTTOM]
figparam.matmargin = [0 0  0  0 ];
figparam.cellmargin = [0.03 0.035  0.06  0.06 ];


nr = length(calignEvent)*2;
nc = length(ctypes);
fig = figure('Position',[ 680          54        1226         924],...
   'Renderer', 'OpenGL','Name',[ licks.sweeps.Animal ' '  licksFiltered.sweeps.Date] );
sAlign = '';
for ialign = 1:length(calignEvent)
    alignEvent = calignEvent{ialign};
    sAlign = [sAlign ' ' alignEvent];

    WOI = cWOI{ialign};
    
    for itype = 1:length(ctypes)
        sTrialType = ctypes{itype}
        
        options.sDesc = [sTrialType 'StimNoStim'];
        
        
        sAnimal = licksFiltered.sweeps.Animal;
        sDate = licksFiltered.sweeps.Date;
        options.savefile = sprintf('%s_%s_%s_AL%s_%sLicks',licksFiltered.sweeps.Animal,licksFiltered.sweeps.Date, options.sDesc,alignEvent, sDate);
        options.dpFieldsToPlot = {};
        options.sortSweepsByARelativeToB= {'firstLickAfterResponseAvailable','timeResponseAvailable'}; % {'firstSidePokeTime',alignEvent};
        options.plottype = {'psth','rasterplot'};
        icond = 1;
        cond(icond).sleg = sTrialType;
        cond(icond).spikesf = {'Electrode',Electrode,'Unit',UnitID};
        cond(icond).sweepsf   = {'trialType',sTrialType,'stimulation',0,'ChoiceCorrect',Choice};
        cond(icond).trialRelsweepsf   = {};
        cond(icond).alignEvent= alignEvent; % NOTE Times must be relative to the beginning of the session
        cond(icond).plotparam.scolor = 'k';
        icond = 2;
        cond(icond).sleg =  [sTrialType ' Stim ' num2str(XY{1})];
        cond(icond).spikesf = {'Electrode',Electrode,'Unit',UnitID};
        cond(icond).sweepsf   = {'trialType',sTrialType,'stimulation',1,'ChoiceCorrect',Choice,...
            'stimulationCoordX',XY{1}(1),'stimulationCoordY',XY{1}(2)};
        cond(icond).trialRelsweepsf   = {};
        cond(icond).alignEvent= alignEvent; % NOTE Times must be relative to the beginning of the session
        cond(icond).plotparam.scolor = 'b'
        icond = 3;
        
        cond(icond).sleg = [sTrialType ' Stim ' num2str(XY{2})];
        cond(icond).spikesf = {'Electrode',Electrode,'Unit',UnitID};
        cond(icond).sweepsf   = {'trialType',sTrialType,'stimulation',1,'ChoiceCorrect',Choice,...
            'stimulationCoordX',XY{2}(1),'stimulationCoordY',XY{2}(2)};
        cond(icond).trialRelsweepsf   = {};
        cond(icond).alignEvent= alignEvent; % NOTE Times must be relative to the beginning of the session
        cond(icond).plotparam.scolor = [0 0 0.5];

        [h  ntrialsInCond]= psthCondSpikes(licksFiltered,cond, WOI, options);
%           
        % set(h.fig,'WindowStyle','docked')
        
        setaxesOnaxesmatrix(h.hAx(1),nr,nc,(ialign-1)*nc*2+itype,figparam,fig)
        setaxesOnaxesmatrix(h.hAx(2),nr,nc,(ialign-1)*nc*2+nc +itype,figparam,fig)
              clear sleg; for icond =1 : length(cond),       sleg{icond} =  [cond(icond).sleg ' n = ' num2str(ntrialsInCond(icond),'%d')] ; end
        hlegPsth = legend(h.hAx(1),h.hpsth,sleg);
        defaultLegend(hlegPsth,[],7)
        close(h.fig);

    end
end

sAnn = sprintf('%s_%s_%s_Choice%s Licks_%s',licks.sweeps.Animal,deblank(sAlign),'LightOnandOFF', deblank(num2str(Choice,' %d')), licks.sweeps.Date);

plotAnn(sAnn, fig );

 if bsave
%     r = brigdefs;
    sAnimal = licks.sweeps.Animal;
    savepath = fullfile('C:\Users\Bassam\Dropbox (Mainen Lab)\Bassam\BVA_MainenLab\Behavior\Data\HF_GoNoGoWait',sAnimal,'Licks');
    parentfolder(savepath,1);
%         export_fig(fig,fullfile(savepath,sAnn),'-pdf','-transparent')
    plot2svg(fullfile(savepath,[sAnn '.svg']),fig)
%     saveas(fig,fullfile(savepath,sAnn))
    disp([ 'saved to ' fullfile(savepath,sAnn)])
 end
        