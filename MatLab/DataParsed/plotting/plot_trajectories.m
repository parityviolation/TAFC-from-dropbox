function dataParsed = plot_trajectories(dataParsed,source,splitStimCond,bplot_ind,bplotavg,framenumbers)

%splitStimCond varies from 0-no stim 1-split in stim/no stim 2-split by all
%stim cond
NtranjectorsToPlot = 5;

bMarkSecondBeep = 0
bMarkFirstBeep = 0

if nargin<2
    source = 'extremes';
end

savename = ['_Traj' source];

switch(lower(source))
    
    case 'extremes'
%         xy_positionsParsed = dataParsed.video.extremesTransf;
        
        xy_positionsParsed = dataParsed.video.extremes.xyParsed;
        xy_positionsParsed = xy_positionsParsed(:,:,[4 3]);
    case 'cm'     
         xy_positionsParsed = dataParsed.video.cm.xyParsed;
        
    case 'qr1'
        m = 1;
        xy_positionsParsed = dataParsed.video.qr(m).modelViewMatrixParsed(:,:,[13 14]);
    case 'qr2'
        m = 2;
        xy_positionsParsed = dataParsed.video.qr(m).modelViewMatrixParsed(:,:,[13 14]);
    case 'qr3'
        m = 3;
        xy_positionsParsed = dataParsed.video.qr(m).modelViewMatrixParsed(:,:,[13 14]);
   case 'qref'
        xy_positionsParsed = dataParsed.video.qrRef.modelViewMatrixParsed(:,:,[13 14 15]);
   case 'qrefi'
        xy_positionsParsed = dataParsed.video.qrRef.mVMPInterp(:,:,[13 14]);
end

bplotAvgOnlyUntilTone2 = 1;

if nargin<3
    splitStimCond = 0;
end
if nargin<4
    bplot_ind = 1;
    
end
if nargin<5
    bplotavg = 1;
end
if nargin <6
    framenumbers = [];
else
    mycolor = colormap(lines(length(framenumbers)));
end


if bplot_ind
    savename = [savename 'Indv'] ;
end
if bplotavg
    savename = [savename 'Avg'] ;
    if bplotAvgOnlyUntilTone2
        savename = [savename 'ToTone2'];
    end
end

r = brigdefs();



% filtering
%
if isnan(xy_positionsParsed)
    disp('Tracking information does not exist in this dataParsed')
    return
end
Hz = dataParsed.video.info.meanFrameRate;
% lowpass = 10;% Hz
% for n = 1:2
%     xy_positionsParsed(:,:,n) = filterdata(xy_positionsParsed(:,:,n),1/Hz,lowpass,0);
% end


num_trials = min(size(xy_positionsParsed,1),dataParsed.ntrials);
frame_disp = min(size(xy_positionsParsed,2),2000);

% for i = 1:num_trials
%     
%     temp = squeeze(xy_positionsParsed(i,1:frame_disp,:));
%         plot(temp(:,1),temp(:,2),'color', 'g');
%         hold on
%         plot(temp(1,1),temp(1,2),'.m');
%     
% end



% set(hf,'Visible','on')
%%
% addTrajectors to dataParsed
%
% prem_long = dataParsed.matrix(:,9)==1;
% prem_short = dataParsed.matrix(:,9)==0;
%
% choice_short = dataParsed.matrix(:,3)==0;
% choice_long = dataParsed.matrix(:,3)==1;
%
dataParsed.video.extremes_simple = xy_positionsParsed(:,:,[1,2,3]);
% saveBstruct(dataParsed);
for i = 1:size(dataParsed.video.extremes_simple,3)
dataParsed.video.extremes_simple(:,:,i) = (dataParsed.video.extremes_simple(:,:,i) - nanmean(dataParsed.video.extremes_simple(:,1,i))) *(10/640*10) ; 
end
hfig.h = figure;clf;

% set(hfig.h,'Color','none')
set(hfig.h,'Position',[ 642          77        1095         901])


