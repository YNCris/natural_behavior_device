%{
    output sbea label
%}
clear all
close all
%% set path
rootpath = 'D:\paper\jove_20250321\data_revise';
bea_path = [rootpath,'\bea'];
reclus_path = [bea_path,'\recluster_data'];
%% load data
load([reclus_path,'\SBeA_data_sample_cell_20250625.mat']);
%% get name
unique_name = unique(data_sample_cell(:,3));

spl_name = split(unique_name,'-');

merge_name = cellfun(@(a,b,c,d,e) ...
    [a,'-',b,'-',c,'-',d,'-',e],...
    spl_name(:,1),...
    spl_name(:,2),...
    spl_name(:,3),...
    spl_name(:,4),...
    spl_name(:,5),...
    'UniformOutput',false);
%% run batch
for k = 1:size(unique_name,1)
    %% sel name
    sel_name = unique_name{k};
    sel_idx = strcmp(data_sample_cell(:,3),sel_name);
    %% process
    savelist = cell2mat(data_sample_cell(sel_idx,2));
    
    all_label = cell2mat(data_sample_cell(sel_idx,8));
    
    savelist(:,4) = all_label(:,1);
    
    mov_list = zeros(27000,1);
    
    for m = 1:size(savelist,1)
        mov_list(savelist(m,1):savelist(m,2),1) = savelist(m,4);
    end
    
    %% save
    rootsavename = merge_name{k};

    save([rootpath,'\',...
        rootsavename,...
        '-sbea.mat'],...
        'mov_list')
    disp('save!')
end

