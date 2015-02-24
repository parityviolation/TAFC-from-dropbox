function b = updating_TAFC(varargin)
% Updating, time effects, Drugs

dataParsed = varargin{1};
if nargin == 1
    plt = true;
else
    plt = varargin{2};
end

lasttrial = 1; %outcome of last trial

stimVector = dataParsed.Interval;
stimSet = dataParsed.IntervalSet;
choiceLong = dataParsed.ChoiceLeft;
choiceCorr = dataParsed.ChoiceCorrect;
SRD = dataParsed.StimRwdDelay;

clear matrix_upd; clear matrix_upd_lower; clear matrix_upd_upper

matrix_upd = stimVector';
matrix_upd(:,2) = choiceLong';
matrix_upd(:,3) = choiceCorr';
matrix_upd(2:end,4:6) = matrix_upd(1:end-1,1:3); % previous trial stim, choice and correct
matrix_upd(2:end,7) = SRD(1:end-1);
% matrix_upd(isnan(matrix_upd(:,2))|isnan(matrix_upd(:,5))|matrix_upd(:,6)~=lasttrial|isnan(matrix_upd(:,7)),:) = [];
% matrix_upd(isnan(matrix_upd(:,2))|isnan(matrix_upd(:,5)),:) = [];
% [~,sort_ndx] = sort(matrix_upd(:,7));
% matrix_upd = matrix_upd(sort_ndx,:);
matrix_upd_early = matrix_upd(matrix_upd(:,7)<median(matrix_upd(:,7)),:);
matrix_upd_long = matrix_upd(matrix_upd(:,7)>median(matrix_upd(:,7)),:);
i = length(stimSet)/2;
bias = nan(i,length(stimSet));


for s = 1:length(stimSet)
    data_pr = matrix_upd(matrix_upd(:,4)==stimSet(s) & matrix_upd(:,6)==lasttrial,:);   % Filters trials preceded by stimulus 's' and outcome 'lasttrial'.
    
    for a = 1:i
    data_easy = data_pr(data_pr(:,1)==stimSet(a)|data_pr(:,1)==stimSet(end-a+1),:);     % Filters very easy trials
    data_easy_1 = length(data_easy(data_easy(:,1)==stimSet(a) & data_easy(:,3)==0))/length(data_easy(data_easy(:,1)==stimSet(a))); % Fraction of errors to one side
    data_easy_8 = length(data_easy(data_easy(:,1)==stimSet(8) & data_easy(:,3)==0))/length(data_easy(data_easy(:,1)==stimSet(end-a+1))); % Fraction of errors to another side
    bias(a,s) = data_easy_1 - data_easy_8; % Bias on trials preceded by stim s, for very easy stimuli
    
%     data_mideasy = data_pr(data_pr(:,1)==stimSet(2)|data_pr(:,1)==stimSet(7),:);     % Filters easy trials
%     data_mideasy_2 = length(data_mideasy(data_mideasy(:,1)==stimSet(2) & data_mideasy(:,3)==0))/length(data_mideasy(data_mideasy(:,1)==stimSet(2))); % Fraction of errors to one side
%     data_mideasy_7 = length(data_mideasy(data_mideasy(:,1)==stimSet(7) & data_mideasy(:,3)==0))/length(data_mideasy(data_mideasy(:,1)==stimSet(7))); % Fraction of errors to another side
%     bias(2,s) = data_mideasy_2 - data_mideasy_7; % Bias on trials preceded by stim s, for easy stimuli
%     
%     data_middiff = data_pr(data_pr(:,1)==stimSet(3)|data_pr(:,1)==stimSet(6),:);     % Filters difficult trials
%     data_middiff_3 = length(data_middiff(data_middiff(:,1)==stimSet(3) & data_middiff(:,3)==0))/length(data_middiff(data_middiff(:,1)==stimSet(3))); % Fraction of errors to one side
%     data_middiff_6 = length(data_middiff(data_middiff(:,1)==stimSet(6) & data_middiff(:,3)==0))/length(data_middiff(data_middiff(:,1)==stimSet(6))); % Fraction of errors to another side
%     bias(3,s) = data_middiff_3 - data_middiff_6; % Bias on trials preceded by stim s, for difficult stimuli
%     
%     data_diff = data_pr(data_pr(:,1)==stimSet(4)|data_pr(:,1)==stimSet(5),:);     % Filters very difficult trials
%     data_diff_4 = length(data_diff(data_diff(:,1)==stimSet(4) & data_diff(:,3)==0))/length(data_diff(data_diff(:,1)==stimSet(4))); % Fraction of errors to one side
%     data_diff_5 = length(data_diff(data_diff(:,1)==stimSet(5) & data_diff(:,3)==0))/length(data_diff(data_diff(:,1)==stimSet(5))); % Fraction of errors to another side
%     bias(4,s) = data_diff_4 - data_diff_5; % Bias on trials preceded by stim s, for difficult stimuli
    end
end

% Plot
if plt
    color = copper(i);
    h = figure;
    hold on
    for a = 1:i
        plot(stimSet,(bias(a,:)-nanmean(bias(a,:))),'color',color(a,:),'MarkerSize',20,'LineWidth',3)
        %         plot(stimSet,bias(i,:),'color',color(i,:),'MarkerSize',20,'LineWidth',3)
    end
    axis([0 1 -1 1]), % set(h,'Name',['Rat ' smatrix{1,1} ', under ' smatrix{1,4} ' on ' smatrix{1,3}]),title(get(h,'Name'));
    xlabel('Stim duration at previous trial (S_t_-_1)')
    ylabel('Bias')
    legend 'very easy' 'easy' 'difficult' 'very difficult' 'extreme'
    legend boxoff
    %     if isunix == 1
    %         print(h,'-r300','-dtiff',['/home/thiago/Dropbox/Matlab code/Olfaction/Data/Figures/zach/Updating/' get(h,'Name')])
    %     elseif isunix == 0
    %         print(h,'-r300','-dtiff',['C:\Users\Thiago\Dropbox\Matlab code\Olfaction\Data\Figures\zach\Updating\' get(h,'Name')])
    %     end
    clear h
end
b = bias;
end