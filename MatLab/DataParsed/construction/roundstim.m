function [ Interval, IntervalSet, fixcount ] = roundstim( IntervalPrecise, Scaling )
%ROUNDSTIM Rounds and normalizes intervals
%   Takes the n-length vector of intervals in miliseconds IntervalPrecise, 
%   where n is the number of trials in a session, and returns:
%   Interval 
%       (n-long vector of Intervals rounded and normalized between 0 and 1), 
%   IntervalSet (unique(Intervals))
%   fixcount (how many Intervals had
%       jitters large enough to get a different rounding, and needed to be
%       corrected)

Interval = round(IntervalPrecise/(Scaling(end)/100))/100;
thresh = Scaling(end)/2/1000;
table = tabulate(Interval);
IntervalSet = table(table(:,3)>thresh,1)';
eliminate = table(table(:,3)<thresh & table(:,3)~=0,1);
fixcount = 0;

for e = 1:length(eliminate)
    fix_ndx = Interval == eliminate(e);
    difference = abs(IntervalSet - eliminate(e));
    nearest = IntervalSet(difference ==  min(difference));
    Interval(fix_ndx) = nearest;
    fixcount = fixcount + sum(fix_ndx);
end
end

