function hf = setArduinoParametersGUI(source_protocol,target_protocol)
% function getArduinoParameters(source_protocol,,target_protocol)
% pull up a uitable with paramemters from sourceprotocol
% % source can be a filepath or a mouseName
% allows user to edit parameters and then right click 's'ave or 'q'uit (in figure not uitable)
% BA
%
[~, ~, all]  = getArduinoParameters(source_protocol);

hf = figure;
[~, fnamein, extin] = fileparts(source_protocol);
[~, fname, ext] = fileparts(target_protocol);
set(hf,'WindowStyle','modal','NumberTitle','off','Name',[fnamein ' TO ' fname ext]);
set(hf,'KeyPressFcn',@updatefigure);

pos = round(get(gcf,'Position'))*.99;
hut = uitable('Data',all','Position',[0 0 pos(3) pos(4)],'ColumnEditable',[true],...
    'ColumnWidth', {7*max(cellfun('length',all)) 'auto'}) ;

hcmenu = uicontextmenu;
% Define the context menu items and install their callbacks
item2 = uimenu(hcmenu, 'Label', 'save to protocol', 'Callback', @helpsave);
item3 = uimenu(hcmenu, 'Label', 'quit',  'Callback',@helpquit );
set(hf,'uicontextmenu',hcmenu)
set(hut,'uicontextmenu',hcmenu)

    function helpsave(src,event)
        editeddata = get(hut,'data')';
        writeArduinoVar(target_protocol,editeddata);
        disp([target_protocol   ' UPDATED']);
        close(hf);
    end
    function helpquit (src,event)
        close(hf);
    end
    
    

end
%   target_protocol = 'C:\Users\Behave\Dropbox\TAFCmice\Code\Arduino\TAFCv08_stimulation02_box0\TAFCv08_stimulation02_box0.ino';
