function [ deltaF_F ] = calcDeltaF_F( fData,baselineWindow,syncPulseTimes,WOI)
%calcDeltaF_F Calculates the deltaF/F values for fData
%   Detailed explanation goes here



baselineW = fData(syncPulseTimes-baselineWindow:syncPulseTimes);
baseline = mean(baselineW);

deltaF = fData(syncPulseTimes-WOI(1):syncPulseTimes+WOI(2)) - baseline;

deltaF_F = deltaF/baseline;


end

