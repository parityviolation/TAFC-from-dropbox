function strc = filtbdata(strc,bOR,sweepfilter,trialRelativeSweepfilter)
% function strc = filtBdata(strc,bOR,sweepfilter,trialRelativeSweepfilter)
%
% Filter the strc struct according to one or more property/value pairs.
%
% INPUTS
%   strc: The strc struct
%   bOR: 0 for AND, 1 for OR
%   sweepfilter: A cell: A property value pair used to filter the strc struct
%   according to the value of the given property for each spike. Multiple
%   property/value pairs can be used to output the strc corresponding to
%   the intersection (AND) or union (OR) of multiple conditions.
%
%   trialRelativeSweepfilter: { [relative Trials to include], property
%   value pair to filter}
% OUTPUTS
%   strc: The filtered strc struct

% e.g
% % if I want all trials ONE before right Correct choices
%  filtBdata(dp,0,{'Correct', 1,'ChoiceLeft' 0},{-1})
% % if I want all trials ONE or TWO AFTER right Correct choices, that are not
% % Premature
%  filtBdata(dp,0,{'Correct', 1,'ChoiceLeft' 0},{[1 2] , 'Premature',0})

%   Created: 5/2013 - BA
%



if nargin < 3
    error('Not enough arguments supplied')
end

sortfield = {};
sortvalue = {};
if(~iscell(sweepfilter))
    fromStruct = 0;
    if length(sweepfilter) == 1
        sw = sweepfilter;
        fromStruct = isstruct(sw);
        if fromStruct
            
            sortfield = sw.fieldnames;
            sortvalue = sw.sortvalue;
            numSortFields = length(sortfield);
            emptyspots = zeros(numSortFields,1);
            for i = 1:numSortFields
                emptyspots(i)= ~isempty(sortfield(i));
            end
        else
            error('Not enough input arguments')
        end
    else
        error('sweepfilter incorrectly specified must be a struct or cell')
    end
    
else
    numSortFields = length(sweepfilter)/2;
    emptyspots = zeros(numSortFields,1);
    thecell = sweepfilter;
    for i = 1:numSortFields
        sortfield{i} = thecell{(i-1)*2+1};
        sortvalue{i} = thecell{2*i};
        emptyspots(i) = ~isempty(sortfield{i});
    end
end

if ~isempty(sortfield)
sortfield = sortfield(logical(emptyspots));
sortvalue = sortvalue(logical(emptyspots));
end

trialRelative = []; trialRelativeSortField = {}; trialRelativeSortValue = {};
if exist('trialRelativeSweepfilter','var')
    if ~isempty(trialRelativeSweepfilter)
        trialRelative = trialRelativeSweepfilter{1};
        if length(trialRelativeSweepfilter)>1
            thecell = trialRelativeSweepfilter(2:end);
            clear emptyspots
            for i = 1:length(thecell)/2;
                
                trialRelativeSortField{i} = thecell{(i-1)*2+1};
                trialRelativeSortValue{i} =  thecell{2*i};
                emptyspots(i) = ~isempty(trialRelativeSortField{i});
                
            end
            trialRelativeSortField = trialRelativeSortField(logical(emptyspots));
            trialRelativeSortValue = trialRelativeSortValue(logical(emptyspots));
        end
    end
end


sortvector = helper(strc,sortfield,sortvalue,bOR);

if ~isempty(trialRelative) % filter to get only the trials Relative to those matching sortvector
    tempvector = zeros(size(sortvector));
    ntrials = size(sortvector,2);
    trial_ind = [];
    for itrial = 1:length(trialRelative)
        trial_ind = [trial_ind find(sortvector)+trialRelative(itrial)];
    end
    trial_ind(trial_ind<=0 | trial_ind >ntrials) = [];  % make sure new trials are added;
    tempvector(trial_ind) = 1;
    
    if ~isempty(trialRelativeSortField) % filter the trials Relative by additional sort vector
        sortvector = helper(strc,trialRelativeSortField,trialRelativeSortValue,bOR,tempvector);
    else
        sortvector = tempvector;
    end
end

% Find fields that have same length as spiketimes
if isfield(strc,'TrialAvail')
    reqLength = size(strc.TrialAvail,2);
elseif isfield(strc,'exptFilename') % for animalLog
    reqLength = size(strc.exptFilename,2);
end
% Use logical vector to extract spikestimes, trials, etc.
strc = helperfiltfunc(strc,find(sortvector),reqLength);

end
function sortvector = helper(strc,sortfield,sortvalue,bOR,sortvector)
numSortFields = length(sortfield);

if isempty(sortfield) && ~exist('sortvector','var')  % if not sort criteria is given all trials are included
    sortvector = ones(1,size(strc.TrialAvail,2));
end
% Make logical vector to sort strc
for i = 1:numSortFields
    
    if isfield(strc,sortfield{i})
        if(isa(sortvalue{i}, 'function_handle'))
            fcn_hand = sortvalue{i};
            tempvector = arrayfun(fcn_hand, strc.(sortfield{i}));
        else
            tempvector = ismember(strc.(sortfield{i}),sortvalue{i});     % Take trials = value
        end
        
        
        
        if ~exist('sortvector','var')
            sortvector = tempvector;
        end
        % Combine multiple conditions
        if bOR  % OR
            sortvector = sortvector | tempvector;
        else    % AND
            sortvector = sortvector & tempvector;
        end
        
    else
        error([ sortfield{i} ' does not Exist as a Field'])
    end
    
end
end



