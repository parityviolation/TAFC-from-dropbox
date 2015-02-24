%%

% 15-17 had effect on both animals wait
% 17 changed form 85 to constant stimulus
% 17,18 stimulationoff response 85 (I don't udnerstand this because off no
% longer means off )
% several animals
% several days
% lick sensor changed

% pick a session

% 3 cases,
%       no light,
%       light above head,
%       light at 1,2
%      light on/ light off align
%


% VGAT 1385
% NEW sensor
% 111214
%

% TO DO
% SHIELD LIGHT
% There is a offset response (larger when the fiber is higher and hitting more of the cortex

% Remove first X trials
% split out correct and incorrect?

licks = buildLicks();
bsave = 1
clear XY
XY{1} = [0 2.5]
XY{2} = [0 0];
% analysis

% What are the most likely trials to fail on
% reaction time for go and wait across session

% average length of time before wait give up (control for this with go)
% Is there longer waiting time when they wait longer ?? Hazard Rate

% video and lick when the fail and lick what does the animal actually do (the lick port is quite close so it could be not a real lick)

% lick latency (go) as a function of trial in session
% lick boute (haven't detected yet) 
% lick rate

% what does licking boute look like as a fucntino of how long they wait?
% hazard rate? surprise?
% firstTrial = 1; 
% licks = filtspikes(licks,1,{},{'sessionTrial', @(x) x<100})

% problems plotting concatenated session in raster

% 
% ADD HAZARD RATE
% ANALYZE across days ( should at least be no light effect)
% 
% 

s_HF_summarizePerformanceANDSelect

s_HF_Performance_StimVsControl_FisherExactTest
 
%%
s_HF_LightStimulationLickAnalysis
