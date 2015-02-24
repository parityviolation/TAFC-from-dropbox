%% GLM fit R, D, RD, S

clear all
close all
clc

if ismac
    dataDir = '/Users/thiago/Dropbox/Paton Lab/Data/';
elseif isunix
    dataDir = '/home/thiago/Dropbox/Paton Lab/Data/';
else
        dataDir = 'C:\Users\Behave\Dropbox\PatonLab\Paton Lab\Data\';
end
 

%% Stuff to tweak
tsSet = [0:6:240];
% tsSet = [0:48:240];
iboot = 100;
nPoints = 10;
coordSet = [];
coordWeight = [];
AUC = nan(iboot,length(tsSet));
perf = nan(iboot,length(tsSet));

%%
for ts = 1:length(tsSet)
% for ts = 12
    display(['Decoding from frames at ' num2str(tsSet(ts)/.12) ' ms from poke in.'])
    % for ts = 3
    %% Correct
    %     framesDir = [dataDir 'TAFC/Frames to decode/JPG/']; % Edgar
    framesDir = [dataDir 'TAFC/Frames to decode2/JPG/']; % Fernando
    filesC = dir([framesDir '*_cor_' num2str(tsSet(ts)) '_*.jpg']);
    filesI = dir([framesDir '*_incor_' num2str(tsSet(ts)) '_*.jpg']);
    % ROIs = nan(800,1120,length(files));
    
    %% Picking ROI
    xl = 201; xr = 1100; yt = 601; yb = 800; % ROI
    % xl = 81; xr = 1200; yt = 101; yb = 900; % box area
    
    roiC = nan(yb-yt+1,xr-xl+1,length(filesC));
    roiI = nan(yb-yt+1,xr-xl+1,length(filesI));
%         figure, imagesc(im); hold on, plot([xl xr xr xl xl],[yt yt yb yb yt]), daspect([1 1 1]), colormap gray
    
    %% 2D Gaussian
    kernel = normpdf(-10:10,0,5); kernel = kernel./sum(kernel);
    kernel2 = kernel'*kernel; kernel2 = kernel2/sum(sum(kernel2));
    clear kernel
