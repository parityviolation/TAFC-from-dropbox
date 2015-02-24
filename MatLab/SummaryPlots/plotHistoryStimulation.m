function dpArray =  plotHistoryStimulation(varargin)
% looks for HISTORY of stimulation across trials i.e.
% for example not stimulated ont the 3 trials before the current trial
% stimulated on the last 2 trials etc
% [ 0 0 0 1
% 0 0 1 1]
%  also looks at the total number of stimulations in the last N trials

% for      Matching only 
       fld = {'Light','ShuffledLight',}% 'Rewarded','NoReward'}; 
%         fld = {'Light','ShuffledLight'};
bplotErrorBar = 1;

nback = 5; % NOTE: 1  is current trial

brandomizeStimulation  =0;
rd = brigdefs();
bsave = 1;


dpArray = dpArrayInputHelper(varargin{:});
sAnnot =  dpArray(1).collectiveDescriptor ;

dpC =concdp(dpArray);

% collapse across conditions
dpC.stimulationOnCond(dpC.stimulationOnCond>=1) = 1;

if brandomizeStimulation
    if 0
        % randomize the stimulation as a control
        N = sum(dpC.stimulationOnCond>0)/length(dpC.stimulationOnCond);
        dpC.stimulationOnCond = rand(size(dpC.stimulationOnCond))<N;
    else
        % randomize the stimulation as a control
        dpC.stimulationOnCond = circshift(dpC.stimulationOnCond,[1 round(rand(1)*500)]);
    end
    sAnnot = [sAnnot '_RandStim'];
end

%%


%%

if  strcmpi(dpArray(1).Protocol,'tafc')
    tafc_helper;
elseif strcmpi(dpArray(1).Protocol,'matching')
    matching_helper;
else
    error('unknown protocol')
end

savefiledesc = [ sAnnot '_History_Stimulation' ];


if bsave
    patht = fullfile(rd.Dir.SummaryFig,'Stimulation History');
    parentfolder(patht,1)
    saveas(hfig, fullfile(patht,[savefiledesc '.fig']));
    export_fig(hfig, fullfile(patht,[savefiledesc]),'-pdf');
end


    function matching_helper
        dpC = filtbdata(dpC,0,{'ChoiceLeft',@(x) ~isnan(x),'RwdMiss',0});
        
        hfig = figure(1);clf;
        mycolor = {'-b','-k','-g','-r'};
        dpC.Light = dpC.stimulationOnCond;
        % randomize the stimulation as a control
        dpC.ShuffledLight = circshift(dpC.stimulationOnCond,[1 round(rand(1)*500)]);
        % create NoReward field
        dpC.NoReward = dpC.Rewarded;
        dpC.NoReward(dpC.NoReward==0) = -1; % monkey busines to avoid NaNs
        dpC.NoReward(dpC.NoReward==1) = 0;
        dpC.NoReward(dpC.NoReward==-1) = 1;
        
        for ifield = 1:length(fld)
            thisFld = fld{ifield};
            savefiledesc = [savefiledesc '_' thisFld ];

            
            % stimulation in a row
            patterns{1} = zeros(1,nback);
            for ipattern = 1:nback
                patterns{ipattern+1} = ones(1,nback-(ipattern-1));
            end
            
            
            
            for ipattern = 1:length(patterns)
                % al
                trialsLeftMatch = find(getTrialAfterTrialPattern(dpC,thisFld,patterns{ipattern},'ChoiceLeft',patterns{ipattern}));
                t = trialsLeftMatch;
                LeftMatchchoiceLeft = dpC.ChoiceLeft(t)==1;
                LeftMatchchoiceRight =  dpC.ChoiceLeft(t)==0;
                
                trialsRightMatch = find(getTrialAfterTrialPattern(dpC,thisFld,patterns{ipattern},'ChoiceLeft',~patterns{ipattern}));
                t = trialsRightMatch;
                RightMatchchoiceRight = dpC.ChoiceLeft(t)==0;
                RightMatchchoiceLeft =  dpC.ChoiceLeft(t)==1;
                
                NLeftMatch(ipattern)  = max(length(trialsLeftMatch),1); % to avoid dividing by zero
                NRightMatch(ipattern)  = max(length(trialsRightMatch),1); % to avoid dividing by zero
                [RightMatchchoiceRight LeftMatchchoiceRight] = makeEqual(double(RightMatchchoiceRight),double(LeftMatchchoiceRight));
                [RightMatchchoiceLeft LeftMatchchoiceLeft] = makeEqual(double(RightMatchchoiceLeft),double(LeftMatchchoiceLeft));
                delta = (nansum(LeftMatchchoiceLeft)  - nansum(LeftMatchchoiceRight)) + (nansum(RightMatchchoiceRight)  - nansum(RightMatchchoiceLeft)) ;
                %      bias is positive is animal stays on same side as was stimulated on else negative
                bias(ipattern) = ( delta )/(NRightMatch(ipattern)+NLeftMatch(ipattern));
                
                biasci(ipattern,1:2) = NaN;
                if bplotErrorBar
