% function [ pos_xyz modelViewMatrix] = readBonsaiQRMarkerCSV(filein)
% function [modelViewMatrix pos_xyz] = readBonsaiQRMarkerCSV(filein)
% read CSV with 1 col of a value and 2nd col of timestamp

%BA
filein{1} ='C:\Users\Bassam\Documents\qr40.csv';
filein{2} ='C:\Users\Bassam\Documents\qr41.csv';
filein{3} ='C:\Users\Bassam\Documents\qr41.csv';

if ~iscell(filein)
    files{1} = filein;
else
    files = filein;
end

clear pos_xyz modelViewMatrix
for ifile = 1:length(files)
    f = fopen(files{ifile});
    file = textscan(f,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f');
    fclose(f);
    
    for i = 1:16 % for each colunm
        modelViewMatrix(i,:,ifile) = cell2mat(file(i));
    end
    
    for iframe = 1:size(position_data(ifile).modelViewMatrix,2)
        if all((modelViewMatrix(:,iframe,ifile))==0)  % remove frames where  marker was not detected
            modelViewMatrix(:,iframe,ifile) = NaN;
        end
    end
    
    pos_xyz(:,:,ifile) = position_data(ifile).modelViewMatrix([13 14 15],:)';
end

%% plotting


figure(1);clf;
% plotting
clear pos_avg
% combine all markers
for iaxis = 1:3
    pos_avg(:,iaxis) = nanmean(squeeze(pos_xyz(:,iaxis,:)),2);
    subplot(1,3,iaxis)
    plot(pos_avg(:,iaxis)); hold all
end

figure(2)
plot(pos_avg(:,1),pos_avg(:,2))



