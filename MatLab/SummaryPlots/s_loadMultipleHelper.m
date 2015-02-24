

if bloadFromdp % get dpArray for mutiple animals
    clear dpAnimalCell dpAnimalArray;
    collectiveDescriptor ='';
    for iAnimal = 1:length(A)
        dpAnimalCell{iAnimal} =  dpArrayInputHelper(A{iAnimal},condCell);
        dpAnimalArray(iAnimal) = concdp(dpAnimalCell{iAnimal} );
%    % Removed because the results don't make sense     dpAnimalArray(iAnimal).trialWeight = ones(size(dpAnimalArray(iAnimal).TrialAvail)).*1/dpAnimalArray(iAnimal).ntrials 
%         % this for weighting fits by the number of trials for an animal, so an n is an animal not a trial
%         % NOTE this weighting isn't quite right.. shoudlreally weight be
%         % the number of trials in the cond filtered dp (so weight would
%         % depend on filter but we will ignore this for now and assume the
%         % total trials is a good enough estimate
        collectiveDescriptor= [collectiveDescriptor dpAnimalArray(iAnimal).collectiveDescriptor ];
    end
    dpAnimalArray(1).collectiveDescriptor = collectiveDescriptor;
    save(groupsavefile,'dpAnimalCell','dpAnimalArray')
else
    
    load(groupsavefile,'dpAnimalCell','dpAnimalArray')
end

