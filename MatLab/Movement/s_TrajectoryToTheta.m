% looks like the difference between stimulated and unstimualated angle
% increases as time goes on? consistent with speed.
%
% go through the tranjectory and calculate the average vector at each
% frame?  
%   - Move faster to turn around. then stay there longer.


% 


A = {'sert864sub'}
groupsavefile = fullfile(r.Dir.dropboxtemp,'sert864sub');


bAcrossAnimals = 0; % set to 1 to get the average across animals
bloadFromdp =1

condCell.condGroup = {[1 2 3]}; % group Stimulations conditions accordingly
condCell.condGroupDescr = '[1 2 3]';


s_loadMultipleHelper

% add modified 
for ifile = 1:length(thisAnimal)
    thisAnimal(ifile) = addExtremes(thisAnimal(ifile));
    
end

dpC2 = concdp(thisAnimal);
%%

bsave = 1
bin = 20;

avgfun = @circ_mean;
avgfunR= @nanmean;
hfig.h = figure('Position',[ 494         558        1332         420]);
subplot(1,3,1)
% parametrize with theta.
% get time at second tone
dpC2 = plot_trajectoriesByInterval(dpC2,[],[]);
dpC2 = paramTraj(dpC2); % must run first 
% dpC868 = paramTraj(dpC868); % must run first dpC2 = plot_trajectoriesByInterval(dpC,[],[]);
%dpC2 = dpC864
%%plot Theta as a function of time
param = 'theta'

switch param
    case 'theta'        
        savename = ['_TrajThetaTimeCourse'];
        statfun =@circ_wwtest;
    case 'r'
        savename = ['_RTrajTimeCourse'];
                statfun =@ranksum;

end
%%
figure; clf
lastFrame = size(dpC2.polarTraj,2);
stepFrame = 40;
frameSet = stepFrame:stepFrame: lastFrame ;
frameSet = round(dpC2.IntervalSet*dpC2.Scaling/1000*dpC2.video.info.medianFrameRate);
nr = 2;
nc = ceil(length(frameSet)/nr);

clear theta_all
i =0; tim = nan(lastFrame/stepFrame,1); avgTheta = nan(lastFrame/stepFrame,2);
for iframe = frameSet
    i = i+1;
    thisTime = double(iframe)/dpC2.video.info.medianFrameRate;
    if bIntervalGTX
        intervalFilter = {'Interval', @(x) x>=thisTime/(dpC2.Scaling/1000)*0.99};
    else
        intervalFilter = {'Interval', round(thisTime/(dpC2.Scaling/1000)*100)/100};
    end
        thisInterval = round(thisTime/(dpC2.Scaling/1000)*100)/100;

    for icond = 1 : length(cond)
        thisfilter ={cond(icond).filter{:} intervalFilter{:}}; % add the interval filter
        
        dpTemp= filtbdata(dpC2,0,thisfilter);
        theta = dpTemp.polarTraj(:,iframe,1);
        rad = dpTemp.polarTraj(:,iframe,2);
        
        theta(isnan(theta)) = [];
        avgTheta(i,icond) = avgfun(theta);
        avgR(i,icond) = avgfunR(rad);
        
                subplot(nr,nc,i)
        switch param
            case 'theta'
                if 1
                    circ_plot(theta,'pretty',cond(icond).style,true,'linewidth',2,'color',cond(icond).color); hold on
                else
                    t = unwrap(theta);
                    [a x] = hist(t,bin);
                    a = a/sum(a);
                    stairs(x,a,'color',cond(icond).color);hold on;
                    yl = ylim;
                    line([1 1].*mean(t),yl,'color',cond(icond).color,'linewidth',3)
                end
                
                param_all{icond,i} = theta;
            case 'r'
                
                [a x] = hist(rad,bin);
                a = a/sum(a);
                stairs(x,a,'color',cond(icond).color);hold on;
                yl = ylim;
                line([1 1].*mean( avgR(i,icond) ),yl,'color',cond(icond).color,'linewidth',3)
                
                param_all{icond,i} = rad;
                
        end
        
    end
    
    
    s = '';
    if bIntervalGTX, s = '>='; end
    
    pval = statfun( param_all{1,i},param_all{2,i});
    title([ 'Intv' s num2str(thisInterval*dpC2.Scaling/1000,'%1.1f') 's' ' p = ' num2str(pval,'%1.2g')])
    
    tim(i) = thisTime;
