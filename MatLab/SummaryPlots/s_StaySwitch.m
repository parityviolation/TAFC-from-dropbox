%   stay switch
%   Stay (same as last trial)
%   Stimulation 1 0
%
%   Stay (same as current trial)
%   Stimulation 1 0 1 0
% Analysis of STay (same side on next trial) vs switch

%   There should be a Increase in probablity of Staying after CORRECT vs after ERROR
%   choiceLeft    = dpC.ChoiceLeft;
options.savefileHeader = '';
bsave = 1
r = brigdefs;
savename_fig = '_StaySwitch';

condset(1).desc = 'Stay/Switch ShortCorrect LastTrial';
condset(1).cond(1).filter = {'stimulationOnCond',[0],'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'Premature',0};
% cond(1).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[0],'ChoiceCorrect', [ 1],'ChoiceLeft', [ 1]},{-2,'stimulationOnCond',[0]},{-3,'stimulationOnCond',[0]},{-4,'stimulationOnCond',[0]},{-5,'stimulationOnCond',[0]}};
condset(1).cond(1).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[0],'ChoiceCorrect', [ 1],'ChoiceLeft', [ 0]},{-2,'stimulationOnCond',[0]}};
condset(1).cond(1).color = 'k';
condset(1).cond(1).desc = 'No Stim';

condset(1).cond(2).filter = {'stimulationOnCond',[0],'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'Premature',0};
% cond(2).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[1 2 3],'ChoiceCorrect', [ 1],'ChoiceLeft', [ 1]},{-2,'stimulationOnCond',[0]},{-3,'stimulationOnCond',[0]},{-4,'stimulationOnCond',[0]},{-5,'stimulationOnCond',[0]}};
condset(1).cond(2).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[1 2 3],'ChoiceCorrect', [ 1],'ChoiceLeft', [ 0]},{-2,'stimulationOnCond',[0]}};
condset(1).cond(2).color = 'b';
condset(1).cond(2).desc = 'Stim';

iconset = 2;
condset(iconset).desc = 'Stay/Switch LongCorrect LastTrial';
condset(iconset).cond(1).filter = {'stimulationOnCond',[0],'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'Premature',0};
condset(iconset).cond(1).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[0],'ChoiceCorrect', [ 1],'ChoiceLeft', [ 1]},{-2,'stimulationOnCond',[0]}};
condset(iconset).cond(1).color = 'k';
condset(iconset).cond(1).desc = 'No Stim';

condset(iconset).cond(2).filter = {'stimulationOnCond',[0],'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'Premature',0};
condset(iconset).cond(2).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[1 2 3],'ChoiceCorrect', [ 1],'ChoiceLeft', [ 1]},{-2,'stimulationOnCond',[0]}};
condset(iconset).cond(2).color = 'b';
condset(iconset).cond(2).desc = 'Stim';

iconset =3;
condset(iconset).desc = 'Stay/Switch ShortError LastTrial';
condset(iconset).cond(1).filter = {'stimulationOnCond',[0],'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'Premature',0};
condset(iconset).cond(1).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[0],'ChoiceCorrect', [ 0],'ChoiceLeft', [0]},{-2,'stimulationOnCond',[0]}};
condset(iconset).cond(1).color = 'k';
condset(iconset).cond(1).desc = 'No Stim';

condset(iconset).cond(2).filter = {'stimulationOnCond',[0],'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'Premature',0};
condset(iconset).cond(2).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[1 2 3],'ChoiceCorrect', [ 0],'ChoiceLeft', [ 0]},{-2,'stimulationOnCond',[0]}};
condset(iconset).cond(2).color = 'b';
condset(iconset).cond(2).desc = 'Stim';

iconset = 4;
condset(iconset).desc = 'Stay/Switch LongError LastTrial';
condset(iconset).cond(1).filter = {'stimulationOnCond',[0],'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'Premature',0};
condset(iconset).cond(1).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[0],'ChoiceCorrect', [ 0],'ChoiceLeft', [ 1]},{-2,'stimulationOnCond',[0]}};
condset(iconset).cond(1).color = 'k';
condset(iconset).cond(1).desc = 'No Stim';

