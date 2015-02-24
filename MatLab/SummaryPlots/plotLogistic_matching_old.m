function [dpArray, glm, BIC] = plotLogistic_matching(varargin)
% function [dpArray fit BIC] = plotLogistic_tafc(dpA/name, condCell,modelnumber(imodel),regularize)
% This function is for testing dp of Timing task
% A figure of the the probabilty of picking the same port  after

% to algorithm to determine what level to put the penalty parameter.
rd = brigdefs();
bsave = 1;
% bforfigure = 0;

stimCond = [1 2 3]; % hack so that different light conditions are grouped
stimoffCond = 0;

trialsBack = 5; % Then number of trial before the current trial to include in the model
regularization = 1;


% pick which algorithms to use
buseMatlab = 1;                 Ncrossvalid = 20; % for regularized with Matlab
buse_glmnet = 0;                 L1_penalty = .001; % for glmnet
v = ver('Matlab');
if regularization & all(str2num( v.Version) < 8.1) % older versions of matlab statistical toobox don't have the regularized regression function
    buse_glmnet = 1;  % This is much faster TOO !!!!
    disp(' older version of matlab: using glmnet.m for regularized regression');
end

dpArray = dpArrayInputHelper(varargin{1:min(length(varargin),1)});
if  ~strcmpi(dpArray(1).Protocol,'matching')
    warning('This function is designed for the matching task');
end

if length(varargin)<3
    modelnumber = 1;
else
    modelnumber = varargin{3};
end

if length(varargin)<4
    regularization = 1;
else
    regularization = varargin{4};
end

% for testing whether light effect is real
if length(varargin)<5
    brandomizeStimulation = 0; bplotaverage=0;
else
    brandomizeStimulation = varargin{5}; bplotaverage=varargin{5};
end

dpC =concdp(dpArray);

