function hAx = plotCompareStimulatedMatching(varargin)
%%                       dpArray,condCell,hAx)

ntrialAfter = 1;

bconc = 0;

rd = brigdefs();
bsave = 1;


dpArray = dpArrayInputHelper(varargin{1:min(2,length(varargin))});
sAnnot =  dpArray(1).collectiveDescriptor ;

savefiledesc = [ sAnnot '_Compare_StimulatedMatching' ];



if nargin <2 | isempty(varargin{2})
    condCell.condGroup = {[1 2 3]};
else
    condCell = varargin{2}
end
    

if nargin <3 |  isempty(varargin{3}) % make a new figure if not axis is supplied
    hfig = figure('Name','CompareStimulationMatched','Number','off');
    hAx = subplot(1,1,1);
else
    hAx = varargin{3};
    hfig = get(hAx,'Parent');
end


if bconc
    dpC =concdp(dpArray); % for concatenating
else
    dpC =(dpArray);
end

hfig = figure('Position',[837   137   419   778]);


mycolor = colormap('lines');
for idp = 1:length(dpC)
    [dpCond] = getdpCond(dpC(idp),condCell.condGroup);
    
    clear P_same condlabel N
    for itrial = 1: ntrialAfter;
        
        for icond = 1:length(dpCond);
            dpL = filtbdata(dpC(idp),0,{'ChoiceLeft',1,'stimulationOnCond',unique(dpCond(icond).stimulationOnCond)});
            dpR = filtbdata(dpC(idp),0,{'ChoiceLeft',0,'stimulationOnCond',unique(dpCond(icond).stimulationOnCond)});
            
            dpAfterL_L=  filtbdata(dpC(idp),0,{'TrialNumber',dpL.absolute_trial+itrial,'ChoiceLeft',1});
            dpAfterL_R=  filtbdata(dpC(idp),0,{'TrialNumber',dpL.absolute_trial+itrial,'ChoiceLeft',0});
            
            dpAfterR_L=  filtbdata(dpC(idp),0,{'TrialNumber',dpR.absolute_trial+itrial,'ChoiceLeft',1});
            dpAfterR_R=  filtbdata(dpC(idp),0,{'TrialNumber',dpR.absolute_trial+itrial,'ChoiceLeft',0});
            
            P_same(icond) = (dpAfterL_L.ntrials/dpL.ntrials +dpAfterR_R.ntrials/dpR.ntrials)/2;
            N(icond,:) = [dpAfterL_L.ntrials dpL.ntrials dpAfterR_R.ntrials dpR.ntrials];
            condlabel{icond} = num2str(unique(dpCond(icond).stimulationOnCond));
        end
        
        subplot(1,ntrialAfter,itrial)
        h(idp) = line([1:length(dpCond)],P_same,'color',mycolor(idp,:));
    end
end

legend(h,structfld2cell(dpC,'Date'))
set(gca,'xtick',[1:length(dpCond)],'xtickLabel',condlabel)
title(['same ' num2str(itrial) 'trial after'])
%%
plotAnn(sAnnot);

if bsave
    patht = fullfile(rd.Dir.SummaryFig,'CompareStimulatedMatching');
    parentfolder(patht,1)
    saveas(hfig, fullfile(patht,[savefiledesc '.pdf']));
    saveas(hfig, fullfile(patht,[savefiledesc '.fig']));
end



