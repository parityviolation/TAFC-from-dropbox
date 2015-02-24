% probabilty of Premature

dp = builddp()

%%
sf = {};
sf(1) = {'PrematureLong'};
sf(2) = {'stimulationOnCond'};
dp.(sf{2})(isnan(dp.(sf{2})))=0;
dp.(sf{1})(isnan(dp.(sf{1})))=0;

a(1) = sum(dp.(sf{1})~=0&dp.(sf{2})~=0);
a(2) = sum(dp.(sf{1})~=0&dp.(sf{2})==0);
a(3) = sum(dp.(sf{1})==0&dp.(sf{2})~=0);
a(4) = sum(dp.(sf{1})==0&dp.(sf{2})==0);

a(1)/(a(1)+a(3)) % fraction in stimulated

a(2)/(a(2)+a(4))  % fraction in nonstimualted

%%
sf = {};
sf(1) = {'TrialInit'};
sf(2) = {'stimulationOnCond'};
dp.(sf{2})(isnan(dp.(sf{2})))=0;
dp.(sf{1})(isnan(dp.(sf{1})))=0;

a(1) = sum(dp.(sf{1})~=0&dp.(sf{2})~=0);
a(2) = sum(dp.(sf{1})~=0&dp.(sf{2})==0);
a(3) = sum(dp.(sf{1})==0&dp.(sf{2})~=0);
a(4) = sum(dp.(sf{1})==0&dp.(sf{2})==0);

a(1)/(a(1)+a(3)) % fraction in stimulated

a(2)/(a(2)+a(4))  % fraction in nonstimualted

%%




