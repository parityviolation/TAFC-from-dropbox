function dataParsed = addBExptDetails(dataParsed)


FullPath = dataParsed.FullPath;
[FileName PathName Animal ...
    Date Protocol ProtocolVersion Box Experimenter FileNumber Rev] = getBfileparts(FullPath);
dataParsed.FileNumber = FileNumber;
dataParsed.FileName = FileName;
dataParsed.PathName = PathName;
dataParsed.Animal = Animal;
dataParsed.Date = Date;
dataParsed.Protocol = Protocol;
dataParsed.ProtocolVersion = ProtocolVersion;
dataParsed.Box = Box;
dataParsed.Experimenter = Experimenter;
dataParsed.AnimalSpecies = 'Unknown';
dataParsed.Rev = Rev;



