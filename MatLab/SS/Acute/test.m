

for i = 1:3%length(struct_names)
    
    h = figure;
    set(h, 'WindowStyle', 'docked');
    data.pulses=pulses;
    i_color = 0;
    
    data = structs.(['data' num2str(i)]);
    
    for i_pulse=pulses
        
        i_color = i_color+1;
        [a b] = getWOI(data.raster',idx_full_sess(:,i_pulse),[window_before window_after]);
        
        
        pta(:,i_color) = mean(a)'*samp_rate;
        smooth_pta(:,i_color) = conv(pta(:,i_color),kernel,'same');
        
        %plot([1:length(pta)]/data.samp_rate*1000-before*1000,pta,'k')
        %hold on
        plot([1:length(smooth_pta(:,i_color))]/data.samp_rate*1000-before*1000,smooth_pta(:,i_color),'color',mycolor(i_color,:),'linewidth',2);
        hold on
        sleg{i_color}=['trial number ' num2str(i_pulse)];
        
        integral(i_color) = sum(smooth_pta(:,i_color));
        
        
    end
    
    frac(i) = integral(end)/integral(1);
    
    data.smooth_pta = smooth_pta;
    data.pta = pta;
    
    
end
