function summarizeTAFC()
bsave =1
rd = brigdefs();
datadir = rd.Dir.DataBehav;
[FileName,PathName,FilterIndex] = uigetfile([datadir '\*.txt'],'Select Behavior file(s) to analyze','MultiSelect','on');

% dir([datadir dstruct.mouseName '\*.txt'])

% doesn't work with only one file
ind =1; % filenames with valid data
for i = 1: length(FileName)
    dstruct= loadBdata([PathName FileName{i}]);
    if ~isempty(dstruct)
        try
            [summary.psyc(ind,:), summary.xaxis(ind,:), summary.param_fit(ind,:)] = psycurve_t(dstruct.matrix,false,true);
            temp = strfind(FileName{i},'_');
            summary.date(ind,:) = [FileName{i}(temp(end-1)+3:temp(end-1)+4) '-' FileName{i}(temp(end-1)+5:temp(end-1)+6) '-20' FileName{i}(temp(end-1)+1:temp(end-1)+2)] ;
            summary.datenum(ind) = datenum(summary.date(ind,:),'mm-dd-yyyy');

            summary.mouseName(ind) = {dstruct.mouseName};
            summary.slope(ind) = summary.param_fit(ind,1);
            summary.bias(ind) = summary.param_fit(ind,2);
            summary.Ncorrect(ind) = length(find(dstruct.matrix(:,4)==1));
            summary.Nincorrect(ind) = length(find(dstruct.matrix(:,4)==0));
            summary.Ntrials(ind) = size(dstruct.matrix,1);
            summary.Premature(ind) = length(find(dstruct.matrix(:,7)==1));
            
            ind = ind+1;
        catch ME
            getReport(ME)
        end
        
    end
end

% sort
[junk sortind ] = sort(summary.datenum,'ascend');
hax = [];
% plotting
nr = 2;
nc = 2;
hf = figure;
set(hf,'Name',  summary.mouseName{1}) % BA watch out assuming only one mouse
hax(end+1) = subplot(nr,nc,1);
plot(summary.datenum(sortind),summary.slope(sortind));
title ('Psych slope')
axis tight
ylim([0 1])

hax(end+1) =subplot(nr,nc,2);
plot(summary.datenum(sortind),summary.bias(sortind));
title ('Bias ')
axis tight
ylim([0 1])

hax(end+1) =subplot(nr,nc,3);
plot(summary.datenum(sortind),summary.Ntrials(sortind)); hold all;
plot(summary.datenum(sortind),summary.Ncorrect(sortind)); hold all;
plot(summary.datenum(sortind),summary.Ncorrect(sortind)./summary.Ntrials(sortind)*100)
title ('Trials')
s{1} = 'Total Trial';
s{2} = 'Correct Trials';
s{3} = 'Fraction Correct';
axis tight
%ylim([0 300])
legend(s)

hax(end+1) =subplot(nr,nc,4);
plot(summary.datenum(sortind),summary.Premature(sortind));
title ('Premature trials ')
axis tight
 
for i = 1:length(hax)
    datetick(hax(i),'x',6);
end
% plotAnn(summary.mouseName(1))
linkaxes(hax,'x');

if bsave
    export_fig(fullfile(rd.Dir.SummaryFig,['Summary_' summary.mouseName{1}]),'-transparent','-pdf',gcf)
    disp('saving figures.................................');
end




% plot