%         figure, imagesc(kernel2)
%         rndx = randi(56);
%         figure, imagesc(roiC(:,:,rndx))
%         figure, imagesc(conv2(roiC(:,:,rndx),kernel2))
    
    %% Extracting ROIs
    for fc = 1:length(filesC)
        im = double(imread([framesDir filesC(fc).name]));
        im = squeeze(im(:,:,1));
        linim = reshape(im,1,numel((im)));
        im = (im-mean(linim))./std(linim);
        
        convc = conv2(im,kernel2);
        cropped = convc(yt:yb,xl:xr,1); % crop to ROI
        % cropped = im(101:900,81:1200,1); % crop to box area
        roiC(:,:,fc) = cropped;
    end
    
    for fi = 1:length(filesI)
        im = double(imread([framesDir filesI(fi).name]));
        im = squeeze(im(:,:,1));
        linim = reshape(im,1,numel((im)));
        im = (im-mean(linim))./std(linim);
        
        convi = conv2(im,kernel2);
        cropped = convi(yt:yb,xl:xr,1); % crop to ROI
        % cropped = im(101:900,81:1200,1); % crop to box area
        roiI(:,:,fi) = cropped;
    end
    
    %%
                figure,
                subplot(2,1,1), imagesc(mean(roiC,3)); hold on, plot([xl xr xr xl xl],[yt yt yb yb yt]), daspect([1 1 1])
                subplot(2,1,2), imagesc(mean(roiI,3)); hold on, plot([xl xr xr xl xl],[yt yt yb yb yt]), daspect([1 1 1])
                colormap gray
    %%
    for bs = 1:iboot
        
        %% Selecting points
        [coord, imdiff] = select_points(roiC,roiI,nPoints);

        
        %% Design matrix
        % flat = squeeze(sum(ROIs,1))';
        % flat = conv(flat,kernel,'same');
        
        Xc = nan(size(roiC,3),nPoints);
        for i = 1:size(roiC,3)
            roinow = squeeze(roiC(:,:,i));
            roinow = abs(roinow-median(reshape(roinow,1,numel(roinow))));
            Xc(i,:) = roinow(coord);
        end
        yc = zeros(size(roiC,3),1);
        
        Xi = nan(size(roiI,3),nPoints);
        for i = 1:size(roiI,3)
            roinow = squeeze(roiI(:,:,i));
            roinow = abs(roinow-median(reshape(roinow,1,numel(roinow))));
            Xi(i,:) = roinow(coord);
        end
        yi = ones(size(roiI,3),1);
        
        X = [Xc; Xi];
        y = [yc; yi];
        
        %% Fitting
        trainSetatt = rand(size(y))<0.7;
        testSetatt = ~trainSetatt;
        while var(y(testSetatt))==0
            trainSetatt = rand(size(y))<0.7;
            testSetatt = ~trainSetatt;
            display('Avoided bootstrap error (less than two categories on label vector)')
        end
        trainSet = trainSetatt;
        testSet = testSetatt;
        
        [~,~,glm] = glmfit(X(trainSet,:),y(trainSet),'binomial','constant','off');
        
        logodds = X(testSet,:) * glm.beta;
        coordWeight = [coordWeight, coord .* glm.beta'];
        
        [~,~,~,auclocal] = perfcurve(logical(y(testSet)),logodds,true);
        AUC(bs,ts) = auclocal;
        perf(bs,ts) = mean(y(trainSet));
        if isnan(auclocal)
            display 'AUC is nan'
        end
        
    end
    %     figure, hold on
    %     plot(logodds)
    %     plot(logoddsC,'g')
    %     plot(logoddsI,'r')
    
    % decod = logodds>0;
end
%%
figure('name','Time course of choice predictability'),
plot(tsSet,median(AUC),'linewidth',3)
set(gca,'xtick',tsSet,'xticklabel',tsSet*1000/120,'ytick',[0.5 .75 1],'fontsize',14,'tickdir','out','box','off')
hold on
% patch([tsSet, fliplr(tsSet)],[median(AUC)-std(AUC) fliplr(median(AUC)+std(AUC))],'b','facealpha',0.1,'edgealpha',0);
patch([tsSet, fliplr(tsSet)],[prctile(AUC,25) fliplr(prctile(AUC,75))],'b','facealpha',0.1,'edgealpha',0);

xlabel 'Time from interval onset (ms)'; ylabel aucROC
axis([0 max(tsSet) .45 1])
% annotation('textarrow',[.69 .69],[0.3 0.16])
%%
figure('windowstyle','docked','name','Sampled pixels at example trial'), imagesc(imdiff), daspect([1 1 1])
hold on
[xcoor, ycoor] = ind2sub(size(imdiff),coord);
plot(ycoor,xcoor,'k.')

%%
for i = 1:length(tsSet)
figure('name',['Sampled pixels at ' num2str(tsSet(i)/.12)]),% imagesc(imdiff), daspect([1 1 1])
hold on
[xcoor, ycoor] = ind2sub(size(imdiff),coordSet);
fakeIm = zeros(size(imdiff));
fakeIm(coordSet) = 1;
fakeIm = conv2(fakeIm,kernel2,'same');
imagesc(fakeIm), daspect([1 1 1]), axis tight
end
%
%%
figure('name','Is this concerning?'),
plot(perf(:,ts),AUC(:,ts),'.')

%%
figure('name','Betas projected on image')
canvas = zeros(size(imdiff));
coordWeight(coordWeight>prctile(coordWeight,95)|coordWeight<prctile(coordWeight,5)) = 0;
for i = 1:length(coordSet)
    canvas(coordSet(i)) = canvas(coordSet(i)) + coordWeight(i);
end
imagesc(conv2(canvas,kernel2,'same')), daspect([1 1 1])