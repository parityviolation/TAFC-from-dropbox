function [rise fall raw_data binary_data] = getTTLfromAnalog(filein,gpio,bplot)
if nargin < 2
gpio=0;
end

if nargin < 3
bplot =1;
end


nframe = 1; % number of frames that pulse must be low before pulse and high 
% BA
if nargin<1
    [FileName,PathName] = uigetfile('*.csv','Select CSV file with Analog signal');
    filein = [PathName FileName];
end
try
    raw_data = dlmread(filein,' ');
    
    if gpio
    raw_data =raw_data(:,3);
    else
    raw_data =raw_data(:,1);
    end
catch ME % this is a sloppy way of dealing with the possiblity that file may have 1 or 2 columns
    [raw_data time_sec] = readBonsaiCSV(filein);
end
thres = max(raw_data-(median(raw_data)))/2+(median(raw_data));

%
binary_data=raw_data>=thres;
rise = find([0; diff(binary_data)==1]);
fall = find([0; diff(binary_data)==-1]);

% filter even better by requiring a history of low and high before and
% after the rising edge respectively
nrise = length(rise);
include = [];
for irise = 1:nrise
    if (all(binary_data(rise(irise)-nframe:rise(irise)-2) ==0)&& ...% before rising is below threshold
          all(binary_data(rise(irise):rise(irise)+nframe)==1)) % after is above threshold
    include(end+1) = irise;
    end
end
rise = rise(include);

nfall = length(fall);
include = [];
for ifall = 1:nfall
    if (all(binary_data(fall(ifall)-nframe:fall(ifall)-2) ==0)&& ...% before rising is below threshold
          all(binary_data(fall(ifall):fall(ifall)+nframe)==1)) % after is above threshold
    include(end+1) = ifall;
    end
end
fall = fall(include);


if bplot
    plot(raw_data)
    hold on
    plot(rise,ones(1,length(rise))*thres,'.g')
    hold on
    plot(fall,ones(1,length(fall))*thres/2,'.r')
end
