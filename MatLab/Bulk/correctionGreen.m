function [ data ] = correctionGreen(data,dataGreen,dataRed, hf)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% dataGreen = data.splitCh(1,:);
% dataRed = data.splitCh(2,:);

if ~exist('hf','var')
 hf = figure;
 set(hf, 'WindowStyle', 'docked'); 
    
end


figure(hf)
subplot(4,2,1)
%plot(dataRed,dataGreen,'.','markersize',2);
ndhist(dataRed,dataGreen);

hold on

p = polyfit(dataRed,dataGreen,1);

x(1) = min(dataRed);
x(2) = max(dataRed);

xFit = linspace(x(1),x(2));

yFit = p(1)*xFit + p(2);

plot(xFit,yFit,'k--')

axis square
xlabel ('deltaF/F red','FontSize',13)
ylabel ('deltaF/F green','FontSize',13)
title('DeltaF/F fit','FontSize',13);


predGreen = p(1)*dataRed + p(2);

% plot(dataRed,predGreen,'.k','markersize',2);

corrGreen = dataGreen - predGreen;

data.corrGreen = corrGreen;

subplot(4,2,3)

%plot(dataRed,corrGreen,'.g','markersize',2);
ndhist(dataRed,corrGreen);


axis square
xlabel ('deltaF/F red','FontSize',13)
ylabel ('Corrected green','FontSize',13)
title('DeltaF/F correction','FontSize',13);

end

