plotdpFieldDistribution_cond

A={};
A{end+1} = 'Sert868_all'
A{end+1} = 'Sert867_all'


varAnimal = varargin{1};
condGroup = varargin{2};
fld = varargin{3};
options = varargin{4};
if isfield(options,'bSplitByInterval')
    bSplitByInterval = options.bSplitByInterval;
end

localoptions.bsave = 0;

if iscell(varAnimal)
    mycolor = colormap(lines(length(varAnimal)));
    sAnnot = '';
    
    for iAnimal = 1:length(varAnimal)
        fld(1).condfilter(icondfilter).scolor = mycolor(iAnimal,:);
        fld(2).condfilter(icondfilter).scolor = mycolor(iAnimal,:);
        sAnnot = [sAnnot varAnimal{iAnimal}];
        
        localoptions.sAnnot = sAnnot;
        
        [dpArray options h]=  plotdpFieldDistribution_cond(varAnimal{iAnimal},[],fld,localoptions);
        localoptions.h.hfig = h.hfig;
        hl(iAnimal) = h.hJl(1);
        
        if iAnimal <length(varAnimal)
            delete(h.hAnn);
        end
        
    end
    legend(h.hAx(1),hl,varAnimal,'Interpreter','none')
else
    
    [dpArray localoptions h] =  plotdpFieldDistribution_cond(varargin{:});
end


rd = brigdefs();
if options.bsave
    patht = fullfile(rd.Dir.SummaryFig,fldname);
    parentfolder(patht,1)
    orient tall
    saveas(h.hfig, fullfile(patht,[localoptions.savefiledesc '.pdf']));
    saveas(h.hfig, fullfile(patht,[localoptions.savefiledesc '.fig']));
end



