function unit = populateUnit_spikes(unit, curExpt, curTrodeSpikes, varargin)
    unit.spikes = filtspikes(curTrodeSpikes, 0, 'assigns', unit.assign);    
end