condset(iconset).cond(2).filter = {'stimulationOnCond',[0],'ChoiceCorrect', [ 0 1],'controlLoop',@(x) isnan(x)|x==0,'Premature',0};
condset(iconset).cond(2).trialRelativeSweepfilter = {{-1,'stimulationOnCond',[1 2 3],'ChoiceCorrect', [ 0],'ChoiceLeft', [ 1]},{-2,'stimulationOnCond',[0]}};
condset(iconset).cond(2).color = 'b';
condset(iconset).cond(2).desc = 'Stim';


%dpArray =   concdp(thisAnimal);  % remove this if to do Session by session analysis
 dpArray = dpAnimalArray;

alpha = 0.05;
mycolor = colormap(lines(length(dpArray)));
% if nargin >2
%     if isfield(options,'bsave')
%         bsave = options.bsave;
%     end
%     if isfield(options,'mycolor')
%         mycolor = options.mycolor;
%     end
%
%
% end

h.hfig = figure('NumberTitle','off','Name','Stay/Switch','Position',[ 680   558   955   420]);
nc = length(condset);
for icondset = 1:length(condset)
    clear hl;
    for idp = 1:length(dpArray)
        dpC = dpArray(idp);
        % CHANGE this if you want to test Stay switch of 2 trials back
        % (i.e. imagine stimulation reinforces not the choice on the
        % current trial, but the choice on the trial before
        dpC.switchSide = [NaN abs(diff(dpC.ChoiceLeft))]; % create Stay Switch for each ChoiceLeft
        
        thiscond = condset(icondset).cond;
        for icond = 1:length(thiscond)
            
            [thisdp] = filtbdata(dpC,[],thiscond(icond).filter,thiscond(icond).trialRelativeSweepfilter);
            
            thisCond_switch  = thisdp.switchSide;
            
            o(icond) = nansum(thisCond_switch);
            n(icond) = sum(~isnan(thisCond_switch));
        end
        
        h.hAx(icondset) = subplot(1,nc,icondset);
        hl(idp) = line(o(1)/n(1),o(2)/n(2),'Marker','o','MarkerEdgeColor',mycolor(idp,:),'LineStyle','none');
        p = MyBinomTest(o(2),n(2),o(1)/n(1)); % NOTE this test depends on the direction, i.e. results will differ depending on which o has more observations
        if p < alpha
            set(hl(idp),'MarkerFaceColor',mycolor(idp,:))
        end
        sleg{idp} = [dpC.Animal ' p= ' num2str(p,'%1.2g')];
        
    end
    axis equal ; axis square
%     defaultAxes(h.hAx(icondset))
    set(h.hAx(icondset),'xlim',[0 1],'ylim',[0 1])
    xl = xlim;
    line(xl,xl,'color','k')
    setXLabel(h.hAx(icondset),['P(Switch | ' condset(icondset).cond(1).desc ')']);
    setYLabel(h.hAx(icondset),['P(Switch | ' condset(icondset).cond(2).desc ')']);
    setTitle(h.hAx(icondset),condset(icondset).desc );
    h.hleg(icondset) = legend(hl,sleg);
    defaultLegend(h.hleg(icondset),'Best',7);
    
end

sAnnot =  dpArray(1).collectiveDescriptor ;

plotAnn( sAnnot);
if bsave
 
         %         savename = [cell2mat(nAnimal) savename_fig2];
        patht = fullfile(r.Dir.SummaryFig, 'StaySwitch',dpArray(1).Animal);
        parentfolder(patht,1)
        savefiledesc = [sAnnot savename_fig];
        export_fig(h.hfig, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
        saveas(h.hfig, fullfile(patht,[savefiledesc '.fig']));
end


