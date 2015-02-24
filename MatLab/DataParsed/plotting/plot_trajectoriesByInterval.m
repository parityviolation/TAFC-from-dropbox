function dp = plot_trajectoriesByInterval(dp,cond,source,savenameheader,options)
% function plot_trajectoriesByInterval(dp,cond,source,savenameheader,options)


% TODO:  something about outliers
% where first or last position is 'too' far away

if nargin<3|isempty(source),   source = 'extremes';end

if nargin<4,   savenameheader = '';end

if isempty(cond)
% %     
%     savenameheader = 'StimVsCtrl';
%         cond(1).name = 'Ctrl' ;
%     cond(1).color = [0 0 0];
%     cond(1).filter = {'stimulationOnCond',0};
%     cond(1).offset = 0 ;
%     cond(2).name = 'Stim' ;
%     cond(2).color = [0 0 1];
%     cond(2).filter = {'stimulationOnCond',@(x) x~=0};
%     cond(2).offset = 0 ;
    
%     savenameheader = 'StimCorrectVsCtrlCorrect';
%         cond(1).name = 'Ctrl' ;
%     cond(1).color = [0 0 0];
%     cond(1).filter = {'stimulationOnCond',0,'ChoiceCorrect',1};
%     cond(1).offset = 0 ;
%     cond(2).name = 'Stim' ;
%     cond(2).color = [0 0 1];
%     cond(2).filter = {'stimulationOnCond',@(x) x~=0,'ChoiceCorrect',1};
%     cond(2).offset = 0 ;
%     
        savenameheader = 'StimErrorVsCtrlError';
        cond(1).name = 'Ctrl' ;
    cond(1).color = [0 0 0];
    cond(1).filter = {'stimulationOnCond',0,'ChoiceCorrect',0};
    cond(1).offset = 0 ;
    cond(2).name = 'Stim' ;
    cond(2).color = [0 0 1];
    cond(2).filter = {'stimulationOnCond',@(x) x~=0,'ChoiceCorrect',0};
    cond(2).offset = 0 ;

    
%       savenameheader = 'CorrectVsError';  
%     cond(1).name = 'Correct' ;
%     cond(1).color = [0 1 0];
%     cond(1).filter = {'ChoiceCorrect',1};
%     cond(1).offset = 0 ;
%     cond(2).name = 'Error' ;
%     cond(2).color = [1 0 0];
%     cond(2).filter = {'ChoiceCorrect',0};
%     cond(2).offset = 0 ;
end
if ~isfield(cond,'trialfilter'),cond(1).trialfilter = []; end

