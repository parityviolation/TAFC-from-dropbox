fitFunction = 'logistic';
free_parameters = {'none','all','l','bias','l slope','bias slope'};

% d = dataTime
d = dataLearning
d.Animal = 'ModelLearning';

d.Scaling = 3000;
d.controlLoop = zeros(size(d.ChoiceLeft));
d.TrialInit = zeros(size(d.ChoiceLeft));
d.Premature = zeros(size(d.ChoiceLeft));
d.PrematureLong = zeros(size(d.ChoiceLeft));
d.trialRelativeSweepfilter = [1:length(d.ChoiceLeft)];
d.TrialAvail = [1:length(d.ChoiceLeft)];
d.ntrials = length(d.ChoiceLeft);
d.Interval = d.IntervalPrecise/d.Scaling;
d.ChoiceLeft(d.ChoiceLeft<0) = 0;
 plotmlefit(d,'default',fitFunction,free_parameters)
 d.stimulationOnCond = double(d.stimulationOnCond );
 thisAnimal = d;
 
 s_trialafterstimulation