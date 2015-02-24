% psthCellsSessions
% What sessions have video
% Have movement?
% 26(reextract) 27 (test with this) 28 (only 1 qr code, use CM must rerun
% extract 1 of them
% % rerun qrcode on 26-28

%how good is it? plotTraj looks like crap!, is it right or is there a
%misalignemtn between the trials? no although seems to be a few frames
%before the poke in.
%      TODO: look at overlay on film
%      In the meantime assume is good and do PCA on x,y position making
%      same plots as for neural data.
% RUN movement more sessions
% pick sessions with QR code and use that?

% WHAT about activity between trials? predicting choice?

% to do from joe
% is there more bias for counterlateral modulation?

%
% smooth?
% plot all psths select a subset and normalize?
savepath = 'C:\Users\Behave\Dropbox\PatonLab\Paton Lab\Data\TAFCmice\Ephys\InTask\Analysis\SertxChR2_179\PCA';
savefile = 'UnitForPCAallGoodSessions_CorrectErrorPMShortPMLong';
bd = brigdefs;
flist = dirc([fullfile(bd.Dir.spikesStruct,'SertxChR2_179\') '*.mat']);
fname = flist(:,1);

nfiles =  1:length(fname); % 6 and 7 have 8 intervals the easiest 2 are not 2.4 but could be averaged

int_list = round([0.6    1.05    1.26    1.74    1.95    2.4]*1000);
saveheader = 'PreMature'
saveheaderMove = 'MovementCM'
alignEvent = {'TrialInit','firstSidePokeTime'};
WOI  = {[3 3]*1000,[3 3]*1000};
clear options
options.binsize = 50;
options.nsmooth =round(200/ options.binsize);

bMovementAnal = 0;
% videoField = {'cm','extremes','qrRef'};
% videosubField = {{'xy','speed'},{'xy','noseSpeed'},{'modelViewMatrix'}};
%videoField = {'cm','extremes'};
videosubField = {{'xy','speed'},{'xy','noseSpeed'}};
% TODO CHECK quality of movement data
% TODO SMOOTH movementdata

% build conditions
nintv = length(int_list);
ncondPerAlignEvent = 4;
nAlign = length(alignEvent);
clear cond
for intv = 1: nintv
    ncondtype = ncondPerAlignEvent*length(alignEvent);
    for ialgn = 1:nAlign
        ii = 0;
        ii  = ii +1;
        icond = (intv-1)*ncondtype +ii+(ialgn-1)*ncondPerAlignEvent;
        cond(icond).sleg = 'Correct';
        cond(icond).sweepsf   = {'ChoiceCorrect',1,'IntervalR',int_list(intv)};
        cond(icond).trialRelsweepsf   = {};
        cond(icond).alignEvent= alignEvent{ialgn};   % NOTE Times must be relative to the beginning of the session
        cond(icond).WOI= WOI{ialgn}; 
        cond(icond).plotparam.scolor = 'g';
        ii  = ii +1;
        icond = (intv-1)*ncondtype +ii+(ialgn-1)*ncondPerAlignEvent;
        cond(icond).sleg = 'Error';
        cond(icond).sweepsf   = {'ChoiceCorrect',0,'IntervalR',int_list(intv)};
        cond(icond).trialRelsweepsf   = {};
        cond(icond).alignEvent= alignEvent{ialgn};   % NOTE Times must be relative to the beginning of the session
        cond(icond).WOI= WOI{ialgn}; 
        cond(icond).plotparam.scolor = 'r';
        ii  = ii +1;
        icond = (intv-1)*ncondtype+ii +(ialgn-1)*ncondPerAlignEvent;
        cond(icond).sleg = 'PrematureShort';
        cond(icond).sweepsf   = {'PrematureShort',1,'IntervalR',int_list(intv)};
        cond(icond).trialRelsweepsf   = {};
        cond(icond).alignEvent= alignEvent{ialgn};   % NOTE Times must be relative to the beginning of the session
        cond(icond).WOI= WOI{ialgn}; 
%         cond(icond).plotparam.scolor = 'r';
        ii  = ii +1;
        icond = (intv-1)*ncondtype +ii +(ialgn-1)*ncondPerAlignEvent;
        cond(icond).sleg = 'PrematureLong';
        cond(icond).sweepsf   = {'PrematureLong',1,'IntervalR',int_list(intv)};
        cond(icond).trialRelsweepsf   = {};
        cond(icond).alignEvent= alignEvent{ialgn};   % NOTE Times must be relative to the beginning of the session
        cond(icond).WOI= WOI{ialgn}; 
%         cond(icond).plotparam.scolor = 'r';
    end
end
ncond = length(cond);

unitPsth = struct([]);
movementPsth = struct([]);
 allMovement =[];
for ifile = nfiles
    
    load(fullfile(bd.Dir.spikesStruct,'SertxChR2_179\',fname{ifile}));
    [spikes.sweeps]= prematurePsycurvHelper(spikes.sweeps);
    spikes.sweeps.Interval = spikes.sweeps.IntervalwithPM;
    spikes.sweeps.IntervalR = round(spikes.sweeps.Interval*spikes.sweeps.Scaling);
    spikes.sweeps.IntervalSet*spikes.sweeps.Scaling

    if bMovementAnal
            if ~isfield(spikes.sweeps.video,'cm')
                spikes.sweeps = builddp(1,0);
                save(fullfile(bd.Dir.spikesStruct,'SertxChR2_179\',fname{ifile}),'spikes');
            end
        videosubFieldnew = {};
        for  ialgn = 1:length(alignEvent)
            [spikes.sweeps newtempFields] = addVideoWOI_dp(spikes.sweeps,alignEvent{ialgn},WOI{ialgn},videoField,videosubField); % ADD WOI around the alignEvent for video
            if ialgn>1 ,            for i = 1:length(newtempFields), videosubFieldnew{i} = {videosubFieldnew{i}{:},newtempFields{i}{:}}; end
            else,            videosubFieldnew = newtempFields;      end
        end
    end
     EUPlus = spikes.Analysis.EUPlusLabel;
    for iEU = 1:size(EUPlus,1),        [spikes]= addUnits_spikes(spikes, EUPlus(iEU,:) );   end
    EU = cell2mat(EUPlus(:,1:2));
    spikesNoW = rmfield(spikes,'waveforms');
    
    for iEU =1: size(EU,1)
        Electrode = EU(iEU,1);
        UnitID =  EU(iEU,2);
        label =  EUPlus(iEU,3);
        
        options.bsave = 0;
        options.bootstrap = 0;
        
        options.sDesc = 'Correct';
        sAnimal = spikesNoW.sweeps.Animal;
        sDate = spikesNoW.sweeps.Date;
        options.bplot = 0;
        options.dpFieldsToPlot = {};
        options.sortSweepsByARelativeToB= {};
        options.plottype = {'psth'};         
        for icond = 1:ncond,           cond(icond).spikesf = {'Electrode',Electrode,'Unit',UnitID};      end
        [h  ntrialsInCond data]= psthCondSpikes(spikesNoW,cond, [], options);
        
        % replace conditions that don't exist with mean of everything else
        notexistingCondition= (ntrialsInCond==0);
        temp = data.psth(~notexistingCondition,:);
        data.psth(notexistingCondition,:) = mean(temp(:));

        iunit = length(unitPsth)+1;
        unitPsth(iunit).options = options;
        unitPsth(iunit).cond = cond;
        unitPsth(iunit).data = data;
        unitPsth(iunit).Electrode = Electrode;
        unitPsth(iunit).unitID = UnitID;
        unitPsth(iunit).label = label;
        unitPsth(iunit).wv = spikesNoW.units.wv(iEU,:);
        unitPsth(iunit).wvstd = spikesNoW.units.wvstd(iEU,:);
        unitPsth(iunit).info = spikes.info;
        
        
    end % each Unit
    
    % % movement PSTH
    if bMovementAnal
        clear meanThisParameter;
        tempcenters = 1/spikes.sweeps.video.info.medianFrameRate*[spikes.sweeps.video.cm.WOIfr_firstSidePokeTime(1)*-1:spikes.sweeps.video.cm.WOIfr_firstSidePokeTime(2)];
        for icond = 1:ncond
            movementPsth(icond).centers =tempcenters;
            thisSw = filtbdata(spikes.sweeps,0, cond(icond).sweepsf );
            thisCol =[];
            for ifield = 1:length(videoField)
                if isfield(spikes.sweeps.video,videoField{ifield})
                    for isubfield = 1:length(videosubFieldnew{ifield})
                        temp = thisSw.video.(videoField{ifield}).(videosubFieldnew{ifield}{isubfield});
                        %                     % % Filter
                        %                     for ipage = 1:size(temp,3)
                        %                         for irow = 1:size(temp,1)
                        %                             temp(irow,:,ipage) = smooth(squeeze(temp(irow,:,ipage)),5,'lowess');
                        %                         end
                        %                         %                                                                temp(:,:,ipage) = medfilt1(squeeze(temp(:,:,ipage))',7)';% Median filter!!! might be too much
                        %                     end
                        %                     clear meanThisParameter
                        %                                            meanThisParameter = squeeze(nanmean(temp));
                        tempmeanThisParameter =  squeeze(nanmean(temp))';                     % % get mean across trials
                        if ~isvector(tempmeanThisParameter)
                            for irow =1:size(tempmeanThisParameter,1) % % interpolate
                                meanThisParameter(irow,:) = interp1(tempcenters,tempmeanThisParameter(irow,:),unitPsth(iunit).data.center,'linear')'; % interpolate to same window as PSTH
                            end
                        else
                            meanThisParameter = interp1(tempcenters,tempmeanThisParameter,unitPsth(iunit).data.center,'linear'); % interpolate to same window as PSTH
                        end
                        movementPsth(icond).centers = unitPsth(iunit).data.center;
                        movementPsth(icond).(videoField{ifield}).(videosubFieldnew{ifield}{isubfield}) = meanThisParameter;
                        %                     if ~isrowvector(meanThisParameter),meanThisParameter = meanThisParameter'; end
                        thisCol = [thisCol; meanThisParameter];
                    end
                end
            end
            %         movementPsth(icond).centers = unitPsth(iunit).data.center;
            allMovement = cat(2,allMovement,thisCol); % each parameter, and each session is an observation
        end
        for irow = 1:size(allMovement,1),      allMovement(irow,isnan(allMovement(irow,:))) = nanmean(allMovement(irow,:));   end
        % this a rowvector concatenating all the movement
        % info you want to include in PCA.
        
        allMovement = single(allMovement);
    end
end

%
% pcaAnalysis.filenames =  fname(nfiles);
% pcaAnalysis.options.alignEvent =  alignEvent;
% pcaAnalysis.options.binsize =  options.binsize ;
% pcaAnalysis.options.nsmooth =  options.nsmooth; 
% pcaAnalysis.intv_list = int_list;
% pcaAnalysis.unitPsth = unitPsth;
% pcaAnalysis.nUnit = nUnit;
if bMovementAnal
    savename = ['pcaComponentsInterval' ' ' saveheaderMove];

    temp1 = jet(nintv+2);
    temp2 = jet(nintv+2);
    mycolor(1:nintv/2,:) = temp1(1:nintv/2,:);
    mycolor(nintv/2+1:nintv,:) = temp2(end-(nintv)/2+1:end,:);
    mycolor = mycolor(end:-1:1,:) ;
    
    npca = 6
    [mpc,mSCORE,mlatent] = princomp(allMovement) ;
    mpca = mpc(:,1:npca);
    ntimebin_fr =  length(movementPsth(icond).centers); % USER HARD CODED
    %%
    pca = reshape(mpca,[ntimebin_fr ncond size(mpca,2)]);
    pca = permute(pca,[2 1 3]);
    
    clear c
    % tricky part reshaping all the conditions so they make sense
    % seperate the conditions
    for icond = 1:ncondtype
        c(icond).pca = pca(icond:ncondtype :end,:,:);
    end
    
    

    h.fig = figure('Name',['PrinComp' ' ' saveheaderMove],'Position',[  79   144   794   834]);
    savename = [alignEvent '_' savename];

    for ialgn = 1:nAlign
        xtime = movementPsth(1).centers;
        for ic =  1:ncondtype/nAlign
            icond = ic + (ialgn-1) * ncondtype/nAlign;
            pca =  c(icond).pca;
            for ipc = 1:npca
                subplot(npca,ncondtype,(ipc-1)*ncondtype +icond)
                for intv= 1:nintv
                    plot(xtime,pca(intv,:,ipc),'color',mycolor(intv,:));hold all
                end
                if ipc==1,     title( [cond(icond).sleg ' ' cond(icond).alignEvent] ); xlabel('time (s)');end
                axis tight
                ylabel(['PC-' num2str(ipc)])
            end
            
        end
    end
    
    plotAnn('Movement');
    parentfolder(savepath,1)
saveall = fullfile(savepath,[savename{:}]);
export_fig(h.fig,saveall,'-pdf')
saveas(h.fig,saveall)

end

save(savefile,'flist','nfiles','int_list','cond','unitPsth')
%% EXCLUDING units, plot PSTH for each unit and Remove units with
nUnit = length(unitPsth);
savename = ['psthAllUnits' ' ' saveheader];
savename = [alignEvent '_' savename];
MINRATE = 0.4; % haz
ncol = 10;
nrow = ceil(nUnit/ncol);
for icond = 1:ncondtype
    h.fig = figure('Name','PSTH','Position',[  105          73        1808         882]);
    for iunit =1:nUnit
        haxPsth(iunit) = subplot(ncol,nrow,iunit);
        plot(repmat(unitPsth(iunit).data.center,nintv,1)',unitPsth(iunit).data.psth(icond:ncondtype:end,:)')
        temp = unitPsth(iunit).data.psth(icond:ncondtype:end,:);
        meanRate(icond,iunit) = mean(mean(temp'));
        title(sprintf('%d %1.1fHz',iunit, meanRate(icond,iunit)))
        ylabel(unitPsth(iunit).label{1});
        axis tight
        if meanRate(icond,iunit) < MINRATE
            set(haxPsth(iunit),'color','none')
        end
        
    end
    defaultAxes(haxPsth)
end
plotAnn(alignEvent)

parentfolder(savepath,1)
saveall = fullfile(savepath,[savename{:}]);
export_fig(h.fig,saveall,'-pdf')
saveas(h.fig,saveall)
%%
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
 % tricky part reshaping all the conditions so they make sense
% seperate the conditions
for icond = 1:ncondtype
    c(icond).pca = pca(icond:ncondtype :end,:,:);   
end

%% plot pcomponents
% to do, plot only until second tone on trial Init
% 
mycolor = jet(nintv+1);
mycolor(ceil(end/2),:) = [];
mycolor = mycolor(end:-1:1,:);
savename = ['pcaComponentsInterval' ' ' saveheader];
savename = [alignEvent '_' savename];
h.fig = figure('Name','PrinComp','Position',[    79         144        1564         834],'Visible','off');
xtime =  unitPsth(1).data.center;
ind = [];
clear hAxes
for icond = 1:ncondtype
    pca =  c(icond).pca;
    for ipc = 1:npca
%         subplot(npca,ncondtype,(ipc-1)*ncondtype +icond)
        hAxes((ipc-1)*ncondtype +icond) = axes;
        ind(end+1) = (ipc-1)*ncondtype +icond;
        for intv= 1:nintv
            plot(xtime,pca(intv,:,ipc),'color',mycolor(intv,:));hold all
        end
        axis tight
        
        if ipc==1,     title( cond(icond).sleg); xlabel('time (s)');end
        if intv==1,        ylabel(['PC-' num2str(ipc)]); end
    end
end
setaxesOnaxesmatrix(hAxes,npca,ncondtype,[],[],h.fig)
set(hAxes,'YTickLabel','')
set(hAxes,'color','none')
% set all plots of the same PC on same y axis
for ipc = 1:npca, setAxEq(hAxes([1:ncondtype]+(ipc-1)*ncondtype)); setYLabel(hAxes(1+(ipc-1)*ncondtype),['PC-' num2str(ipc)] );end
defaultAxes(hAxes)

% add Interval lines
temp = [1 -1] % switch side for TrialInit and firstSidepoke
for ialgn = 1:nAlign;
for ic = 1:ncondtype/2
    icond = (ialgn-1)*ncondtype/2+ic;
    for ipc = 1:npca
        axes(hAxes((ipc-1)*ncondtype +icond));
        line([0 0],ylim,'linestyle','-','Parent', hAxes((ipc-1)*ncondtype +icond),'color','k')
                for intv= 1:nintv,    line(temp(ialgn)*[1 1]*int_list(intv)/1000,ylim,'linestyle',':','color',mycolor(intv,:),'Parent', hAxes((ipc-1)*ncondtype +icond)) ;               end
    end
end
end

plotAnn([alignEvent{:}])
set(h.fig,'Visible','on')
orient landscape
parentfolder(savepath,1)
saveall = fullfile(savepath,[savename{:}]);
export_fig(h.fig,saveall,'-pdf','-transparent')
saveas(h.fig,saveall)
% 
%% plot each INTERVAL in its own subplot
LINEWIDTH =2;
savename = ['pcaComponentsErrorCorrect' ' ' saveheader];
mycolor2 = {'g','r','k','b'};
npc = 6;
ncplot= 2 % ncondPerAlignEvent
indbegin = find(xtime>0,1,'first');
for ialgn = 1:nAlign
    thissavename = [alignEvent{ialgn} '_' savename];

    h.fig(ialgn) = figure('Name',alignEvent{ialgn},'Position',[ 31+(926)*(ialgn-1)    39   926   958],'Visible','off');
    clear hAxes  ; hl = []; ind = [];
    for intv= 1:nintv
        for ip = 1:npc
            hAxes(intv+(ip-1)*nintv) = axes;
            ind(end+1) = intv+(ip-1)*nintv;
            
            for ic = 1: ncplot %
                icond = ic+ ncondPerAlignEvent*(ialgn-1);
                pca =  c(icond).pca;
                thiscolor = mycolor2{ic};
                
                %                 hax(intv) = subplot(npc,nintv,intv+(ip-1)*nintv);
                htemp = plot(xtime,pca(intv,:,ip),thiscolor,'linewidth',LINEWIDTH); hold on;
                axis tight
                if intv== nintv  & ip == 1 ,   hl(end+1) = htemp;              end
                sleg{ic} =  cond(ic).sleg;
            end
            if ip==1 , title(num2str(int_list(intv)/1000,'%1.2f')) ;  end

       end
    end
    defaultAxes(hAxes)
    % set all plots of the same PC on same y axis
    for ipc = 1:npc, setAxEq(hAxes([1:nintv]+(ipc-1)*nintv)); setYLabel(hAxes(1+(ipc-1)*nintv),['PC-' num2str(ipc)] );end
    
    setaxesOnaxesmatrix(hAxes,npc,nintv,[],[],h.fig(ialgn))
    defaultLegend(legend(hAxes(nintv),hl,sleg))
    setXlabel(hAxes(1),'time (s)')
    plotAnn(alignEvent{ialgn})
    set(hAxes,'YTickLabel','')
    set(hAxes,'color','none')
    
    % add Interval lines
    temp = [1 -1]; % switch side for TrialInit and firstSidepoke
    for ipc = 1:npca
        for intv = 1:nintv            
            axes(hAxes(intv+(ipc-1)*nintv));
            line([0 0],ylim,'linestyle','-','Parent', hAxes(intv+(ipc-1)*nintv),'color','k');
            line(temp(ialgn)*[1 1]*int_list(intv)/1000,ylim,'linestyle',':','color',mycolor(intv,:),'Parent', hAxes(intv+(ipc-1)*nintv) );
        end
    end
    
    set(h.fig(ialgn),'Visible','On')
    parentfolder(savepath,1)
    saveall = fullfile(savepath,[thissavename]);
    export_fig(h.fig(ialgn),saveall,'-pdf','-transparent')
    saveas(h.fig(ialgn),saveall)
end
%% PLOT HARDEST STIMULI with error of other HARDEST stimulus
%% plot all intervals together
savename = ['Intervals_PCAx vs PCAy' ' ' saveheader];
savename = [[alignEvent{:}] '_' savename];

h.fig = figure('Position',[1058          58         838         922],'Name','PCAx vs PCAy');
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
saveall = fullfile(savepath,[savename{:}]);
export_fig(h.fig,saveall,'-pdf','-transparent')
saveas(h.fig,saveall)
%% 3D

% savename = 'Intervals_PCAx vs PCAy';
% savename = [[alignEvent{:}] '_' savename];

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

