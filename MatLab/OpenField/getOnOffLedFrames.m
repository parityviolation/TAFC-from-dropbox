function openField = getOnOffLedFrames(openField,filename)

led_intensity = openField.([filename '_intensity']);
%led23_intensity = openfield_struct.led23_intensity(openfield_struct.led23_intensity~=0);
LED_intensity_threshold = max(led_intensity-(median(led_intensity)))/2+(median(led_intensity));
%LED_intensity_threshold = 99000;
on_all_intensity_led_frames=find(led_intensity>=LED_intensity_threshold); %3116 is the first on frame

on_intensity_led_frames = on_all_intensity_led_frames(find(diff(on_all_intensity_led_frames)~=1)+1);
off_intensity_led_frames = on_all_intensity_led_frames(diff(on_all_intensity_led_frames)~=1)+1;
off_intensity_led_frames = off_intensity_led_frames(2:end);

openField.(genvarname([filename '_on_frames'])) = on_intensity_led_frames;
openField.(genvarname([filename '_off_frames'])) = off_intensity_led_frames;

end
