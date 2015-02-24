% Decode Time 2

intv = 5
icondDecoder =  2; 
icondTest = 2
nunit = size(decode(intv,icondTest).pseudoTrial,3)
clear p 

for iTestTrial = 1:nTest
    % for each timeBin
    for iTestbin = 1:nbin
%         for icondTest = 1  % Test Condition LEFT CORRECT
            thisTestTrial =  squeeze(decode(intv,icondTest).pseudoTrial(iTestTrial, iTestbin,:));
            [~, ind] =min((repmat(spkCountEdge,nunit,1)-repmat(thisTestTrial,1,length(spkCountEdge)))'.^2); % for all units
            
            p(iTestTrial,iTestbin,:,intv,icondTest,icondDecoder) = ones(nbin,1);
            

            for iunit = 1:nunit
                thisTemplate = squeeze(decode(intv,icondDecoder).leaveOutTemplate{iTestTrial}(ind(iunit),:,iunit));
                p(iTestTrial,iTestbin,:,intv,icondTest,icondDecoder) =  squeeze(p(iTestTrial,iTestbin,:,intv,icondTest,icondDecoder))' .* thisTemplate;
                if any(p==0)
                    disp(iunit)
                end
            end
    end
end

imagesc(squeeze(mean(p(:,:,:,intv,icondTest,icondDecoder))))