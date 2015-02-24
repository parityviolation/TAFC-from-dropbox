function h = plotRunningAvg(dataParsed,hAx,bvertical,bplotPrem)
bplotBias = 1;

if ~exist('bplotPrem','var')
    bplotPrem = 1;
end
if ~exist('bvertical','var')
    bvertical = 0;
end
if ~exist('hAx','var')
    hAx = gca;
end
x = 1:dataParsed.ntrials;


h.hlPrem = [];
if bvertical
    xlabel 'Average performance'
    if bplotBias
           h.hlBias = line(dataParsed.movingAvg.biasLeft,x,'LineWidth',2,'color',[.5 .5 .5],'Parent',hAx);
    end
    if bplotPrem
        h.hlPrem = line(dataParsed.movingAvg.Premature,x,'LineWidth',3,'color',[.8 .8 .8],'Parent',hAx);
    end
     h.hlPerf = line(dataParsed.movingAvg.ChoiceCorrect,x,'LineWidth',3,'Parent',hAx);
else
    ylabel 'Average performance'
    if bplotBias
        h.hlBias = line(c,dataParsed.movingAvg.biasLeft,'LineWidth',2,'color',[.5 .5 .5],'Parent',hAx);
    end

    if bplotPrem
    h.hlPrem = line(x,dataParsed.movingAvg.Premature,'LineWidth',3,'color',[.8 .8 .8],'Parent',hAx);
    end
    h.hlPerf = line(x,dataParsed.movingAvg.ChoiceCorrect,'LineWidth',3,'Parent',hAx);
end