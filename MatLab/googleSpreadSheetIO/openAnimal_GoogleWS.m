
function [googleWS newrow hfig]= openAnimal_GoogleWS(googleWS,data)
newrow = [];
googleWS = openGoogleWorkSheet(googleWS);
if nargin > 1
    [googleWS newrow]= addExptRow(googleWS,data);
end
hfig = createTable_GoogleWS(googleWS);
