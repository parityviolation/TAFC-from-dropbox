function saveBstruct(dp)
r = brigdefs();
if isfield(dp,'collectiveDescriptor') % save dpArray
    fname =  dp(1).collectiveDescriptor;
else
    [junk fname junk] = fileparts(dp.FileName);
end
disp('******** saving saving dataparsed');
save(fullfile(r.Dir.BStruct,[fname '_bstruct']), 'dp');

