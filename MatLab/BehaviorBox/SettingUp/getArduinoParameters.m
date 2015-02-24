function [variableTypeName, variableValues, all]  = getArduinoParameters(source)
% source can be a filepath or a mouseName

rd = brigdefs();
if parentfolder(source) % check if it is a file path
    configfile = source;
else % assume it is a name of an mouseNamee
    configfile = fullfile(rd.Dir.AnimalSettings, lower(mouseName),'arduinoVar.txt');
end

%
[variableTypeName, variableValues, all] =   loadArduinoVar(configfile);