% first order remove all NaN from ChoiceLeft and pretend they don't happen
%  Note: small mystery what are the other trials that are NaN in ChoiceLeft which
% are not ChoiceMiss
%
dp_valid = filtbdata(dpC,0,{'ChoiceLeft',@(x) ~isnan(x),'RwdMiss',0,'stimulationOnCond',[stimoffCond stimCond]});
% exclude light conditions that are wanted
% NOTE: by removing trials we are making it even harder to create a good
% model of the data but seems easier for now (otherwise need regressors for
% controlLopps etc


%% define models
models{1} = {'bias','dRew', 'dNoRew' , 'dLight'};
models_nterms{1} = [1 trialsBack trialsBack trialsBack ];
model_name{1}= 'RewNoRewLight';

models{2} = {'bias','dRew', 'dNoRew' , 'ChLLight','ChRLight'};
models_nterms{2} = [1 trialsBack trialsBack trialsBack trialsBack];
model_name{2}= 'RewNoRew_LRLight';

models{3} = {'bias', 'dChoice', 'dRew', 'dNoRew' , 'dLight'};
models_nterms{3} = [1 trialsBack trialsBack trialsBack trialsBack];
model_name{3} = 'ChioceRewLight';

% with CorrectAndLight
models{4} = {'bias', 'ChoiceL','ChoiceR','RewL','RewR','noRewL','noRewR', 'ChLLight','ChRLight'}; % a parameter for each stimulus
models_nterms{4} = [1   trialsBack trialsBack trialsBack trialsBack trialsBack  trialsBack trialsBack trialsBack];
model_name{4} =  'Lots';



%%
for imodel =  1:length(modelnumber)
    
    if brandomizeStimulation
        if 0
            % randomize the stimulation as a control
            N = sum(dp_valid.stimulationOnCond>0)/length(dp_valid.stimulationOnCond);
            dp_valid.stimulationOnCond = rand(size(dp_valid.stimulationOnCond))<N;
        else
            % randomize the stimulation as a control
            dp_valid.stimulationOnCond = circshift(dp_valid.stimulationOnCond,[1 round(rand(1)*500)]);
        end
    end
    paramlabels = models{modelnumber(imodel)};
    
    savefiledesc = [ dpArray(1).collectiveDescriptor '__logisticReg_' model_name{modelnumber(imodel)} '_L' num2str(regularization)  ];
    sAnnot = [dpArray(1).collectiveDescriptor '_L' num2str(regularization) ' ' model_name{modelnumber(imodel)}];
    
    if brandomizeStimulation             % randomize the stimulation as a control
        if 0
            N = sum(dp_valid.stimulationOnCond>0)/length(dp_valid.stimulationOnCond);
            dp_valid.stimulationOnCond = rand(size(dp_valid.stimulationOnCond))<N;
        else
            dp_valid.stimulationOnCond = circshift(dp_valid.stimulationOnCond,[1 round(rand(1)*500)]);
        end
        savefiledesc = [savefiledesc '_randStim'];
        sAnnot = [sAnnot '_randStim'];
    end
    ntrials = length(dp_valid.ChoiceLeft);
    LeftChoice  = dp_valid.ChoiceLeft;
    RightChoice = double(dp_valid.ChoiceLeft==0);
    LeftRew = LeftChoice & dp_valid.Rewarded;
    RightRew = RightChoice & dp_valid.Rewarded;
    LeftNoRew = LeftChoice & ~dp_valid.Rewarded;
    RightNoRew = RightChoice & ~dp_valid.Rewarded;
    LeftLight = LeftChoice & ismember(dp_valid.stimulationOnCond,stimCond);
    RightLight = RightChoice & ismember(dp_valid.stimulationOnCond,stimCond);
    
    deltaChoice = RightChoice - LeftChoice ;
    deltaReward = RightRew - LeftRew;
    deltaNoReward = RightNoRew - LeftNoRew;
    deltaLight = RightLight - LeftLight;
    
    y = RightChoice;  % y is observations (in this case choices)
    
    % X is a matrix with rows corresponding to observations, and columns to predictor variables
    % from Lau DOI: 10.1901/jeab.2005.110-04
    % deltaChoice i-n, ...  deltaChoice i-1, deltaReward i-n, ... deltaReward
    % i-1,
    % where deltaChoice = choiceR - choice and deltaReward = rewardR - rewardL
    
    
    
    % nparameterTypes = sum(models_nterms;
    
    % X = nan(dp_valid.ntrials-trialsBack,(nparameterTypes-1)*(trialsBack) +1);
    %
    clear X
    for itrial = trialsBack+1:dp_valid.ntrials
        
        % pick model
        switch(modelnumber(imodel))
            case 1
                %             models{1} = {'bias','dRew', 'dNoRew' , 'dLight'};
                % models_nterms{1} = [1 trialsBack trialsBack trialsBack ];
                % model_name{1}= 'RewNoRewLight';
                X(itrial,:) = [
                    deltaReward(itrial-trialsBack:itrial-1)...
                    deltaNoReward(itrial-trialsBack:itrial-1)...
                    deltaLight(itrial-trialsBack:itrial-1)...
                    ];
            case 2
                %             models{1} = {'bias','dRew', 'dNoRew' , 'dLight'};
                % models_nterms{1} = [1 trialsBack trialsBack trialsBack ];
                % model_name{1}= 'RewNoRewLight';
                X(itrial,:) = [
                    deltaReward(itrial-trialsBack:itrial-1)...
                    deltaNoReward(itrial-trialsBack:itrial-1)...
                    LeftLight(itrial-trialsBack:itrial-1),...
                    RightLight(itrial-trialsBack:itrial-1),...
                    ];
            case 3
                %                 models{2} = {'bias', 'dChoice', 'dRew', 'dNoRew' , 'dLight'};
                %                 models_nterms{2} = [1 trialsBack trialsBack trialsBack trialsBack];
                %                 model_name{2} = 'ChioceRewLight';
                
                X(itrial,:) = [
                    deltaChoice(itrial-trialsBack:itrial-1)...
                    deltaReward(itrial-trialsBack:itrial-1)...
                    deltaNoReward(itrial-trialsBack:itrial-1)...
                    deltaLight(itrial-trialsBack:itrial-1)...
                    ];
            case 4
                % % with CorrectAndLight
                % models{3} = {'bias', 'ChoiceL','ChoiceR','RewL','RewR','noRewL','noRewR', 'ChLLight','ChRLight'}; % a parameter for each stimulus
                % models_nterms{3} = [1   trialsBack trialsBack trialsBack trialsBack trialsBack  trialsBack trialsBack trialsBack];
                % model_name{3} =  'Lots';
                
                X(itrial,:) = [LeftChoice(itrial-trialsBack:itrial-1),...
                    RightChoice(itrial-trialsBack:itrial-1),...
                    LeftLight(itrial-trialsBack:itrial-1),...
                    RightLight(itrial-trialsBack:itrial-1),...
                    LeftRew(itrial-trialsBack:itrial-1),...
                    RightRew(itrial-trialsBack:itrial-1),...
                    LeftNoRew(itrial-trialsBack:itrial-1),...
                    RightNoRew(itrial-trialsBack:itrial-1),...
                    ];
                
                
            otherwise
                error('unknown model')
        end
        
    end
    %% do logistic regression
    BIC(imodel) = NaN;
    LLK = NaN;
    switch (regularization)
        case 0
            [this_beta,fit] = glmfit(X,y','binomial','link','logit');
            
        case 1
            if  buse_glmnet
                
                %     tempy = y' +1;fit = glmnet(X, tempy, 'binomial');
                this_beta =  glmnetCoef(fit,L1_penalty);
            elseif 0
                % this is another algorithm that also alows L2, the penalties
                % work differently and the results are marginally different,
                % but I don't understand it so not usingit
                % liblinear (National Taiwan University)
                [model]= train(y'+1, sparse(X) ,['-s 5 -c ' num2str(L1_penalty) '  -B 1']);
                this_beta = model.w';
                this_beta = [this_beta(end); this_beta(1:end-1)];% put bias in same spot as the other functions
            else
                options = statset('lassoglm'); options.UseParallel = 'true';
                if Ncrossvalid
                    [this_betaNoIntercept,fit] = lassoglm(X,y','binomial','link','logit','options',options,'CV', Ncrossvalid,'NumLambda',20);                    
                      indx = fit.Index1SE;
                    
                else
                    [this_betaNoIntercept,fit] = lassoglm(X,y','binomial','link','logit','options',options,'NumLambda',20);
                    indx = 1; % length(fit.Lambda); % take the lowest lambda by default when no CV
                end
                %             indx = fit.IndexMinDeviance; % pick the Beta that is the minimum LLK
                nlambda = length(fit.Intercept); % lambda is the cost of adding weights
                for ilambda = 1:nlambda % calculate BIC
                    this_nparams =sum(abs(this_betaNoIntercept(:,ilambda))>0.001); % number of non-zero parmaters Note doesn't seem to make much difference
                end
                fit.BIC = 2*fit.Deviance +this_nparams*log(ntrials); % not fit.Deviance is the log-likelihood
                LLK(imodel) = -1*fit.Deviance(:,indx) ;
                BIC(imodel) = fit.BIC(:,indx);
                this_beta = [fit.Intercept(:,indx); this_betaNoIntercept(:,indx)];
                betaNoIntercept{imodel} = this_betaNoIntercept;

            end
    end
    beta{imodel} = this_beta;
    glm{imodel} = fit;
end
% plotting
if bplotaverage & brandomizeStimulation
    % Used for multiple runs of the same model (e.g. if laser stimulation
    % time is randomally permuted repeatedly)
    % this only works if the same model is repeatedly run
    temp = cell2mat(beta);
    
    % get percentile of betas
    p = 95;
    for iparam = 1:size(temp,1)
        betaci(iparam,:) = prctile(temp(iparam,:),[100-p p]);
    end
    modelnumbertoplot = modelnumber(1);
    
    clear beta
    beta{1} = mean(temp')';
else
    modelnumbertoplot = modelnumber;
end
  %%  
for imodel =  1:length(modelnumbertoplot)
    if buseMatlab & regularization & Ncrossvalid>0
        hfig = figure('Name',['LassoPlot' sAnnot]);
        ax = subplot(1,2,1);
        lassoPlot(betaNoIntercept{imodel},fit,'PlotType','CV','Parent',ax);
        hfig = gcf;
        ax = subplot(1,2,2);
        plot(fit.BIC(end:-1:1));
        title ('BIC');
   
        plotAnn(sAnnot);
        
        patht = fullfile(rd.Dir.SummaryFig,'Logistic Regression');
        parentfolder(patht,1)
        saveas(hfig, fullfile(patht,[savefiledesc '_LassoPlot' '.pdf']));
        saveas(hfig, fullfile(patht,[savefiledesc '_LassoPlot' '.fig']));
    end
    %%
    nterms = models_nterms{modelnumbertoplot(imodel)};
    nparameterTypes = length(nterms)-1;
    
    Xb0 = [ones(size(X,1),1) X ] ; % add colum for the constent term in the fit
    
    if ~buseMatlab
        PrightAll = 1./(1+exp(-Xb0 * beta{imodel})); % compute probabilty of choice Right using all regression parameters
    else
        [PrightAll]= glmval(beta{imodel},X,'logit');
        %     ybool = y==1;    Xbool = X==1;
        %     predictors = find(beta{imodel}(2:end)); % indices of nonzero predictors
        %     mdl = fitglm(Xbool,ybool','linear',...
        %         'Distribution','binomial','PredictorVars',predictors,'link','logit');
    end
    %  action value
    actionValue = Xb0 * beta{imodel}; % Correct this
    [actionValue ind] = sort(actionValue);
    N = 100; kernel = ones(1,N)/N;
    y_filt = filter(kernel,1,[nan(1,N+1) y(ind)]);
    actionValue_filt = filter(kernel,1,[nan(1,N+1) actionValue']);
    PrightAll_filt =filter(kernel,1,[nan(1,N+1)  PrightAll(ind)']);
    
    % %% plotting
    hfig = figure('Position',[ 451         163        1397         739],'Name',['LogReg ' sAnnot]);
    
    nc = 3;
    nr = 2;
    % plot raw data vs prediction  across time
    subplot(nr,nc,[1 2])
    N = 3; kernel = ones(1,N)/N;
    plot(filter(kernel,1,[nan(1,N+1)  y]),'LineWidth',1,'color','r'); hold on
    plot(PrightAll,'LineWidth',1,'color','b'); hold on;
    axis tight
    defaultAxes
    % plot raw data vers prediction
    subplot(nr,nc, 3)
    plot(PrightAll_filt,y_filt,'.')
    xlabel('Predicted Choice')
    ylabel('Actual Choice');
    ylim([0 1])
    xlim([0 1])
    defaultAxes
    title(['BIC ' num2str( BIC(imodel) ,'%1.0f') ' LogLk:'  num2str(LLK(imodel),'%1.0f')]);
    
    subplot(nr,nc,4)
    plot(actionValue_filt,y_filt,'.')
    xlabel('Action Value ')
    ylabel('Actual Choice');
    defaultAxes
    
    
    % plot Beta coeffecients and P-values
    subplot(nr,nc,[5 6]); cla;
    offset = 1;
    for iParam = 1:nparameterTypes+1
        termsbefore = sum(nterms(1:iParam-1));
        ind = [1+termsbefore:termsbefore+nterms(iParam)];
        if exist('betaci','var')
            errorbar(offset*(iParam-1)+ind,beta{imodel}(ind),betaci(ind,1),betaci(ind,2)); hold on;
        else
            plot(offset*(iParam-1)+ind,beta{imodel}(ind),'.-'); hold on;
        end
        if isfield(fit,'p')
            plot(offset*(iParam-1)+ind,fit.p(ind),'-k','linewidth',1); hold on;
        end
    end
    
    xval = [1 cumsum(nterms(2:end))+offset*[1:nparameterTypes]];
    set(gca,'xtick',xval,'xticklabel',paramlabels);
    rotateXLabels( gca, 45 )
    
    defaultAxes(gca,[],[],10)
    axis tight
    plotAnn(sAnnot);
    plotAnn(['n = ' num2str(ntrials) ' nSess = ' num2str(length(dpArray))],gcf,5)
    
    if bsave
        % save the data in the figure
        figdata.fit = fit;
        guidata(hfig,figdata);
        
        
        patht = fullfile(rd.Dir.SummaryFig,'Logistic Regression');
        parentfolder(patht,1)
        saveas(hfig, fullfile(patht,[savefiledesc '.pdf']));
        saveas(hfig, fullfile(patht,[savefiledesc '.fig']));
    end
    
end