end

for icond = 1 : length(cond)
subplot(1,3,2)
    t = unwrap(avgTheta(:,icond));
    line(tim, t,'color',cond(icond).color);
    title('theta')

subplot(1,3,3)
    line(tim, avgR(:,icond),'color',cond(icond).color);hold on;
    title('r')

end

plotAnn([savenameheader ' ' savename ' ' dpC2.FileName],gcf)

if bsave
    try
        if ~isempty(hfig.h)
            patht = fullfile(r.Dir.SummaryFig,'TrajectoryTheta',dpC2.Animal,dpC2.Date);
            parentfolder(patht,1);
            export_fig(hfig.h, fullfile(patht, [savenameheader '_' dpC2.FileName '_' savename]),'-pdf','-transparent');
        end
    catch ME
        getReport(ME)
    end
end
%%
r = brigdefs;


bIntervalGTX = 0;
      savenameheader = 'StimUnStimCorrectVsError';
    cond(1).name = 'StimCorrect' ;
    cond(1).color = [0 0 1];
    cond(1).filter = {'ChoiceCorrect',1,'stimulationOnCond',@(x) x~=0};
    cond(1).offset = 0 ;
    cond(1).style = 'ob';
    cond(2).name = 'StimError' ;
    cond(2).color = [0 0 0];
    cond(2).style = 'ok';
    cond(2).filter = {'ChoiceCorrect',0,'stimulationOnCond',@(x) x~=0};
    cond(2).offset = 0 ;

        cond(3).name = 'Correct' ;
    cond(3).color = [0 1 0];
    cond(3).filter = {'ChoiceCorrect',1,'stimulationOnCond',0};
    cond(3).offset = 0 ;
    cond(3).style = 'og';
    cond(4).name = 'Error' ;
    cond(4).color = [1 0 0];
    cond(4).style = 'or';
    cond(4).filter = {'ChoiceCorrect',0,'stimulationOnCond',0};
    cond(4).offset = 0 ;

    
    bIntervalGTX = 0;
      savenameheader = 'CorrectVsError';
    cond(1).name = 'Correct' ;
    cond(1).color = [0 1 0];
    cond(1).filter = {'ChoiceCorrect',1};
    cond(1).offset = 0 ;
    cond(1).style = 'og';
    cond(2).name = 'Error' ;
    cond(2).color = [1 0 0];
    cond(2).style = 'or';
    cond(2).filter = {'ChoiceCorrect',0};
    cond(2).offset = 0 ;

 bIntervalGTX = 0;
savenameheader = 'StimVsCtrl';
cond(1).name = 'Ctrl' ;
cond(1).color = [0 0 0];
    cond(1).style = 'ok';
cond(1).filter = {'stimulationOnCond',0};
cond(1).offset = 0 ;
cond(2).name = 'Stim' ;
cond(2).color = [0 0 1];
    cond(2).style = 'ob';
cond(2).filter = {'stimulationOnCond',@(x) x~=0};
cond(2).offset = 0 ;


savenameheader = 'StimCorrectVsCtrlCorrect';
bIntervalGTX = 0;
cond(1).name = 'Ctrl' ;
cond(1).color = [0 0 0];
cond(1).style = 'ok';
cond(1).filter = {'stimulationOnCond',0,'ChoiceCorrect',1};
cond(1).offset = 0 ;
cond(2).name = 'Stim' ;
cond(2).color = [0 0 1];
cond(2).style = 'ob';
cond(2).filter = {'stimulationOnCond',@(x) x~=0,'ChoiceCorrect',1};
cond(2).offset = 0 ;

savenameheader = 'StimErrorVsCtrlError';
bIntervalGTX = 0;
cond(1).name = 'Ctrl' ;
cond(1).color = [0 0 0];
cond(1).style = 'ok';
cond(1).filter = {'stimulationOnCond',0,'ChoiceCorrect',0};
cond(1).offset = 0 ;
cond(2).name = 'Stim' ;
cond(2).color = [0 0 1];
cond(2).style = 'ob';
cond(2).filter = {'stimulationOnCond',@(x) x~=0,'ChoiceCorrect',0};
cond(2).offset = 0 ;

