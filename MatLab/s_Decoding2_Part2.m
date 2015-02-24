% decode
intv = 3;
nTest = NTESTTRIALS;
nbin = length(bin_end);
% decodeSpikeCount(code,type)
% 
% case 'choice'
nunit = size( decode(intv,icond).pseudoTrial,3);
% for each testTrial
ntimes = 0;
clear p_thisbin
for iTestTrial = 1:nTest
    
    % for each timeBin
    for iTestbin = 1:nbin

        for icond = 1:ncond % Test Condition
                    ntimes = 0;
            if ~isempty(decode(intv,icond).leaveOutTemplate{iTestTrial})
                thisTestTrial =  squeeze(decode(intv,icond).pseudoTrial(iTestTrial, iTestbin,:));
                [~, ind] =min((repmat(spkCountEdge,nunit,1)-repmat(thisTestTrial,1,length(spkCountEdge)))'.^2); % for all units
                
                for icond2 = 1:ncond % Decoded as cond
                    thisntimes = 0;
                    p_thisbin(iTestTrial,iTestbin,intv,icond,icond2) = 1;
                    %spkcountbin, timebin, units
                    
                    for iunit = 1:nunit
                        p_thisbin(iTestTrial,iTestbin,intv,icond,icond2) = p_thisbin(iTestTrial,iTestbin,intv,icond,icond2)*...
                            ( squeeze(decode(intv,icond2).leaveOutTemplate{iTestTrial}(ind(iunit),iTestbin,iunit)));
                        
                        if icond2 ==1
                            if p_thisbin(iTestTrial,iTestbin,intv,icond,icond2) < 1e-10,
                                p_thisbin(iTestTrial,iTestbin,intv,icond,icond2) = p_thisbin(iTestTrial,iTestbin,intv,icond,icond2) *1000;
                                ntimes = ntimes+1;
                            end
                        elseif p_thisbin(iTestTrial,iTestbin,intv,icond,icond2) < 1e-10 & thisntimes < ntimes
                            p_thisbin(iTestTrial,iTestbin,intv,icond,icond2) = p_thisbin(iTestTrial,iTestbin,intv,icond,icond2) *1000;
                            thisntimes = thisntimes+1;
                        end
                    end
                    
                    if icond2 ~=1 
                         p_thisbin(iTestTrial,iTestbin,intv,icond,icond2) = p_thisbin(iTestTrial,iTestbin,intv,icond,icond2) *1000*(ntimes-thisntimes);
                    end
                end
            end
        end
    end
end

                   
%%

% probablity of icond 1
clear p_thisbinCond1
% for each timeBin
for iTestbin = 1:nbin
    
    for icond = 1:ncond % Test Condition
        p_thisbinCond1(:,iTestbin,intv,icond) = diff(p_thisbin(:,iTestbin,intv,icond,:),1,5)./nansum(p_thisbin(:,iTestbin,intv,icond,:),5);
        
    end
end

figure
plot(bin_end/1000,  nanmean(p_thisbinCond1(:,:,intv,icond)));hold all
imagesc( p_thisbinCond1(:,:,intv,icond))


           