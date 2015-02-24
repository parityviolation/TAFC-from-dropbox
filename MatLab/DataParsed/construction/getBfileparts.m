function [FileName PathName Animal ...
    Date Protocol ProtocolVersion Box Experimenter FileNumber Rev] = getBfileparts(FullPath)

[PathName FileName Ext] = fileparts(FullPath);

ndx = regexp(FileName,'\(I)');
FileNumber = FileName(ndx+3:end);

if isempty(ndx)
    FileNameWOFN = FileName;
else
    FileNameWOFN = FileName(1:ndx-2);
end
uscore_ndx = regexp(FileNameWOFN,'_');

% the Animal name can contain 1 _ but the character after the underscore
% must be a number
if ~isempty(regexp(FileNameWOFN(uscore_ndx(1)+1),'[0-9]'))
    incUnderscore = 2;
else
    incUnderscore = 1;
end

Animal =FileNameWOFN(1:uscore_ndx(incUnderscore)-1);
Date = FileNameWOFN(uscore_ndx(end-1)+1:uscore_ndx(end)-1); % YYMMDD
% Box must only be used for the boxnumber
indBox = strfind(lower(FileNameWOFN),'box');
if isempty(indBox)
    Box = 'Unknown';
else
    indend = uscore_ndx(find(uscore_ndx>indBox,1,'first'));
    Box = FileNameWOFN(indBox+3:indend-1);
end

rev = strfind(FileNameWOFN,'REV');
if isempty(rev)
    Rev = 0;
else
    Rev=1;
end

 strfind(FileNameWOFN,'REV')

% Protocol must go until Box
Protocol = FileNameWOFN(uscore_ndx(incUnderscore)+1:indBox-2);
if ismember('v',Protocol)
    ProtocolVersion = Protocol(find(Protocol=='v')+1:find(Protocol=='v')+2);
    Protocol = Protocol(1:find(Protocol=='v')-1);
else
    ProtocolVersion = 'Unknown';
end


try
    Experimenter = FileNameWOFN(uscore_ndx(end)+1:end);
catch
    Experimenter = 'Unknown';
end
end