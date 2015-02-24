function [dpArray fit h]=  plotMLEfit(varargin)
% function [dpArray fit]=  plotMLEfit(varargin)
% e.g dpArray/getStimulated_String,cond,fit_function,free_parameters, bplot,hAx
%
% dpA = plotMLEfit('fi12_1013_3freq',[],'logistic',{'all','slope','bias','l','u','lu'})
%
% BA
rd = brigdefs();
bsave = 1;
bplot = 1;
bploterrorbar = 1;
bdisplayfittext = 1; % in legend
bplotRawdata = 1;

bplotBIC = 1;
bplotN = 1; % in legend

CI = 0.32; % CONFIDENCSE INTERVAL FOR BOOTSTRAPPING 0.05

% note using number_of_fits for different stimulation conditions
if nargin<2 | isstr(varargin{2}) % hack so that if you put a string in it will use this as default
    cond(1).filter = {'stimulationOnCond',0,'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
    cond(1).trialRelativeSweepfilter = {};
    cond(1).color = 'k';
    cond(1).desc = 'ctrl';
    
    cond(2).filter = {'stimulationOnCond',[1 2 3],'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
    cond(2).trialRelativeSweepfilter = {};
    cond(2).color = 'c';
    cond(2).desc = 'stim';
    varargin{2} = []; % hack so that this input arg can be used as condCell in dpArrayInputHelper as well
elseif isempty(varargin{2})
    cond(1).filter = []; % {'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x)};
    cond(1).trialRelativeSweepfilter = {};
    cond(1).color = 'k';
    cond(1).desc = '';
else
    cond = varargin{2};
end

% choose function to fit
fit_function = 'logistic' ;
if length(varargin)>2
    fit_function = lower(varargin{3});
end

% chose free parameters
free_parameters{1} = 'all' ; % by default all parameters are free
if length(varargin)>3
    free_parameters = varargin{4};
end

% default options
bplot = 1;
savefileHeader = '';
bnewfigure = 1;
if nargin >4
    options =  varargin{5};
    
    if isfield(options,'bplot')
        bplot = options.bplot;
    end
    
    if isfield(options,'hAx')
        hAx = options.hAx;
        bnewfigure = 0;
    end
    
    if isfield(options,'savefileHeader')
        savefileHeader = options.savefileHeader;
    end
    
    if isfield(options,'bploterrorbar')
        bploterrorbar = options.bploterrorbar;
    end
    
end


number_fits =max(1,length(cond));

[dpArray]= dpArrayInputHelper(varargin{1:min(length(varargin),2)});
sAnnot =  dpArray(1).collectiveDescriptor ;
if length(dpArray)>1
    dpC =concdp(dpArray);
else
    dpC = dpArray;
end
sAnnot = [ savefileHeader '_' sAnnot];


XL = [min(dpC.IntervalSet) max(dpC.IntervalSet)]*dpC.Scaling(end)/1000 + [-1 1]*0.05*dpC.Scaling(end)/1000; % xrange to plot


savefiledesc = [sAnnot 'mlefit_' fit_function];

% you might need to change these changes to more reasonable values
switch (fit_function)
    
    case 'weibull'
        thr_guess = 0.5;
        slope_guess = 5;
        l_guess = 0.2;
        u_guess = 0.8;
        fn = @weibull;
        u_ub = 1;
        l_ub = 0.8;
    case 'logistic'
        thr_guess = .5;
        slope_guess = .3;
        l_guess = 0.1;
        u_guess = 0.8;
        fn = @logistic;
        u_ub = 1;
        l_ub = 0.5;
        
    case 'logistic2' % use this function if you want to test Y offset (l) independent of Sigmoid amplitude (u)
        thr_guess = .5;
        slope_guess = .3;
        l_guess = 0.2;
        u_guess = 0.6;
        fn = @logistic2;
        u_ub = 1;
        l_ub = 0.3;
        % set bounds for minimization
end

% setup
num_hypothesis_to_test = length(free_parameters);

% Define Free Parameters in fits
for ihyp = 1: num_hypothesis_to_test
    switch (free_parameters{ihyp})  % adding cases herer must be added to settingParamsLLKFit.m as well
        case 'none' % use the same model for all data
            param_guess{ihyp} = [thr_guess slope_guess l_guess u_guess];
            LB{ihyp} = zeros(1,length(param_guess{ihyp}));
            UB{ihyp} = [inf   inf  l_ub  u_ub];
        case 'all'
            param_guess{ihyp} = [repmat(thr_guess, 1,number_fits) ...
                repmat(slope_guess,1,number_fits) repmat(l_guess,1,number_fits) repmat(u_guess,1,number_fits)];
            LB{ihyp} = zeros(1,length(param_guess{ihyp}));
            UB{ihyp} = [inf.*ones(1,number_fits) inf.*ones(1,number_fits) l_ub.*ones(1,number_fits) u_ub.*ones(1,number_fits)];
        case 'bias'
            param_guess{ihyp} = [repmat(thr_guess,1,number_fits) ...
                slope_guess l_guess u_guess];
            LB{ihyp} = zeros(1,length(param_guess{ihyp}));
            UB{ihyp} = [inf inf inf l_ub  u_ub];
        case 'slope'
            param_guess{ihyp} = [thr_guess repmat(slope_guess,1,number_fits) ...
                l_guess u_guess];
            LB{ihyp} = zeros(1,length(param_guess{ihyp}));
            UB{ihyp} = [inf inf inf l_ub  u_ub];
        case 'lu'
            param_guess{ihyp} = [thr_guess slope_guess repmat(l_guess,1,number_fits) ...
                repmat(u_guess,1,number_fits)];
            LB{ihyp} = zeros(1,length(param_guess{ihyp}));
            UB{ihyp} = [inf inf l_ub  l_ub u_ub u_ub];
        case 'l'
            param_guess{ihyp} = [thr_guess slope_guess repmat(l_guess,1,number_fits) ...
                u_guess];
            LB{ihyp} = zeros(1,length(param_guess{ihyp}));
            UB{ihyp} = [inf inf l_ub  l_ub u_ub];
        case 'u'
            param_guess{ihyp} = [thr_guess slope_guess l_guess repmat(u_guess,1,number_fits) ...
                ];
            LB{ihyp} = zeros(1,length(param_guess{ihyp}));
            UB{ihyp} = [inf inf l_ub  u_ub u_ub];
        case 'l slope'
            param_guess{ihyp} = [ thr_guess  slope_guess slope_guess repmat(l_guess,1,number_fits) ...
                repmat(u_guess,1,1)];
            LB{ihyp} = zeros(1,length(param_guess{ihyp}));
            UB{ihyp} = [inf inf inf  l_ub  l_ub u_ub];
        case 'bias slope'
            param_guess{ihyp} = [ thr_guess thr_guess slope_guess slope_guess repmat(l_guess,1,1) ...
                repmat(u_guess,1,1)];
            LB{ihyp} = zeros(1,length(param_guess{ihyp}));
            UB{ihyp} = [inf inf inf inf l_ub   u_ub];
        case 'bias l'
            param_guess{ihyp} = [ thr_guess thr_guess  repmat(slope_guess,1,1) l_guess  l_guess ...
                repmat(u_guess,1,1)];
            LB{ihyp} = zeros(1,length(param_guess{ihyp}));
            UB{ihyp} = [inf inf inf  l_ub   l_ub u_ub];
    end
end


% find MLE params for each hypothesis
for ihypn = 1 : num_hypothesis_to_test
    this_guess = param_guess{ihypn};
    
    for icond = 1 : number_fits
        if ~isempty(cond(icond).filter)
            this_dpC = filtbdata(dpC,0,cond(icond).filter, cond(icond).trialRelativeSweepfilter);
        else
            this_dpC = dpC;
        end
        
        % combine Choices and PM (filter the dpC if you only want one or
        % the other)
        ChoiceANDPM_Long = this_dpC.ChoiceLeft;
        ChoiceANDPM_Long(this_dpC.Premature==1) = 0;
        ChoiceANDPM_Long(this_dpC.PrematureLong==1) = 1;
        
        trialWeight = ones(size(ChoiceANDPM_Long)); % default
        if isfield(this_dpC,'trialWeight')
            trialWeight = this_dpC.trialWeight;
        end
        
        data{icond} = [this_dpC.Interval' ChoiceANDPM_Long' trialWeight'];
    end
    % can weight by ntotal this_dpC.stats.
    options = optimset('TolX',10^-50, 'TolFun', 10^-50, 'MaxFunEvals', 10000); % default for MaxFunEvals is 200*numberofvariables
    [tempparam, fval] = fminsearchbnd(@fitLLK, this_guess, ...
        LB{ihypn},   UB{ihypn} , options, data,  free_parameters{ihypn}, number_fits,fit_function); % all the parameters are constrained between 0 and inf
    
    fit(ihypn).param = tempparam;
    fit(ihypn).llk = -fval;
    fit(ihypn).free_parameters = free_parameters{ihypn};
    fit(ihypn).nfree_parameters = length( this_guess);
    fit(ihypn).ntrials = length( this_dpC.Interval);
    
    fit(ihypn).fit_function = fit_function;
    fit(ihypn).bic =  -2 *fit(ihypn).llk + fit(ihypn).nfree_parameters * log(fit(ihypn).ntrials); %http://en.wikipedia.org/wiki/Bayesian_information_criterion
end

if bplot
    %% plotting
    if bnewfigure
        %         hfig = figure('Position',[    38         103        1760         863],'Name',savefiledesc); % dimensions are good for 2,2 figure
        hfig = figure('Position',[   38   103   559   863],'Name',savefiledesc); % dimensions are good for 2,2 figure
    else
        hfig = gcf;
    end
    
    for ihypn = 1 : num_hypothesis_to_test
        if bnewfigure
            if num_hypothesis_to_test ==1
                nc = 1;
            else
                nc = 2;
            end
            hAx = subplot(ceil(num_hypothesis_to_test/2),nc,ihypn);
        end
        [thr, slope, l, u] = settingParamsLLKFit(fit(ihypn).param, fit(ihypn).free_parameters, number_fits);
        for icond = 1 : number_fits
            if ~isempty(cond(icond).filter)
                this_dpC = filtbdata(dpC,0,cond(icond).filter, cond(icond).trialRelativeSweepfilter);
            else
                this_dpC = dpC;
            end
            if this_dpC.ntrials
                if bploterrorbar % this probably shouldn't be in this function
                    this_dpC = addBootStrap(this_dpC,CI);
                    y = this_dpC.fracLongMean;
                    fit(ihypn).fracLong(icond,:) = y;
                    fit(ihypn).fracLongCI(:,:,icond) = this_dpC.fracLongCI;
                    fit(ihypn).IntervalSet = this_dpC.IntervalSet;
                    
                    if bplotRawdata
                        try
                            h.hle = errorbar(hAx,this_dpC.IntervalSet*this_dpC.Scaling(end)/1000,y,this_dpC.fracLongCI(1,:)-y,this_dpC.fracLongCI(2,:)-y,'color',cond(icond).color );
                            hold on;
                            set(h.hle,'Parent',hAx);
                            set(h.hle,'LineStyle','none','Marker','.','MarkerSize',15)
                            h.he = get(h.hle, 'Children');
                            h.he =  h.he(2);% Second handle is the handle to the error bar lines
                            set(h.he,'linewidth',1.5)
                        catch ME
                            getReport(ME)
                            h.hle = [];
                            h.he = [];
                        end
                    end
                else
                    line(this_dpC.stats.IntervalSet*this_dpC.Scaling(end)/1000,this_dpC.stats.frac.choiceLong,'linestyle','none','Marker','.','color',cond(icond).color,'parent',hAx);hold all
                end
                fx = [0:0.001:1];
                x = [0:dpC.Scaling(end)/1000/(length(fx)-1):dpC.Scaling(end)/1000];
                h.hl2(icond) = line(x,fn([slope(icond),thr(icond),l(icond),u(icond)],fx),'linestyle','-','color',cond(icond).color,'linewidth',1.5);
                stemp = '';
                if bdisplayfittext,                stemp = num2str([slope(icond),thr(icond),l(icond),u(icond)],'%1.2f '); end
                s{icond} = [stemp cond(icond).desc];
                if bplotN,s{icond} = [ s{icond} ' n=' num2str(this_dpC.ntrials)]; end
            end
        end
        title([fit(ihypn).fit_function ' ' fit(ihypn).free_parameters])
        
        if 0 % plot all intervals
            set(hAx,'XTick',dpC.IntervalSet*dpC.Scaling(end)/1000,'XTickLabel',cellfun(@(x) num2str(x,' %1.1f'),num2cell(dpC.IntervalSet*dpC.Scaling(end)/1000),'UniformOutput',false))
            rotateXLabels(gca,40);
        else % plot first, last and boundry
            xticklabels = cellfun(@(x) num2str(x,' %1.1f'),num2cell(dpC.IntervalSet*dpC.Scaling(end)/1000),'UniformOutput',false);
            xticklabels{end+1} = xticklabels{end};
            for i = 2: length(xticklabels)-1, xticklabels{i} = ''; end
            xticklabels{length(dpC.IntervalSet)/2+1} = num2str(dpC.Scaling(end)/1000/2);
            
            set(hAx,'XTick',sort([dpC.IntervalSet 0.5]*dpC.Scaling(end)/1000) ,'XTickLabel',xticklabels)
        end
        
        set(hAx,'YTick',[0 0.5 1] ,'YTickLabel',{'0','0.5','1'})
        set(hAx,'Linewidth',1)

        axis(hAx,'square')
        defaultAxes(hAx,[],[],12);
        xlim(XL)
        ylim([0 1])
        
        if bplotBIC
            h.htext = text(0.05,0.95,['BIC = ' num2str(fit(ihypn).bic,'%1.0f')],'Fontsize',7);
        end
        h.hleg = legend(h.hl2,s,'Fontsize',7,'Location','SouthEast');
        legend(h.hleg,'boxoff')
        defaultLegend(h.hleg,'SouthEast');
        
    end
    
    if bnewfigure
        plotAnn(sAnnot);
    end
    
    
    if bsave
        patht = fullfile(rd.Dir.SummaryFig,'MLEfits',dpC.Animal);
        parentfolder(patht,1)
        orient tall
        export_fig(hfig, fullfile(patht,[savefiledesc]),'-pdf','-transparent');
        saveas(hfig, fullfile(patht,[savefiledesc '.fig']));
    end
end