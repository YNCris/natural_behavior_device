function BeA_cell = import_BeA_data(BeA_struct_path,tempdataname)
%{
    import BeA_struct
    BeA_cell: save all of the BeA structs in a videos
%}
BeA_cell = cell(size(tempdataname,1),1);
for k = 2:size(tempdataname,2)
    %%
    tempname = [tempdataname{1,k},'-',tempdataname{1,1}];
    %% 
    tempdata = load([BeA_struct_path,'\',tempname]);
    %%
    BeA_cell{k-1,1} = tempdata.BeA;
end