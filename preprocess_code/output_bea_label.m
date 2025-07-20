%{
    output bea label
%}
clear all
close all
%% set path
rootpath = 'D:\paper\jove_20250321\data_revise';
bea_path = [rootpath,'\bea'];
reclus_path = [bea_path,'\recluster_data'];
%% load data
load([reclus_path,'\data_sample_cell.mat']);
%% process
unique_name = unique(data_sample_cell(:,3));

for k = 1:size(unique_name,1)
    %%
    selidx = strcmp(unique_name{k},data_sample_cell(:,3));
    seldsc = data_sample_cell(selidx,:);

    savelist = cell2mat(seldsc(:,2));
    %% create labellist
    mov_list = zeros(savelist(end,2),1);

    for m = 1:size(savelist,1)
        mov_list(savelist(m,1):savelist(m,2),1) = savelist(m,4);
    end
    %% save
    splname = split(unique_name{k,1}(1:(end-11)),'-');
    savename = [...
        splname{1},'-',...
        splname{2},'-',...
        splname{3},'-',...
        splname{4},'-',...
        splname{5},'-',...
        'mov','-',...
        splname{7},'.mat',...
        ];

    save([rootpath,'\',savename],'mov_list');

    disp(k)
end