% for all stimuli
cond(1).val= dataParsed.IntervalSet;
cond(1).color =  repmat([1:length(cond(1).val)]'/length(cond(1).val),1,3) .*repmat([1 0 0],length(cond(1).val),1);
cond(1).name = 'Stim';
dataParsed.computed.cond(1).val=cond(1).val;
dataParsed.computed.cond(1).name=cond(1).name;


% for  correct/incorrect
% cond(2).val= [1 0];
cond(2).val= [1];
cond(2).offset = [0 0];
cond(2).color =  [[0 1 0];[1 0 0]];
cond(2).index = 4;
cond(2).name = 'Correct/incorrect';
dataParsed.computed.cond(2).val=cond(2).val;
dataParsed.computed.cond(2).name=cond(2).name;


cond(3).val = cond(1).val*(dataParsed.Scaling(end)/1000);
frame_rate = dataParsed.video.info.medianFrameRate;
cond(3).val = round(cond(3).val*frame_rate); % index of when the 2nd tone should theoretically come
cond(3).val = single(cond(3).val);

% for  stimOff/stimOn

 bsplitStimCond = 0;
 bsplitAllStimCond = 0;

[dpCond] = getdpCond(dataParsed,bsplitStimCond,bsplitAllStimCond);

if splitStimCond==1
    bsplitStimCond = 1;
    bsplitAllStimCond = 0;
    
    [dpCond] = getdpCond(dataParsed,bsplitStimCond,bsplitAllStimCond);
    
elseif splitStimCond==2
    
    bsplitStimCond = 1;
    bsplitAllStimCond = 1;
    
    [dpCond] = getdpCond(dataParsed,bsplitStimCond,bsplitAllStimCond);
end
dpCond = dpCond(end:-1:1);
    

cond(4).val= 0:length(dpCond)-1;
cond(4).offset = [0 0];
cond(4).name = 'stimOn/stimOff';
dataParsed.computed.cond(4).val=cond(4).val;
dataParsed.computed.cond(4).name=cond(4).name;


nc = length(cond(1).val)/2;
nr = 2;

if bplotavg && bplot_ind
    nr = 2*2;
end

%%
%%SOFIA

if bplot_ind||bplotavg
    
    xy_positionsParsed2 = nan(num_trials, max(cond(3).val),size(xy_positionsParsed,3));
    frames_parsed_ind = nan(num_trials,length(cond(2).val),length(cond(1).val));
    
    for ival1 = 1:length(cond(1).val)
        
        for ival2 = 1:length(cond(2).val)
            
            ind = find(dataParsed.Interval==cond(1).val(ival1) & dataParsed.ChoiceCorrect==cond(2).val(ival2) );
            
            % 
            if length(ind)> NtranjectorsToPlot
                ind = ind(1:NtranjectorsToPlot);
            else
                ind = ind(1:length(ind));
                
            end
            %save trial indexes for correct and incorrect responses across the
            %8 different stimuli
            frames_parsed_ind(1:length(ind),ival2,ival1) = ind;
            
            %coordinates end on second beep
            xy_positionsParsed2(ind,1:cond(3).val(ival1),:) = dataParsed.video.extremes_simple(ind,1:cond(3).val(ival1),:);
%             xy_positionsParsed2(ind,1:cond(3).val(ival1),:) = dataParsed.video.qrRef.modelViewMatrixParsed(ind,1:cond(3).val(ival1),[13 14]);
            hfig.hsp(ival1) = subplot(nr,nc,ival1);
            
            
            if ~isempty(ind)
                if bplot_ind
                    
                    if 0
                    h = line(squeeze(xy_positionsParsed2(ind,:,1))',squeeze(xy_positionsParsed2(ind,:,2))'+cond(2).offset(ival2)*ones(size(squeeze(xy_positionsParsed2(ind,:,2))')) ...
                        ,'color',cond(2).color(ival2,:),'Parent', hfig.hsp(ival1),'LineWidth',0.3); hold on;
                    uistack(h,'top')
                    else % plot 3D
                        x = squeeze(xy_positionsParsed2(ind,:,1));
                        y = squeeze(xy_positionsParsed2(ind,:,2));
                        z = squeeze(xy_positionsParsed2(ind,:,3));
                        indout = isnan(z);
                        x(indout) = []; y(indout) = []; z(indout) = [];
                        
                        if 0 % markersize changes with Z
                            surface([x;x],[y;y],zeros(2,length(z)),[z;z],'EdgeColor','flat','Parent', hfig.hsp(ival1)); hold on
                            MarkerSize = round(z*1000)+1;
                            MarkerSize = MarkerSize-min(MarkerSize)+1;
                            MarkerSize = ceil(MarkerSize/max(MarkerSize)*800);
                            scatter(x,y,MarkerSize,z,'.','MarkerFaceColor','auto','Parent', hfig.hsp(ival1)); 
                        else
                            planez = zeros(size(x));
                            surface([x;x],[y;y],[planez;planez],[z;z],...
                                'facecol','no',...
                                'edgecol','interp',...
                                'linew',2);
                        end
                    end
%                     line(,squeeze(xy_positionsParsed2(ind,:,2))
                     % plot the position at the First stimulus 
                     if bMarkFirstBeep
                         h = line(squeeze(xy_positionsParsed2(ind,1,1))',...
                             squeeze(xy_positionsParsed2(ind,1,2))'+cond(2).offset(ival2)*ones(size(squeeze(xy_positionsParsed2(ind,1,2))')) ...
                             ,'Parent', hfig.hsp(ival1),'Linestyle','none','Marker','o','MarkerSize',3,'LineWidth',1.1,'MarkerEdgeColor','w','MarkerFaceColor',cond(2).color(ival2,:)); hold on;
                         uistack(h,'top')
                     end
                     
                     % plot the position at the Second stimulus
                     if bMarkSecondBeep
                         h = line(squeeze(xy_positionsParsed2(ind,cond(3).val(ival1),1))',...
                             squeeze(xy_positionsParsed2(ind,cond(3).val(ival1),2))'+cond(2).offset(ival2)*ones(size(squeeze(xy_positionsParsed2(ind,cond(3).val(ival1),2))')) ...
                             ,'Parent', hfig.hsp(ival1),'Linestyle','none','Marker','o','MarkerSize',7,'LineWidth',1.1,'MarkerEdgeColor','k','MarkerFaceColor',cond(2).color(ival2,:)); hold on;
                         uistack(h,'top')
                     end
                     
                    for ifr = 1:length(framenumbers)
                         h = line(squeeze(xy_positionsParsed2(ind,framenumbers(ifr),1))',...
                            squeeze(xy_positionsParsed2(ind,framenumbers(ifr),2))'+cond(2).offset(ival2)*ones(size(squeeze(xy_positionsParsed2(ind,framenumbers(ifr),2))')) ...
                            ,'color',mycolor(ifr,:),'Parent', hfig.hsp(ival1),'Linestyle','none','Marker','.'); hold on;
                         uistack(h,'top')
                    end
                    
                    
                end
                
                axis tight
