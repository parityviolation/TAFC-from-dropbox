% rd = brigdefs();
% %dp = builddp(1,0);
% dp = loadbstruct();
% %%
% 
% 
% alignCond = 'pokeIn_fr';
% interval = 0.8;
% choice_correct = 1;
% stim_on = 0;
% %desc = [num2str(interval), '_Learning'];
% desc = 'all'
% dp1=dp;
% %dp1 = filtbdata(dp,0,{'Interval',interval,'ChoiceCorrect',choice_correct,'stimulationOnCond',stim_on});
% pokeIn_fr = dp1.video.pokeIn_fr;
% 
% frame_rate = round(dp.video.info.medianFrameRate);
% framesBefore = 0;
% framesAfter = round(frame_rate*interval*dp.Scaling/1000);
% 
% start_fr = pokeIn_fr-framesBefore;
% end_fr = start_fr + framesAfter;
% 
% [~,fname,~] = fileparts(dp.FileName);
% 
% f = fopen(fullfile(rd.Dir.DataBonsaiVideo,dp.Animal,[fname '_vid_time.csv']));
% a = textscan(f,'%s');
% fclose(f);
% 
% fmTimes = a{:};
% 
% startTimes = fmTimes(start_fr(~isnan(start_fr)));
% 
% endTimes = fmTimes(end_fr(~isnan(end_fr)));
% 
% startTimes = cell2mat(startTimes);
% endTimes = cell2mat(endTimes);
% 
% [m n] = size(startTimes);
% WindowOpening = repmat(' WindowOpening', m, 1);
% [m n] = size(endTimes);
% WindowClosing = repmat(' WindowClosing', m, 1);
% 
% startTimestamp = [startTimes(1:end,:) WindowOpening];
% endTimestamp = [endTimes(1:end,:) WindowClosing];
% 
% outputstringStart = startTimestamp';
% outputstringEnd = endTimestamp';
% 
% fullfilename = fullfile(rd.Dir.DataBonsaiVideo,dp.Animal,[fname '_' alignCond '_'  desc '.csv']);
% 
% f = fopen(fullfilename,'wt');
% 
% for i = 1:(size(outputstringStart,2))
%     fprintf(f,'%s\n',outputstringStart(:,i));
%     fprintf(f,'%s\n',outputstringEnd(:,i));
% end
% fclose(f);

%%
text_dur = 20;%in frames
choice_txt_dur = 200; %in frmaes

trial_start = 38;
trial_end = 45;
frame_start = dp.video.pokeIn_fr(trial_start);
poke_in_text = [];
trial_avail_text = [];
second_stim_text = [];
stim_short_to_choice_correct_r = [];
stim_short_to_choice_correct_l = [];
stim_short_to_choice_incorrect_r = [];
stim_short_to_choice_incorrect_l = [];
stim_long_to_choice_correct_r = [];
stim_long_to_choice_correct_l = [];
stim_long_to_choice_incorrect_r = [];
stim_long_to_choice_incorrect_l = [];


for i= trial_start:trial_end
    current_trial_avail = dp.video.TrialAvail_fr(i)-frame_start+1;
    current_poke = dp.video.pokeIn_fr(i)-frame_start+1;
    current_second_stim = dp.video.secondStim_fr(i)-frame_start+1;
    current_choice = dp.video.choice_fr(i)-frame_start+1;
    
    trial_avail_text = [trial_avail_text current_trial_avail:current_poke];   
    
    poke_in_text = [poke_in_text current_poke:current_poke+text_dur];
    
    if dp.Premature(i)==0
        
        second_stim_text = [second_stim_text current_second_stim:current_second_stim+text_dur];
        
        if dp.ChoiceLeft(i)==0 & dp.ChoiceCorrect(i)==1
            
            stim_short_to_choice_correct_r = [stim_short_to_choice_correct_r current_second_stim:current_choice+choice_txt_dur];
            stim_short_to_choice_correct_l = [stim_short_to_choice_correct_l current_second_stim:current_choice];
            
        elseif dp.ChoiceLeft(i)==0 & dp.ChoiceCorrect(i)==0
            
            stim_short_to_choice_incorrect_r = [stim_short_to_choice_incorrect_r current_second_stim:current_choice];
            stim_short_to_choice_incorrect_l = [stim_short_to_choice_incorrect_l current_second_stim:current_choice+choice_txt_dur];
            
        elseif dp.ChoiceLeft(i)==1 & dp.ChoiceCorrect(i)==1
            
            stim_long_to_choice_correct_r = [stim_long_to_choice_correct_r current_second_stim:current_choice];
            stim_long_to_choice_correct_l = [stim_long_to_choice_correct_l current_second_stim:current_choice+choice_txt_dur];
            
        elseif dp.ChoiceLeft(i)==1 & dp.ChoiceCorrect(i)==0
            
            stim_long_to_choice_incorrect_r = [stim_long_to_choice_incorrect_r current_second_stim:current_choice+choice_txt_dur];
            stim_long_to_choice_incorrect_l = [stim_long_to_choice_incorrect_l current_second_stim:current_choice];
            
        end
    end
