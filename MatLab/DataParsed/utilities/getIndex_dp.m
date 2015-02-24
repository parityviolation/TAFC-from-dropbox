function ndx = getIndex_dp(dataParsed)

ndx.valid = find(dataParsed.ChoiceCorrect==1 |dataParsed.ChoiceCorrect==0 & ~isnan(dataParsed.TrialInit));% 
ndx.correct = find(dataParsed.ChoiceCorrect==1);
ndx.incorrect = find(dataParsed.ChoiceCorrect==0);
ndx.prem_long = find(dataParsed.PrematureLong==1);
ndx.prem_short = find(dataParsed.PrematureLong==0);
ndx.prem = find(dataParsed.Premature==1);
ndx.rw_miss = find(dataParsed.RwdMiss==1);
ndx.choice_miss = find(dataParsed.ChoiceMiss==1);
ndx.stimulation = find(dataParsed.stimulationOnCond);
ndx.nostimulation = find(~(dataParsed.stimulationOnCond));
ndx.valid_stimulation = find(dataParsed.stimulationOnCond~=0&(dataParsed.ChoiceCorrect==1 |dataParsed.ChoiceCorrect==0) & ~isnan(dataParsed.TrialInit));
ndx.valid_nostimulation = find(dataParsed.stimulationOnCond==0&(dataParsed.ChoiceCorrect==1 |dataParsed.ChoiceCorrect==0)& ~isnan(dataParsed.TrialInit));
ndx.valid_nostimulation_nocorrectionloop = find(dataParsed.stimulationOnCond==0&(dataParsed.ChoiceCorrect==1 |dataParsed.ChoiceCorrect==0)...
                                           &(isnan(dataParsed.controlLoop)|dataParsed.controlLoop==0)& ~isnan(dataParsed.TrialInit));

end