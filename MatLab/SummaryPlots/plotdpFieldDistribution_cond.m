function [dpArray options h]=  plotdpFieldDistribution_cond(varargin)
% this function is for comparing the distribution of something like
% Reaction times stimulated vs unstimulated (see below for example
% condfilter, condfilter currently must have 4 entries
%
% varargin{1} = A or dpArray
% varargin{2} = condGroup
% varargin{3} = fld
% varargin{4} = options.bSplitByInterval
%           options.bsave
%           options.nbins
%           options.plottype e.g. 'cdf', 'pdf', 'median', 'mean'
%           options.sAnnot
%

% icondfilter = 1;
% fld(1).condfilter(icondfilter).desc  = 'Stim Correct';
% fld(1).condfilter(icondfilter).fldname  = 'ReactionTime';
% fld(1).condfilter(icondfilter).fsweep = {'stimulationOnCond',[1 2 3],'ChoiceCorrect',[1]};
% fld(1).condfilter(icondfilter).fsweepTrial = {};
% fld(1).condfilter(icondfilter).scolor = 'b';
%
% icondfilter = 2;
% fld(1).condfilter(icondfilter).desc  = 'Ctrl Correct';
% fld(1).condfilter(icondfilter).fldname  = 'ReactionTime';
% fld(1).condfilter(icondfilter).fsweep = {'stimulationOnCond',[0],'ChoiceCorrect',[1]};
% fld(1).condfilter(icondfilter).fsweepTrial = {};
% fld(1).condfilter(icondfilter).scolor = 'k';
%
% icondfilter = 1;
% fld(2).condfilter(icondfilter).desc  = 'Stim Error';
% fld(2).condfilter(icondfilter).fldname  = 'ReactionTime';
% fld(2).condfilter(icondfilter).fsweep = {'stimulationOnCond',[1 2 3],'ChoiceCorrect',[0]};
% fld(2).condfilter(icondfilter).fsweepTrial = {};
% fld(2).condfilter(icondfilter).scolor = '--b';
%
% icondfilter = 1;
% fld(2).condfilter(icondfilter).desc  = 'Ctrl Error';
% fld(2).condfilter(icondfilter).fldname  = 'ReactionTime';
% fld(2).condfilter(icondfilter).fsweep = {'stimulationOnCond',[0],'ChoiceCorrect',[0]};
% fld(2).condfilter(icondfilter).fsweepTrial = {};
% fld(2).condfilter(icondfilter).scolor = '--k';

fld = varargin{3};
% defaults
bSplitByInterval = 0;
nbin = 30;
bsave = 1;
plottype = 'median'; %'cdf','pdf','mean' ; % will plot cumdist

sAnnot  = '';
h.hfig = [];
if nargin>3
    options = varargin{4};
    if isfield(options,'bSplitByInterval')
        bSplitByInterval = options.bSplitByInterval;
    end
    if isfield(options,'bsave')
        bsave = options.bsave;
    end
    if isfield(options,'nbins')
        nbins = options.nbins;
    end
    if isfield(options,'sAnnot')
        sAnnot = options.sAnnot;
    end
    if isfield(options,'plottype')
        plottype = options.plottype;
    end
    if isfield(options,'h')
        h = options.h;
    end
end

rd = brigdefs();

% bplotDiff

[dpArray condfilterCell]= dpArrayInputHelper(varargin{1:2});

dpC =concdp(dpArray);
%%
sAnnot =  [sAnnot dpC.collectiveDescriptor  '_' plottype '_' fld(1).fldname] ;


if isempty(h.hfig)
    h.hfig = figure;
end
    

set(h.hfig ,'Name',[sAnnot '_' fld(1).fldname],'NumberTitle','off'...
    ,'Position',[ 680    49   806   947]);

h.hJl = [];

nfld = length(fld);% this is the number of fields that will be compared
ncondfilter = 2; % each fld must have 2 conditions (could be increased later)

nIntv = 1;

% Figure Setup
nr = 1; nc = 1; bnewplotforEachField = 0;
if ismember(plottype,{'cdf','pdf'}), bnewplotforEachField = 1;  bplotSimple= 0;end% new plot for each field
if bnewplotforEachField, nr = nfld;
else        nr = 2; end

if bSplitByInterval
    nIntv = length(dpC.IntervalSet);
    nc = length(dpC.IntervalSet)/2;
    if bnewplotforEachField, nr = nfld*2;
    else        nr = 2; end

end

for ifld = 1:nfld
    fldname = fld(1).fldname;
    
    condfilter = fld(ifld).condfilter;
    clear sleg
    for iInt = 1:nIntv
        clear pdf dist  condfilterdp;
        for icondfilter = 1:ncondfilter
            
            
            thisfsweep = condfilter(icondfilter).fsweep;
            if bSplitByInterval
                thisfsweep(end+1:end+2) = {'Interval',dpC.IntervalSet(iInt)};
            end
            condfilterdp(icondfilter) = filtbdata(dpC,0,thisfsweep,condfilter(icondfilter).fsweepTrial);
            
            dist{icondfilter} = condfilterdp(icondfilter).(fldname)/1000;
            %     if icondfilter==1
            [a x] = hist(condfilterdp(icondfilter).(fldname),nbin);
            
            if bnewplotforEachField,plotInd = iInt+(ifld-1)*nIntv;
            else plotInd = iInt; end
                
                h.hAx(plotInd) =  subplot(nr,nc,plotInd);

            md(icondfilter) = nanmedian(dist{icondfilter});
            m(icondfilter) = nanmean(dist{icondfilter});
            
            switch (plottype)
                case 'pdf'
                    
                    pdf(icondfilter,:) = a/sum(a);
                    plot(x,pdf(icondfilter,:),condfilter(icondfilter).scolor); hold all
                    sleg{icondfilter} = [condfilter(icondfilter).desc ' n= '  num2str(condfilterdp(icondfilter).ntrials)];
                    axis tight
                case 'cdf'
                    A = cumsum(a);
                    A = A/max(A);
                    plot(x,A,condfilter(icondfilter).scolor); hold all
                    sleg{icondfilter} = [condfilter(icondfilter).desc ' n= '  num2str(condfilterdp(icondfilter).ntrials)];
                    axis tight
                    
                otherwise
                    sleg = {};
            end
            
        end
        %
        [stats(ifld).KS.H, stats(ifld).KS.pValue, stats(ifld).KS.KSstatistic] = kstest2(dist{1}, dist{2});
        
        switch (plottype)
            case 'median'
                yplot = md;
                bplotSimple = 1;
            case 'mean'
                yplot = m;
                bplotSimple = 1;
            otherwise
        end
        
        if  bplotSimple
            [~, h.hJl(ifld)] = plotJoinLine(yplot(1),yplot(2),[1 2]+(2*(ifld-1)),h.hAx(plotInd) );
            set(h.hJl(ifld),'Marker','o','MarkerEdgeColor',condfilter(icondfilter).scolor)
            if stats(ifld).KS.H % color in center of significant differences
                set(h.hJl(ifld),'Marker','o','MarkerFaceColor',condfilter(icondfilter).scolor)
            end
            xname{ifld} = fld(ifld).desc;
        else
            
            if bSplitByInterval, s = num2str(dpC.IntervalSet(iInt),'%1.2f');
            else s= ''; end
            if bSplitByInterval
                if iInt==1,                s = fld(ifld).desc; end
                setTitle(h.hAx(plotInd),[s ' p_{KS} = ' num2str(stats(ifld).KS.pValue,'%1.2g')],7)
            else
                setTitle(h.hAx(1+(ifld-1)*nIntv),[s ' p_{KS} = ' num2str(stats(ifld).KS.pValue,'%1.2g')],7)
            end
        end
        
    end
    if ismember(plottype,{'cdf','pdf'})
        h.hleg(ifld) = legend(h.hAx(1+(ifld-1)*nIntv),sleg);
        setXLabel(h.hAx(1+(ifld-1)*nIntv),[fldname '(s)' ])
        
    else        h.hleg = []; end
    
    
    
end

% TO DO ADD XLABELS
if ismember(plottype,{'cdf','pdf'})
    setAxEq(h.hAx,'x')
elseif bplotSimple
    set(h.hAx,'xtick',[1.5:2:length(xname)*2],'xticklabel',xname)
end
defaultAxes(h.hAx);
for ifld = 1:length(h.hleg)
    defaultLegend(h.hleg(ifld),[],7);
end

h.hAnn = plotAnn(sAnnot);

options.savefiledesc = [ sAnnot '_'  ];
if bSplitByInterval
    options.savefiledesc = [options.savefiledesc 'byInterval'];
end

if bsave
    patht = fullfile(rd.Dir.SummaryFig,fldname,dpC.Animal);
    parentfolder(patht,1)
    orient tall
    export_fig(h.hfig, fullfile(patht,[options.savefiledesc]),'-pdf','-transparent');
    saveas(h.hfig, fullfile(patht,[options.savefiledesc '.fig']));
end

options.sAnnot = sAnnot;
