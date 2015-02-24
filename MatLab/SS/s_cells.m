
    %% add average WAveforms
% 
%     EU = [ 43 1 ;...
%     39 1;...
%     37 2;...
%     60 1];
%     
%     for iEU = 1:size(EU,1)
%     [spikes]= addUnits_spikes(spikes, EU(iEU,:) );
%     end
%     spikesNoW = rmfield(spikes,'waveforms');
    
    for iEU = 1%1:size(EU,1)
        Electrode = EU(iEU,1);
        UnitID =  EU(iEU,2);
        
          %% Pm vs non PM
        
            WOI  = [2 2]*1000;
        alignEvent = 'TrialInit';
        clear options cond;
        options.bsave = 1;
        options.BOOTSTRAP = 0;
        options.BINSIZE = 20;
        options.NSMOOTH =round(50/ options.BINSIZE);
        options.sDesc = 'Pm vs non premature';
        sAnimal = spikesNoW.sweeps.Animal;
        sDate = spikesNoW.sweeps.Date;
        options.savefile = sprintf('%s_AL%s_%sE%d_U%d%s%s',options.sDesc,alignEvent, sDate,Electrode,UnitID );
        options.dpFieldsToPlot = {};
        options.sortSweepsByARelativeToB= {'TrialInit',alignEvent};
        options.plottype = {'psth','rasterplot'};
        icond = 1;
        cond(icond).sleg = 'Not PM';
        cond(icond).spikesf = {'Electrode',Electrode,'Unit',UnitID};
        cond(icond).sweepsf   = {'Premature',0};
        cond(icond).trialRelsweepsf   = {};
        cond(icond).alignEvent= alignEvent; % NOTE Times must be relative to the beginning of the session
        cond(icond).plotparam.scolor = 'k';
        icond = 2;
        cond(icond).sleg = 'PM';
        cond(icond).spikesf = {'Electrode',Electrode,'Unit',UnitID};
        cond(icond).sweepsf   = {'Premature',1};
        cond(icond).trialRelsweepsf   = {};
        cond(icond).alignEvent= alignEvent; % NOTE Times must be relative to the beginning of the session
        cond(icond).plotparam.scolor = 'b';
        
        
        [h  ntrialsInCond]= psthCondSpikes(spikesNoW,cond, WOI, options);
        
        set(h.hAx,'Color','none')
        %set(h.hpsth(2),'Linestyle','--')
        %     set(h.hpsth(3),'Linestyle',':')
        
        plotSpikeWave(spikesNoW,Electrode,UnitID,1);
        
        clear sleg; for icond =1 : length(cond),       sleg{icond} =  [cond(icond).sleg ' n = ' num2str(ntrialsInCond(icond),'%d')] ; end
        hlegPsth = legend(h.hAx(1),h.hpsth,sleg);
        defaultLegend(hlegPsth,[],7)
        
            if 1
                r = brigdefs;
                sAnimal = spikes.sweeps.Animal;
                savepath = fullfile(r.Dir.EphysFigs,sAnimal,'PSTH');
                parentfolder(savepath,1);
                export_fig(h.fig,fullfile(savepath,options.savefile),'-pdf')
                saveas(h.fig,fullfile(savepath,options.savefile))
                disp([ 'saved to ' fullfile(savepath,options.savefile)])
            end
        
        
    end
    