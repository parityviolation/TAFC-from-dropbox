
if isunix
    slash = '/';
else
    slash = '\';
end


spreadSheet = GetGoogleSpreadsheet('1qc2U5x9ImAfJBSb8AUU0HCnF4PpGpBhSB07nKg4x4sI');



archAnimals = {'FI12_974', 'FI12_1146', 'FI12_1144', 'FI12_1016', 'FI12_1085','FI12_1020'}; %'FI12_1293'
archAnimalsForLegend = {'ArchT', 'ArchT', 'ArchT', 'ArchT', 'ArchT','ChR2'}

r = brigdefs;
nAnimals = length(archAnimals);
allNames = spreadSheet(:,2);
animalInfoIdx =zeros(1,nAnimals);

bAcrossAnimals = 0; % set to 1 to get the average across animals
bloadFromdp =0;%reload behavior files
groupsavefile = 'fi12_arch_mystery';


condCell.condGroup = {[1 2 3]}; % group Stimulations conditions accordingly
condCell.condGroupDescr = '[1 2 3]';

A = {'fi12_974_arch_mystery','fi12_1446_arch_mystery','fi12_1444_arch_mystery','fi12_1016_arch_mystery','fi12_1085_arch_mystery','fi12_1020_arch_mystery'}; %'fi12_1013_arch_mystery'
        
        
s_loadMultipleHelper
%%
clear ArchInfoIdx ArchInfo surgeryDate performance day
hf = figure;
set(hf,'WindowStyle','docked');

range = linspace(0.2,1,nAnimals)';

colors = zeros(nAnimals,3);

colors(:,2) = range;

%colors = cool(nAnimals);

for iAnimal = 1:nAnimals
    
    dpThisAnimal = dpAnimalCell{iAnimal};

    ArchInfoIdx(iAnimal) = find(strcmp(allNames,archAnimals(iAnimal)));
    
    ArchInfo(iAnimal,:) = spreadSheet(ArchInfoIdx(iAnimal),:);
       
    surgeryDate(iAnimal,:) = datestr(spreadSheet(ArchInfoIdx(iAnimal),9),'yymmdd');

    [performance{iAnimal}, day{iAnimal}]  = getAnimalPerformance(dpThisAnimal);
    
    surgeryDateIdx = find(strcmp(day{iAnimal},surgeryDate(iAnimal,:)));
    
    smoothPerformance = smooth(performance{iAnimal},4);
    
    plot (smoothPerformance,'color',colors(iAnimal,:),'linewidth',3)
    hold on
    %plot (surgeryDateIdx, performance{iAnimal}(surgeryDateIdx),'ok','markersize',10,'markerfacecolor',[0 0 0])
    
    

end
%%
axis tight
axis square

yAxis = ylim;
xAxis = xlim;
plot(xAxis,[0.5 0.5],'--','color',[0.5 0.5 0.5],'linewidth',2)
plot(xAxis,[0.7 0.7],'--','color',[0.5 0.5 0.5],'linewidth',2)
plot([5 5],[0.45 1],'--','color',[0.5 0.5 0.5],'linewidth',2)

title('Smoothed Performance across days','FontSize',20)
xlabel('sessions','FontSize',20)
ylabel('performance','FontSize',20)
set(gca,'TickDir','out','FontSize',20,'LineWidth',2)
legend(archAnimalsForLegend,'FontSize',15)
box off

fileName = 'Performance summary';

figDir = fullfile([r.Dir.SummaryFig , slash, 'Arch Mystery',slash, fileName, '.pdf']);
save2pdf(figDir)
