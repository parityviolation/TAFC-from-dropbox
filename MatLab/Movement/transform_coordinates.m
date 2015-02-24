function dp = transform_coordinates(dp)

%load image
%click on the 3 ports
%calculate the slope between the two side ports
%calculate the rotation angle theta=tan-1(deltaY/deltaX)
%for each X AND Y, calculate alpha and r. r=sqrt(x2 +y2) and alpha = tan-1(x/y).
%build a funtion f such that [x' y'] = f(vectorX,vectorY, alpha, theta, r);
%how does it calculate it? x' = r.sin(alpha+theta) + x_centre port and
%y'=r.cos(alpha+theta)+ y_centre port

xVectorRaw = dp.video.extremes(:,:,3);
yVectorRaw = dp.video.extremes(:,:,4);

%[FullPathVideo] = selectVideo(dp);

[FullPathVideo] = '/Users/ssoares/Dropbox/PatonLab/Paton Lab/Data/TAFC/Tracking/Frontiers Mice data/BII_TAFCv07_130314_SSAB.avi';

vid = VideoReader(FullPathVideo);

nFrames = vid.NumberOfFrames;
vidHeight = vid.Height;
vidWidth = vid.Width;

imageFrame = 20;

mov(1) = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),'colormap', []);

mov.cdata = read(vid, imageFrame);


figure('WindowStyle', 'docked')
image(mov.cdata)
title ('uncroped image')


figure('WindowStyle', 'docked')

imageCropped = imcrop(mov.cdata,[46 2 568 474]); %croping

image(imageCropped);
title ('CROPPED IMAGE: select: 1st-center poke; 2nd short(right) poke; 3rd long(left) poke')

%click on the 3 ports
[x,y] = ginput(3);

%calculate the slope between the two side ports
centerPortRaw = [x(1) y(1)];
shortPortRaw = [x(2) y(2)];
longPortRaw = [x(3) y(3)];
slope = (shortPortRaw(2)-longPortRaw(2))/(shortPortRaw(1)-longPortRaw(1));

xLineRaw = [shortPortRaw(1) longPortRaw(1)];
yLineRaw = [shortPortRaw(2) longPortRaw(2)];

%calculate the rotation angle theta=tan-1(deltaY/deltaX)
theta = atand(slope);
%theta = 0;

frms = size(xVectorRaw,2);
trials = size(xVectorRaw,1);
%trials = 10;
color = copper(trials);

 
% subtracting the center port
% centerPort = centerPortRaw-centerPortRaw;
% shortPort = shortPortRaw-centerPortRaw;
% longPort = longPortRaw-centerPortRaw;

% xVector = xVectorRaw-centerPortRaw(1);
% yVector = yVectorRaw-centerPortRaw(2);
% 
% xLine = [shortPort(1) longPort(1)];
% yLine = [shortPort(2) longPort(2)];


figure('WindowStyle', 'docked')
image(imageCropped);
title ('tarjectories on image')
hold on
 
for i = 1:trials
    hl = line(xVectorRaw(i,1:frms)',yVectorRaw(i,1:frms)', 'color', color(i,:));
    plot(xVectorRaw(i,1)',yVectorRaw(i,1)','.m', 'markersize',10);
    hf = line(xLineRaw,yLineRaw);
    %hg = line(xLine,yLine);
    %delete(hl)
    hold on
    
end

 plot(centerPortRaw(1),centerPortRaw(2), '.k', 'markersize',20)
 plot(shortPortRaw(1),shortPortRaw(2), '.b', 'markersize',20)
 plot(longPortRaw(1),longPortRaw(2), '.r', 'markersize',20)
 axis tight

 


%for each X AND Y, calculate alpha and r. r=sqrt(x2 +y2) and alpha = tan-1(x/y).


%build a funtion f such that [x' y'] = f(vectorX,vectorY, alpha, theta, r);
%how does it calculate it? x' = r.sin(alpha+theta) + x_centre port and
%y'=r.cos(alpha+theta)+ y_centre port
[xVectorTransRaw,yVectorTransRaw,alpha1,r1] = transformCoordinates(xVectorRaw,yVectorRaw, theta);

[xLineTransRaw,yLineTransRaw,alpha2,r2] = transformCoordinates(xLineRaw,yLineRaw, theta);

[xCenterTransRaw,yCenterTransRaw,alpha3,r3] = transformCoordinates(centerPortRaw(1),centerPortRaw(2), theta);

xVectorTrans = xVectorTransRaw-xCenterTransRaw;
yVectorTrans = yVectorTransRaw-yCenterTransRaw;

xLineTrans = xLineTransRaw - xCenterTransRaw;
yLineTrans = yLineTransRaw - yCenterTransRaw;

xCenterTrans = xCenterTransRaw-xCenterTransRaw;
yCenterTrans = yCenterTransRaw-yCenterTransRaw;

figure('WindowStyle', 'docked')
image(imageCropped);
title ('tarjectories transposed')
hold on
 
for i = 1:trials
    hl = line(xVectorTrans(i,1:frms)',yVectorTrans(i,1:frms)', 'color', color(i,:));
    plot(xVectorTrans(i,1)',yVectorTrans(i,1)','.m', 'markersize',10);
    hf = line(xLineTrans,yLineTrans);
    %delete(hl)
    hold on
    
end

 plot(xCenterTrans,yCenterTrans, '.k', 'markersize',20)
%  plot(shortPortRaw(1),shortPortRaw(2), '.b', 'markersize',20)
%  plot(longPortRaw(1),longPortRaw(2), '.r', 'markersize',20)
 axis tight

 
 dp.video.extremesTransf(:,:,1) = xVectorTrans;
 dp.video.extremesTransf(:,:,2) = yVectorTrans;

%%%%% croping x = 46; y = 2;width = 568; height = 474


 
