function [ ] = plot_raw_filt( data,type)
%plot_raw_filt overlaps raw and filtered data for full sessions


%   data_raw and data_filt is the vector with data raw and filtered with n_samples as columns
%   samp_rate is the sampling rate at which data was acquired
%   type is a scalar value from 0 to 2 where 0-plot only raw, 1-plot only
%   filtered_low pass, 2 - plot only filtered high pass, 3 - plot all

r = brigdefs();
samp_rate = data.samp_rate;
data_raw = data.raw;
 

if type==0

plot([1:length(data_raw)]/samp_rate,data_raw,'k');

elseif type == 1    

plot([1:length(data_filt)]/samp_rate,data_filt,'b');

elseif type==2
    
plot([1:length(data_raw)]/samp_rate,data_raw,'k');
 hold on;
 plot([1:length(data_filt)]/samp_rate,data_filt,'b');


 patht = fullfile(r.Dir.SummaryFig, 'Full_Session',nAnimal);
 parentfolder(patht,1)
 savefiledesc = [sAnnot savename_fig1];
 export_fig(hf2pt, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
 saveas(hf2pt, fullfile(patht,[savefiledesc '.fig']));
 
end