% *************** options (not yet implemented as struct
%splitStimCond varies from 0-no stim 1-split in stim/no stim 2-split by all
%stim cond
% options.IntervalSet =  dp.IntervalSet;
% options.bIntervalGTX = 1;
bIntervalGTX = 1;
NtranjectorsToPlot = 100000;
bsplitStimCond = 0; % seperate stimulated from unstimuated
bsplitAllStimCond = 0; % seperate different types of stimualtion
bplotavg =1;
bplot_ind =1;
bMarkSecondBeep = 1;
bMarkFirstBeep = 1;
bplotAvgOnlyUntilTone2 = 1;
bplot_ind = 1;


xscale = 10/640*10;
yscale = 10/480*10;

avgfun = @nanmedian;

intervalSet = dp.IntervalSet;



r = brigdefs();

[dp] = getdpCond(dp,bsplitStimCond,bsplitAllStimCond);


switch(lower(source))
    
    case 'extremes'
        dp.tempxy_positionsParsed = dp.video.extremes.xyParsed;
        dp.tempxy_positionsParsed = dp.tempxy_positionsParsed(:,:,[4 3]);
    case 'cm'
        dp.tempxy_positionsParsed = dp.video.cm.xyParsed;      
    case 'qr1'
        m = 1;
        dp.tempxy_positionsParsed = dp.video.qr(m).modelViewMatrixParsed(:,:,[13 14]);
    case 'qr2'
        m = 2;
        dp.tempxy_positionsParsed = dp.video.qr(m).modelViewMatrixParsed(:,:,[13 14]);
    case 'qr3'
        m = 3;
        dp.tempxy_positionsParsed = dp.video.qr(m).modelViewMatrixParsed(:,:,[13 14]);
    case 'qref'
        dp.tempxy_positionsParsed = dp.video.qrRef.modelViewMatrixParsed(:,:,[13 14]);
    case 'qrefi'
        dp.tempxy_positionsParsed = dp.video.qrRef.mVMPInterp(:,:,[13 14]);
end

if isnan(dp.tempxy_positionsParsed)
    disp('Tracking information does not exist in this dp')
    return
end



savename = ['_Traj' source];

frame_rate = dp.video.info.medianFrameRate;

hfig.h = figure;clf;

set(hfig.h,'Position',[ 642          77        1095         901]);
% set(hfig.h,'Color','none')

nc = length(intervalSet)/2;
nr = 2;

if bplotavg && bplot_ind
    nr = 2*2;
end

num_trials = min(size(dp.tempxy_positionsParsed,1),dp.ntrials);
maxFramesToPlot = round(max(intervalSet)*dp.Scaling(end)/1000*frame_rate);
dp.temp.allTraj = nan(num_trials,maxFramesToPlot,2);

if bplot_ind||bplotavg
        
    for iIntv = 1:length(intervalSet)
        for icond = 1 : length(cond)
            thisInterval = intervalSet(iIntv);
            
            if bIntervalGTX
                intervalCond.filter = {'Interval', @(x) x>=thisInterval*0.999};
            else
                intervalCond.filter = {'Interval', thisInterval};
            end
            thisfilter ={cond(icond).filter{:} intervalCond.filter{:}}; % add the interval filter
            
            [thisdp sortvector]= filtbdata(dp,[],thisfilter,cond(icond).trialfilter);
            thisFrameLength = round(thisInterval*dp.Scaling(end)/1000*frame_rate);
            % plot only subset of trials
            if thisdp.ntrials> NtranjectorsToPlot
                thisdp = filtbdata(thisdp,[],{'TrialNumber',NtranjectorsToPlot});
            end
            
            theseTraj = thisdp.tempxy_positionsParsed;
            theseTraj(:,thisFrameLength+1:end,:)=NaN; % plot only until the second tone
            
           dp.tempallTraj(sortvector,:,:) = theseTraj(:,1:maxFramesToPlot,:);
           dp.tempTrajTone2(sortvector,:,:) = theseTraj(:,thisFrameLength,:); % position at tone2
           
             theseTraj(:,:,1) = theseTraj(:,:,1)*xscale; 
             theseTraj(:,:,2) = theseTraj(:,:,2)*yscale ;
             
             
            hfig.hsp(iIntv) = subplot(nr,nc,iIntv);
            
            if thisdp.ntrials
                if bplot_ind
                    
                    h = line(squeeze(theseTraj(:,:,1))',squeeze(theseTraj(:,:,2))'+cond(icond).offset*ones(size(squeeze(theseTraj(:,:,2))')) ...
                        ,'color',cond(icond).color,'Parent', hfig.hsp(iIntv),'LineWidth',0.3); hold on;
                    uistack(h,'top')
                    % plot the position at the First stimulus
                    if bMarkFirstBeep
                        h = line(squeeze(theseTraj(:,1,1))',...
                            squeeze(theseTraj(:,1,2))'+cond(icond).offset*ones(size(squeeze(theseTraj(:,1,2))')) ...
                            ,'Parent', hfig.hsp(iIntv),'Linestyle','none','Marker','o','MarkerSize',3,'LineWidth',1.1,'MarkerEdgeColor','w','MarkerFaceColor',cond(icond).color); hold on;
                        uistack(h,'top')
                    end
                    
                    % plot the position at the Second stimulus
                    if bMarkSecondBeep
                        h = line(squeeze(theseTraj(:,thisFrameLength,1))',...
                            squeeze(theseTraj(:,thisFrameLength,2))'+cond(icond).offset*ones(size(squeeze(theseTraj(:,thisFrameLength,2))')), ...
                            'Parent', hfig.hsp(iIntv),'Linestyle','none','Marker','o','MarkerSize',3,'LineWidth',1.1,'MarkerEdgeColor','k','MarkerFaceColor',cond(icond).color); hold on;
                        uistack(h,'top')
                    end
                    
                    %                     for ifr = 1:length(framenumbers)
                    %                          h = line(squeeze(theseTraj(:,framenumbers(ifr),1))',...
                    %                             squeeze(theseTraj(:,framenumbers(ifr),2))'+cond(2).offset(ival2)*ones(size(squeeze(theseTraj(:,framenumbers(ifr),2))')) ...
                    %                             ,'color',mycolor(ifr,:),'Parent', hfig.hsp(iIntv),'Linestyle','none','Marker','.'); hold on;
                    %                          uistack(h,'top')
                    %                     end
                    
                end
                axis tight
                set(gca,'Color','none')
                title(num2str(thisInterval));
                set(gca,'TickDir','out','Box','off')
                %
                iplotAvg = iIntv;
                if bplotavg && bplot_ind
                    iplotAvg = iIntv+(nc*2);
                end
                
                
                hfig.hsp(iplotAvg) = subplot(nr,nc,iplotAvg);
                
                if bplotavg %% && thisdp.ntrials>2
                    offset = 0;
                    x = avgfun(squeeze(theseTraj(:,:,1))',2);
                    y = avgfun(squeeze(theseTraj(:,:,2))',2);
                    offset = offset*ones(size(avgfun(squeeze(theseTraj(:,:,2))',2)));
                    
                    if bplotAvgOnlyUntilTone2
                        fr_Tone2 = round(thisInterval*dp.Scaling(end)/1000*frame_rate);
                        x(fr_Tone2:end) = NaN;
                        y(fr_Tone2:end) = NaN;
                    end
                    
                end
                line(x, y+offset,'color',cond(icond).color,'Parent', hfig.hsp(iplotAvg),'Linestyle','-','LineWidth',3.5); hold on;
                axis tight
                set(gca,'Color','none')
                title(num2str(thisInterval))
                set(gca,'TickDir','out','Box','off')
                
            end
        end
    end
    
    axis(hfig.hsp(:),'tight')
    
    x_dim = cell2mat(get ( hfig.hsp,'xlim'));
    
    x_dim = [min(x_dim(:,1)),max(x_dim(:,2))];
    
    y_dim = cell2mat(get ( hfig.hsp,'ylim'));
    
    y_dim = [min(y_dim(:,1)),max(y_dim(:,2))];
    
    xymax = max(range(x_dim), range(y_dim));
    
    set(hfig.hsp(:),'xlim',[x_dim(1) x_dim(1)+xymax]);
    set(hfig.hsp,'ylim',[y_dim(1) y_dim(1)+xymax]);
    
    plotAnn([savenameheader ' ' savename ' ' dp.FileName],hfig.h)
    if ~isempty(hfig.h)
        patht = fullfile(r.Dir.SummaryFig,'Trajectory',dp.Animal,dp.Date);
        parentfolder(patht,1);
        export_fig(hfig.h, fullfile(patht, [savenameheader '_' dp.FileName '_' savename]),'-pdf','-transparent');
    end
end