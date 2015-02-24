% check distribution of stimuli
ind1  = a(:,3)==-1;
ind2  = a(:,3)==0;
figure
subplot(1,2,1)
hist(a(ind1,end),max(a(:,end))+1)
title('-1')
subplot(1,2,2)
hist(a(ind2,end),max(a(:,end))+1)
title('0')

WHere do all the trials go.
when does the new blockstart?

- 179 one block 77/80 stimuli (why?) look at other sesions
- check that onset of new block is right (because some have
- in 77 stim bias short unstim long

- something is wrong with labeling of controlloop

- When premature on controlloop, .controlloop field is 0 but redraw is also 0

- 
        if it is should be more even than non extra block
         
- where do the redraws go that are not premature or a control loop?
    THEY are either choicemiss or last Premature
        - choicemiss doesn't change the state of redraw.. so there can be premature, premature, choicemiss and the stimulus won't change.
        - last premature is no redraw but not premature.
 

     
     
 - consolidate the reDraw, controlLoop Interval information to the beginning of each trial
 

%% get distribution of  Intervals
dp = ss_parsedata
%%
dpNoControl = filtbdata(dp1,0,{'controlLoop', @(x) isnan(x)|x==0,'ChoiceMiss', @(x) isnan(x)|x==0}); % contains all the prematures
%%
dpNoControl = prematurePsycurvHelper(dpNoControl);
figure
subplot(1,2,1)
% [a x] = hist(dp.Interval,8)
% stairs(x,a,'color','b');hold all
bins = dp.IntervalSet
dpreDraw = filtbdata(dpNoControl,0,{'reDraw', 1})
[a x] = hist(dpreDraw.Interval,bins)
stairs(x,a,'color','k');

dpStim = filtbdata(dpNoControl,0,{'stimulationOnCond', @(x) x ~= 0 & ~isnan(x)})
subplot(1,2,2)
[a x] = hist(dpStim.Interval,bins)
stairs(x,a,'color','b');hold all
dpreDraw = filtbdata(dpStim,0,{'reDraw', 1,'ChoiceCorrect', [0 1]})
[a x] = hist(dpreDraw.Interval,bins);
stairs(x,a,'color','k');

[a x] = hist(dpStim.IntervalwithPM,bins);
stairs(x,a,'color','r');

dpNoStim = filtbdata(dpNoControl,0,{'stimulationOnCond', x == 0})
subplot(1,2,2)
[a x] = hist(dpNoStim.Interval,bins)
stairs(x,a,'color','b');hold all
dpreDraw = filtbdata(dpNoStim,0,{'reDraw', 1,'ChoiceCorrect', [0 1]})
[a x] = hist(dpreDraw.Interval,bins)
stairs(x,a,'color','k');
[a x] = hist(dpNoStim.IntervalwithPM,bins);
stairs(x,a,'color','r');

%is it just because premature trials are not stimulated?
% no it can't be

