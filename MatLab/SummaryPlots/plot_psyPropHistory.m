function [dpArray dpC_p]=  psy_rewardRateHistory(varargin)
% function dpArray =  psy_rewardRateHistory(varargin)
% e.g dpArray/getStimulated_String,cond,wBack,p
%
% dpA = psy_rewardRateHistory('fi12_1013_3freq',[],600000,[25 50 75])
%
% SS

property = 'rewardrate'; %% other properties like trial rate

if nargin<2 | isempty(varargin{2})
    cond.condGroup = {[1 2 3]}; % group Stimulations conditions accordingly
    cond.condGroupDescr = '[1 2 3]';
else
    cond = varargin{2};
end

[dpArray]= dpArrayInputHelper(varargin{1:min(length(varargin),2)});

wBack = 600000; %window of time in ms to look back at each trial and calculate reward rate
if length(varargin)>2
    wBack = varargin{3};
end

p = [25 50 75]; %number of percentiles for trial binning
if length(varargin)>3
    p = varargin{4};
end


%%


%%THESE ARE INPUTS (4) TO THE FUTURE FUNCTION
%%
rd= brigdefs();
bplotfit = 1;
bsave = 1;

for i = 1:length(dpArray)
    
    trialInit = dpArray(i).TrialInit;
    trialInitWind = NaN(length(trialInit));
    rewardRate = NaN(length(trialInit),1);
for a = 1:length(trialInit)
    trialInitWind(a,:) = trialInit-trialInit(a);
    rewardRate(a) = length(find(trialInitWind(a,:)<0 & trialInitWind(a,:)>-wBack & dpArray(i).ChoiceCorrect==1))/wBack;  
    rewardRate(a) = length(find(trialInitWind(a,:)<0 & trialInitWind(a,:)>-wBack & dpArray(i).ChoiceCorrect==1))/wBack; 
end
dpArray(i).rewardRate = rewardRate;

end


dpC =concdp(dpArray);
ndx = getIndex_dp(dpC);

rewardRate = dpC.rewardRate;


%%

figure
hist(rewardRate)


percentiles = prctile(rewardRate,p);
pp = [p 100];
color_spec = cool(length(p)+1);

hfig = figure;

for b = 1:length(p)+1
    
    if b==1
        eval('dpC_p(b) = filtbdata(dpC,1,{''rewardRate'',@(x) x>0 & x<percentiles(b)})');
    elseif b == length(p)+1
        eval('dpC_p(b) = filtbdata(dpC,1,{''rewardRate'',@(x) x>percentiles(b-1)})');
    else
        eval('dpC_p(b) = filtbdata(dpC,1,{''rewardRate'',@(x) x>percentiles(b-1) & x<percentiles(b)})'); 
        
    end
    [fit(b) h] = ss_psycurve(dpC_p(b),1,bplotfit,gca); hold on;
    setColor(h, color_spec(b,:));
    defaultAxes(gca,[],[],12);
    hl(b) = h.hl; 
    sleg{b} = ['Percentile _ ' num2str(pp(b))];
    
dpC_p(b).collectiveDescriptor = [dpArray(1).collectiveDescriptor '_' num2str(pp(b)) '_p'];

end 
%% in construct

legend(hl,sleg,'Location','NorthWest')
sAnnot = [dpArray(1).collectiveDescriptor num2str(wBack/1000) 'sec'];  
savefiledesc = [ sAnnot '_PsycRewardRate_ ' num2str(pp) ' _Percentiles'];
plotAnn(sAnnot);
axis tight

if bsave
    patht = fullfile(rd.Dir.SummaryFig,'PsycRewardRate');
    parentfolder(patht,1)
    orient tall
    saveas(hfig, fullfile(patht,[savefiledesc '.pdf']));
    saveas(hfig, fullfile(patht,[savefiledesc '.fig']));
end
end

