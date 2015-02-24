%% analyze velocity

dp.FileName  = 'C:\Users\Bassam\Dropbox\Patlab protocols (1)\Data\TAFCmice\Behavior\Sert_868\Sert_868_TAFCv08_stimulation02_box3_130521_SSAB.txt';
dp.FileName  = 'C:\Users\Bassam\Dropbox\Patlab protocols (1)\Data\TAFCmice\Behavior\Sert_868\Sert_868_TAFCv08_stimulation01_box3_130520_SSAB.txt';
dp.FileName  = 'C:\Users\Bassam\Dropbox\Patlab protocols (1)\Data\TAFCmice\Behavior\Sert_868\Sert_868_TAFCv08_stimulation01_box3_130512_SSAB.txt';
dp.FileName  = 'C:\Users\Bassam\Dropbox\Patlab protocols (1)\Data\TAFCmice\Behavior\Sert_868\Sert_868_TAFCv08_stimulation01_box3_130511_SSAB.txt';
dp.FileName  = 'C:\Users\Bassam\Dropbox\Patlab protocols (1)\Data\TAFCmice\Behavior\Sert_868\Sert_868_TAFCv08_stimulation01_box3_130509_SSAB.txt';

dp.FileName  = 'C:\Users\Bassam\Dropbox\Patlab protocols (1)\Data\TAFCmice\Behavior\Sert_864\Sert_864_TAFCv08_stimulation01_box4_130508_SSAB.txt';
dp.FileName  = 'C:\Users\Bassam\Dropbox\Patlab protocols (1)\Data\TAFCmice\Behavior\Sert_866\Sert_866_TAFCv08_stimulation01_box3_130511_SSAB.txt';
dp.FilseName  = 'C:\Users\Bassam\Dropbox\Patlab protocols (1)\Data\TAFCmice\Behavior\Sert_867\Sert_867_TAFCv08_stimulation01_box3_130508_SSAB.txt';
dp.FileName  = 'C:\Users\Bassam\Dropbox\Patlab protocols (1)\Data\TAFCmice\Behavior\Sert_867\Sert_867_TAFCv08_stimulation01_box3_130509_SSAB.txt';
dp.FileName  = 'C:\Users\Bassam\Dropbox\Patlab protocols (1)\Data\TAFCmice\Behavior\Sert_867\Sert_867_TAFCv08_stimulation01_box3_130515_SSAB.txt';
dp.FileName  = 'C:\Users\Bassam\Dropbox\Patlab protocols (1)\Data\TAFCmice\Behavior\Sert_867\Sert_867_TAFCv08_stimulation02_box3_130521_SSAB.txt';


%%
dataParsed =  builddp(1,dp.FileName );
speedExFig(dataParsed)

%%
A = {};
A(end+1) = {'Sert_864'};
% A(end+1) = {'Sert_867'};
% A(end+1) = {'Sert_868'};
colorbyAnimal = 0;

    hf = figure;
mycolor = colormap(hsv(length(A)+1));
stext = ''; nAnimal = {};
% function summ = addBsummPreMature(summ,dpArray)
for ianimal =1:length(A)
    [exptnames trials] = getStimulatedExptnames(A{ianimal});
        dpArray = constructDataParsedArray(exptnames, trials);

    speedExFig(dpArray)

end

