% plot probability of picking LEFt stimulated blocks
% vs unstimulated over times

function trialAvg = getAvgInTrialRange(dp,trialRange)
trialAvg.trialRange = trialRange';
%  triggerTrial is a n x 2 matrix. col1 is the Trial that a Block begins, col2 is the trial the block ends.
flds = fieldnames(dp);
ntrials = dp.ntrials;

for itrig = 1:size(trialRange,1) % for each trial given as input
    
    for ifield = 1:length(flds)
        this_field = flds{ifield};
        
        if length(dp.(this_field))==ntrials
            try
                 trialAvg.(this_field)(itrig)= nanmean(dp.(this_field)...
                    (trialRange(itrig,1):trialRange(itrig,2)));
            catch ME
                getReport(ME)
            end
        end
    end
end

