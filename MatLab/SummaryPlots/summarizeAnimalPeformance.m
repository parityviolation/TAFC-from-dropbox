%s_summarize_all_animals
mice = {'BII','BIII'}
lastNsession = [35 45]
%%
mice = {'868','867','866' ,'864'}

mice = {'1013','1020' ,'FI12_21','FI12_24','FI12xArCH_117'};

mice = {'1422'}
mice = {'1421'};

mice = {'1109'}
myc = colormap(lines(length(mice)));
 lastNsession = [5]
%%

for im = 1:length(mice)
h= summarizeTAFC(mice{im},lastNsession);
% setColor(h,myc(im,:))
hl(im) = h.hl;
end
legend(hl,mice,'Interpreter','none');