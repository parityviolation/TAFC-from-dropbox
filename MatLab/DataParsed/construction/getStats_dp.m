function [dataParsed  stats] = getStats_dp(dataParsed)

if ~isfield(dataParsed,'stats')
    dataParsed.stats = [];
end

if ~isfield(dataParsed.stats,'frac')
    dataParsed.stats.frac = [];
end

if dataParsed.ntrials & isfield(dataParsed,'ChoiceLeft')
    % compute useful
    fd = {'premTrials','Correct','Error'};
    
    dpfd = {'Premature','ChoiceCorrect','ChoiceCorrect'};
    dpval = {1,1,0};
    
    ntrials = length(dataParsed.absolute_trial);
    for ifd = 1:length(fd)
        if isfield(dataParsed,dpfd{ifd})
            dataParsed.stats.frac.(fd{ifd}) = sum(ismember(dataParsed.(dpfd{ifd}),dpval{ifd}))/ntrials;
        else
            dataParsed.stats.frac.(fd{ifd}) = NaN;
        end
        
    end
    dataParsed.stats.ntrials = ntrials;
    

    
    % frac of  Valid Trials Left
    ntrialsValid = sum(ismember(dataParsed.ChoiceCorrect, [1 0]));
    dataParsed.stats.fracValid_ChoiceLeft = nansum(dataParsed.ChoiceLeft)/ntrialsValid;
    dataParsed.stats.ntrialsValid =ntrialsValid;
    
    % frac of Stimulate Valid Trials Left
    f = @(x) x~=0 &  ~isnan(x);
    ntrailsValidStim = nansum( f(dataParsed.stimulationOnCond) & ismember(dataParsed.ChoiceCorrect, [1 0])  );
    dataParsed.stats.fracValidStim_ChoiceLeft = nansum(dataParsed.ChoiceLeft==1 & f(dataParsed.stimulationOnCond) )/ntrailsValidStim;
    dataParsed.stats.ntrailsValidStim = ntrailsValidStim;
    
    % frac of UNStimulate Valid Trials Left
    f = @(x) x==0 ;
    ntrailsValidUnStim = nansum( f(dataParsed.stimulationOnCond) & ismember(dataParsed.ChoiceCorrect, [1 0])  );
    dataParsed.stats.fracValidUnStim_ChoiceLeft = nansum(dataParsed.ChoiceLeft==1 & f(dataParsed.stimulationOnCond) )/ntrailsValidUnStim;
    dataParsed.stats.ntrailsValidUnStim = ntrailsValidUnStim;
    
    % fraction of PM trials Left
    ntrialsPM = sum(dataParsed.Premature); % perhaps should only include first premature
    dataParsed.stats.fracPM_PrematureLong = nansum(dataParsed.PrematureLong)/ntrialsPM;
    dataParsed.stats.ntrialsPM =ntrialsPM;

    % fraction of Stimulated PM trials Left
    f = @(x) x~=0 &  ~isnan(x);
    ntrailsPMStim = nansum( f(dataParsed.stimulationOnCond) & ismember(dataParsed.Premature, [1])  );
    dataParsed.stats.fracPMStim_PrematureLong = nansum(dataParsed.PrematureLong==1 & f(dataParsed.stimulationOnCond) )/ntrailsPMStim;
    dataParsed.stats.ntrailsPMStim = ntrailsPMStim;

    % fraction of UnStimulated PM trials Left
    f = @(x) x==0 ;
    ntrailsPMUnStim = nansum( f(dataParsed.stimulationOnCond) & ismember(dataParsed.Premature, [1])  );
    dataParsed.stats.fracPMUnStim_PrematureLong = nansum(dataParsed.PrematureLong ==1 & f(dataParsed.stimulationOnCond) )/ntrailsPMUnStim;
    dataParsed.stats.ntrailsPMUnStim = ntrailsPMUnStim;
    
        dataParsed.stats.predict_nPMUnStim_PrematureLong = dataParsed.stats.fracPMUnStim_PrematureLong *...
                                                            dataParsed.stats.fracValidStim_ChoiceLeft/dataParsed.stats.fracValidUnStim_ChoiceLeft *...
                                                            dataParsed.stats.ntrailsPMStim;

    dataParsed.stats.predict_fracPMUnStim_PrematureLong = dataParsed.stats.fracPMUnStim_PrematureLong *...
                                                            dataParsed.stats.fracValidStim_ChoiceLeft/dataParsed.stats.fracValidUnStim_ChoiceLeft ;
%   fracValidStim_ChoiceLeft/fracValidUnStim_ChoiceLeft X
    %   ntrailsPMStim
    % predict the number of Stimulated PM Left
    % = fraction of Unstimulated PM Left X
    %   fracValidStim_ChoiceLeft/fracValidUnStim_ChoiceLeft X
    %   ntrailsPMStim
 
         % fraction of PM trials Left
     f = @(x) x==0 ;
    ntrailsUnStim = nansum( f(dataParsed.stimulationOnCond) );
   dataParsed.stats.fracPM_UnStim =ntrailsPMUnStim/ntrailsUnStim;
    dataParsed.stats.fracChoiceLeft_UnStim =nansum(dataParsed.ChoiceLeft==1 & f(dataParsed.stimulationOnCond) )/ntrailsUnStim;

    f = @(x) x~=0 &  ~isnan(x);
    ntrailsStim = nansum( f(dataParsed.stimulationOnCond) );
    dataParsed.stats.fracPM_Stim = ntrailsPMStim/ntrailsStim;
    dataParsed.stats.fracChoiceLeft_Stim = nansum(dataParsed.ChoiceLeft==1 & f(dataParsed.stimulationOnCond) )/ntrailsStim;


    
    if isfield(dataParsed,'IntervalSet')
        IntervalSet = dataParsed.IntervalSet;
        valid = ~isnan(dataParsed.ChoiceLeft);
        choiceLong = dataParsed.ChoiceLeft(valid)==1;
        IntervalVector = dataParsed.Interval(valid);
        stimvalid = dataParsed.stimulationOnCond(valid);
        
        psyc = zeros(size(IntervalSet));
        n = nan(size(IntervalSet));
        
        for s = 1:length(IntervalSet)
            s_index = IntervalVector==IntervalSet(s);
            nlong(s) = nansum(choiceLong(s_index));
            ntotal(s) = sum(s_index);
            
            
            this_s_stimvalid = stimvalid(s_index);
            f = @(x) x~=0 &  ~isnan(x);
            nlongStim(s) = nansum(choiceLong(s_index) & f(this_s_stimvalid));
            ntotalStim(s) = nansum(s_index & f(stimvalid));
  
            f = @(x) x==0;
            nlongUnStim(s) = nansum(choiceLong(s_index) & f(this_s_stimvalid));
            ntotalUnStim(s) = nansum(s_index & f(stimvalid));
        end
        
        psyc = nlong./ntotal;
        
        dataParsed.stats.IntervalSet = IntervalSet;
        dataParsed.stats.ntrialTotal = ntotal;
        dataParsed.stats.nchoiceLong = nlong ;
        
        dataParsed.stats.frac.choiceLong = psyc;
        dataParsed.stats.frac.choiceLongUnStim = nlongUnStim./ntotalUnStim;
        dataParsed.stats.frac.choiceLongStim = nlongStim./ntotalStim;
        
    end
    
    
end

stats = dataParsed.stats;
