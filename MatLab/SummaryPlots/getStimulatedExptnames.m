function [exptnames trials]  = getStimulatedExptnames(name)

[exptnames trials]  = getStimulatedExptnames_Timing(name);

if isempty(exptnames)
    [exptnames trials]  = getStimulatedExptnames_Matching(name);
end

if isempty(exptnames)
    [exptnames trials]  = getManipulatedExptnames_Timing(name); % pharmacology
end

if isempty(exptnames)
    [exptnames trials]  = getArchTExptnames_Mistery(name); % pharmacology
end


if isempty(exptnames)
    error('no stimulation Exptnames were found');
end