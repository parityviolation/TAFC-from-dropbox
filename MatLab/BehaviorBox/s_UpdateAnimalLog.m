% script to add performance to all logged experiments
r = brigdefs;
nEntry = length(animalLog.exptFilename);
for iexpt = 1:nEntry
    FullPath  =  fullfile(r.Dir.DataBehav,animalLog.name{iexpt},[animalLog.exptFilename{iexpt} '.txt']);
    try
        dp = ss_parsedata(FullPath);
    catch ME
        getReport(ME)
        iexpt
    end
        
   
    performSummary = getPerformance(dp);
     animalLog = addToLocalLog(performSummary,[],dp.FileName);

end
    

%% script to add performance of all experiments in Listed animals