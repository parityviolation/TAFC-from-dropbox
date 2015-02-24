function [dp subFieldout]= addVideoWOI_dp(dp,alignEvent,WOImsec,videoField,videosubField)
% BA 071014
% alignEvent = 'firstSidePokeTime';
% WOI  = [3 1]*1000;

if nargin < 4
    videoField = {'cm','extremes','qrRef'};
    videosubField = {{'xy','speed'},{'xy','noseSpeed'},{'modelViewMatrix'}};
end

alField = [alignEvent '_fr'];
WOI_fr = round(WOImsec/1000*dp.video.info.medianFrameRate);
events = dp.video.(alField);

for ifield = 1:length(videoField)
    if isfield(dp.video,videoField{ifield})
        dp.video.(videoField{ifield}).(['WOImsec_' alignEvent]) = WOImsec;
        dp.video.(videoField{ifield}).(['WOIfr_' alignEvent])  = WOI_fr;
        clear temp;
        for isubfield = 1:length(videosubField{ifield})
            data = dp.video.(videoField{ifield}).(videosubField{ifield}{isubfield} )';
            nrow = size(data,1) ;
            thisWOI = [videosubField{ifield}{isubfield} '_' alignEvent];
            temp{isubfield}= thisWOI;
            dp.video.(videoField{ifield}).(thisWOI) = nan(length(events),sum(WOI_fr)+1,nrow);
            for irow = 1:nrow
                [a skipped] = getWOI(data(irow,:),events,WOI_fr);
                dp.video.(videoField{ifield}).(thisWOI)(~skipped,:,irow) = a;
            end
        end
        subFieldout{ifield} = temp;
    end
end