%                     if isequal(thisFld,'NoReward')
                    try
                        biasci(ipattern,:) = bootci(1000,{@(x,y,m,n) nanmean([(nansum(x)-nansum(y))/ NLeftMatch(ipattern) ...
                            (nansum(m)-nansum(n))/ NRightMatch(ipattern)]) ...
                            ,LeftMatchchoiceLeft,LeftMatchchoiceRight,RightMatchchoiceRight,RightMatchchoiceLeft})';
                    catch
                        biasci(ipattern,:) = NaN;
                    end
%                     end
                end
                patternBiasci = biasci;
                patternBias = bias;
                patternN = NLeftMatch+NRightMatch;
                
            end
            %  subplot(2,1,1)
            hE = errorbar([0:nback]',patternBias', patternBiasci(:,1)',patternBiasci(:,2)',mycolor{ifield}); hold on
            set(hE                            , ...
                'LineWidth'       , 1           , ...
                'Marker'          , 'o'         , ...
                'MarkerSize'      , 3           , ...
                'MarkerEdgeColor' , mycolor{ifield}(2)  , ...
                'MarkerFaceColor' , mycolor{ifield}(2)  );
            
            
            %             line([0:nback],patternBias(1).*repmat(1,length(patternBias)),'linestyle','--','linewidth',1,'color',[1 1 1].*0.7);
            
        end
        plotAnn(sAnnot);
        
        legend(fld)
        xlabel('# previous trials stimulated')
        ylabel('Stay / Switch')
        
        axis tight
        defaultAxes
        title('Bias Dependence on previous stimulation history')
        

    end
    function tafc_helper
        % find trials were stimulation occured in the precise pattern of
        % PatternMatch
        stimoffCond =0
        stimCond =1
        dpC = filtbdata(dpC,0, {'ChoiceCorrect', [0 1],'controlLoop',@(x) isnan(x)|x==0,'TrialInit',@(x) ~isnan(x),'stimulationOnCond', [stimoffCond stimCond]});
        
        stimOn = dpC.stimulationOnCond;
        patterns = zeros(nback+1,nback);
        for ipattern = 1:nback
            patterns(ipattern+1,end-(ipattern-1):end) = 1;
        end
        
        bpatternMatch = zeros(length(patterns),length(stimOn));
        bNMatch = zeros(length(patterns),length(stimOn));
        for ipattern = 1:length(patterns)
            for itrial = nback:length(stimOn)
                thisTrialHistory_light = stimOn(itrial-(nback-1):itrial);
                
                if all(thisTrialHistory_light==patterns(ipattern,:))
                    bpatternMatch(ipattern,itrial)=1;
                end
                
                if sum(thisTrialHistory_light) == sum(patterns(ipattern,:))
                    bNMatch(ipattern,itrial)=1;
                end
            end
            
            
            
            
        end
        
        clear errorLeft errorRight N bias biasci
        temp = bpatternMatch;
        for ipattern = 1:length(patterns)
            trials = find(temp(ipattern,:));
            % bias
            if length(trials)<4
                bias(ipattern) = NaN;         biasci(ipattern,:) = NaN;
                pmLeft(ipattern) = NaN;          pmRight(ipattern) = NaN;          fracpmLeft(ipattern) = NaN;
            else
                errorLeft = dpC.Interval(trials) < 0.5 & dpC.ChoiceLeft(trials)==1;
                errorRight = dpC.Interval(trials) > 0.5 & dpC.ChoiceLeft(trials)==0;
                
                N(ipattern)  = length(trials);
                delta = sum(errorLeft)  - sum(errorRight);
                biasci(ipattern,:) = bootci(1000,{@(x,y) (sum(x)-sum(y))/ N(ipattern),errorLeft,errorRight})';
                bias(ipattern) = ( delta )/N(ipattern) ;
                
                %          % premature
                %           pmLeft(ipattern) = sum((dpC.PremTime(trials) < 0.5*dpC.Scaling(end) & dpC.PrematureLong(trials)==1));
                %          pmRight(ipattern) = sum((dpC.PremTime(trials) > 0.5*dpC.Scaling(end) & dpC.PrematureLong(trials)==0));
                %          fracpmLeft(ipattern) = pmLeft(ipattern)/sum(~isnan(dpC.PrematureLong(trials)));
            end
            
            
        end
        
        patternBiasci = biasci;
        patternBias = bias;
