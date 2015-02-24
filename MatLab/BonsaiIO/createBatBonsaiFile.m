function batfile = createBatBonsaiFile(bonsaiFullFile,bcreateANDrun,buse64,brunNewProcess)
% function batfile = createBatBonsaiFile(bonsaiFullFile,bcreateANDrun,buse64)
bstartBonsaiOnRun = 1;
rd = brigdefs();

if nargin < 4
    brunNewProcess =1;
end

if nargin < 3
    buse64 =0;
end

if nargin < 2
    bcreateANDrun =0;
end

directory = rd.Dir.BonsaiEditor86;

if buse64
    directory = rd.Dir.BonsaiEditor64;
end

batfile = fopen(fullfile(rd.Dir.BatFile,'batfile.bat'),'w');
if bstartBonsaiOnRun
    fwrite(batfile,fullfile(directory,['Bonsai.Editor.exe ' '"' bonsaiFullFile '"' ' --start']));
else
    fwrite(batfile,fullfile(directory,['Bonsai.Editor.exe ' '"' bonsaiFullFile '"']));
end
fclose(batfile);

if bcreateANDrun
    if brunNewProcess
        system(fullfile(rd.Dir.BatFile,'batfile.bat &'));
    else
        system(fullfile(rd.Dir.BatFile,'batfile.bat'));
    end
   
end
