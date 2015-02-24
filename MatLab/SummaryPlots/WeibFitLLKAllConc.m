function [llk] = WeibFitLLK(th, xData, hypn, number_fits)
    
[thrConVec, slopeConVec, lConVec, uConVec] = settingParamsWeibLLKFit(th, hypn, number_fits);

for c = 1 : number_fits
    thr = thrConVec(c);
    slope = slopeConVec(c);
    l = lConVec(c);
    u = uConVec(c);
    
    f{c} = l + (1 - l - u) .* (1 - exp(-((xData ./ thr) .^ slope)));

end

fAllConc = cell2mat(f');
logf = log(fAllConc);

llk = -nansum(logf);