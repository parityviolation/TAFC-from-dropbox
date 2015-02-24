events = dp.video.pokeIn_fr;
WOI = [0 1999];
data = dp.video.cm.xy;
data = data* cm_px; % cm/sec
data =data(~isnan(data(:,1)),:) ;
datafilt = data;% filtdata(data,hz,lowfilt,'low');


dp.video.extremesTransf(:,:,1) = getWOI(datafilt(:,1),events,WOI);
dp.video.extremesTransf(:,:,2) = getWOI(datafilt(:,2),events,WOI);

plot_trajectories(dp,300)