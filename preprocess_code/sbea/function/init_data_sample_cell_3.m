function data_sample_cell = init_data_sample_cell_3(savelist_cell,...
    data_move_cell,data_speed_cell,data_dist_cell,fileNames)
%%
data_sample_cell = [];
w_dist = 1;
for k = 1:size(savelist_cell,1)
    temp_savelist = savelist_cell{k,1};
    %%
    for m = 1:size(temp_savelist,1)
        tempmove = data_move_cell{k,1}(:,temp_savelist(m,1):temp_savelist(m,2));
        tempspeed = data_speed_cell{k,1}(:,temp_savelist(m,1):temp_savelist(m,2));
        tempdist = data_dist_cell{k,1}(:,temp_savelist(m,1):temp_savelist(m,2));

        tempsavelist = temp_savelist(m,:);
        tempsavelist(1,5) = m;
        tempfilename = fileNames{k,1};
        data_sample_cell = [data_sample_cell;...
            {tempsavelist,tempfilename,[],tempmove,tempspeed,tempdist}];
    end
end
%% DR distance
dist_all = cell2mat(data_sample_cell(:,end)')';
[~, umap, ~] = run_umap(dist_all,'n_neighbors',80,'sgd_tasks',1,...
'min_dist',0.051,'metric','euclidean','n_components', 2, 'verbose', 'text');
embedding = umap.embedding;
zsdatadist = zscore(embedding',[],2);
%% DR speed
speed_all = cell2mat(data_sample_cell(:,end-1)')';
[~, umap, ~] = run_umap(speed_all,'n_neighbors',80,'sgd_tasks',1,...
'min_dist',0.051,'metric','euclidean','n_components', 2, 'verbose', 'text');
embedding = umap.embedding;
zsdataspeed = zscore(embedding',[],2);
%% DR move
move_all = cell2mat(data_sample_cell(:,end-2)')';
[~, umap, ~] = run_umap(move_all,'n_neighbors',80,'sgd_tasks',1,...
'min_dist',0.051,'metric','euclidean','n_components', 2, 'verbose', 'text');
embedding = umap.embedding;
zsdatamove = zscore(embedding',[],2);
%% 
seglistall = cumsum(cellfun(@(x) size(x,2),data_sample_cell(:,6)));
startlistall = [1;seglistall(1:(end-1),1)+1];
endlistall = seglistall;
savelistall = [startlistall,endlistall];
%% append data
zs_cell = cell(size(data_sample_cell,1),1);
for k = 1:size(zs_cell,1)
    start_pos = savelistall(k,1);
    end_pos = savelistall(k,2);
    zs_cell{k,1} = [...
        zsdatadist(:,start_pos:end_pos);...
        zsdataspeed(:,start_pos:end_pos);...
        zsdatamove(:,start_pos:end_pos)];
end
data_sample_cell = [zs_cell,data_sample_cell];
%%
%  min_dist = min(dist_all,[],2);
% zscore_embed = cell2mat(cellfun(@(x) x',data_sample_cell(:,1),'UniformOutput',false));
% cmap = jet(256);
% cmaplist = cmap(normspeedlist,:);
% scatter(zscore_embed(:,1),zscore_embed(:,2),10*ones(size(zscore_embed,1),1),cmaplist,'filled');
% axis square




% %% temp test
% min_dist = min(dist_all,[],2);
% %% temp show
% speedlist = min_dist;
% normspeedlist = round(mat2gray(speedlist)*255+1);
% cmap = jet(256);
% cmaplist = cmap(normspeedlist,:);
% zscore_embed = zsdatadist';
% scatter(zscore_embed(:,1),zscore_embed(:,2),10*ones(size(zscore_embed,1),1),cmaplist,'filled');
% axis square
% 
% 
% %%
% dist_embed_cell = cell(size(savelistall,1),1);
% for k = 1:size(dist_embed_cell,1)
%     dist_embed_cell{k,1} = zscore_embed(savelistall(k,1):savelistall(k,2),:);
% end
% 
% %% temp show
% for k = 1:size(dist_embed_cell,1)
%     scatter(zscore_embed(:,1),zscore_embed(:,2),10*ones(size(zscore_embed,1),1),cmaplist,'filled');
%     hold on
%     plot(dist_embed_cell{k,1}(:,1),dist_embed_cell{k,1}(:,2),'-*k','LineWidth',2)
%     hold off
%     title(k)
%     axis square
%     pause(0.01)
% end

































