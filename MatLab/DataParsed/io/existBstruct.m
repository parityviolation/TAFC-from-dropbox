function [bexists FullPath] = existBstruct(dp)
r = brigdefs();
FullPath = [];
bexists = 0;
if nargin >0
    if isstruct(dp)
        [junk fname junk] = fileparts(dp.FileName);
        FullPath = fullfile(r.Dir.BStruct,[fname '_bstruct.mat']);
    else
        [junk fname junk] = fileparts(dp);
        FullPath = fullfile(r.Dir.BStruct,[fname '_bstruct.mat']);
    end
else
    [FileName,PathName] = uigetfile(fullfile(r.Dir.BStruct,'*_bstruct.mat'),'Select Behavior file to analyze');
    FullPath = fullfile(PathName,FileName);
end
bexists =  exist(FullPath, 'file');