%                 set(gca,'Color','none')
                title(num2str(cond(1).val(ival1)))
                set(gca,'TickDir','out','Box','off')
                %
                ival1Avg = ival1;
                if bplotavg && bplot_ind
                    ival1Avg = ival1+(nc*2);
                end
                
                hfig.hsp(ival1Avg) = subplot(nr,nc,ival1Avg);
                
                if bplotavg && length(ind)>2
                    offset = 0;
                    x = nanmedian(squeeze(xy_positionsParsed2(ind,:,1))',2);
                    y = nanmedian(squeeze(xy_positionsParsed2(ind,:,2))',2);
                    offset = offset*ones(size(nanmedian(squeeze(xy_positionsParsed2(ind,:,2))',2)));
                    
                    if bplotAvgOnlyUntilTone2
                        fr_Tone2 = round(cond(1).val(ival1)*dataParsed.Scaling(end)/1000*frame_rate);
                        x(fr_Tone2:end) = NaN;
                        y(fr_Tone2:end) = NaN;
                    end
                    
                    line(x, y+offset,'color',cond(2).color(ival2,:),'Parent', hfig.hsp(ival1Avg),'Linestyle','-','LineWidth',3.5); hold on;
                    
                end
                axis tight
                set(gca,'Color','none')
                title(num2str(cond(1).val(ival1)))
                set(gca,'TickDir','out','Box','off')
                
            end
        end
        
    end
    
    %save trial indexes for correct and incorrect responses across the
    %8 different stimuli in dataParsed
    
    dataParsed.computed.frames_parsed_ind = frames_parsed_ind;
    
    
    axis(hfig.hsp(:),'tight')
    
    x_dim = cell2mat(get ( hfig.hsp,'xlim'));
    
    x_dim = [min(x_dim(:,1)),max(x_dim(:,2))];
    
    y_dim = cell2mat(get ( hfig.hsp,'ylim'));
    
    y_dim = [min(y_dim(:,1)),max(y_dim(:,2))];
    
    xymax = max(range(x_dim), range(y_dim));
    
    set(hfig.hsp(:),'xlim',[x_dim(1) x_dim(1)+xymax]);
    set(hfig.hsp,'ylim',[y_dim(1) y_dim(1)+xymax]);
    
    %axis(hfig.hsp(:),'equal')
    
    plotAnn([num2str(dataParsed.Scaling(1)/1000) 's ' dataParsed.FileName],hfig.h)
    if ~isempty(hfig.h)
        parentfolder(fullfile(r.Dir.SummaryFig,'Trajectory'),1)
        export_fig(hfig.h, fullfile(r.Dir.SummaryFig,'Trajectory', [dataParsed.FileName '_' num2str(dataParsed.Scaling(1)/1000) savename]),'-pdf','-transparent');
    end
end

 dataParsed.computed.frames_parsed_ind = frames_parsed_ind;

%%
%Stimulated trials


if splitStimCond
    
    for ival4 = 1:length(cond(4).val)
        
%         xy_positionsParsed = dpCond(ival4).video.extremes.xyParsed;
%         xy_positionsParsed = xy_positionsParsed(:,:,[4 3]);
        
        
        if isnan(xy_positionsParsed)
            disp('Tracking information does not exist in this dataParsed')
            return
        end
        Hz = dpCond(ival4).video.info.medianFrameRate;
        lowpass = 10;% Hz
        for n = 1:2
            xy_positionsParsed(:,:,n) = filterdata(xy_positionsParsed(:,:,n),1/Hz,lowpass,0);
        end
        
        dpCond(ival4).video.extremes_simple = xy_positionsParsed(:,:,[1,2]);
        dpCond(ival4).video.extremes_simple(:,:,1) = dpCond(ival4).video.extremes_simple(:,:,1)  - nanmean(dpCond(ival4).video.extremes_simple(:,1,1));
        dpCond(ival4).video.extremes_simple(:,:,2) = dpCond(ival4).video.extremes_simple(:,:,2)  - nanmean(dpCond(ival4).video.extremes_simple(:,1,2));
        
    end
    hfigStim.h = figure;clf;
    
    % set(hfig.h,'Color','none')
    set(hfigStim.h,'Position',[ 642          77        1095         901])
    
    
    xy_positionsParsed2 = nan(num_trials, max(cond(3).val),2);
    frames_parsed_ind = nan(num_trials,length(cond(2).val),length(cond(1).val));
    
    nc = length(cond(1).val)/2;
    nr = 4;
    
    
    
    
    
    for ival1 = 1:length(cond(1).val)
        
        for ival2 = 1:length(cond(2).val)
            
            hfigStim.hsp(ival1) = subplot(nr,nc, ival1+(length(cond(1).val)*cond(2).val(ival2)));
            
            for ival4 = 1:length(cond(4).val)
                
                cond(4).color = dpCond(ival4).plotparam.color;
                ind = find(dpCond(ival4).Interval==cond(1).val(ival1) & dpCond(ival4).ChoiceCorrect==cond(2).val(ival2) );
                
                %save trial indexes for correct and incorrect responses across the
                %8 different stimuli
                
                frames_parsed_ind(1:length(ind),ival2,ival1) = ind;
                
                %coordinates end on second beep
                xy_positionsParsed2(ind,1:cond(3).val(ival1),:) = dpCond(ival4).video.extremes_simple(ind,1:cond(3).val(ival1),:);
                
                
                if ~isempty(ind)
                    
                    %                     line(squeeze(xy_positionsParsed2(ind,:,1))',squeeze(xy_positionsParsed2(ind,:,2))'+cond(2).offset(ival2)*ones(size(squeeze(xy_positionsParsed2(ind,:,2))')) ...
                    %                         ,'color',cond(2).color(ival2,:),'Parent', hfig.hsp(ival1),'LineWidth',0.3); hold on;
                    
                    line(squeeze(xy_positionsParsed2(ind,:,1))',squeeze(xy_positionsParsed2(ind,:,2))' ...
                        ,'color',cond(4).color,'Parent', hfigStim.hsp(ival1),'LineWidth',0.3); hold on;
                    
                    
                    % plot the position at the Second stimulus
                    
                    line(squeeze(xy_positionsParsed2(ind,cond(3).val(ival1),1))',...
                        squeeze(xy_positionsParsed2(ind,cond(3).val(ival1),2))' ...
                        ,'color','k','Parent', hfigStim.hsp(ival1),'Linestyle','none','Marker','.','MarkerSize',5); hold on;
                    
                    
                    for ifr = 1:length(framenumbers)
                        line(squeeze(xy_positionsParsed2(ind,framenumbers(ifr),1))',...
                            squeeze(xy_positionsParsed2(ind,framenumbers(ifr),2))' ...
                            ,'color',mycolor(ifr,:),'Parent', hfigStim.hsp(ival1),'Linestyle','none','Marker','.'); hold on;
                        
                    end
                    
                    %
%                     %FOR AVERAGES
%                     
%                                     ival1Avg = ival1;
%                                     if bplotavg && bplot_ind
%                                         ival1Avg = ival1+(nc*2);
%                                     end
%                     
%                                     hfig.hsp(ival1Avg) = subplot(nr,nc,ival1Avg);
%                     
%                                     if bplotavg && length(ind)>2
%                                         offset = 0;
%                                         x = nanmedian(squeeze(xy_positionsParsed2(ind,:,1))',2);
%                                         y = nanmedian(squeeze(xy_positionsParsed2(ind,:,2))',2);
%                                         offset = offset*ones(size(nanmedian(squeeze(xy_positionsParsed2(ind,:,2))',2)));
%                     
%                                         if bplotAvgOnlyUntilTone2
%                                             fr_Tone2 = round(cond(1).val(ival1)*dataParsed.Scaling(end)/1000*frame_rate);
%                                             x(fr_Tone2:end) = NaN;
%                                             y(fr_Tone2:end) = NaN;
%                                         end
%                     
%                                         line(x, y+offset,'color',cond(2).color(ival2,:),'Parent', hfig.hsp(ival1Avg),'LineWidth',4); hold on;
%                     
%                                     end
%                     axis tight
%                     set(gca,'Color','none')
%                     title([num2str(cond(1).val(ival1)) ' and ' num2str(cond(2).val(ival2))])
%                     set(gca,'TickDir','out','Box','off')
                    
                    
                end
            end
        end
        
    end
    
    %save trial indexes for correct and incorrect responses across the
    %8 different stimuli in dataParsed
    
    
    
    
    axis(hfigStim.hsp(:),'tight')
    
    x_dim = cell2mat(get ( hfigStim.hsp,'xlim'));
    
    x_dim = [min(x_dim(:,1)),max(x_dim(:,2))];
    
    y_dim = cell2mat(get ( hfigStim.hsp,'ylim'));
    
    y_dim = [min(y_dim(:,1)),max(y_dim(:,2))];
    
    xymax = max(range(x_dim), range(y_dim));
    
    set(hfigStim.hsp(:),'xlim',[x_dim(1) x_dim(1)+xymax]);
    set(hfigStim.hsp(:),'ylim',[y_dim(1) y_dim(1)+xymax]);
    
    %axis(hfig.hsp(:),'equal')
    
    plotAnn([num2str(dataParsed.Scaling(1)/1000) 's ' dataParsed.FileName],hfigStim.h)
    
        if ~isempty(hfigStim.h)
            parentfolder(fullfile(r.Dir.SummaryFig,'TrajectoryStim'),1)
            export_fig(hfigStim.h, fullfile(r.Dir.SummaryFig,'TrajectoryStim', [dataParsed.FileName '_' num2str(dataParsed.Scaling(1)/1000) savename]),'-pdf','-transparent');
        end
end






















%%
%get(hfig.hsp(1)) %useful

%%
%
% % set all axis the same
% temp = cell2mat(get( hfig.hsp ,'xlim'));
% set(hfig.hsp ,'xlim',[min(temp(:,1)) max(temp(:,2))])
% temp = cell2mat(get( hfig.hsp ,'ylim'));
% set(hfig.hsp ,'ylim',[min(temp(:,1)) max(temp(:,2))])
%
% % add center poke
% cp = nanmean(dataParsed.video.extremes_simple(1,:,:),3);
% hl = line(cp(1)*[1 1],cp(2)*[1 1],'Marker','.','MarkerSize',20,'Color',[0 0 0]);
% copyobj(hl,hfig.hsp)
% set(hfig.hsp,'Xtick',[])
% set(hfig.hsp,'Ytick',[])
%
% [junk name] =  fileparts(dataParsed.FileName);
% plotAnn(name,hfig.h)