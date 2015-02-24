function [ dataParsed ] = custom_parsedata( varargin )

dataParsed = ss_parsedata(varargin{:});

% if ~isempty(strfind(dataParsed.Protocol,'TAFCv'))
%     matrix = reconst(dataParsed.RawData);
% else
%     matrix = reconst_simple(dataParsed.RawData);
% end
% dataParsed.matrix = matrix;
try
dataParsed.totalTrials =  size(dataParsed.TrialAvail,2);
dataParsed.absolute_trial = 1:dataParsed.totalTrials;
dataParsed.ntrials = length(dataParsed.absolute_trial);
dataParsed = getStats_dp(dataParsed);
catch
    dataParsed.totalTrials = NaN;
    dataParsed.absolute_trial = NaN;
    dataParsed.ntrials = NaN;
end


