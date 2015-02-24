function hfig = compare_reactime(dp1,dp2,cond)
% make plots of correct, error and all RT for bot dp1 and dp2

rd = brigdefs();
bsave = 1;
savefiledesc = 'RTcomp';


if nargin<2
    cond(1).color = 'k';
    cond(2).color = 'b';
    cond(1).desc = '';
    cond(2).desc = '';
end

hfig = figure;
set(hfig,'Position',[680   172   560   806],'Name','Comp RT','NumberTitle','off','WindowStyle','docked')

hAx(1) = subplot(3,1,1);
dpCorrect = filtbdata(dp1,0,{'ChoiceCorrect',1});
[~, h(1)] = ss_reactime(dpCorrect,1,gca); hold on;
setColor([h(1).hl h(1).hp],cond(1).color);
dpCorrect = filtbdata(dp2,0,{'ChoiceCorrect',1});
[~, h(2)] = ss_reactime(dpCorrect,1,gca); hold on;
setColor([h(2).hl h(2).hp],cond(2).color);
title('Correct')

if ~isempty(cond(1).desc)
    sleg{1} = cond(1).desc;
    sleg{2} = cond(2).desc;
    hl = [h(1).hl h(2).hl];
    legend(hl,sleg,'Location','Best');
end
    
hAx(end+1) = subplot(3,1,2);
dpError = filtbdata(dp1,0,{'ChoiceCorrect',0});
[~, h] = ss_reactime(dpError,1,gca);
setColor(h,cond(1).color);
dpError = filtbdata(dp2,0,{'ChoiceCorrect',0});
[~, h] = ss_reactime(dpError,1,gca);
setColor(h,cond(2).color);
title('Error')

hAx(end+1) = subplot(3,1,3);
[~, h] = ss_reactime(dp1,1,gca);
setColor(h,cond(1).color);
[~, h] = ss_reactime(dp2,1,gca);
setColor(h,cond(2).color);
title('All')

[~, name] = fileparts(dp1.FileName);
plotAnn(name,hfig)

axis(hAx,'tight')
setAxEq(hAx);
%
if bsave
    patht = fullfile(rd.Dir.RT,dp1.Animal,dp1.Date);
    parentfolder(patht,1)
    saveas(hfig, fullfile(patht,[name savefiledesc '.pdf']));
    saveas(hfig, fullfile(patht,[name savefiledesc '.fig']));
end