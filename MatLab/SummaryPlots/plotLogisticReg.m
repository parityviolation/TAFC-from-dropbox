function [dpArray, glm, BIC] = plotLogisticReg(varargin)
% function [dpArray fit BIC] = 
% plotLogisticReg(dpA/name, condCell,modelnumber(imodel),regularize,brandomizeStimulation,ntrialsback)
% This function is for testing dp of Timing task
% A figure of the the probabilty of picking the same port  after

% BA 10/2013
boverlay = 1 ;% overlay wieghts
bplotcoll = 0;
bnewfigure = 1;
mycolor = 'b';
% to algorithm to determine what level to put the penalty parameter.
rd = brigdefs();
bsave = 1;
% bforfigure = 0;


stimCond = [1 2 3]; % hack so that different light conditions are grouped
stimoffCond = 0;

regularization = 1;


% pick which algorithms to use
buseMatlab = 1;                 Ncrossvalid =20; alpha = 0.5;
buse1SE = 0; % use the minimum LLK solution if 1 use 1SE above the minimum
% for regularized with Matlab % alpha 0.0001 Ridge (lots of small variables), 1 LASSO (few big ones, but collapses high correlated variables into just 1) between 0 and 1 Elastic-Net better with correlated variables
buse_glmnet = 0;                 L1_penalty = .1; % for glmnet
v = ver('Matlab');
if regularization & all(str2num( v.Version) < 8.1) % older versions of matlab statistical toobox don't have the regularized regression function
    buse_glmnet = 1;  % This is much faster TOO !!!!
    disp(' older version of matlab: using glmnet.m for regularized regression');
end

dpArray = dpArrayInputHelper(varargin{1:min(length(varargin),1)});

lambda = []; % set to specific lambda
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
if ~regularization
    alpha = 0; % this is because alpha is used to describe regularization too
end

% for testing whether light effect is real
brandomizeStimulation = 0; bplotaverage=0;
if length(varargin)<5
    brunrandomizedStimulation = 0; 
else
    brunrandomizedStimulation = varargin{5};  
end

    

% for testing whether light effect is real
if length(varargin)<6
trialsBack = 4; % Then number of trial before the current trial to include in the model
else
    trialsBack = varargin{6}; 
end

dpC =concdp(dpArray);

[glm BIC] = helper();

if brunrandomizedStimulation
    if regularization
        if buse1SE
            lambda = fit.Lambda1SE;
        else
            lambda =  fit.LambdaMinDeviance;
        end
    end
    brandomizeStimulation = 1;
    bplotaverage=1;
    bnewfigure =0;
    mycolor = 'k';
    if brandomizeStimulation% repeatedly run the same model for confidences intervals in
        % randomization
        modelnumber = ones(1,20) * modelnumber(1);
        Ncrossvalid = 0;
    end
    helper();
