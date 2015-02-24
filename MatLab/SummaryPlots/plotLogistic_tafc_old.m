function [dpArray glm BIC] = plotLogistic_tafc(varargin)
% function [dpArray fit BIC] = plotLogistic_tafc(dpA/name, condCell,modelnumber(imodel),regularize)
% This function is for testing dp of Timing task
% A figure of the the probabilty of picking the same port  after

% to algorithm to determine what level to put the penalty parameter.
rd = brigdefs();
bsave = 1;
% bforfigure = 0;

stimCond = [1 2 3]; % hack so that different light conditions are grouped
stimoffCond = 0;

trialsBack = 2; % Then number of trial before the current trial to include in the model
regularization = 1;

% pick which algorithms to use
buseMatlab = 1;
buse_glmnet = 0;                 L1_penalty = .001; % for glmnet 
v = ver('Matlab');
if regularization & all(str2num( v.Version) < 8.1) % older versions of matlab statistical toobox don't have the regularized regression function
    buse_glmnet = 1;  % This is much faster TOO !!!!
    disp(' older version of matlab: using glmnet.m for regularized regression');
end

dpArray = dpArrayInputHelper(varargin{1:min(length(varargin),1)});
if  ~strcmpi(dpArray(1).Protocol,'tafc')
    warning('This function is designed for the TAFC task');
end

if length(varargin)<3
    modelnumber = 4;
else
    modelnumber = varargin{3};
end

if length(varargin)<4
    regularization = 1;
else
    regularization = varargin{4};
end


nstimuli = length(dpArray(1).IntervalSet);

dpC =concdp(dpArray);

% first order remove all NaN from ChoiceLeft and pretend they don't happen
%  Note: small mystery what are the other trials that are NaN in ChoiceLeft which
% are not ChoiceMiss
%
dp_valid = filtbdata(dpC,0, 'ChoiceCorrect', [0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x),'stimulationOnCond', [stimoffCond stimCond]);
% exclude light conditions that are wanted

