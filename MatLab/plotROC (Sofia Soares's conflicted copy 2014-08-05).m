%function h = plotROC(spikes,alignEvent,WOIin,ElectUnit,options)
% function h = plotAlignedByIntervalOverLay_spikes(spikes,alignEvent,ElectUnit,options)
%
% plots Raster and PSTH for each stimulus interval aligned on alignEvents

r = brigdefs;
cond = options.cond;
syncEvent = 'TrialAvail';
syncEventEphys = 'TrialAvailEphys';

tempoptions.syncEventEphys = syncEventEphys;
tempoptions.syncEvent = syncEvent;
myColor = copper(length(cond));

%%

for icond = 1:length(cond)
    filt_spikes = filtspikes(spikes,0,cond(icond).spikesf,cond(icond).sweepsf);
    [spikeTimeRelativeToEvent trials] = relativeSpiketimes_spikes(filt_spikes,cond(icond).alignEvent,[WOI(1) WOI(2)],tempoptions);
    trialsUnique = unique(trials);
    
    for itrial = 1:length(trialsUnique)
        trial_ind = trials==trialsUnique(itrial);
        
        these_spikes = spikeTimeRelativeToEvent(trial_ind);
        spikeCounts(icond,itrial) = sum(~isnan(these_spikes));
        
    end
    %[hist(icond).vect,hist(icond).bins] = hist(spikeCounts(icond,:));
    [lala,bin] = hist(spikeCounts(icond,:),30);
    
end

bins = max(max(spikeCounts));
clear h;
for icond = 1:length(cond)
    hist(spikeCounts(icond,:),bins)
    hold on;
    a = findobj(gca,'Type','patch');
    h(icond) = a(1);
    set(h(icond),'FaceColor',myColor(icond,:),'EdgeColor','w');
    
end

%%
% [a,bins(] = hist(spikeCounts(1,:));
%  hold on;
%  hist(spikeCounts(2,:));
%  
%  
% h = findobj(gca,'Type','patch');
% display(h)
%  
% set(h(1),'FaceColor','r','EdgeColor','k');
% set(h(2),'FaceColor','g','EdgeColor','k');













% if bsave
%     %     export_fig(h.fig,fullfile(savepath,savefile),'-pdf')
%     plot2svg(fullfile(savepath,[savefile,'.svg']),h.fig)
%     saveas(h.fig,fullfile(savepath,savefile))
% end
