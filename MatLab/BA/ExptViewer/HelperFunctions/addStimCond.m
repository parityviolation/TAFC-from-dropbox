function expt = addStimCond(expt)
%
%
%   Created: 4/6/10 - SRO
%   Modified: 4/19/10 - BA added TDT compatibility made singles

RigDef = RigDefs;

exptname = expt.name;
startInd = 1;
for i = 1:length(expt.files.names)
    triggers = single(expt.files.triggers(i));
    
    if triggers>0
        if isTDTexpt(expt)
            fName = fullfile(RigDef.Dir.Data,expt.files.names{i});
            [junk swcond] = loadTDThelper_getStimCond(fName ,'Vcod');
            
        else
            
            files = dir([RigDef.Dir.Data expt.name '*_TrigCond.mat']);
            if ~isempty(files)  % Determine whether any Trig condition files exist
                fileInd = GetFileInd(expt.files.names{i});
                fName = [RigDef.Dir.Data exptname '_' num2str(fileInd)];
                [junk swcond] = getStimCond({fName},0);
                
            elseif isfield(expt.sweeps,'trial')
                expt.sweeps.stimcond = nan(size(expt.sweeps.trial),'single');
                sprintf('\t\t **************************************************');
                sprintf('\t\t No Stimulus condition data exists .stimcond is NAN');
                sprintf('\t\t **************************************************');
                i = length(expt.files.names)+1; % break out of for loop
            end
            
        end
        
        if size(swcond,2) > triggers
            % Remove nans, if they exist (this occurs when DaqController is
            % stopped before completing specified triggers)
            swcond(:,any(isnan(swcond),1)) = [];
        end
        % BA deal with case where somehow swcond doesn't equal triggers (assume
        % the last one(s) is missing)
        if length(swcond)<triggers
            swcond = [swcond nan(1,triggers-length(swcond))];
            %         warning(sprintf('There are more triggers than swcond, triggers>length(swcond) will be ignored.\n But Stimulus condition maybe wrong or mismatched'))
            %         triggers = length(swcond);
        end
        if length(swcond)>triggers, disp('WARNING more swcond then triggers.. data may be corrupt'); swcond = swcond(1:triggers); end
        
        expt.sweeps.stimcond(startInd:startInd+triggers-1) = single(swcond);
        startInd = startInd + triggers;
    end
end