%         patternN = N;
%         pattern_pmLeft =pmLeft;
%         pattern_pmRight = pmRight;
        
        % find trials where the sum of Stimulated trials in the last Nn trials is
        % NMatch
        temp = bNMatch;
        for ipattern = 1: length(patterns)
            trials = find(temp(ipattern,:));
            if length(trials)<4
                bias(ipattern) = NaN;         biasci(ipattern,:) = NaN;
                pmLeft(ipattern) = NaN;          pmRight(ipattern) = NaN;          fracpmLeft(ipattern) = NaN;
            else
                errorLeft = dpC.Interval(trials) < 0.5 & dpC.ChoiceLeft(trials)==1;
                errorRight = dpC.Interval(trials) > 0.5 & dpC.ChoiceLeft(trials)==0;
                N(ipattern)  = length(trials);
                delta = sum(errorLeft)  - sum(errorRight);
                biasci(ipattern,:) = bootci(1000,{@(x,y) (sum(x)-sum(y))/ N(ipattern),errorLeft,errorRight})';
                bias(ipattern) = ( delta )/N(ipattern) ;
                %         % premature
                %          pmLeft(ipattern) = sum(dpC.PremTime(trials) < 0.5*dpC.Scaling(end) & dpC.PrematureLong(trials)==1);
                %          pmRight(ipattern) = sum(dpC.PremTime(trials) < 0.5*dpC.Scaling(end) & dpC.PrematureLong(trials)==0);
                %          fracpmLeft(ipattern) = pmLeft(ipattern)/sum(~isnan(dpC.PrematureLong(trials)));
            end
        end
        
        %% plotting
        hfig = figure(1);clf;
        %  subplot(2,1,1)
        hE = errorbar([0:nback]',patternBias', patternBiasci(:,1)',patternBiasci(:,2)','-b'); hold on
        set(hE                            , ...
            'LineWidth'       , 1           , ...
            'Marker'          , 'o'         , ...
            'MarkerSize'      , 3           , ...
            'MarkerEdgeColor' , [.0 .0 1]  , ...
            'MarkerFaceColor' , [.0 .0 .4]  );
        hE = errorbar([0:nback]',bias', biasci(:,1)',biasci(:,2)','-r');
        set(hE                            , ...
            'LineWidth'       , 1           , ...
            'Marker'          , 'o'         , ...
            'MarkerSize'      , 3           , ...
            'MarkerEdgeColor' , [1 .0 0]  , ...
            'MarkerFaceColor' , [.4 .0 0]  );
        
        line([0:nback],patternBias(1).*repmat(1,length(patternBias)),'linestyle','--','linewidth',1,'color',[1 1 1].*0.7);
        plotAnn(sAnnot);
        
        
        
        legend('pattern','sum')
        xlabel('# previous trials stimulated')
        ylabel('Bias Long')
        
        axis tight
        defaultAxes
        title('Bias Dependence on previous stimulation history')
        
        %  subplot(2,1,2)
        %  hE = plot([0:nback]',pattern_pmLeft','-b'); hold on
        %  set(hE                            , ...
        %      'LineWidth'       , 1           , ...
        %      'Marker'          , 'o'         , ...
        %      'MarkerSize'      , 3           , ...
        %      'MarkerEdgeColor' , [.0 .0 1]  , ...
        %      'MarkerFaceColor' , [.0 .0 .4]  );
        %  hE = plot([0:nback]',pmLeft','-r'); hold on
        %  set(hE                            , ...
        %      'LineWidth'       , 1           , ...
        %      'Marker'          , 'o'         , ...
        %      'MarkerSize'      , 3           , ...
        %      'MarkerEdgeColor' , [.0 .0 1]  , ...
        %      'MarkerFaceColor' , [.0 .0 .4]  );
        %  hE = plot([0:nback]',pattern_pmRight','-.b'); hold on
        %  set(hE                            , ...
        %      'LineWidth'       , 1           , ...
        %      'Marker'          , 'o'         , ...
        %      'MarkerSize'      , 3           , ...
        %      'MarkerEdgeColor' , [1 .0 0]  , ...
        %      'MarkerFaceColor' , [.4 .0 0]  );
        %  hE = plot([0:nback]',pmRight','-.r'); hold on
        %  set(hE                            , ...
        %      'LineWidth'       , 1           , ...
        %      'Marker'          , 'o'         , ...
        %      'MarkerSize'      , 3           , ...
        %      'MarkerEdgeColor' , [1 .0 0]  , ...
        %      'MarkerFaceColor' , [.4 .0 0]  );
        %
        % %  line([0:nback],patternBias(1).*repmat(1,length(patternBias)),'linestyle','--','linewidth',1,'color',[1 1 1].*0.7);
        % %
        %   legend('pat PMLeft','sum PMLeft','pat PMRight','sum PMRight')
        %  xlabel('# previous trials stimulated')
        %  ylabel('Bias Long')
        %
        %  title('PMature Dependence on previous stimulation history')
    end

%%

end


