% psthCellsSessions
% What sessions have video
% Have movement?
% 26(reextract) 27 (test with this) 28 (only 1 qr code, use CM must rerun
% extract 1 of them
% % rerun qrcode on 26-28

dp = builddp(1)
%how good is it? plotTraj looks like crap!, is it right or is there a
%misalignemtn between the trials?

% to do from joe
% same stimulus different choices, generate the pcas, 

%%
% smooth?
% plot all psths select a subset and normalize?
savepath = 'C:\Users\Behave\Dropbox\PatonLab\Paton Lab\Data\TAFCmice\Ephys\InTask\Analysis\SertxChR2_179\PCA';

bd = brigdefs;
flist = dirc([fullfile(bd.Dir.spikesStruct,'SertxChR2_179\') '*.mat']);
fname = flist(:,1);

nfiles = 1:7; %length(fname); % 6 and 7 have 8 intervals the easiest 2 are not 2.4 but could be averaged
% add 


int_list = round([0.6    1.05    1.26    1.74    1.95    2.4]*1000);
% alignEvent = 'TrialInit';
% WOI  = [1 3]*1000;
alignEvent = 'firstSidePokeTime';
WOI  = [3 1]*1000;
clear options
options.binsize = 50;
options.nsmooth =round(200/ options.binsize);

nintv = length(int_list);
unitPsth = struct([]);
% do I need to normalize each cell? probably not

for ifile = nfiles
    
    load(fullfile(bd.Dir.spikesStruct,'SertxChR2_179\',fname{ifile}));
    [spikes.sweeps]= prematurePsycurvHelper(spikes.sweeps);
    spikes.sweeps.Interval = spikes.sweeps.IntervalwithPM;
    spikes.sweeps.IntervalR = round(spikes.sweeps.Interval*spikes.sweeps.Scaling);
    spikes.sweeps.IntervalSet*spikes.sweeps.Scaling
    EU = spikes.Analysis.EU;
    for iEU = 1:size(EU,1)
        [spikes]= addUnits_spikes(spikes, EU(iEU,:) );
    end
    spikesNoW = rmfield(spikes,'waveforms');
    
    for iEU =1: size(EU,1)
        Electrode = EU(iEU,1);
        UnitID =  EU(iEU,2);
        
        options.bsave = 0;
        options.bootstrap = 0;
        
        options.sDesc = 'Correct';
        sAnimal = spikesNoW.sweeps.Animal;
        sDate = spikesNoW.sweeps.Date;
        options.bplot = 0;
        options.savefile = sprintf('%s_AL%s_%sE%d_U%d%s%s',options.sDesc,alignEvent, sDate,Electrode,UnitID );
        options.dpFieldsToPlot = {};
        options.sortSweepsByARelativeToB= {'firstSidePokeTime',alignEvent};
        options.plottype = {'psth'};
        clear  cond;
        for intv = 1: nintv
            ncondtype = 4;
            icond = (intv-1)*ncondtype +1;
            cond(icond).sleg = 'Correct';
            cond(icond).spikesf = {'Electrode',Electrode,'Unit',UnitID};
            cond(icond).sweepsf   = {'ChoiceCorrect',1,'IntervalR',int_list(intv)};
            cond(icond).trialRelsweepsf   = {};
            cond(icond).alignEvent= alignEvent; % NOTE Times must be relative to the beginning of the session
            cond(icond).plotparam.scolor = 'g';
            icond = (intv-1)*ncondtype +2;
            cond(icond).sleg = 'Error';
            cond(icond).spikesf = {'Electrode',Electrode,'Unit',UnitID};
            cond(icond).sweepsf   = {'ChoiceCorrect',0,'IntervalR',int_list(intv)};
            cond(icond).trialRelsweepsf   = {};
            cond(icond).alignEvent= alignEvent; % NOTE Times must be relative to the beginning of the session
            cond(icond).plotparam.scolor = 'r';
            icond = (intv-1)*ncondtype+3 ;
            cond(icond).sleg = 'PrematureShort';
            cond(icond).spikesf = {'Electrode',Electrode,'Unit',UnitID};
            cond(icond).sweepsf   = {'PrematureShort',1,'IntervalR',int_list(intv)};
            cond(icond).trialRelsweepsf   = {};
            cond(icond).alignEvent= alignEvent; % NOTE Times must be relative to the beginning of the session
            cond(icond).plotparam.scolor = 'r';
           icond = (intv)*ncondtype ;
            cond(icond).sleg = 'PrematureLong';
            cond(icond).spikesf = {'Electrode',Electrode,'Unit',UnitID};
            cond(icond).sweepsf   = {'PrematureLong',1,'IntervalR',int_list(intv)};
            cond(icond).trialRelsweepsf   = {};
            cond(icond).alignEvent= alignEvent; % NOTE Times must be relative to the beginning of the session
            cond(icond).plotparam.scolor = 'r';
            
        end
        
        [h  ntrialsInCond data]= psthCondSpikes(spikesNoW,cond, WOI, options);
        % replace conditions that don't exist with mean of everything else
        notexistingCondition= (ntrialsInCond==0);
        temp = data.psth(~notexistingCondition,:);
        data.psth(notexistingCondition,:) = mean(temp(:));
        %         if ~isempty(data.psth)
        iunit = length(unitPsth)+1;
        unitPsth(iunit).options = options;
        unitPsth(iunit).cond = cond;
        unitPsth(iunit).data = data;
        unitPsth(iunit).Electrode = Electrode;
        unitPsth(iunit).unitID = UnitID;
        unitPsth(iunit).wv = spikesNoW.units.wv(iEU,:);
        unitPsth(iunit).wvstd = spikesNoW.units.wvstd(iEU,:);
        unitPsth(iunit).info = spikes.info;
        %         end
    end
end

nUnit = length(unitPsth);

pcaAnalysis.filenames =  fname(nfiles);
pcaAnalysis.options.alignEvent =  alignEvent;
pcaAnalysis.options.binsize =  options.binsize ;
pcaAnalysis.options.nsmooth =  options.nsmooth; 
pcaAnalysis.intv_list = int_list;
pcaAnalysis.unitPsth = unitPsth;
pcaAnalysis.nUnit = nUnit;

%% EXCLUDING units, plot PSTH for each unit and Remove units with
savename = 'psthAllUnits';
savename = [alignEvent '_' savename];
MINRATE = 1; % haz
ncol = 10;
nrow = ceil(nUnit/ncol);
for icond = 1:ncondtype
    h.fig = figure('Name','PSTH','Position',[ 1353          73         560         882]);
    for iunit =1:nUnit
        haxPsth(iunit) = subplot(ncol,nrow,iunit);
        plot(repmat(unitPsth(iunit).data.center,nintv,1)',unitPsth(iunit).data.psth(icond:ncondtype:end,:)')
        temp = unitPsth(iunit).data.psth(icond:ncondtype:end,:);
        meanRate(icond,iunit) = mean(mean(temp'));
        title(sprintf('%d %1.1fHz',iunit, meanRate(icond,iunit)))
        axis tight
        if meanRate(icond,iunit) < MINRATE
            set(haxPsth(iunit),'color','none')
        end
        
    end
    defaultAxes(haxPsth)
end
plotAnn(alignEvent)

parentfolder(savepath,1)
saveall = fullfile(savepath,savename);
export_fig(h.fig,saveall,'-pdf')
saveas(h.fig,saveall)

meanRate = mean(meanRate);
excludeUnits = find(meanRate<MINRATE);
unitPsth(excludeUnits) = [];
%%PCA
nUnit = length(unitPsth);

[ncond ntimebin] = size( unitPsth(1).data.psth);
l = prod(size( unitPsth(1).data.psth));
allUnits = nan(nUnit,l);
% reshape each unit into a row
for iunit = 1:nUnit
    temp =   unitPsth(iunit).data.psth';
    allUnits(iunit,:) = temp(:)/max(temp(:));
end
allUnits(isnan(allUnits(:,1)),:) = []; % remove NaN
[COEFF,SCORE,latent,tsquare] = princomp(allUnits) ;
figure;
plot(latent(1:10))
xlabel('p comp')
ylabel('variance')
% seperate back into different types of PSTHs
npca = 6;

pca = COEFF(:,1:npca);
pca = reshape(pca,[ ntimebin ncond size(pca,2)]);
pca = permute(pca,[2 1 3]);

clear c
% seperate the conditions
for icond = 1:ncondtype
    c(icond).pca = pca(icond:ncondtype :end,:,:);
    
end

%% plot pcomponents
% to do, plot only until second tone on trial Init
% 
savename = 'pcaComponents';
savename = [alignEvent '_' savename];
% mycolor = hot(nintv+2);
% mycolor = mycolor(2:end,:)
% mycolor(nintv+1:end,:) = [];
% temp = cool(nintv);
% temp = temp(end:-1:1,:);
% mycolor(nintv/2+1:end,:) = temp(1:nintv/2,:);
temp1 = jet(nintv+2);
temp2 = jet(nintv+2);
mycolor(1:nintv/2,:) = temp1(1:nintv/2,:);
mycolor(nintv/2+1:nintv,:) = temp2(end-(nintv)/2+1:end,:);
% mycolor = cool(nintv);
h.fig = figure('Name','PrinComp','Position',[  79   144   794   834]);
xtime =  unitPsth(1).data.center;

for icond = 1:ncondtype
    pca =  c(icond).pca;
    for ipc = 1:npca
        subplot(npca,ncondtype,(ipc-1)*ncondtype +icond)
        for intv= 1:nintv
            plot(xtime,pca(intv,:,ipc),'color',mycolor(intv,:));hold all
        end
        if ipc==1,     title( cond(icond).sleg); xlabel('time (s)');end
        axis tight
        ylabel(['PC-' num2str(ipc)])
    end
    
end
% plot(pca(1,:,2))
plotAnn(alignEvent)

orient tall

% parentfolder(savepath,1)
% saveall = fullfile(savepath,savename);
% export_fig(h.fig,saveall,'-pdf')
% saveas(h.fig,saveall)
% 


%% plot all intervals together
savename = 'Intervals_PCAx vs PCAy';
savename = [alignEvent '_' savename];

h.fig = figure('Position',[1058          58         838         922],'Name','PCAx vs PCAy')
ipca = [1 2; 1 3; 1 4; 2 3];
indbegin = find(xtime>0,1,'first');
icond = 1;
for icond = 1:ncondtype
    pca =  c(icond).pca;
    for ip = 1:size(ipca,1)
        for intv= 1:6
            thiscolor = mycolor(intv,:);
            hax(icond,ip) = subplot(size(ipca,1),ncondtype,icond+(ip-1)*ncondtype);
            plot(pca(intv,indbegin,ipca(ip,1)),pca(intv,indbegin,ipca(ip,2)),'.','markersize',20,'color',thiscolor); hold on;
            if isequal(alignEvent,'TrialInit')
                indtone= find(xtime>int_list(intv)/1000,1,'first');
            else
                indtone = length(xtime);
            end
            plot(pca(intv,indtone,ipca(ip,1)),pca(intv,indtone,ipca(ip,2)), '*','markersize',10,'color',thiscolor)
            plot(pca(intv,1:indtone,ipca(ip,1)),pca(intv,1:indtone,ipca(ip,2)),'color',thiscolor);
            %         title(num2str(int_list(intv)/1000,'%1.2f'))
            axis tight
            
        end
        if ip==1 , title(cond(icond).sleg); end
        
        xlabel(['PC-' num2str(ipca(ip,1))])
        ylabel(['PC-' num2str(ipca(ip,2))])
        
    end
end
for ip = 1:size(ipca,1)
    setAxEq(hax(:,ip))
    linkAxes(hax(:,ip))
end
plotAnn(alignEvent)

parentfolder(savepath,1)
saveall = fullfile(savepath,savename);
export_fig(h.fig,saveall,'-pdf')
saveas(h.fig,saveall)

%% 3D

savename = 'Intervals_PCAx vs PCAy';
savename = [alignEvent '_' savename];

h.fig = figure('Position',[1058          58         838         922],'Name','PCAx vs PCAy')
ipca = [1 2 3;];
indbegin = find(xtime>0,1,'first');
icond = 1;
for icond = 1:ncondtype
    pca =  c(icond).pca;
    for ip = 1:size(ipca,1)
        for intv= 1:6
            thiscolor = mycolor(intv,:);
            hax(icond,ip) = subplot(size(ipca,1),ncondtype,icond+(ip-1)*ncondtype);
            plot3(pca(intv,indbegin,ipca(ip,1)),pca(intv,indbegin,ipca(ip,2)),pca(intv,indbegin,ipca(ip,3)),'.','markersize',20,'color',thiscolor); hold on;
            if isequal(alignEvent,'TrialInit')
                indtone= find(xtime>int_list(intv)/1000,1,'first');
            else
                indtone = length(xtime);
            end
            plot3(pca(intv,indtone,ipca(ip,1)),pca(intv,indtone,ipca(ip,2)),pca(intv,indtone,ipca(ip,3)), '*','markersize',10,'color',thiscolor)
            plot3(pca(intv,1:indtone,ipca(ip,1)),pca(intv,1:indtone,ipca(ip,2)),pca(intv,1:indtone,ipca(ip,3)),'color',thiscolor);
            %         title(num2str(int_list(intv)/1000,'%1.2f'))
            axis tight
            
        end
        if ip==1 , title(cond(icond).sleg); end
        
        xlabel(['PC-' num2str(ipca(ip,1))])
        ylabel(['PC-' num2str(ipca(ip,2))])
        
    end
end
for ip = 1:size(ipca,1)
    setAxEq(hax(:,ip))
    linkAxes(hax(:,ip))
end
plotAnn(alignEvent)

% parentfolder(savepath,1)
% saveall = fullfile(savepath,savename);
% export_fig(h.fig,saveall,'-pdf')
% saveas(h.fig,saveall)

% % % plot second condtion on top
% % icond = 2;
% % pca =  c(icond).pca;
% % for ip = 1:size(ipca,1)
% %     for intv= [4]
% %         thiscolor = [0 0 0];
% %         hax(intv) = subplot(size(ipca,1),1,ip);
% %         plot(pca(intv,indbegin,ipca(ip,1)),pca(intv,indbegin,ipca(ip,2)),'.','markersize',20,'color',thiscolor); hold on;
% %         indtone= find(data.center>int_list(intv)/1000,1,'first');
% %         plot(pca(intv,indtone,ipca(ip,1)),pca(intv,indtone,ipca(ip,2)), 'o','markersize',5,'color',thiscolor)
% %         plot(pca(intv,1:indtone,ipca(ip,1)),pca(intv,1:indtone,ipca(ip,2)),'color',thiscolor);
% %         title(num2str(int_list(intv)/1000,'%1.2f'))
% %         axis tight
% %
% %     end
% %
% % end
% setAxEq(hax)

% %% animate
% figure

% indtone= find(data.center>int_list(intv)/1000,1,'first')
% for itime = 1:10:length(data.center)
%     hl =  line(pca(intv,1:itime,1),pca(intv,1:itime,ipca)); hold on;
%     title(data.center(itime))
%     if itime== indtone
%         plot(pca(intv,indtone,1),pca(intv,indtone,ipca),'g.','markersize',20)
%     end
%     if itime== indbegin
%         plot(pca(intv,indbegin,1),pca(intv,indbegin,ipca),'r.','markersize',20)
%     end
%
%     pause;
%     delete(hl)
% end

%% plot each interval in its own subplot
% mycolor2 = {'g','r','c'}
% ipca = [1 2; 1 3; 2 3];
% figure
% indbegin = find(data.center>0,1,'first');
% for icond = 1:ncondtype
%     pca =  c(icond).pca;
%     thiscolor = mycolor2{icond};
%     for ip = 1:size(ipca,1)
%         for intv= 1:nintv
%
%             hax(intv) = subplot(2*size(ipca,1),3,intv+(ip-1)*nintv);
%             plot(pca(intv,indbegin,ipca(ip,1)),pca(intv,indbegin,ipca(ip,2)),[thiscolor '.'],'markersize',20); hold on;
%             indtone= find(data.center>int_list(intv)/1000,1,'first');
%             plot(pca(intv,indtone,ipca(ip,1)),pca(intv,indtone,ipca(ip,2)),[thiscolor 'o'],'markersize',5)
%             htemp = plot(pca(intv,1:indtone,ipca(ip,1)),pca(intv,1:indtone,ipca(ip,2)),thiscolor);
%             if ip==1 && intv==1, hl(icond) = htemp; end
%             title(num2str(int_list(intv)/1000,'%1.2f'))
%             axis tight
%
%         end
%         xlabel(['PC-' num2str(ipca(ip,1))])
%         ylabel(['PC-' num2str(ipca(ip,2))])
%         setAxEq(hax)
%         defaultAxes(hax)
%     end
%     sleg{icond} =  cond(icond).sleg;
% end
%
% defaultLegend(legend(hax(1),hl,sleg))