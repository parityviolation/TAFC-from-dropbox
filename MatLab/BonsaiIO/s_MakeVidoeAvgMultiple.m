dp = loadBstruct;
% 15 17 18
%%
% INCORRECT STIM vs NONSTIM
param.scorrect1 = 0
param.scorrect2 = 0
param.sstim1 = 0
param.sstim2 = [1:3];
param.alignfield = 'pokeIn_fr';

s_MakingVideoAvg(dp,param)

% CORRECT STIM vs NONSTIM
param.scorrect1 = 1
param.scorrect2 = 1
param.sstim1 = 0;
param.sstim2 = [1:3];
param.alignfield = 'pokeIn_fr';

s_MakingVideoAvg(dp,param)

% NONSTIM CORRECT vs INCORRECT
param.scorrect1 = 1
param.scorrect2 = 0
param.sstim1 = 0
param.sstim2 = 0
param.alignfield = 'pokeIn_fr';

s_MakingVideoAvg(dp,param)


% STIM CORRECT vs INCORRECT
param.scorrect1 = 1
param.scorrect2 = 0
param.sstim1 = [1:3];
param.sstim2 = [1:3];
param.alignfield = 'pokeIn_fr';

s_MakingVideoAvg(dp,param)