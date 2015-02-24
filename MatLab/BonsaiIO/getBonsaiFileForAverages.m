function bonsaiFileName = getBonsaiFileForAverages(dp1,dp2,averageFilename,field,filter1,filter2,threshold,framesDisp)
% function bonsaiFileName = getBonsaiFileForAverages(dp1,dp2,averageFilename,field,filter1,filter2,threshold)
% threshold intensity is optional

%field should be a field in dp.video
rd = brigdefs();

if ~exist('threshold','var')
    switch(str2double(dp1.Box))
        case 3
            threshold = 120;
        case 4
            threshold = 166;
        otherwise
            threshold = 100;
            display(['Box UNKNOWN threshold set to: ' num2str(threshold)])
    end
end
if ~exist('framesDisp','var')
    framesDisp = 480;
end
if isfield(dp2.video,'nframesInAvi')
    if ~isempty(dp2.video.nframesInAvi)
        dp2.video.nframesInAvi = dp2.video.nframesInAvi - framesDisp; % make sure that the enough frames exist to make the average
    end
end
if isfield(dp1.video,'nframesInAvi')
    if ~isempty(dp1.video.nframesInAvi)
        dp1.video.nframesInAvi = dp1.video.nframesInAvi - framesDisp; % make sure that the enough frames exist to make the average
    end
end
% check if frames is okay
if dp1.video.info.medianFrameRate*5 < framesDisp
    warning('average probably will not work asking for too many frames');
end

bonsaiTemplateFilePath = fullfile(rd.Dir.BonsaiCode, 'TEMPLATE_test_color_average_crop_colors_2.bonsai');

% create CSV files with timestamps
fullfilename1 = createTimestampCSV(dp1,field,filter1);
fullfilename2 = createTimestampCSV(dp2,field,filter2);

[FullPathVideo, PathNameVideo] = selectVideo(dp1); % note video for both dps must be the same

path = fullfile(PathNameVideo,'Averages',dp1.Date);
parentfolder(path,1);

saveAviFile = fullfile(path,[averageFilename '_' field '_' filter1 '_' filter2 '.avi']);
patht = fullfile(rd.Dir.BonsaiCode, 'Generated');
parentfolder(patht,1);
bonsaiFileName = fullfile(patht,['color_average_' field '_' filter1 '_' filter2 '.bonsai']);


createBonsaiAverageFile(bonsaiTemplateFilePath,bonsaiFileName,FullPathVideo,saveAviFile,fullfilename1,fullfilename2,threshold,framesDisp);

% copy the timestamps file the same directory and same name (Necessary for
% bonsai)
[~, fname, ~] = fileparts(dp1.FileName);
filein = fullfile(rd.Dir.DataBonsaiVideo,dp1.Animal,[fname '_vid_time.csv']);
[fpath, fname, ~] = fileparts(FullPathVideo);
copyfile(filein,fullfile(fpath,[fname '.csv']));

% copy the bonsai layout file 
copyfile([bonsaiTemplateFilePath '.layout'],[bonsaiFileName '.layout']);

end