savenameheader = 'StimErrorVsCorrect';
bIntervalGTX = 0;
cond(1).name = 'CorrectStim' ;
cond(1).color = [0 1 0];
cond(1).style = 'og';
cond(1).filter = {'stimulationOnCond',@(x) x~=0,'ChoiceCorrect',1};
cond(1).offset = 0 ;
cond(2).name = 'ErrorStim' ;
cond(2).color = [1 0 0];
cond(2).style = 'or';
cond(2).filter = {'stimulationOnCond',@(x) x~=0,'ChoiceCorrect',0};
cond(2).offset = 0 ;

% % %
% % savename = ['_TrajTheta_ByInterval' source];
% % 
% % radOffset = 0; % just for visualization
% % % dpC2.polarTrajTone2(1,:)  = dpC2.polarTrajTone2(1,:) - nanmean(dpC2.polarTrajTone2(1,:)  );
% % avgfun = @circ_median;
% % statfun = @circ_wwtest;
% % nboot = 1;
% % 
% % hfig.h = figure('Name',savenameheader,'NumberTitle','off');clf;
% % intervalSet = dpC2.IntervalSet;
% % nc = length(intervalSet)/2;
% % nr = 2;
% % 
% % for iIntv = 1:length(intervalSet)
% %     for icond = 1 : length(cond)
% %         thisInterval = intervalSet(iIntv);
% %         
% %         if bIntervalGTX
% %             intervalCond.filter = {'Interval', @(x) x>=thisInterval*0.99};
% %         else
% %             intervalCond.filter = {'Interval', thisInterval};
% %         end
% %         thisfilter ={cond(icond).filter{:} intervalCond.filter{:}}; % add the interval filter
% %         
% %         tempdp= filtbdata(dpC2,0,thisfilter);
% %         
% %         hfig.hsp(iIntv) = subplot(nr,nc,iIntv);
% %         
% %         thet{icond} = tempdp.polarTrajTone2(:,1)+radOffset;
% %         thet{icond}(isnan( thet{icond})) = [];
% %         
% %         if 0
% %             [a x] = hist( rad2deg(thet{icond}),bin);
% %             a = a/sum(a);
% %             h(iIntv,icond) = stairs(x,a,'color',cond(icond).color); hold on;
% %         else
% %             circ_plot(thet{icond},'pretty',cond(icond).style,true,'linewidth',2,'color',cond(icond).color); hold on
% %         end
% %         
% %         %         avg = avgfun(thet{icond});
% %         %
% %         %         hfig.hsp(iIntv) = subplot(nr,nc,length(intervalSet)+iIntv);
% %         %         hpol = polar(thet{icond},ones(size(thet{icond}))); hold on;
% %         %         set(hpol,'LineStyle','none','Marker','o','color',cond(icond).color);
% %         %
% %         %         hpolavg = polar(avg,1); hold on;
% %         %         set(hpolavg,'LineStyle','none','Marker','*','MarkerSize',30,'color',cond(icond).color);
% %         %
% %         
% %     end
% %     s = '';
% %     if bIntervalGTX, s = '>='; end
% %     
% %     pval = statfun( thet{1},thet{2});
% %     title([ 'Intv' s num2str(thisInterval*dpC2.Scaling/1000,'%1.1f') 's' ' p = ' num2str(pval,'%1.2g')])
% % end
% % 
% % plotAnn([savenameheader ' ' savename ' ' dpC2.FileName],hfig.h,1)
% % 
% % try
% %     if ~isempty(hfig.h)
% %         patht = fullfile(r.Dir.SummaryFig,'TrajectoryTheta',dpC2.Animal,dpC2.Date);
% %         parentfolder(patht,1);
% %         export_fig(hfig.h, fullfile(patht, [savenameheader '_' dpC2.FileName '_' savename]),'-pdf','-transparent');
% %     end
% % catch ME
% %     getReport(ME)
% % end