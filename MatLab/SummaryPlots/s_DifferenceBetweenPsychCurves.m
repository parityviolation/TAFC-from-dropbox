% make plot of difference psychcurves



hfig = figure(100);clf
my_color = ['r','b','g','k'];

clear m h
for ianimal = 1:  length(dpAnimal) % EXCLUDING 179 TOO Noise only 4 sessions add more
    thisAnimal = dpAnimal{ianimal} ;
    clear summ
    for ifile = 1:length(thisAnimal);
        thisAnimal(ifile) = getStats_dp(thisAnimal(ifile));
        
        
        summ(1).pLong(ifile,:) = thisAnimal(ifile).stats.frac.choiceLongUnStim;
        summ(2).pLong(ifile,:) = thisAnimal(ifile).stats.frac.choiceLongStim;
    end
    
    x= thisAnimal(ifile).stats.IntervalSet*thisAnimal(ifile).Scaling/1000;
    s = summ(1).pLong - summ(2).pLong;
    m(ianimal,:) = nanmedian(s);
    %m(ianimal,:) = nanmean(s./repmat(max(s,[],2),1,size(s,2))); %normalized to max
    %m(ianimal,:) = nanmedian(s./repmat(nansum(s,2),1,size(s,2))); %normalized to max
    
    %subplot(1,2,1)
    
    h(ianimal)= line(x,m(ianimal,:),'color',my_color(ianimal), 'linestyle','-',...
        'marker','.');
    
    
    sleg{ianimal} = thisAnimal(1).Animal;
    
    if ianimal==length(dpAnimal)
        hleg = legend(h,sleg);
        defaultLegend(hleg,'SouthWest',6);
    end
    
end

acrossCells = m;
%acrossCells = m./repmat(max(m,[],2),1,size(s,2));% normalize
%acrossCells = m./repmat(sum(m,2),1,size(s,2));% normalize

% Plot mean subtraction of psyc curves

%subplot(1,2,2)

line(x,nanmean(acrossCells),'color','k', 'linestyle','-',...
    'marker','.','linewidth',2);
%
%  line(x,nanmedian(acrossCells),'color','k', 'linestyle','--',...
%        'marker','.','linewidth',2);


set(gca,'Xtick',x)
set(gca,'XtickLabel',round(x*10)/10)

setXLabel(gca,'Interval')
setYLabel(gca,'P_{Ctrl}(Long) - P_{Photo}(Long) ')
defaultAxes(gca,[],[],8)




sAnnot =  thisAnimal(ifile).collectiveDescriptor ;
if 1
    %         savename = [strtrim(cell2mat(nAnimal)) savename_fig1];
    patht = fullfile(r.Dir.SummaryFig, 'DiffBetweenPsyc');
    parentfolder(patht,1)
    savefiledesc = [ savename_fig1];
    export_fig(hfig, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
    saveas(hfig, fullfile(patht,[savefiledesc '.fig']));
    plotAnn(sAnnot,hfig);
end
