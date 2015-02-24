function dataParsed = addExtremes(dataParsed)
% function dataParsed = addExtremes(dataParsed)
% This function gets the xy coordinates of 2 extremes (aproximation of nose position and "tail") extracted from the video for each frame in the video file
%it also tries to correct for switches in extremes and returns
%dataParsed.video.extremes, a 3D matrix: [trials, number of frames displayed,
%xExtr1 yExtr1 xExtr2 yExtr2] and also outputs
%dataParsed.video.extremesFrames, a 2D matrix: [trials, frame numbers]
bdebug =0;

rd = brigdefs();
% read file with coordinates xy xy for item 1 and 2 in each frame
[junk fname junk] = fileparts(dataParsed.FileName);

filein = fullfile(rd.Dir.DataBonsai,dataParsed.Animal,[fname '_tracking.csv']);
if ~exist(filein,'file')
    dataParsed.video.extremes.xyParsed = NaN;
    dataParsed.video.extremes.xy = NaN;
    dataParsed.video.extremes.speed = NaN;
    dataParsed.video.extremes.framesParsed = NaN;
    disp([filein ' does not exist'])
    disp('*** NO: Position of Extremum ');
    
else
    %open csv file with 4 columns, representing x and y coordinates of 2 extreme points (item1 and item2) taken from the largest region tracked in bonsai
    %[item 1x item1y item2x item2y]
    raw_coordinates = dlmread(filein,' ');
    %raw_coordinates = dlmread('C:\Users\Bassam\Dropbox\TAFCmice\Data\SS\Bonsai\BII\BII_TAFCv06_130227_SSAB_tracking.csv');
    
    
    %maximum number of frames to display
    max_frames_disp = 2000;
    
    %minimum change in distance within consecutive frames to
    thres = 120;
    
    %create your trajectories vector for x y coordinates of both items parsed
    %by trials
    
    dataParsed.video.extremes = nan(dataParsed.ntrials,max_frames_disp,4);
    extremesFrames = nan(dataParsed.ntrials,max_frames_disp);
    xy_positions = raw_coordinates(:,1:4);
    xy_positionsParsed = dataParsed.video.extremes;
    xy_positionsParsed2 = dataParsed.video.extremes;
    dataParsed.video.extremes.xy = nan(size(xy_positions));
    pokeIn_fr = dataParsed.video.pokeIn_fr;
    
    ind_jump = [];
    
    for i = 1:dataParsed.ntrials
        if pokeIn_fr(i)+max_frames_disp<length(xy_positions)
            % trials,frames,xyxy
            xy_positionsParsed(i,:,:)=[xy_positions(pokeIn_fr(i):pokeIn_fr(i)+(max_frames_disp-1),:)];
            extremesFrames(i,:) = pokeIn_fr(i):pokeIn_fr(i)+(max_frames_disp-1);
            
            
            % detect when the extremes switch sides
            if 1
                dposition = diff(squeeze(xy_positionsParsed(i,:,:)));
                xdposition = abs(dposition(:,2)); % only X distance as a threshold but then the total distance as a criteria for it really being a switch
                ind_potential_jump = find(xdposition>thres)+1;
                dposition = sqrt(dposition(:,1).^2+(dposition(:,2).^2));
                
                %                 difference between extremes
                ind_jump = [];
                if ~isempty(ind_potential_jump)
                    dimen = 1;
                    if length(ind_potential_jump)>1
                        dimen = 2;
                    end
                    d2 = sqrt(sum(squeeze(xy_positionsParsed(i,ind_potential_jump,[3,4])-xy_positionsParsed(i,ind_potential_jump-1,[1,2])).^2,dimen));
                    %                     d2 =squeeze(abs(xy_positionsParsed(i,ind_potential_jump,[4])-xy_positionsParsed(i,ind_potential_jump-1,[2]))); % only X distance
                    ind_jump =  ind_potential_jump(d2(:)< dposition(ind_potential_jump-1));
                    
                end
            else % old version
                dposition = diff(squeeze(xy_positionsParsed(i,:,:)));
                dposition = sqrt(dposition(:,1).^2+(dposition(:,2).^2));
                ind_jump = find(dposition>thres(1))+1;
            end
            xy_positionsParsed2(i,:,:) = xy_positionsParsed(i,:,:);
            
            if ~isempty(ind_jump)
                for j = 1:2:length(ind_jump) % only correct every odd flip because even flips are back to the original correct position
                    if j+1>length(ind_jump)
                        xy_positionsParsed2(i,ind_jump(j):max_frames_disp,[3,4,1,2])  = xy_positionsParsed(i,ind_jump(j):max_frames_disp,:);
                    else
                        xy_positionsParsed2(i,ind_jump(j):ind_jump(j+1)-1,[3,4,1,2])  = xy_positionsParsed(i,ind_jump(j):ind_jump(j+1)-1,:);
                    end
                end
            end
            
            
            if bdebug
                subplot(3,1,1);cla;
                plot( xy_positionsParsed(i,:,2),xy_positionsParsed(i,:,1)); hold on
                plot( xy_positionsParsed(i,:,4),xy_positionsParsed(i,:,3),'r'); hold on
                plot(xy_positionsParsed(i,ind_potential_jump,2),xy_positionsParsed(i,ind_potential_jump,1),'.g')
                plot(xy_positionsParsed(i,ind_potential_jump,4),xy_positionsParsed(i,ind_potential_jump,3),'.g')
                plot(xy_positionsParsed(i,ind_jump,2),xy_positionsParsed(i,ind_jump,1),'.r')
                plot(xy_positionsParsed(i,ind_jump,4),xy_positionsParsed(i,ind_jump,3),'.k')
                plot( xy_positionsParsed2(i,:,2),xy_positionsParsed2(i,:,1),'k'); hold on
                subplot(3,1,2);cla;
                plot(xy_positionsParsed(i,:,2),'b'); hold on
                plot(xy_positionsParsed(i,:,4),'r')
                plot(ind_potential_jump,xy_positionsParsed(i,ind_potential_jump,2),'.g')
                plot(ind_jump,xy_positionsParsed(i,ind_jump,2),'.r')
                
                plot(xy_positionsParsed2(i,:,2),'k')
                subplot(3,1,3);cla;
                plot(xy_positionsParsed(i,:,1),'b'); hold on
                plot(xy_positionsParsed(i,:,3),'r')
                plot(xy_positionsParsed2(i,:,1),'k')
                
                
                
            end
            
            % put xy_positionsParsed back into the unparsed sequence
            dataParsed.video.extremes.xy(pokeIn_fr(i):pokeIn_fr(i)+(max_frames_disp-1),:) = squeeze(xy_positionsParsed2(i,:,:));
        end
    end
    dataParsed.video.extremes.noseSpeed = [sqrt(sum(diff(squeeze(dataParsed.video.extremes.xy(:,[1 2])))'.^2)) NaN]';
    dataParsed.video.extremes.xyParsedraw = xy_positionsParsed2;
    dataParsed.video.extremes.xyParsed = xy_positionsParsed2 - repmat( nanmedian(xy_positionsParsed2(:,1,:)),[size(xy_positionsParsed2,1),size(xy_positionsParsed2,2),1]);
    dataParsed.video.extremes.framesParsed = extremesFrames;
    
end

