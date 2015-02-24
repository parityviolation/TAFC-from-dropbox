  struct_names = {'BVA__2014-04-09_#468-cell#7-3021_6'};
% %     
% % 
% % % ;...
% % %     'BVA__2014-04-09_#468-cell#7-3021_7';...
% % %     'BVA__2014-04-09_#468-field2_8';...
% % %     'BVA__2014-04-09_#468-field2_8'};
% % 
% % 
% % %%
  struct = loadAcuteStruct(struct_names{1});
%%

fps = 20;
quality = 100;

%mv=avifile('test2.avi', 'fps', fps, 'quality', 100);
mv=VideoWriter('test2.avi','Motion JPEG AVI');
mv.FrameRate = fps;
mv.Quality = quality;
open(mv);


h=figure;
%set(h, 'WindowStyle', 'docked');
clear idx;
clear stim;


wind=struct.samp_rate*(1/fps);
stim = nan(1,length(struct.filt_h));


idx(1,:) = [struct.samp_rate*struct.offset:1/struct.pulse_freq*struct.samp_rate:struct.samp_rate*struct.offset+3*struct.samp_rate];
idx(2,:) = idx(1,:)+struct.pulse_width/1000*struct.samp_rate-1;
idx = idx(:,1:end-1);

for i =1:length(idx)
    
    stim(idx(1,i):idx(2,i)) = [idx(1,i):idx(2,i)];

    
end

lastj = 0;
for i=4%1:length(mat_frame(:,1))
    for j=wind:wind:length(struct.filt_h_split(:,i))
        
        
        plot(struct.filt_h_split(lastj+1:j,i),'k')
        %plot(struct.filt_h_split(lastj+1:j,i),'k')
        hold on
        %
        if j>struct.samp_rate*struct.offset & j<struct.samp_rate+3*struct.samp_rate
            
            %y = ones(1,length(stim(1:j)))*max(struct.filt_h_split(:,i));
            y = ones(1,length(stim(lastj+1:j)))*max(struct.filt_h_split(:,i));
            
            %plot(stim(1:j),y,'color','b','LineWidth',4)
            plot(stim(lastj+1:j),y,'color','b','LineWidth',4)
            
            hold on
        end
        %                 if j>struct.samp_rate+3*struct.samp_rate
        %
        %                     y = ones(1,length(stim))*max(struct.filt_h_split(:,i));
        %
        %                      plot(stim,y,'color','b','LineWidth',4)
        %                 end
        
        axis([0 length(struct.filt_h_split(:,i)) min(struct.filt_h_split(:,i)) max(struct.filt_h_split(:,i))])
        
        axis off
        
        F=getframe(h);
        %mv=addframe(mv,F);
        
        writeVideo(mv,F);
    end
    
    lastj = j;
    
end
 
 
close(mv);
 
spike_sound=struct.filt_h_split(:,i);
 
wavwrite(spike_sound,struct.samp_rate,'temp')