end
    function [glm BIC] = helper
        if  strcmpi(dpArray(1).Protocol,'tafc')
            [glm BIC] = tafc_helper;
        elseif strcmpi(dpArray(1).Protocol,'matching')
            [glm BIC] = matching_helper;
        else
            error('unknown protocol')
        end
        
    end

    function [glm BIC] = tafc_helper
        
        dp_valid = filtbdata(dpC,0, 'ChoiceCorrect', [0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x),'stimulationOnCond', [stimoffCond stimCond]);
        % exclude light conditions that are wanted
        
        % NOTE: by removing trials we are making it even harder to create a good
        % model of the data but seems easier for now (otherwise need regressors for
        % controlLopps etc
        
        
        %% define model.xlabel
        nstimuli = length(dpArray(1).IntervalSet);
        
        model.xlabel{1} = {'bias','stimN'};
        model.nterms{1} = [1 nstimuli ];
        model.name{1}= 'stimuli';
        
        model.xlabel{2} = {'bias','stimN', 'dRew', 'dNoRew' , 'dLight'};
        model.nterms{2} = [1 nstimuli  trialsBack trialsBack trialsBack];
        model.name{2} = 'stimuliChioceRewLight';
        
        model.xlabel{3} = {'bias','stimN','dReward','Light-1','Light'}; % a parameter for each stimulus
        model.nterms{3} = [1  nstimuli trialsBack nstimuli nstimuli];
        model.name{3} =  'Reward Light-1 and Light';
        
        % with CorrectAndLight and 2 errors in a row
        model.xlabel{4} = {'bias','stimN', 'ChoiceL','ChoiceR','Cor-2','Cor-1','Er-2','Er-1','doubleEr-1', 'ChLLight','ChRLight','CorLight-2','CorLight-1', 'ErLight-2','ErLight-1', 'Light-2', 'Light-1','Light'}; % a parameter for each stimulus
        model.nterms{4} = [1  nstimuli trialsBack trialsBack nstimuli nstimuli nstimuli nstimuli nstimuli trialsBack trialsBack nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli];
        model.name{4} = 'KitchenSink';
        % model.xlabel{6} = {'bias','stimN', 'ChoiceL','ChoiceR','ChLeft-2', 'ChLeft-1' , 'ChRight-2', 'ChRight-1','Cor-2','Cor-1','doubleEr', 'Er-2','Er-1','CorLight-2','CorLight-1', 'ErLight-2','ErLight-1', 'Light-1','Light'}; % a parameter for each stimulus
        %  model.nterms{6} = [1  nstimuli trialsBack trialsBack nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli];
        
        model.xlabel{5} = {'bias','stimN','Cor-1','Er-1','Light'}; % a parameter for each stimulus
        model.nterms{5} = [1  nstimuli nstimuli nstimuli nstimuli];
        model.name{5} =  'Cor-1 Er-1 Light';
        
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
            
            
            
            % nparameterTypes = sum( model.nterms;
            
            % X = nan(dp_valid.ntrials-trialsBack,(nparameterTypes-1)*(trialsBack) +1);
            %
            clear X
            for itrial = trialsBack+1:dp_valid.ntrials
                
                % pick model
                switch(modelnumber(imodel))
                    case 1
                        %       model.xlabel{1} = {'bias','stimN'};
                        %  model.nterms{1} = [1 nstimuli ];
                        tempstimulusAll =        stimulusAll(itrial,:)';
                        X(itrial,:) = [tempstimulusAll(:)'...
                            ];
                    case 2
                        %       model.xlabel{1} = {'bias','stimN', 'dChoice', 'dRew', 'dNoRew' , 'dLight'};
                        %  model.nterms{1} = [1 nstimuli trialsBack trialsBack trialsBack trialsBack];
                        tempstimulusAll =        stimulusAll(itrial,:)';
                        X(itrial,:) = [tempstimulusAll(:)'...
                            deltaReward(itrial-trialsBack:itrial-1)...
                            deltaNoReward(itrial-trialsBack:itrial-1)...
                            deltaLight(itrial-trialsBack:itrial-1)...
                            ];
                        
                    case 3
                        %
                        %         model.xlabel{3} = {'bias','stimN','dReward','Light-1','Light'}; % a parameter for each stimulus
                        %         model.nterms{3} = [1  nstimuli trialsBack nstimuli nstimuli];
                        %         model.name{3} =  'Reward Light-1 and Light';
                        
                        tempstimulusAll =        stimulusAll(itrial,:)';
                        nback =1;
                        tempstimulusAllLight = stimulusAllLight(itrial-nback:itrial,:)';
                        tempstimulusAllReward = stimulusAllReward(itrial-nback:itrial-1,:)';
                        tempstimulusAllnoReward = stimulusAllnoReward(itrial-nback:itrial-1,:)';

                        X(itrial,:) = [tempstimulusAll(:)'...                          
                            deltaReward(itrial-trialsBack:itrial-1)...
                            tempstimulusAllLight(:)' ...
                            ];
                        
                    case 4
                        % with CorrectAndLight and 2 errors in a row
                        % model.xlabel{4} = {'bias','stimN', 'ChoiceL','ChoiceR','Cor-2','Cor-1','Er-2','Er-1','doubleEr-1', 'ChLLight','ChRLight','CorLight-2','CorLight-1', 'ErLight-2','ErLight-1', 'Light-2', 'Light-1','Light'}; % a parameter for each stimulus
                        %  model.nterms{4} = [1  nstimuli trialsBack trialsBack nstimuli nstimuli nstimuli nstimuli nstimuli trialsBack trialsBack nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli nstimuli];
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
                    case 5
                        %                         model.xlabel{5} = {'bias','stimN','Cor-1','Er-1','Light'}; % a parameter for each stimulus
                        %                         model.nterms{5} = [1  nstimuli nstimuli nstimuli nstimuli nstimuli];
                        %                         model.name{5} =  'Cor-1 Er-1 Light';
                        %
                        tempstimulusAll =        stimulusAll(itrial,:)';
                        nback =1;
                        tempstimulusAllLight = stimulusAllLight(itrial,:)';
                        tempstimulusAllReward = stimulusAllReward(itrial-nback:itrial-1,:)';
                        tempstimulusAllnoReward = stimulusAllnoReward(itrial-nback:itrial-1,:)';
                        
                        X(itrial,:) = [tempstimulusAll(:)'...
                            tempstimulusAllReward(:)'...
                            tempstimulusAllnoReward(:)'...
                            tempstimulusAllLight(:)' ...
                            ];
                    otherwise
                        error('unknown model')
                end
                
            end
            
            [this_glm, this_BIC ,this_beta,this_LLK,this_betaNoIntercept] = doRegression(imodel,X,y,model);
            betaNoIntercept{imodel} = this_betaNoIntercept;
            beta{imodel} = this_beta;
            glm(imodel) = this_glm;
            BIC(imodel) = this_BIC;
            LLK(imodel) = this_LLK;
            
        end
        plot_helper(X,y,model,beta,BIC,LLK,glm,betaNoIntercept) ;
    end

    function [glm BIC] = matching_helper
        
        
        %
        dp_valid = filtbdata(dpC,0,{'ChoiceLeft',@(x) ~isnan(x),'RwdMiss',0,'stimulationOnCond',[stimoffCond stimCond]});
        % exclude light conditions that are wanted
        
        
        %% define model.xlabel
        model.xlabel{1} = {'bias','dRew', 'dNoRew' };
        model.nterms{1} = [1 trialsBack trialsBack  ];
        model.name{1}= 'RewNoRew';
        
        model.xlabel{2} = {'bias','dRew', 'dNoRew' , 'dLight'};
        model.nterms{2} = [1 trialsBack trialsBack trialsBack ];
        model.name{2}= 'RewNoRewLight';
        
        model.xlabel{3} = {'bias', 'dRewNoLight',  'dRewLight', 'dNoRewNoLight','dNoRewLight'};
        model.pcolor{3} = {};
        model.boffset{3} = [];
        model.plotlabels{3} =[]; %
        if boverlay
            model.pcolor{3} = {'k', 'k',  'c', 'k','c'};
            model.boffset{3} = [0, 1,  0, 1,0];
            model.plotlabels{3} =[1 0 1 0 1]; %
        end


        model.nterms{3} = [1 trialsBack trialsBack trialsBack trialsBack];
        model.name{3} = 'RewLightNoLight';
        
        
        %         model.xlabel{2} = {'bias','dRew', 'dNoRew' , 'ChLLight','ChRLight'};
        %         model.nterms{2} = [1 trialsBack trialsBack trialsBack trialsBack];
        %         model.name{2}= 'RewNoRew_LRLight';
        %
        model.xlabel{4} = {'bias', 'dChoice', 'dRew' , 'dLight'};
        model.nterms{4} = [1 trialsBack trialsBack trialsBack];
        model.name{4} = 'ChioceRewLight';
        
        % with CorrectAndLight
        model.xlabel{5} = {'bias', 'ChoiceL','ChoiceR','RewL','RewR','noRewL','noRewR', 'ChLLight','ChRLight'}; % a parameter for each stimulus
        model.nterms{5} = [1   trialsBack trialsBack trialsBack trialsBack trialsBack  trialsBack trialsBack trialsBack];
        model.name{5} =  'Lots';
        
        model.xlabel{6} = {'bias',  'dRew', 'dNoRew' , 'LightRow'};
        model.nterms{6} = [1  trialsBack trialsBack trialsBack+1];
        model.name{6} = 'RewLightInRow';
        
        model.xlabel{7} = {'bias', 'dChoice', 'dRew', 'dNoRew' , 'LightRow'};
        model.nterms{7} = [1 trialsBack trialsBack trialsBack trialsBack+1];
        model.name{7} = 'ChioceRewLightInRow';
        
        
   
     
        
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
            
            ntrials = length(dp_valid.ChoiceLeft);
            LeftChoice  = dp_valid.ChoiceLeft;
            RightChoice = double(dp_valid.ChoiceLeft==0);
            LeftRew = LeftChoice & dp_valid.Rewarded;
            RightRew = RightChoice & dp_valid.Rewarded;
            LeftNoRew = LeftChoice & ~dp_valid.Rewarded;
            RightNoRew = RightChoice & ~dp_valid.Rewarded;
            LeftLight = LeftChoice & ismember(dp_valid.stimulationOnCond,stimCond);
            RightLight = RightChoice & ismember(dp_valid.stimulationOnCond,stimCond);
            stimOn = dp_valid.stimulationOnCond;
            RewardLeftLight  = (LeftRew) & ismember(dp_valid.stimulationOnCond,stimCond);
            RewardRightLight  = (RightRew) & ismember(dp_valid.stimulationOnCond,stimCond);
            NoRewardLeftLight  = (LeftNoRew) & ismember(dp_valid.stimulationOnCond,stimCond);
            NoRewardRightLight  = (RightNoRew) & ismember(dp_valid.stimulationOnCond,stimCond);
            RewardLeftNoLight  = (LeftRew) & ismember(dp_valid.stimulationOnCond,stimoffCond);
            RewardRightNoLight  = (RightRew) & ismember(dp_valid.stimulationOnCond,stimoffCond);
            NoRewardLeftNoLight  = (LeftNoRew) & ismember(dp_valid.stimulationOnCond,stimoffCond);
            NoRewardRightNoLight  = (RightNoRew) & ismember(dp_valid.stimulationOnCond,stimoffCond);
             % specific pattern of stimulation
            
            %   INA ROWin a row % NOTE currently doesn't keep track of
            %   light SIDE
            patterns = zeros(trialsBack+1,trialsBack);
            for ipattern = 1:trialsBack
                patterns(ipattern+1,end-(ipattern-1):end) = 1;
            end
            LightInARow = zeros(length(patterns),length(stimOn))';
            
            for ipattern = 1:length(patterns)
                for itrial = trialsBack:length(stimOn)
                    thisTrialHistory = stimOn(itrial-(trialsBack-1):itrial);
                    if all(thisTrialHistory==patterns(ipattern,:))
                        LightInARow(ipattern,itrial) = 1;
                    end
                end
            end
                
            deltaChoice = RightChoice - LeftChoice ;
            deltaReward = RightRew - LeftRew;
            deltaNoReward = RightNoRew - LeftNoRew;
            deltaLight = RightLight - LeftLight;
            deltaRewLight = RewardRightLight - RewardLeftLight;
            deltaNoRewLight = NoRewardRightLight - NoRewardLeftLight;
            deltaRewNoLight = RewardRightNoLight - RewardLeftNoLight;
            deltaNoRewNoLight = NoRewardRightNoLight - NoRewardLeftNoLight;
            
            y = RightChoice;  % y is observations (in this case choices)
            
            % X is a matrix with rows corresponding to observations, and columns to predictor variables
            % from Lau DOI: 10.1901/jeab.2005.110-04
            % deltaChoice i-n, ...  deltaChoice i-1, deltaReward i-n, ... deltaReward
            % i-1,
            % where deltaChoice = choiceR - choice and deltaReward = rewardR - rewardL
            
            
            
            % nparameterTypes = sum( model.nterms;
            
            % X = nan(dp_valid.ntrials-trialsBack,(nparameterTypes-1)*(trialsBack) +1);
            %
            clear X
            for itrial = trialsBack+1:dp_valid.ntrials
                
                % pick model
                switch(modelnumber(imodel))
                    case 1
                        %             model.xlabel{1} = {'bias','dRew', 'dNoRew' , 'dLight'};
                        %  model.nterms{1} = [1 trialsBack trialsBack trialsBack ];
                        % model.name{1}= 'RewNoRewLight';
                        X(itrial,:) = [
                            deltaReward(itrial-trialsBack:itrial-1)...
                            deltaNoReward(itrial-trialsBack:itrial-1)...
                            ]; 
                    case 2
                        %             model.xlabel{1} = {'bias','dRew', 'dNoRew' , 'dLight'};
                        %  model.nterms{1} = [1 trialsBack trialsBack trialsBack ];
                        % model.name{1}= 'RewNoRewLight';
                        X(itrial,:) = [
                            deltaReward(itrial-trialsBack:itrial-1)...
                            deltaNoReward(itrial-trialsBack:itrial-1)...
                            deltaLight(itrial-trialsBack:itrial-1)...
                            ];
                    case 3                                           %                                 model.xlabel{7} = {'bias', 'dRewNoLight', 'dNoRewNoLight', 'dRewLight', 'dNoRewLight'};
                         X(itrial,:) = [
                            deltaRewNoLight(itrial-trialsBack:itrial-1)...
                            deltaRewLight(itrial-trialsBack:itrial-1)...
                            deltaNoRewNoLight(itrial-trialsBack:itrial-1)...
                            deltaNoRewLight(itrial-trialsBack:itrial-1)...
                            ];

                   
                    case 4
                        %                 model.xlabel{2} = {'bias', 'dChoice', 'dRew', 'dNoRew' , 'dLight'};
                        %                  model.nterms{2} = [1 trialsBack trialsBack trialsBack trialsBack];
                        %                 model.name{2} = 'ChioceRewLight';
                        
                        X(itrial,:) = [
                            deltaChoice(itrial-trialsBack:itrial-1)...
                            deltaReward(itrial-trialsBack:itrial-1)...
                            deltaLight(itrial-trialsBack:itrial-1)...
                            ];
                    case 4
                        % % with CorrectAndLight
                        % model.xlabel{3} = {'bias', 'ChoiceL','ChoiceR','RewL','RewR','noRewL','noRewR', 'ChLLight','ChRLight'}; % a parameter for each stimulus
                        %  model.nterms{3} = [1   trialsBack trialsBack trialsBack trialsBack trialsBack  trialsBack trialsBack trialsBack];
                        % model.name{3} =  'Lots';
                        
                        X(itrial,:) = [LeftChoice(itrial-trialsBack:itrial-1),...
                            RightChoice(itrial-trialsBack:itrial-1),...
                            LeftLight(itrial-trialsBack:itrial-1),...
                            RightLight(itrial-trialsBack:itrial-1),...
                            LeftRew(itrial-trialsBack:itrial-1),...
                            RightRew(itrial-trialsBack:itrial-1),...
                            LeftNoRew(itrial-trialsBack:itrial-1),...
                            RightNoRew(itrial-trialsBack:itrial-1),...
                            ];
                        case 5
                        %                 model.xlabel{2} = {'bias', 'dChoice', 'dRew', 'dNoRew' , 'dLight'};
                        %                  model.nterms{2} = [1 trialsBack trialsBack trialsBack trialsBack];
                        %                 model.name{2} = 'ChioceRewLight';
                        
                        X(itrial,:) = [
                            deltaChoice(itrial-trialsBack:itrial-1)...
                            deltaReward(itrial-trialsBack:itrial-1)...
                            deltaNoReward(itrial-trialsBack:itrial-1)...
                            LightInARow(itrial,:)...
                            ];
                                                
                    otherwise
                        error('unknown model')
                end
                
            end
            [this_glm, this_BIC ,this_beta,this_LLK,this_betaNoIntercept] = doRegression(imodel,X,y,model);
            betaNoIntercept{imodel} = this_betaNoIntercept;
            beta{imodel} = this_beta;
            glm(imodel) = this_glm;
            BIC(imodel) = this_BIC;
            LLK(imodel) = this_LLK;

        end
                    plot_helper(X,y,model,beta,BIC,LLK,glm,betaNoIntercept)

    end

    function [glm, BIC ,beta,LLK,betaNoIntercept] = doRegression(imodel,X,y,model)
    
        
        %% do logistic regression
        
        ntrials = size(X,1);

        BIC = NaN;
        LLK = NaN;
        switch (regularization)
            case 0
                [this_beta,fit] = glmfit(X,y','binomial','link','logit');
                betaNoIntercept = [];
%                 [PrightAll]= glmval(this_beta,X,'logit');
% %                 TO DO GET LOGliklyhood
            case 1
                
                if  buse_glmnet
                    
                    tempy = y' +1;fit = glmnet(X, tempy, 'binomial');
                    this_beta =  glmnetCoef(fit,L1_penalty);
                    betaNoIntercept = [];
                elseif 0
                    % this is another algorithm that also alows L2, the penalties
                    % work differently and the results are marginally different,
                    % but I don't understand it so not usingit
                    % liblinear (National Taiwan University)
                    [model]= train(y'+1, sparse(X) ,['-s 5 -c ' num2str(L1_penalty) '  -B 1']);
                    this_beta = model.w';
                    this_beta = [this_beta(end); this_beta(1:end-1)];% put bias in same spot as the other functions
                betaNoIntercept = [];
                else
                    options = statset('lassoglm'); options.UseParallel = 'true';
                    s =  '[this_betaNoIntercept,fit] = lassoglm(X,y'',''binomial'',''link'',''logit'',''Alpha'',alpha,''options'',options,''NumLambda'',20';

                    if ~isempty(lambda)
                       s =  [s ',''Lambda'',lambda '] ;
                    end
                    if Ncrossvalid
                        s = [s ',''CV'', Ncrossvalid'];
                     end
                     s = [s ');'];
                     eval(s);
                     
                    if Ncrossvalid
                        if buse1SE
                           indx = fit.Index1SE;    
                        else
                           indx =  fit.IndexMinDeviance;
                        end
                    else
                        indx = 1; % length(fit.Lambda); % take the lowest lambda by default when no CV
                    end
                    %             indx = fit.IndexMinDeviance; % pick the Beta that is the minimum LLK
                    nlambda = length(fit.Intercept); % lambda is the cost of adding weights
                    for ilambda = 1:nlambda % calculate BIC
                        this_nparams =sum(abs(this_betaNoIntercept(:,ilambda))>0.001); % number of non-zero parmaters Note doesn't seem to make much difference
                    end
                    fit.BIC = 2*fit.Deviance +this_nparams*log(ntrials); % not fit.Deviance is the log-likelihood
                    LLK= -1*fit.Deviance(:,indx) ;
                    BIC = fit.BIC(:,indx);
                    this_beta = [fit.Intercept(:,indx); this_betaNoIntercept(:,indx)];
                    betaNoIntercept = this_betaNoIntercept;
                    
                end
        end
        beta = this_beta;
        glm = fit;
       
    end

    function plot_helper(X,y,model,beta,BIC,LLK,fit,betaNoIntercept)
        bsmooth = 0;
                ntrials = size(X,1);

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
            
            betatoplot{1} = mean(temp')';
        else
            modelnumbertoplot = modelnumber;
            betatoplot = beta;
        end
        %%
        for imodel =  1:length(modelnumbertoplot)
           
            savefiledesc = [ dpArray(1).collectiveDescriptor '__logisticReg_' model.name{modelnumber(imodel)} '_L' strrep(num2str(alpha),'.','p')     ];
            sAnnot = [dpArray(1).collectiveDescriptor '_L ' strrep(num2str(alpha),'.','p') ' ' model.name{modelnumber(imodel)}];
            if brandomizeStimulation
                savefiledesc = [savefiledesc '_randStim'];
                sAnnot = [sAnnot '_randStim'];
            end
            
            if boverlay
                savefiledesc = [savefiledesc '_OL'];
                sAnnot = [sAnnot '_OL'];
            end
            
            if buseMatlab & regularization & Ncrossvalid>0 & ~brandomizeStimulation
                hfig = figure('Name',['LassoPlot' sAnnot]);
                ax = subplot(1,2,1);
                lassoPlot(betaNoIntercept{imodel},fit(imodel),'PlotType','CV','Parent',ax);
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
            
            
            nterms =  model.nterms{modelnumbertoplot(imodel)};
            nparameterTypes = length(nterms)-1;
            
            Xb0 = [ones(size(X,1),1) X ] ; % add colum for the constent term in the fit
            
            if ~buseMatlab
                PrightAll = 1./(1+exp(-Xb0 * betatoplot{imodel})); % compute probabilty of choice Right using all regression parameters
            else
                [PrightAll]= glmval(betatoplot{imodel},X,'logit');
                %     ybool = y==1;    Xbool = X==1;
                %     predictors = find(betatoplot{imodel}(2:end)); % indices of nonzero predictors
                %     mdl = fitglm(Xbool,ybool','linear',...
                %         'Distribution','binomial','PredictorVars',predictors,'link','logit');
            end
            %  action value
            actionValue = Xb0 * betatoplot{imodel}; % Correct this
            [actionValue ind] = sort(actionValue);
            PrightAll_sort = PrightAll(ind);
            y_sort = y(ind);
            
            % smooth predictions
            N = 100; kernel = ones(1,N)/N;
            y_filt = filter(kernel,1,[nan(1,N+1) y_sort]);
            actionValue_filt = filter(kernel,1,[nan(1,N+1) actionValue']);
            PrightAll_filt =filter(kernel,1,[nan(1,N+1)  PrightAll(ind)']);
            
            
            % bin predictions
            nbins = size(X,2)*2;
            binedges = [0 [1/size(X,2):1/size(X,2):1]];
            i =1;
            for ibin = 2:length(binedges)
                
                
                thisind = PrightAll_sort<binedges(ibin) & PrightAll_sort>=binedges(ibin-1);
                if sum(thisind)>10 % ignore bins with less than 10 trials
                    %                     yInBin{i} = y_sort(thisind);
                    y_Predict(i) = median(PrightAll_sort(thisind));
                    yInBin(i) = mean(y_sort(thisind));
                    %                     yInBinci(i,:) = bootci(500,{@mean, y_sort(thisind)},'alpha',0.25);
                    %                     yInBinStd(i) = std( y_sort(thisind));
                    i = i+1;
                end
            end
            
            % bin limits for action value
            maxActionValue = max(actionValue);
            minActionValue = min(actionValue);
            rangeActionValue = range(actionValue);
            binedgesAction = minActionValue:rangeActionValue/nbins:maxActionValue;
            i =1;
            % bin Action Value
            for ibin = 2:length(binedgesAction)
                thisind = actionValue<binedgesAction(ibin) & actionValue>=binedgesAction(ibin-1);
                if sum(thisind)>5 % ignore bins with less than 10 trials
                    actionBin(i) = median(actionValue(thisind));
                    yInActionBin(i) = mean(y_sort(thisind));
                     i = i+1;
                end
            end
            
            % %% plotting
            
            if bnewfigure
                hfig = figure('Position',[ 451         163        1397         739],'Name',['LogReg ' sAnnot]);
            else
                hfig = gcf;
            end
            nc = 3;
            nr = 2;
            % plot raw data vs prediction  across time
            if ~brandomizeStimulation
                subplot(nr,nc,[1 2])
                N = 3; kernel = ones(1,N)/N;
                plot(filter(kernel,1,[nan(1,N+1)  y]),'LineWidth',1,'color','r'); hold on
                plot(PrightAll,'LineWidth',1,'color',mycolor); hold on;
                % light stimulation time
                N = find(dpC.stimulationOnCond);
                pp.scolor = 'c';               pp.fid = gcf;
                rasterplot(N,ones(size(N)).*1.2,pp);
                set(gca,'YDir','normal')
                axis tight
                defaultAxes
                try
                    l = length(PrightAll);
                    xlim([max(1,l-1000) l]);
                end
                
                % plot raw data vers prediction
                subplot(nr,nc, 3)
                if ~bsmooth
%                     h.hl = errorbar(y_Predict,yInBin,yInBinci(:,1),yInBinci(:,2)); % Advanced box plot
%                     set(h.hl,'LineStyle','none','Marker','.')
%                     h.he = get(h.hl, 'Children');
%                     h.he =  h.he(2);% Second handle is the handle to the error bar lines
%                     set(h.he,'linewidth',1)
                    line(y_Predict,yInBin,'Marker','.','LineStyle','none')
                    line([0 1],[0 1],'linewidth',0.5,'color',[1 1 1]*.3); % unity line.
                else
                    plot(PrightAll_filt,y_filt,'.')
                end
                xlabel('Predicted Choice')
                ylabel('Actual Choice');
                ylim([0 1])
                xlim([0 1])
                defaultAxes
                title(['BIC ' num2str( BIC(imodel) ,'%1.0f') ' LogLk:'  num2str(LLK(imodel),'%1.0f')]);
                
                   
                subplot(nr,nc,4)
                if ~bsmooth
                    line(actionBin,yInActionBin,'Marker','.','LineStyle','none')
                    
                else
                    plot(actionValue_filt,y_filt,'.')
                end
                xlabel('Action Value ')
                ylabel('Actual Choice');
                defaultAxes
            end
            
            % plot Beta coeffecients and P-values
            subplot(nr,nc,[5 6]);
            currentOffset = 0;
            customOffsetParamsBefore = nterms(1);
            offset = 1;
            for iParam = 1:nparameterTypes+1
                termsbefore = sum(nterms(1:iParam-1));
                ind = [1+termsbefore:termsbefore+nterms(iParam)];
                
                if ~isempty(model.boffset{modelnumbertoplot(imodel)}) % set custom offset on x axis for each parameter
                    if model.boffset{modelnumbertoplot(imodel)}(iParam)
                        currentOffset = customOffsetBefore+offset;
                    end
                    xval = (1:nterms(iParam)) + currentOffset;
                    customOffsetBefore = max(xval);
                else % default offset all parameters
                    currentOffset = offset*(iParam-1);
                    xval = ind +currentOffset;
                end
                 
                if exist('betaci','var')
                    errorbar(xval,betatoplot{imodel}(ind),betaci(ind,1)-betatoplot{imodel}(ind),betaci(ind,2)-betatoplot{imodel}(ind),...
                        'color',mycolor); hold on;
                else
                    if ~isempty(model.pcolor{modelnumbertoplot(imodel)})
                        mycolor = model.pcolor{modelnumbertoplot(imodel)}{iParam};
                    end
                    plot(xval,betatoplot{imodel}(ind),'.-','color',mycolor); hold on;
                end
                if isfield(fit,'p')
                    plot(xval,fit.p(ind),'-k','linewidth',1); hold on;
                end
            end
            % plot x axis
            xl = xlim;
            line(xl,[0 0],'color','k','linestyle','--','linewidth',1);
            axis tight
            if ~brandomizeStimulation
                paramlabels = model.xlabel{modelnumbertoplot(imodel)};
                xval = [1 cumsum(nterms(2:end))+offset*[1:nparameterTypes]];
                
                if ~isempty(model.plotlabels{modelnumbertoplot(imodel)}) % select the subset of param labels to plot when using boffset (custom offsets)
                    paramlabels = paramlabels(model.plotlabels{modelnumbertoplot(imodel)}==1);
                    xval  = nterms(model.plotlabels{modelnumbertoplot(imodel)}==1) ;
                    xval = cumsum(xval);
                end
                set(gca,'xtick',xval,'xticklabel',paramlabels);
                rotateXLabels( gca, 45 )
                
                defaultAxes(gca,[],[],10)

                
                
                hText1 = plotAnn(sAnnot);
                hText2 = plotAnn(['n = ' num2str(ntrials) ' nSess = ' num2str(length(dpArray))],gcf,5);
            end
            if bsave
                % save the data in the figure
                figdata.fit = fit;
                guidata(hfig,figdata);

                patht = fullfile(rd.Dir.SummaryFig,'Logistic Regression');
                parentfolder(patht,1)
                saveas(hfig, fullfile(patht,[savefiledesc '.pdf']));
                saveas(hfig, fullfile(patht,[savefiledesc '.fig']));
            end
            
            if bplotcoll
                info = colldiag(X);
                %             colldiag_tableplot(info); % this plots takes
                %             forever and I don't understand it
                figure('Name','Collinearity')
                subplot(8,1,1)
                plot(info.condind);
                title('condition indices ( > 30 starts to be coll)')
                
                subplot(8,1,2:7)
                imagesc(info.vdp);
                title('variance decomposition proportions')
                colorbar
                axis equal
            end
            
        end
    end
end