end

fullfilename = fullfile(rd.Dir.DataBonsaiVideo,dp.Animal,'trialavail.txt');
dlmwrite(fullfilename,trial_avail_text,'\n')

fullfilename = fullfile(rd.Dir.DataBonsaiVideo,dp.Animal,'1sttone.txt');
dlmwrite(fullfilename,poke_in_text,'\n')

fullfilename = fullfile(rd.Dir.DataBonsaiVideo,dp.Animal,'2ndtone.txt');
dlmwrite(fullfilename,second_stim_text,'\n')

fullfilename = fullfile(rd.Dir.DataBonsaiVideo,dp.Animal,'sh_c_r.txt');
dlmwrite(fullfilename,stim_short_to_choice_correct_r,'\n')

fullfilename = fullfile(rd.Dir.DataBonsaiVideo,dp.Animal,'sh_c_l.txt');
dlmwrite(fullfilename,stim_short_to_choice_correct_l,'\n')

fullfilename = fullfile(rd.Dir.DataBonsaiVideo,dp.Animal,'sh_i_r.txt');
dlmwrite(fullfilename,stim_short_to_choice_incorrect_r,'\n')

fullfilename = fullfile(rd.Dir.DataBonsaiVideo,dp.Animal,'sh_i_l.txt');
dlmwrite(fullfilename,stim_short_to_choice_incorrect_l,'\n')

fullfilename = fullfile(rd.Dir.DataBonsaiVideo,dp.Animal,'lg_c_r.txt');
dlmwrite(fullfilename,stim_long_to_choice_correct_r,'\n')

fullfilename = fullfile(rd.Dir.DataBonsaiVideo,dp.Animal,'lg_c_l.txt');
dlmwrite(fullfilename,stim_long_to_choice_correct_l,'\n')

fullfilename = fullfile(rd.Dir.DataBonsaiVideo,dp.Animal,'lg_i_r.txt');
dlmwrite(fullfilename,stim_long_to_choice_incorrect_r,'\n')

fullfilename = fullfile(rd.Dir.DataBonsaiVideo,dp.Animal,'lg_i_l.txt');
dlmwrite(fullfilename,stim_long_to_choice_incorrect_l,'\n')











% f = fopen(fullfilename,'wt');
% fprintf(f,'\n',poke_in_text(:,i));
% % for i = 1:(size(poke_in_text,2))
% %     fprintf(f,'%s\n',poke_in_text(:,i));
% % end
% fclose(f);
%%
% bonsaiTemplateFilePath = fullfile(rd.Dir.BonsaiCode, 'Template_clip_recorder.bonsai');
% [FullPathVideo, PathNameVideo] = selectVideo(dp); % note video for both dps must be the same
% 
% path = fullfile(PathNameVideo,'Learning for Bass',dp.Date);
% parentfolder(path,1);
% 
% bonsaiFileName = fullfile(rd.Dir.BonsaiCode,'Generated',[ 'clip_recorder' datestr(now,'dSSFFF') '.bonsai']);
% 
% createBonsaiClipperFile(bonsaiTemplateFilePath,bonsaiFileName,FullPathVideo,fullfilename,path)
% 
% % copy the timestamps file the same directory and same name (Necessary for
% % bonsai)
% [~, fname, ~] = fileparts(dp.FileName);
% filein = fullfile(rd.Dir.DataBonsaiVideo,dp.Animal,[fname '_vid_time.csv']);
% [fpath, fname, ~] = fileparts(FullPathVideo);
% copyfile(filein,fullfile(fpath,[fname '.csv']));
% 
% createBatBonsaiFile(bonsaiFileName,1,1);
