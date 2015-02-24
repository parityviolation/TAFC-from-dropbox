function [variableTypeName variableValues all_data] =   loadArduinoVar(varSource)
sEQUALS = '=';
sSEMICOLON = ';';
sSLASHSLASH = '//';
sCOMMENT = '/*';
sEND = 'void';

 
if iscell(varSource) % case where input is 'all'
    all_data = varSource;
    
    for i = 1:length(all_data)
        textFile = all_data{i};
        eqndxs = strfind(textFile, sEQUALS);
        endndxs = strfind(textFile, sSEMICOLON);
     

%         variableTypeName{i} = textFile(1:eqndxs(1));
        variableTypeName{i} = [strtrim(textFile(1:eqndxs(1)))];
        variableValues{i} = [textFile(eqndxs+1:endndxs)];
%         all_data{i} = sprintf('\n\r%s%s // \n\r',variableTypeName{i}, variableValues{i});
     end
    

else % case were input is filename
    filenamepath = varSource;
    ff = fopen(fullfile(filenamepath));
    if ff==-1
        error([filenamepath ' may not exist'])
    end
    textFile = fscanf(ff,'%c');
    fclose(ff);
    
    % remove all comments
    slashndxs = strfind(textFile, sSLASHSLASH);
    newlinendxs = find(ismember(textFile, char([13, 10])));
    sizeDecrease = 0;
     initSize = length(textFile);
    for i = 1:length(slashndxs)
        endcommntndx = newlinendxs(find(newlinendxs > slashndxs(i),1,'first'))-1;
        if isempty(endcommntndx),endcommntndx = initSize; end
        ind = (slashndxs(i):endcommntndx)-sizeDecrease; % comment to remove
        textFile(ind) = '';
        sizeDecrease = sizeDecrease + length(ind);
    end
    
    sizeDecrease = 0; % removing /* comments
    commentndx = strfind(textFile,sCOMMENT);
    for i = 1:length(commentndx)
        endcomment = min(strfind(textFile(commentndx(i):end),'*/'));
        ind = (commentndx(i):endcomment+1)-sizeDecrease; % comment to remove
        textFile(ind) = '';
    end
    
    alleqndxs = strfind(textFile, sEQUALS);
    allendndxs = strfind(textFile, sSEMICOLON);
    allnewlinendxs = find(ismember(textFile, char([13, 10])));
    comndxs = strfind(textFile, sEND);
              
    eqndxs = alleqndxs;
    endndxs = allendndxs;
    newlinendxs = allnewlinendxs;
    
    if ~isempty(comndxs)
        eqndxs = alleqndxs(alleqndxs<comndxs(1));
        endndxs = allendndxs(allendndxs<comndxs(1));
    end
    
      
     % remove all empty lines
     iline =  2;
    while iline < length(newlinendxs)
        if all( ismember(textFile(newlinendxs(iline-1):newlinendxs(iline)),char([13, 10, 20])))
            newlinendxs(iline) = [];
        end
        iline = iline+1;
    end
        
    % remove all end of line and newlines that do not have an equals on the line
    endndxs = endndxs(endndxs>eqndxs(1)); % remove newlines before the first equals
    newlinendxs = newlinendxs(newlinendxs>eqndxs(1)); % remove newlines before the first equals
    
    variableTypeName = cell(1,length(eqndxs));
    variableValues = cell(1,length(eqndxs));
    all_data = cell(1,length(eqndxs));
    
    for i = 1:length(eqndxs)
        if i == 1
            variableTypeName{i} = textFile(1:eqndxs(1));
            variableValues{i} = textFile(eqndxs(i)+1:endndxs(i));
        else
            startndx = newlinendxs(find(newlinendxs < eqndxs(i),1,'last'))+1;
            variableTypeName{i} = textFile(startndx:eqndxs(i));
            thisend = endndxs(find(endndxs > eqndxs(i),1,'first'))+1;
            variableValues{i} = textFile(eqndxs(i)+1:thisend);
        end
         all_data{i} = [variableTypeName{i}  variableValues{i} ];
    end
    
end