function dp = paramTraj(dp)
bplot = 1;
% method = 'circle'
x = dp.tempTrajTone2(:,:,1);
x = x(:);
y = dp.tempTrajTone2(:,:,2);
y = y(:);
bkeep = ~isnan(x)&~isnan(y);
xToFit = x(bkeep);yToFit = y(bkeep);


% FitCircle
%   There are lots of ways to do this don't get hung up on it for now
% get Theta;s (could use a subset of data, could squash to be more
% circular, could try elipse fit but not sure how to convert everything.
% could take distance from fit)
% add as field in DP for each 
%
[xc,yc,R] = Landau_new(xToFit,yToFit); % fit circle
dp.paramTraj.circfit = [xc,yc,R];

if bplot
plot(x,y,'ok'); hold all;
circle(xc,yc,R)
end
% convert to polar coordinates centered in the middle of the fit circle
[theta,rho]= cart2pol(x-xc,y-yc);
 dp.polarTrajTone2 = [theta,rho];
 
 dp.polarTraj = nan(size(dp.tempallTraj));
 
%  % convert entire trajectories
 for iframe = 1:size(dp.tempallTraj,2)
     
     x = dp.tempallTraj(:,iframe,1);
     x = x(:);
     y = dp.tempallTraj(:,iframe,2);
     y = y(:);
     
     
     [dp.polarTraj(:,iframe,1) dp.polarTraj(:,iframe,2)] = cart2pol(x-xc,y-yc);
 end
 
 % non-parsed
 [dp.video.extremes.polar(:,1)  dp.video.extremes.polar(:,2)]= cart2pol(dp.video.extremes.xy(:,4)-xc,dp.video.extremes.xy(:,3)-yc);
%  
% 
 

