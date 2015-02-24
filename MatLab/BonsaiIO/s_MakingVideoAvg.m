function s_MakingVideoAvg(dp,param)
% When does the trajectory change?
% param.scorrect1 = 0
% param.scorrect2 = 0
% param.sstim1 = 0
% param.sstim2 = 1
% param.alignfield = 'pokeIn_fr'; % alignfield = 'secondStim_fr';
%%
% defaults
bVideo = 1; % set to 0 to only create trajactors
trajSource = 'cm'; % 'extremeNose'
scorrect1 = 0;
scorrect2 = 0;
sstim1 = 0;
sstim2 = 1;
sinterval1 = dp.IntervalSet;
sinterval2 = dp.IntervalSet;
alignfield = 'pokeIn_fr';

if exist('param','var')
    scorrect1 = param.scorrect1;
    scorrect2 =param.scorrect2;
    sstim1 = param.sstim1;
    sstim2= param.sstim2;
   
    if isfield(param,'sinterval1')
        sinterval1 = param.sinterval1;
    end
    if isfield(param,'sinterval2')
        sinterval1 = param.sinterval1;
    end
    if isfield(param,'alignfield')
        alignfield = param.alignfield;
    end
    %     sinterval1 = param.sinterval1;
    %     sinterval2 = param.sinterval2;
end

if sstim1==sstim2
    mycolor = {'g','r'};
else
    mycolor = {'k','b'};
end
r = brigdefs();


for iIntv = 1:  length(dp.IntervalSet)
    sinterval1 = dp.IntervalSet(iIntv);
    sinterval2 = dp.IntervalSet(iIntv);
    nframes = round(sinterval2*dp.Scaling/1000*round(dp.video.info.meanFrameRate));

    dp1 = filtbdata(dp,0,{'ChoiceCorrect',scorrect1,'stimulationOnCond',sstim1,'Interval',sinterval1});
    dp2 = filtbdata(dp,0,{'ChoiceCorrect',scorrect2,'stimulationOnCond',sstim2,'Interval',sinterval2});
    if dp1.ntrials <= 0 || dp2.ntrials <=0
        disp(['No Trials for ' num2str(sinterval1)]);
    else
        if bVideo
            bonsaiFileName = getBonsaiFileForAverages(dp1,dp2,dp1.Animal,alignfield,['Correct' num2str(scorrect1,'%d_') '_Stim' num2str(sstim1,'%d_') '_Interval' num2str(sinterval1,'%1.2f_')],...
                ['Correct' num2str(scorrect2,'%d_') '_Stim' num2str(sstim2,'%d_') '_Interval' num2str(sinterval2,'%1.2f_')],17,nframes);
            
            init_PID = getPID('Bonsai.Editor.exe');
            createBatBonsaiFile(bonsaiFileName,1,1,1);
        end
        
%         helperMakingVideoAvgTraj
        
        if bVideo
            pause(3); % wait for process to be spawned
            new_PID = getPID('Bonsai.Editor.exe');
            PID = new_PID(~ismember(new_PID,init_PID));
           bwait = 1;
           while getcpuusage(PID) > 1
               pause(1);
              disp(['waiting2 ' num2str(iIntv) ' ' num2str(getcpuusage(PID))])
% 
           end
           pause(2);
           killPID(PID);
        end
        %     pause(5); % ADD KILL PROCESS
        
    end
    
    
    
    end
%  bwait = 1;
%             while (bwait) % wait to start (when performing averages Memory usage goes above 1GB when loading the file and then back down when done)
%                 pause(1);
%                 [now_PID new_MEMUSAGE] = getPID('Bonsai.Editor.exe');
%                 %             new_MEMUSAGE(now_PID==PID)
%                 if isempty(new_MEMUSAGE(now_PID==PID))
%                     bwait = 0;
%                     disp('Process GONE')
%                     break;
%                 else
%                     disp(['waiting ' num2str(iIntv) ' ' num2str(new_MEMUSAGE(now_PID==PID))])
%                 end
%                 if(new_MEMUSAGE(now_PID==PID)>1000000)
%                     bwait = 0;
%                 end
%             end
%             pause(3); % wait for process to be spawned
%             bwait = 1;
%             while (bwait) % wait to end
%                 pause(1);
%                 [now_PID new_MEMUSAGE] = getPID('Bonsai.Editor.exe');
%                 %             new_MEMUSAGE(now_PID==PID)
%                 if isempty(new_MEMUSAGE(now_PID==PID))
%                     bwait = 0;
%                     disp('Process GONE')
%                     break;
%                 else
%                     disp(['waiting2 ' num2str(iIntv) ' ' num2str(new_MEMUSAGE(now_PID==PID))])
%                 end
%                 
%                 if(new_MEMUSAGE(now_PID==PID)<1000000)
%                     bwait = 0;
%                     disp('DONE')
%                 end
%             end
%         end
% % 
%     function helperMakingVideoAvgTraj
%         savename = [dp1.Animal '_' dp.Date '_Correct' num2str(scorrect1,'%d_') '_Stim' num2str(sstim1,'%d_') '_Interval' num2str(sinterval1,'%1.2f_')...
%             'Correct' num2str(scorrect2,'%d_') '_Stim' num2str(sstim2,'%d_') '_Interval' num2str(sinterval2,'%1.2f_')];
%         
%         hf = figure('Position', [680    49   708   948]);clf;
%         hAx = plot_traj(dp1,dp2,trajSource,(sinterval1*dp1.Scaling/1000+1)*dp1.video.info.meanFrameRate,mycolor,savename);
%         for iAx = 1:3
%             yl = get(hAx(iAx),'ylim');
%             xval = sinterval1*dp1.Scaling/1000;
%             line([1 1].*sinterval1*dp1.Scaling/1000,yl,'color','k','linewidth',1,'Parent',hAx(iAx))
%             text([1].*sinterval1*dp1.Scaling/1000,yl(2),num2str(sinterval2),'Parent',hAx(iAx),'rotation',90)
%         end
%         
%         
%         if 1
%             savepath = fullfile(r.Dir.Extremum,dp1.Animal);
%             parentfolder(savepath,1)
%             saveas(gcf, fullfile(savepath, [savename '.pdf']));
%             saveas(gcf, fullfile(savepath, [savename '.fig']));
%         end
%     end
end
