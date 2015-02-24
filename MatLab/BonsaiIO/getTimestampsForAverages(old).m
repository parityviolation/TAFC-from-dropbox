function getTimestampsForAverages (dataParsed)
% function getTimestampsForAverages (dataParsed)
% makes csv files with timestamps
%

rd = brigdefs();

% read file with timestamps for each video frame
[junk fname junk] = fileparts(dataParsed.FileName);
 
f = fopen(fullfile(rd.Dir.DataBonsaiVideo,dataParsed.Animal,[fname '_vid_time.csv']));
a = textscan(f,'%s');
fclose(f);

fmTimes = a{:};

pokeInFrames = dataParsed.video.pokeIn_fr;
% secondStimFrames = dataParsed.video.secondStim_fr;
% choiceFrames = dataParsed.video.choice_fr;
stimOnFrames = dataParsed.video.stimOn_fr;
    
pokeInTimes = fmTimes(pokeInFrames(~isnan(pokeInFrames)));
stimOnTimes = fmTimes(pokeInFrames(~isnan(stimOnFrames)));
 
% secondStimTimes = fmTimes(secondStimFrames);
% choiceTimes = fmTimes(choiceFrames);
% 
% secondStimTimes(secondStimFrames==fmTimes(1))=NaN;
% choiceFrames(choiceFrames==1)=NaN;

pokeInTimes = cell2mat(pokeInTimes);
stimOnTimes = cell2mat(stimOnTimes);

% secondStimTimes = cell2mat(secondStimTimes);
% choiceTimes = cell2mat(choiceTimes);
% 
% secondStimTimes2(secondStimTimes==cell2mat(fmTimes(1)))=NaN;
%outputstring = [pokeInTimes'; repmat('\n',size(pokeInTimes,1),1)'];
outputstringPokeIn = pokeInTimes';
outputstringStimOn = stimOnTimes';
% outputstringSecondStim = secondStimTimes';
% outputstringChoice = choiceTimes';

f = fopen(fullfile(rd.Dir.DataBonsaiVideo,dataParsed.Animal,[fname '_pokeIn_times.csv']),'wt');
j = fopen(fullfile(rd.Dir.DataBonsaiVideo,dataParsed.Animal,[fname '_stimOn_times.csv']),'wt');
% g = fopen(fullfile(rd.Dir.DataBonsaiVideo,dataParsed.mouseName,[fname '_secondStim_times.csv']),'wt');
% h = fopen(fullfile(rd.Dir.DataBonsaiVideo,dataParsed.mouseName,[fname '_choice_times.csv']),'wt');

for i = 1:size(outputstringPokeIn,2)    
fprintf(f,'%s\n',outputstringPokeIn(:,i));
% fprintf(g,'%s\n',outputstringSecondStim(:,i));
% fprintf(h,'%s\n',outputstringChoice(:,i));

end
fclose(f)

for i = 1:size(outputstringStimOn,2)    
fprintf(j,'%s\n',outputstringStimOn(:,i));
% fprintf(g,'%s\n',outputstringSecondStim(:,i));
% fprintf(h,'%s\n',outputstringChoice(:,i));

end
fclose(j)

cond(1).val = dataParsed.computed.cond(1).val;
cond(2).val = dataParsed.computed.cond(2).val;
cond(4).val = dataParsed.computed.cond(4).val;

frames_parsed_ind = dataParsed.computed.frames_parsed_ind;

for ival0 = 1:length(cond(4).val) 
    for ival1 = 1:length(cond(1).val)
        for ival2 = 1:length(cond(2).val)
            if ival0==1
                frames_parsed_ind1 = find(isnan(dataParsed.stimulationOnCond));
                frames_parsed_ind1 = ismember(frames_parsed_ind(:,ival2,ival1),frames_parsed_ind1);
                frames_parsed_ind2 = ~isnan(frames_parsed_ind(frames_parsed_ind1,ival2,ival1));
                frames_parsed_ind3 = frames_parsed_ind(frames_parsed_ind2,ival2,ival1);
                pokeInTimesParsed = pokeInTimes(frames_parsed_ind3,:);
                outputstringPokeInParsed = pokeInTimesParsed';
                
                f = fopen(fullfile(rd.Dir.DataBonsaiVideo,dataParsed.Animal,[fname '_' num2str(cond(1).val(ival1)) '_' num2str(cond(2).val(ival2)) '_' num2str(cond(4).val(ival0)) '_pokeIn_times.csv']),'wt');
                for i = 1:size(outputstringPokeInParsed,2)
                    fprintf(f,'%s\n',outputstringPokeInParsed(:,i));
                end
                
                fclose(f)
                
            else
                
                frames_parsed_ind1 = find(~isnan(dataParsed.stimulationOnCond));
                frames_parsed_ind1 = ismember(frames_parsed_ind(:,ival2,ival1),frames_parsed_ind1);
                frames_parsed_ind2 = ~isnan(frames_parsed_ind(frames_parsed_ind1,ival2,ival1));
                frames_parsed_ind3 = frames_parsed_ind(frames_parsed_ind2,ival2,ival1);
                pokeInTimesParsed = pokeInTimes(frames_parsed_ind3,:);
                outputstringPokeInParsed = pokeInTimesParsed';
                
                f = fopen(fullfile(rd.Dir.DataBonsaiVideo,dataParsed.Animal,[fname '_' num2str(cond(1).val(ival1)) '_' num2str(cond(2).val(ival2)) '_' num2str(cond(4).val(ival0)) '_pokeIn_times.csv']),'wt');
                for i = 1:size(outputstringPokeInParsed,2)
                    fprintf(f,'%s\n',outputstringPokeInParsed(:,i));
                end
                
                fclose(f)
                
            end
        end
    end
    
end
