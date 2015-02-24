function fixAvi(dpORfilename)

r = brigdefs;

if isstruct(dpORfilename) % assume is a dp
    dp = dpORfilename;
    filename = fullfile(r.Dir.DataVideoLoad,dp.Animal,[dp.FileName '.avi']);
else
    filename = dpORfilename;
end

[path name ext] = fileparts(filename);
oldname = [ name '_OLD' ext];

s = ['rename ' filename ' ' oldname ];
dos(s)
s = ['ffmpeg.exe -i ' fullfile(path,oldname) ' -vcodec copy ' filename];

system(s);
