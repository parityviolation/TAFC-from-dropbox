function [performance mean_performance]  = getGroupPerformance(dpAnimalCell)

num_animals = size(dpAnimalCell,2);
performance = nan(num_animals,10);

for a = 1:num_animals

num_sessions = size(dpAnimalCell{1,a},2);

for s = 1:num_sessions
    
   this_dp = dpAnimalCell{1,a}(s)
   performance(a,s) = nansum(this_dp.ChoiceCorrect)/sum(~isnan(this_dp.ChoiceLeft));
    
    
end

end

performance = fliplr(performance)';

mean_performance = nanmean(performance,2);
mean_performance = mean_performance(~isnan(mean_performance));

