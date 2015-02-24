function dpArray = stimulation_probSamePort(varargin)
% This function is for testing dp of MATCHING task
% A figure of the the probabilty of picking the same port  after 

% condCell.condGroup = {2 3};
% condCell.condGroupDescr  = '2 3';

rd = brigdefs();
bsave = 0;
% bforfigure = 0;


ntrialAfter = 2; 


% average psyc points across days.
if isstruct(varargin{1})
    dpArray = varargin{1};
    if ~isfield(dpArray,'collectiveDescriptor')
        dpArray(1).collectiveDescriptor = dpArray(1).Animal;
    end
else
    A = varargin{1}; % 'sert867_lgcl';    
    if iscell(A)
        A = A{1};
    end
    [exptnames trials] = getStimulatedExptnames(A);
    dpArray = constructDataParsedArray(exptnames, trials);
    dpArray(1).collectiveDescriptor = A ;
    
end

if nargin==2
    cond =  varargin{2};
    condCell = cond.condGroup;
    sAddToCollectiveDescriptor = cond.condGroupDescr;
else % default
    condCell = 'all'; % group Stimulations conditions accordingly
    sAddToCollectiveDescriptor = '_';
end

if  ~strcmpi(dpArray(1).Protocol,'matching')
    warning('This function is designed for the MATCHING task');
end

dpArray(1).collectiveDescriptor = [dpArray(1).collectiveDescriptor sAddToCollectiveDescriptor];
sAnnot =  dpArray(1).collectiveDescriptor ;

savefiledesc = [ sAnnot '__Stimulation_ProbSamePort' ];

% probability of choosing after LIGHT
%%


dpC =concdp(dpArray);
[dpCond] = getdpCond(dpC,condCell);
dpCond = dpCond(end:-1:1);
hfig = figure('Position',[837   535   733   380]);


%%


ntrialAfter = 1;
clear P_same condlabel N
for itrial = 1: ntrialAfter;
    
    for icond = 1:length(dpCond);
        dpL = filtbdata(dpC,0,{'ChoiceLeft',1,'stimulationOnCond',unique(dpCond(icond).stimulationOnCond)});
        dpR = filtbdata(dpC,0,{'ChoiceLeft',0,'stimulationOnCond',unique(dpCond(icond).stimulationOnCond)});
        
        dpAfterL_L=  filtbdata(dpC,0,{'TrialNumber',dpL.absolute_trial+itrial,'ChoiceLeft',1});
        dpAfterL_R=  filtbdata(dpC,0,{'TrialNumber',dpL.absolute_trial+itrial,'ChoiceLeft',0});
        
        dpAfterR_L=  filtbdata(dpC,0,{'TrialNumber',dpR.absolute_trial+itrial,'ChoiceLeft',1});
        dpAfterR_R=  filtbdata(dpC,0,{'TrialNumber',dpR.absolute_trial+itrial,'ChoiceLeft',0});
        
        P_same(icond) = (dpAfterL_L.ntrials/dpL.ntrials +dpAfterR_R.ntrials/dpR.ntrials)/2;
        N(icond,:) = [dpAfterL_L.ntrials dpL.ntrials dpAfterR_R.ntrials dpR.ntrials];
        condlabel{icond} = num2str(unique(dpCond(icond).stimulationOnCond));
    end

    subplot(1,ntrialAfter,itrial)
    plot([1:length(dpCond)],P_same);
    set(gca,'xtick',[1:length(dpCond)],'xtickLabel',condlabel)
    title(['same ' num2str(itrial) 'trial after'])
end

plotAnn(sAnnot);

%%
if bsave
    patht = fullfile(rd.Dir.SummaryFig);
    parentfolder(patht,1)
    saveas(hfig, fullfile(patht,[savefiledesc '.pdf']));
    saveas(hfig, fullfile(patht,[savefiledesc '.fig']));
end







