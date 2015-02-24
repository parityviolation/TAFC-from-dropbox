function [performance day]  = getAnimalPerformance(dpAnimal)




num_sessions = size(dpAnimal,2);
performance = nan(1,num_sessions);
day = {};

for s = 1:num_sessions
    
   this_dp = dpAnimal(s);
   performance(1,s) = nansum(this_dp.ChoiceCorrect)/sum(~isnan(this_dp.ChoiceLeft));
   day{s} = this_dp.Date; 
    
end


day = fliplr(day)';
performance = fliplr(performance)';



