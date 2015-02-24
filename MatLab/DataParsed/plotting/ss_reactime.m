function [varargout] = ss_reactime(data_parsed, plotting, hAx , bpatch)
%rt Returns the median reaction time per stimulus
%   Detailed explanation goes here
bBoxWhisker = 0; % instead of SEMs
bscatter = 0;

if nargin < 2
    plotting = true;
end

if nargin < 3
    hAx = gca;
end

if nargin < 4
    bpatch = 1;
end
h = [];
data = [];
if data_parsed.ntrials
    stimSet = data_parsed.IntervalSet;
    stimVector = data_parsed.Interval;
    rtVector = data_parsed.ReactionTime/1000;
    
    
    rt = nan(3,length(stimSet));
    rtSd = nan(3,length(stimSet));
    rtN = nan(3,length(stimSet));
    rtSem = nan(3,length(stimSet));
    
    for s = 1:length(stimSet)
        % All trials
        rt(1,s) = nanmedian(rtVector(stimVector==stimSet(s)));
    %    rtQ(1,s) = prctile(rtVector(stimVector==stimSet(s)),[0 25 75 100]);
        rtSd(1,s) = nanstd(rtVector(stimVector==stimSet(s)));
        rtN(1,s) = sum(and(stimVector==stimSet(s),~isnan(rtVector)));
        rtSem(1,s) = rtSd(1,s)/sqrt(rtN(1,s));
        rtRaw{s} = rtVector(stimVector==stimSet(s));
    end
    
    h = [];
    if plotting
        if ~bBoxWhisker
            if bpatch
                h.hp(1) =  patch([stimSet, fliplr(stimSet)],[rt(1,:)-rtSem(1,:), fliplr(rt(1,:)+rtSem(1,:))],[1 172 235]/255,'edgecolor','none','facealpha',0.2,'Parent',hAx);
                h.hl(1) = line(stimSet,rt(1,:),'color',[1 172 235]/255,'Marker','.','Parent',hAx);
            else
                h.hl = errorbar(stimSet,rt(1,:),fliplr(rt(1,:)-rtSem(1,:)),fliplr(rt(1,:)+rtSem(1,:)),'color',[1 172 235]/255 );
                set(h.hl,'LineStyle','none','Marker','.')
                h.he = get(h.hl, 'Children');
                h.he =  h.he(2);% Second handle is the handle to the error bar lines
                set(h.he,'linewidth',1)
            end
        else % box and whisker plots
            % make into a matrix for plot
            outMat = padCelltoMat(rtRaw);
            nelement = length(rtRaw);
            sizes = reshape(cell2mat(cellfun(@size, rtRaw,'UniformOutput',false)),2,nelement)';
            maxs = max(sizes);
            stimSetMat = ones(maxs(1),maxs(2), nelement);
            for i= 1:nelement
                stimSetMat(:,:,i) = ones(maxs).*stimSet(i);
            end
            outMat = squeeze(outMat);
            stimSetMat = squeeze(stimSetMat);
           if bscatter % scatter
               htemp = scatter(hAx,stimSetMat(:),outMat(:), 'jitter','on', 'jitterAmount',0.005);
            h.hsc = get(htemp,'Children');
            set(h.hsc,'MarkerSize',6);
            
           else
%                aboxplot(squeeze(outMat),'labels',[stimSet]); % Advanced box plot
%                h.boxp = boxplot(gca,squeeze(outMat),stimSet,'plotstyle','compact','whisker',10); % Advanced box plot
               set(hAx,'NextPlot','add')
               h.boxp = boxplot(hAx,squeeze(outMat),stimSet,'plotstyle','compact','whisker',0); % Advanced box plot

           end
        end
        
        
        
%         if ~all(isnan(rt))
%             set(hAx,'xlim',[0 1],'ylim',[ max(0,min(min(rt-rtSem))-200), max(max(rt+rtSem))+200])
%         end
    end
    
    data.rt = rt;
    data.rtSd = rtSd;
    data.rtN = rtN;
    data.rtSem = rtSem;

end

    varargout{1} = data;
    varargout{2} = h;