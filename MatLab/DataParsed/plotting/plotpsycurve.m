function h = plotpsycurve(fit,hAx,brawdataplot)
% function h = plotpsycurve(fit,hAx,brawdataplot)
if nargin<2, hAx = gca; end
if nargin<3, brawdataplot = 0; end
nlin = length(fit);
h = [];
for iln = 1:nlin
    if isstruct(fit(iln))
        if ~isnan(fit(iln).param)
            a = fit(iln).param(end,1); b = fit(iln).param(end,2); l = fit(iln).param(end,3); u = fit(iln).param(end,4);
            x = linspace(0,1,100); y = l + (u-l)*(exp((x-b)/a)./(1+exp((x-b)/a)));
            h.hl(iln) = line(x,y,'color', [0.9569    0.1059    0.1373],'linewidth',2,'Parent',hAx); hold on
            %         h.hp(iln) = patch([x fliplr(x)],[y fliplr(y)],'b','edgecolor', [0.9569    0.1059    0.1373],...
            %             'edgealpha',.25,'linewidth',2,'Parent',hAx); hold on
        end
        if brawdataplot
            h.hlraw(iln) = line(fit(iln).x, fit(iln).psyc,'Line','none','Marker','.','markersize',20,'Parent',hAx);
            set(hAx,'xlim',[0 1],'ylim',[0 1]);
        end
    end
end
defaultAxes(hAx)