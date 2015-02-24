function hl = decodeSpikeCountCode(code,plotoptions)
if nargin<2
plotoptions.boverlayplot = 0;
plotoptions.mycolor = 'r';
end

myfun{1} = @(x) nanmean(x,3);
%myfun{2} = @(x) nanmedian(x,3);
%myfun{3} = @(x) nanmax(x,[],3);

nbin = code.nbin;
nchn = code.nchn;
nTest = code.nTest;
bin_end = code.bin_end;
pseudoTrial = code.pseudoTrial;
centerHistConc = code.centerHistConc;
spikeCountHistConc  = code.spikeCountHistConc;
selcLabel  = code.selcLabel;

clear testTrials;        
%       testbin, timebin, nTest,    Templates, testLabels
p = nan(nbin,nbin,nTest,length(selcLabel),length(selcLabel));
clear p_thisbin
for iLabel=1:length(selcLabel) %making a pseudotrial with all cells available
    
    for iTestTrial = 1:nTest
        iTestTrial
        testTrials(:,:,iTestTrial) = pseudoTrial{iLabel,iTestTrial};  % randi(ntrials,1,ntest);
        
        % TEST this trial against the nTemplates one for each Label
        for iTemplate = 1:length(selcLabel)
            for iTestbin = 1:nbin
                thisTestTrial =  testTrials(:,iTestbin,iTestTrial);
                for ibin = 1:nbin % for each Possible Time in 'Template'
                    p_thisbin(ibin) = 1;
                    for ichn=1:nchn
                        %                 p_thisbin(ibin)  = p_thisbin(ibin) * interp1(squeeze(centerHist(ichn,ibin,:)), squeeze(spikeCountHist(ichn,ibin,:)),thisTestTrial(ichn));
                        [~, ind] = min((centerHistConc{iTemplate,iTestTrial}(ichn,ibin,:)-thisTestTrial(ichn)).^2);
                        % WATCH out this number could be TOO small .. could
                        % use log
                        p_thisbin(ibin)  = p_thisbin(ibin) * spikeCountHistConc{iTemplate,iTestTrial}(ichn,ibin,ind(1));
                    end
                end
                p(iTestbin,:,iTestTrial,iTemplate,iLabel) =  p_thisbin ;
            end
        end
    end
end
%% Plotting
% figure


% % BA seems like I should just take the p at the 'matched' time bin in the
% template
%       
% p = nan(testbin, timebin, nTest,    Templates, testLabels);
% convert into probality of Template 
psimple =  nan(nbin, 1, nTest,  length(selcLabel),length(selcLabel));
for iLabel = 1:length(selcLabel)
    for iTest = 1:nTest
        for ibin = 1:nbin
            temp = sum(p,2);
            psimple(ibin,1,iTest,:,iLabel) = temp(ibin,1,iTest,:,iLabel)/sum(temp(ibin,1,iTest,:,iLabel));
            
%             psimple(ibin,1,iTest,:,iLabel) = p(ibin,ibin,iTest,:,iLabel)/sum(p(ibin,ibin,iTest,:,iLabel));
        end
    end
end

    x = bin_end/1000;

this_p = squeeze(psimple(:,:,:,2,2));
plot(x,mean(this_p,2));hold all;

nfun = length(myfun);
    x = bin_end/1000;
this_p = squeeze(p(:,:,:,1));
for ifun = 1:nfun
    clear npm
    pm = myfun{ifun}(this_p);  
    for i = 1:length(pm)
        npm(i,:) = pm(i,:)/sum( pm(i,:));
    end
    subplot(1,2,1)
    imagesc(npm)
    colormap(bone)
    h(1) = gca;
    axis xy
    axis square
    indx = get(h(1),'xtick');
    indy = get(h(1),'ytick');
    set(h(1),'xtickLabel',x(indx),'yticklabel',x(indy))
    xlabel('Real Time (s)'); ylabel('Decoded Time (s)')
    
    
    if plotoptions.boverlayplot %overlay on imagesc
        
        haxes1_pos = get(h(1),'Position'); % store position of first axes
        h(2) = axes('Position',haxes1_pos,...
            'XAxisLocation','top',...
            'YAxisLocation','right',...
            'Color','none');
        axis square
    else
        h(2) = subplot(1,2,2);
    end
    
    % max
    [~, ind] = nanmax(npm,[],1);
    mpm = sum( npm.*repmat(x,size(pm,1),1)); % mean
    for ip = length(plotoptions.plottype)
        switch plotoptions.plottype{ip}
            case 'mean'
                hl(ip) = line(x,mpm,'linestyle','none','marker','o','linewidth',2.5,'color',plotoptions.mycolor,'Parent',h(2));
            case 'max'
                hl(ip) = line(x,x(ind),'linestyle','none','marker','.','linewidth',2.5,'color',plotoptions.mycolor,'Parent',h(2));
        end
    end
    axis square
    if plotoptions.boverlayplot
        set(h(2),'YTick',[],'XTick',[],'YTickLabel',[],'XTickLabel',[],'XColor','w','YColor','w')
    end
    axis tight
    xlim([min(x),max(x)])
    ylim([min(x),max(x)])
    hold on;
    %    plot(x,myfun2(pm))

    ind = find(code.int_list(selcLabel)/1000>x,1,'last');
    line(x(ind).*[1 1],[min(x),max(x)],'color','k')
   
end
