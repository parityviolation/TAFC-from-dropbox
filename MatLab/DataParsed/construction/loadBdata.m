 function dstruct = loadBdata(varargin)
% function dstruct = loadBdata(varargin)
% loadBdata(dstruct) % will reload the dstruct.filename
% loadBdata() % will pull up a window to select file to load
% loadBdata(mouseName) % will load the Latest file from this mouse
% loadBdata(mouseName,FileName) % will load file

brigdef = brigdefs();
datadir = brigdef.Dir.DataBehav;

if isunix
    slash = '/';
else
    slash = '\';
end

if nargin==0
    [FileName,PathName,FilterIndex] = uigetfile(fullfile(datadir,slash,'*.txt'),'Select Behavior file to analyze');
    dstruct.filename = [PathName FileName];
    ind = regexp(PathName,slash);     % extract protocol from mousename from Path
    dstruct.mouseName = PathName(ind(end-1)+1:ind(end)-1);
    start_ind = length(dstruct.mouseName)+2; 
    ind = regexp(FileName,'_');
    ind2 = find(ind>start_ind);
  
   if length(ind2)>2
        dstruct.protocol = FileName(start_ind:ind(ind2(end-1))-1);
    else
        dstruct.protocol = FileName(start_ind:ind(ind2(1))-1);
        
   end
    
elseif isstruct(varargin{1})
    dstruct = varargin{1};
elseif ~isempty(findstr(varargin{1},slash))% is it a filename with a path? then load it
    dstruct.filename = varargin{1};
    % extract protocol from filename
    [junk FileName]  = fileparts(dstruct.filename);
    ind =findstr(dstruct.filename,slash);
    dstruct.mouseName = dstruct.filename(ind(end-1)+1:ind(end)-1);
    ind = regexp(FileName,'_');
    start_ind = length(dstruct.mouseName)+2; 
    ind2 = find(ind>start_ind);
  
   if length(ind2)>2
        dstruct.protocol = FileName(start_ind:ind(ind2(end-1))-1);
    else
        dstruct.protocol = FileName(start_ind:ind(ind2(1))-1);
        
   end
  
    
else
    
    if nargin == 1 % i.e. mouseName, load the newest file for this mouse
        dstruct.mouseName = varargin{1};
        %         [FileName,PathName,FilterIndex] = uigetfile([datadir dstruct.mouseName '\*.txt'],'Select Behavior file to analyze');
        f = dir([fullfile(datadir,dstruct.mouseName) slash '*.txt']);
        FileName = f(end).name;
        dstruct.filename = [fullfile(datadir,dstruct.mouseName) slash FileName];
        
    elseif nargin == 2 % i.e. mouseName, Filename
        dstruct.mouseName = varargin{1};
        dstruct.filename = varargin{2};
    end
    
    % extract protocol from filename
    ind = regexp(FileName,'_');
    start_ind = length(dstruct.mouseName)+2; 
    ind2 = find(ind>start_ind);
  
   if length(ind2)>2
        dstruct.protocol = FileName(start_ind:ind(ind2(end-1))-1);
    else
        dstruct.protocol = FileName(start_ind:ind(ind2(1))-1);
        
   end
    
end
try
s_data= dlmread(dstruct.filename);
catch ME
    getReport(ME)
    dstruct = [];
    return
end
%generate a matrix in which data rows are trials and data columns are: labels = {'Trial number','Stimulus','Choice long','Correct','Latency','Trial onset','# beeps played','time of prem choice','Prem Long?','Prem Correct?','Reward miss'};

%for sessions with no duration discrimination - check number of trials
%matrix=reconst_simple(s_data);

%for sessions with duration discrimination (TAFCl4 and TAFCv03)
if ~isempty(strfind(dstruct.protocol,'TAFCv'))
    matrix = reconst(s_data);
else
    matrix = reconst_simple(s_data);
end
dstruct.matrix = matrix;


% compute useful shit
totalTrials = length(matrix(:,1));
correctTrials = length(find(matrix(:,4)==1))/totalTrials;
errorTrials = length(find(matrix(:,4)==0))/totalTrials;
premTrials=(totalTrials-length(find(isnan(matrix(:,8)))))/totalTrials;
numLong = length(find(matrix(:,3)==1));

dstruct.computed.totalTrials = totalTrials;
dstruct.computed.correctTrials = correctTrials;
dstruct.computed.errorTrials = errorTrials;
dstruct.computed.premTrials = premTrials;
dstruct.computed.numLong = numLong;
