function getBonsaiExtremes(dpArray,bonsaiParams)%%( bstruct,bonsaiFileName)

% BA
% this function runs a Bonsai Workflow to extract LargestBinaryRegion
% Extremes, CMxy CM orientation for each of dpArray
% bonsaiParams contains the thresholding params for each dp of dpArray

for idp = 1: length(dpArray)
    
    disp([num2str(idp) ' Extremes for ' dpArray(idp).FileName]);
    init_PID = getPID('Bonsai.Editor.exe');
    bonsaiFileName=  createBonsaiFileHelper(dpArray(idp),bonsaiParams(idp));
    createBatBonsaiFile(bonsaiFileName,1,1,1);
    
    % Insure that next file doesn't run until this one is finished
    pause(8); % wait for process to be spawned
    new_PID = getPID('Bonsai.Editor.exe');
    PID = new_PID(~ismember(new_PID,init_PID));
    if isempty(PID)
        error('PID of Bonsai process not found')
    end
    tic;
    while getcpuusage(PID) > 1
        pause(10);
        %         disp([num2str(idp) ' Extremes for ' dpArray.FileName ' CPU' num2str(getcpuusage(PID))])
        %
    end
    pause(2);
    killPID(PID);
    processTime = toc;
    if processTime <  30 % check process time
        warning(['Bonsai took:' num2str(processTime) 's to process ' dpArray(idp).FileName]);
    else
        disp(['Bonsai took:' num2str(processTime) 's to process ' dpArray(idp).FileName]);
    end
    
end


function bonsaiFileName = createBonsaiFileHelper(dp,bonsaiParams,bonsaiFileName)
r = brigdefs();
r.Dir.DataVideo = 'E:\TAFCmiceWaiting';

bonsaiTEMPLATEFilePath = fullfile(r.Dir.BonsaiCode,'TEMPLATE_loadvideofile_get_CM_Extremes.bonsai');
if nargin<3
    bonsaiFileName = 'loadvideofile_get_CM_Extremes.bonsai';
end
bonsaiFileName = fullfile(r.Dir.BonsaiCode,bonsaiFileName);

fn = dp.FileName;
fvdir = fullfile(r.Dir.DataVideo,dp.Animal);
fvdatadir = fullfile(r.Dir.DataBonsai,dp.Animal);

parentfolder(fvdatadir,1)

% TODO create directories automatically
fileAvi = fullfile(fvdir,[fn '.avi']);
filenameExtremes = fullfile(fvdatadir,[fn '_tracking.csv']);
filenameCMxy = fullfile(fvdatadir,[fn '_centroidXY.csv']);
filenameCMOrient = fullfile(fvdatadir,[fn '_centroidOrientation.csv']);

f = fopen(bonsaiTEMPLATEFilePath);
lines = fscanf(f,'%c');
fclose(f);
% AVI FILE
newLines = replaceInXML(lines,'q1:FileName',1,fileAvi);
% extremes file
newLines = replaceInXML(newLines,'q2:FileName',1,filenameExtremes);
newLines = replaceInXML(newLines,'q2:FileName',2,filenameCMxy);
newLines = replaceInXML(newLines,'q2:FileName',3,filenameCMOrient);

if exist('bonsaiParams','var')
    if isfield(bonsaiParams,'SubtractionMethod')
        newLines = replaceInXML(newLines,'q1:SubtractionMethod',1,bonsaiParams.SubtractionMethod);
    end
    if isfield(bonsaiParams,'ThresholdType')
        newLines = replaceInXML(newLines,'q1:ThresholdType',1,bonsaiParams.ThresholdType);
    end
    if isfield(bonsaiParams,'ThresholdValue')
        newLines = replaceInXML(newLines,'q1:ThresholdValue',1,bonsaiParams.ThresholdValue);
    end
    
end


f = fopen(bonsaiFileName,'w');
fwrite(f,newLines);
fclose(f);



