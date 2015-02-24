function animalTable= runbyDate(animalLog,sdate)
% sdate = '22/Feb/14'

r = brigdefs;

if nargin < 1 | isempty(animalLog) % load log
   animalLog = loadAnimalLog;
end

if nargin < 2
    sdate = datestr(now,'dd/mmm/yy');
end

animal_LogDate = filtbdata(animalLog,0,{'date',sdate});

sortByfldnames = 'boxIndex';
includefldnames = {'date','Experimenter','boxIndex','name'};
animalTable = logToTable(animal_LogDate,includefldnames,sortByfldnames);

disp(['Animals run on ' sdate]);

