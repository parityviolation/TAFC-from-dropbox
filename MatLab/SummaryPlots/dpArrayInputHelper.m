function [dpArray  condCell]= dpArrayInputHelper(varargin)
% average psyc points across days.
    bDoNotLoadVideoData = 1;
if nargin==0 || isempty(varargin{1})
    brecomputeDP = 1;
    dpArray = builddp(brecomputeDP,bDoNotLoadVideoData,varargin);
elseif isstruct(varargin{1})
    dpArray = varargin{1};
else
    A = varargin{1}; % 'sert867_lgcl';
    if iscell(A)
        A  = A{1};
    end
    dpArray = loadBstruct(A,1);
    [exptnames trials] = getStimulatedExptnames(A);
    dpArray = constructDataParsedArray(exptnames, trials,bDoNotLoadVideoData,1);  % don't
%     reload dataparsed
%     dpArray = constructDataParsedArray(exptnames, trials);
    dpArray(1).collectiveDescriptor = A ;
end
% take care of special case where dpArray may be just one dp
if ~isfield(dpArray,'collectiveDescriptor')
    dpArray(1).collectiveDescriptor = dpArray(1).Animal;
end

if nargin==2 & ~isempty(varargin{2})
    cond =  varargin{2};
    condCell = cond.condGroup;
    sAddToCollectiveDescriptor = cond.condGroupDescr;
else % default
    condCell = 'all'; % group Stimulations conditions accordingly
    sAddToCollectiveDescriptor = '_';
end

dpArray(1).collectiveDescriptor = [dpArray(1).collectiveDescriptor sAddToCollectiveDescriptor];
