function [bias_dif, numTrials] = calculateBias(dpArray,pairStim,trialsPreCond)
% function calculateBias(dpArray,pairStim,trialsPreCond)
% 
%INPUTS
%
%dpArray is an array of structs of daily data
% pairStim is an binary variable 
%            0 - calculate bias independent of stimulus dificulty in the
%            current trial
%            1 - calculate bias by pairing current trials by the dificulty
%            of the stimulus
%trialsPreCond is an shorted version of the updating matrix, only with the
%trials that were preceded by a given condition (ex. preceded by stimulus 0.2)
%
% 
% OUTPUTS
% bias_dif is the difference between long and short choices = negative
% values indicate bias to short choices, positive values indicate bias to
% long choices
% 
%numTrials is the number of trials used to compute the bias
% 


stimSet = dpArray(1).IntervalSet;
bound = 0.5;
numTrials = 0;

if pairStim
    i = length(stimSet)/2;
    bias_dif = nan(i,1);
    
    
    %filters trials preceded by conditions
    for a = 1:i %runs this loop for i pairs of stimulus difficulty
        
        %filters trials by dificulty
        data_dif = trialsPreCond(trialsPreCond(:,1)==stimSet(a)|trialsPreCond(:,1)==stimSet(end-a+1),:);     % Filters trials_pre_s by dificulty in pairs
        
        %calculate biases short/long
        
        data_dif_short = length(data_dif(data_dif(:,1,1)==stimSet(a) & data_dif(:,3,1)==1))/length(data_dif(data_dif(:,1,1)==stimSet(a))); % Fraction of errors to one side
        data_dif_long = length(data_dif(data_dif(:,1,1)==stimSet(end-a+1) & data_dif(:,3,1)==1))/length(data_dif(data_dif(:,1,1)==stimSet(end-a+1))); % Fraction of errors to another side
        bias_dif(a) = data_dif_long - data_dif_short; % Bias on trials preceded by stim s, for current stimuli in pairs of different difficulties
        
    end
    
else
    
    data_dif = trialsPreCond;
    data_dif_short = length(data_dif(data_dif(:,1,1)<bound & data_dif(:,3,1)==1))/length(data_dif(data_dif(:,1,1)<bound)); % Fraction of errors to one side
    data_dif_long = length(data_dif(data_dif(:,1,1)>bound & data_dif(:,3,1)==1))/length(data_dif(data_dif(:,1,1)>bound)); % Fraction of errors to another side
    bias_dif = data_dif_long - data_dif_short; % Bias on trials preceded by stim s, for all current situli combined
    numTrials = numTrials + length(data_dif); %Number of trials used to calculate the bias

    
end