% NOTE: by removing trials we are making it even harder to create a good
% model of the data but seems easier for now (otherwise need regressors for
% controlLopps etc

%% define models
models{1} = {'bias','stimN'};
models_nterms{1} = [1 nstimuli ];
model_name{1}= 'stimuli';

models{2} = {'bias','stimN', 'dChoice', 'dRew', 'dNoRew' , 'dLight'};
models_nterms{2} = [1 nstimuli trialsBack trialsBack trialsBack trialsBack];
model_name{2} = 'stimuliChioceRewLight';

% with CorrectAndLight
models{3} = {'bias','stimN', 'ChoiceL','ChoiceR','Cor-2','Cor-1','Er-2','Er-1', 'ChLLight','ChRLight','CorLight-2','CorLight-1', 'ErLight-2','ErLight-1', 'Light-1','Light'}; % a parameter for each stimulus
models_nterms{3} = [1  nstimuli trialsBack trialsBack nstimuli nstimuli nstimuli  nstimuli trialsBack trialsBack nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli];
model_name{3} =  'Lots';

% with CorrectAndLight and 2 errors in a row
models{4} = {'bias','stimN', 'ChoiceL','ChoiceR','Cor-2','Cor-1','Er-2','Er-1','doubleEr-1', 'ChLLight','ChRLight','CorLight-2','CorLight-1', 'ErLight-2','ErLight-1', 'Light-2', 'Light-1','Light'}; % a parameter for each stimulus
models_nterms{4} = [1  nstimuli trialsBack trialsBack nstimuli nstimuli nstimuli nstimuli nstimuli trialsBack trialsBack nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli];
model_name{4} = 'KitchenSink';
% models{6} = {'bias','stimN', 'ChoiceL','ChoiceR','ChLeft-2', 'ChLeft-1' , 'ChRight-2', 'ChRight-1','Cor-2','Cor-1','doubleEr', 'Er-2','Er-1','CorLight-2','CorLight-1', 'ErLight-2','ErLight-1', 'Light-1','Light'}; % a parameter for each stimulus
% models_nterms{6} = [1  nstimuli trialsBack trialsBack nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli];


%%
for imodel =  1:length(modelnumber)
    paramlabels = models{modelnumber(imodel)};
    
    sAnnot =  dpArray(1).collectiveDescriptor ;
    savefiledesc = [ sAnnot '__logisticReg_' model_name{modelnumber(imodel)} '_L' num2str(regularization) ];
    sAnnot = [sAnnot '_L' num2str(regularization) ' ' model_name{modelnumber(imodel)}];
    
    ntrials = length(dp_valid.ChoiceLeft);
    LeftChoice  = dp_valid.ChoiceLeft;
    RightChoice = double(dp_valid.ChoiceLeft==0);
    LeftRew = LeftChoice & dp_valid.ChoiceCorrect;
    RightRew = RightChoice & dp_valid.ChoiceCorrect;
    LeftNoRew = LeftChoice & ~dp_valid.ChoiceCorrect;
    RightNoRew = RightChoice & ~dp_valid.ChoiceCorrect;
    LeftLight = LeftChoice & ismember(dp_valid.stimulationOnCond,stimCond);
    RightLight = RightChoice & ismember(dp_valid.stimulationOnCond,stimCond);
    
    
    deltaChoice = RightChoice - LeftChoice ;
    deltaReward = RightRew - LeftRew;
    deltaNoReward = RightNoRew - LeftNoRew;
    deltaLight = RightLight - LeftLight;
    
    % get case of 2 errors in a row
    ndx = getIndex_dp(dp_valid);
    dptemp = filtbdata(dp_valid,0,{'TrialNumber',ndx.incorrect-1},'ChoiceCorrect',0);
    twoErrorInARow = zeros(ntrials,1);
    twoErrorInARow(dptemp.absolute_trial)=1;
    
    stimulus = (dp_valid.Interval-0.5)*-1; % make long negative and short positive
    stimulusAll = zeros(ntrials,nstimuli); stimulusAllLight = zeros(ntrials,nstimuli); stimulusAlltwoErrorInARow = stimulusAll; stimulusAllLeftChoice = stimulusAll; stimulusAllRightChoice = stimulusAll;
    stimulusAllnoReward =stimulusAll; stimulusAllReward =stimulusAll; stimulusAllRewardLight = stimulusAllLight; stimulusAllnoRewardLight = stimulusAllLight; % BA should this be Zeros when there it is not the stimulus given
    stimulusSet = dp_valid.IntervalSet;
    for istim = 1:length(stimulusSet)
        stimulusAll(ismember(dp_valid.Interval,stimulusSet(istim)),istim)= 1;
        stimulusAllRightChoice(stimulusAll(:,istim) & RightChoice',istim) = 1;
        stimulusAllLeftChoice(stimulusAll(:,istim) & LeftChoice',istim) = 1;
        stimulusAllLight(stimulusAll(:,istim) & ismember(dp_valid.stimulationOnCond,stimCond)',istim) = 1;
        stimulusAllReward(stimulusAll(:,istim) & dp_valid.ChoiceCorrect',istim) = 1;
        stimulusAllnoReward(stimulusAll(:,istim) & ~dp_valid.ChoiceCorrect',istim) = 1;
        stimulusAllRewardLight(stimulusAll(:,istim) & dp_valid.ChoiceCorrect'& ismember(dp_valid.stimulationOnCond,stimCond)',istim) = 1;
        stimulusAlltwoErrorInARow(stimulusAll(:,istim) & twoErrorInARow,istim) = 1;
        stimulusAllnoRewardLight(stimulusAll(:,istim) & ~dp_valid.ChoiceCorrect'& ismember(dp_valid.stimulationOnCond,stimCond)',istim) = 1;
    end
    
    
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
                %       models{1} = {'bias','stimN'};
                % models_nterms{1} = [1 nstimuli ];
                tempstimulusAll =        stimulusAll(itrial,:)';
                X(itrial,:) = [tempstimulusAll(:)'...
                    ];
            case 2
                %       models{1} = {'bias','stimN', 'dChoice', 'dRew', 'dNoRew' , 'dLight'};
                % models_nterms{1} = [1 nstimuli trialsBack trialsBack trialsBack trialsBack];
                tempstimulusAll =        stimulusAll(itrial,:)';
                X(itrial,:) = [tempstimulusAll(:)'...
                    deltaChoice(itrial-trialsBack:itrial-1)...
                    deltaReward(itrial-trialsBack:itrial-1)...
                    deltaNoReward(itrial-trialsBack:itrial-1)...
                    deltaLight(itrial-trialsBack:itrial-1)...
                    ];
                
            case 3
                % with CorrectAndLight
                % models{2} = {'bias','stimN', 'ChoiceL','ChoiceR','Cor-2','Cor-1','Er-2','Er-1', 'ChLLight','ChRLight','CorLight-2','CorLight-1', 'ErLight-2','ErLight-1', 'Light-1','Light'}; % a parameter for each stimulus
                % models_nterms{2} = [1  nstimuli trialsBack trialsBack nstimuli nstimuli nstimuli  nstimuli trialsBack trialsBack nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli];
                tempstimulusAll =        stimulusAll(itrial,:)';
                nback =1;
                tempstimulusAllLight = stimulusAllLight(itrial-nback:itrial,:)';
                nback =2;
                tempstimulusAllReward = stimulusAllReward(itrial-nback:itrial-1,:)';
                tempstimulusAllnoReward = stimulusAllnoReward(itrial-nback:itrial-1,:)';
                tempstimulusAllRewardLight = stimulusAllRewardLight(itrial-nback:itrial-1,:)';
                tempstimulusAllnoRewardLight = stimulusAllnoRewardLight(itrial-nback:itrial-1,:)';
                X(itrial,:) = [tempstimulusAll(:)'...
                    LeftChoice(itrial-trialsBack:itrial-1),...
                    RightChoice(itrial-trialsBack:itrial-1),...
                    tempstimulusAllReward(:)'...
                    tempstimulusAllnoReward(:)'...
                    LeftLight(itrial-trialsBack:itrial-1),...
                    RightLight(itrial-trialsBack:itrial-1),...
                    tempstimulusAllRewardLight(:)'...
                    tempstimulusAllnoRewardLight(:)'...
                    tempstimulusAllLight(:)' ...
                    ];
                
            case 4
                % with CorrectAndLight and 2 errors in a row
                % models{4} = {'bias','stimN', 'ChoiceL','ChoiceR','Cor-2','Cor-1','Er-2','Er-1','doubleEr-1', 'ChLLight','ChRLight','CorLight-2','CorLight-1', 'ErLight-2','ErLight-1', 'Light-2', 'Light-1','Light'}; % a parameter for each stimulus
                % models_nterms{4} = [1  nstimuli trialsBack trialsBack nstimuli nstimuli nstimuli nstimuli nstimuli trialsBack trialsBack nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli];
                tempstimulusAll =        stimulusAll(itrial,:)';
                nback =2;
                tempstimulusAllLight = stimulusAllLight(itrial-nback:itrial,:)';
                nback =2;
                tempstimulusAllReward = stimulusAllReward(itrial-nback:itrial-1,:)';
                tempstimulusAllnoReward = stimulusAllnoReward(itrial-nback:itrial-1,:)';
                tempstimulusAllRewardLight = stimulusAllRewardLight(itrial-nback:itrial-1,:)';
                tempstimulusAllnoRewardLight = stimulusAllnoRewardLight(itrial-nback:itrial-1,:)';
                tempstimulusAlltwoErrorInARow = stimulusAllReward(itrial-1,:)';
                X(itrial,:) = [tempstimulusAll(:)'...
                    LeftChoice(itrial-trialsBack:itrial-1),...
                    RightChoice(itrial-trialsBack:itrial-1),...
                    tempstimulusAllReward(:)'...
                    tempstimulusAllnoReward(:)'...
                    tempstimulusAlltwoErrorInARow(:)'...
                    LeftLight(itrial-trialsBack:itrial-1),...
                    RightLight(itrial-trialsBack:itrial-1),...
                    tempstimulusAllRewardLight(:)'...
                    tempstimulusAllnoRewardLight(:)'...
                    tempstimulusAllLight(:)' ...
                    ];
            otherwise
                error('unknown model')
        end
        
    end
    %% do logistic regression
    switch (regularization)
        case 0
            [beta,fit] = glmfit(X,y','binomial','link','logit');
            
        case 1
            if  buse_glmnet

                %     tempy = y' +1;fit = glmnet(X, tempy, 'binomial');
                beta =  glmnetCoef(fit,L1_penalty);
            elseif 0
                % this is another algorithm that also alows L2, the penalties
                % work differently and the results are marginally different,
                % but I don't understand it so not usingit
                % liblinear (National Taiwan University)
                [model]= train(y'+1, sparse(X) ,['-s 5 -c ' num2str(L1_penalty) '  -B 1']);
                beta = model.w';
                beta = [beta(end); beta(1:end-1)];% put bias in same spot as the other functions
            else
                Ncrossvalid = 5;
                options = statset('lassoglm'); options.UseParallel = 'true';
                
                [betaNoIntercept,fit] = lassoglm(X,y','binomial','link','logit','CV', Ncrossvalid,'NumLambda',20);
                nlambda = length(fit.Intercept); % lambda is the cost of adding weights
                for ilambda = 1:nlambda % calculate BIC
                    this_nparams =sum(abs(betaNoIntercept(:,ilambda))>0.001); % number of non-zero parmaters Note doesn't seem to make much difference
                    fit.BIC = 2*fit.Deviance +this_nparams*log(ntrials); % not fit.Deviance is the log-likelihood
                end
                indx = fit.Index1SE;
                %             indx = fit.IndexMinDeviance; % pick the Beta that is the minimum LLK
                LLK = -1*fit.Deviance(:,indx) ;
                BIC(imodel) = fit.BIC(:,indx);
                beta = [fit.Intercept(:,indx); betaNoIntercept(:,indx)];
                
            end
    end
    
    
    if buseMatlab & regularization
        lassoPlot(betaNoIntercept,fit,'PlotType','CV');
        hfig = gcf;
        set(hfig,'Name',['LassoPlot' sAnnot]);
        
        plotAnn(sAnnot);
        
        patht = fullfile(rd.Dir.SummaryFig,'Logistic Regression');
        parentfolder(patht,1)
        saveas(hfig, fullfile(patht,[savefiledesc '_LassoPlot' '.pdf']));
        saveas(hfig, fullfile(patht,[savefiledesc '_LassoPlot' '.fig']));
    end
    %%
    nterms = models_nterms{modelnumber(imodel)};
    nparameterTypes = length(nterms)-1;
    
    Xb0 = [ones(size(X,1),1) X ] ; % add colum for the constent term in the fit
    
    if ~buseMatlab
        PrightAll = 1./(1+exp(-Xb0 * beta)); % compute probabilty of choice Right using all regression parameters
    else
        [PrightAll]= glmval(beta,X,'logit');
        %     ybool = y==1;    Xbool = X==1;
        %     predictors = find(beta(2:end)); % indices of nonzero predictors
        %     mdl = fitglm(Xbool,ybool','linear',...
        %         'Distribution','binomial','PredictorVars',predictors,'link','logit');
    end
    %  action value
    actionValue = Xb0 * beta; % Correct this
    [actionValue ind] = sort(actionValue);
    N = 100; kernel = ones(1,N)/N;
    y_filt = filter(kernel,1,[nan(1,N+1),y(ind)]);
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
    title(['BIC ' num2str( BIC(imodel) ,'%1.0f') ' LogLk:'  num2str(LLK,'%1.0f')]);
    
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
        plot(offset*(iParam-1)+ind,beta(ind),'.-'); hold on;
        if isfield(fit,'p')
            plot(offset*(iParam-1)+ind,fit.p(ind),'-k','linewidth',1); hold on;
        end
    end
    
    xval = [1 cumsum(nterms(2:end))+offset*[1:nparameterTypes]];
    set(gca,'xtick',xval,'xticklabel',paramlabels);
    defaultAxes(gca,[],[],7)
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
    
     glm{imodel} = fit;
end


