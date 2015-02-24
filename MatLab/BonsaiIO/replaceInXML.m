function xmltext = replaceInXML(xmltext,slabel,occrenceN,sINSERTSTRING)
% for replacing in Bonsai file
startStr = ['<' slabel '>'];        endStr = ['</' slabel '>'];
bStartStr = strfind(xmltext, startStr);
bReplace = bStartStr(occrenceN) +length(startStr);
bEndStr = strfind(xmltext, endStr);
bTextAfterReplace = bEndStr(occrenceN);
xmltext = strrep(xmltext, xmltext(bReplace:end), [sINSERTSTRING xmltext(bTextAfterReplace:end)]);