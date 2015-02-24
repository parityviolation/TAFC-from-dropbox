function [thrConVec, slopeConVec, lConVec, uConVec] = settingParamsWeibLLKFit(th, free_parameters, number_fits)


switch (free_parameters)
    case 'all'
        % everything is changing
        thrConVec = th(1:number_fits);
        slopeConVec = th(number_fits+1:2*number_fits);
        lConVec = th(2*number_fits+1:3*number_fits);
        uConVec = th(3*number_fits+1:4*number_fits);
    case 'bias'
        % only thr changes across fits; slope, l and u are fit but are the same
        % for all fits
        thrConVec = th(1:number_fits);
        slopeConVec = repmat(th(number_fits+1),1,number_fits);
        lConVec = repmat(th(number_fits+2),1,number_fits);
        uConVec = repmat(th(number_fits+3),1,number_fits);
    case 'slope'
        % only slope changes across fits; thr, l and u are fit but are the same
        % for all fits
        thrConVec = repmat(th(1),1,number_fits);
        slopeConVec = th(2:number_fits+1);
        lConVec = repmat(th(number_fits+2),1,number_fits);
        uConVec = repmat(th(number_fits+3),1,number_fits);
end

