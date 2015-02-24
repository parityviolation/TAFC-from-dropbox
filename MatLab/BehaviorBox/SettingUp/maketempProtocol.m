function targetpath = maketempProtocol(sourcefile,targetname)

rd = brigdefs();
[pathstr, filename, ext] = fileparts(targetname);
temppath = fullfile(rd.Dir.temp,'arduino_upload',filename);
parentfolder(temppath,1);
targetpath = fullfile(temppath,sprintf('%s.ino',filename));
system(['copy "' sourcefile '"' ' "' targetpath '"']);