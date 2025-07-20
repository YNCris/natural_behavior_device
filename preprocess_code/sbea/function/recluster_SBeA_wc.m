function [data_sample_cell,wc_struct] = recluster_SBeA_wc(dist_mat_all,data_sample_cell,show_flag)
%% umap embedding of movements
[~, umap, ~] = run_umap(dist_mat_all,'n_neighbors',199,'sgd_tasks',1,...
    'min_dist',0.3,'metric','euclidean','n_components', 2, 'verbose', 'text');
embedding = umap.embedding;
zscore_embed = zscore(embedding);
%% data_sample_cell reassignment
for k = 1:size(data_sample_cell,1)
    data_sample_cell{k,4} = zscore_embed(k,:);
    data_sample_cell{k,2}(1,3) = k;
end
%% watershed identify number of clusters
clusnumlist = zeros(100,1);
for k = 1:size(clusnumlist,1)
    sigma = k;
    prec = 0.01;
    [image,XX,YY,embed_img] = data_density(zscore_embed, sigma, prec);
    [idx,L] = watershed_cluster(image,zscore_embed,embed_img);
    clusnumlist(k,1) = length(unique(idx));
end
%% identify number of classies by stable analysis
up_thres = 0.9;
diff_clus = abs([0;diff(clusnumlist)]);
up_thres_k = up_thres*(max(diff_clus)-min(diff_clus));
temptable = tabulate(diff_clus);
stablep = temptable(temptable(:,2)==max(temptable(:,2)),1);
stableidx = find(diff_clus==stablep+1,1,'first');
new_diff_clus = diff_clus;
max_idx = find(new_diff_clus==max(new_diff_clus));
new_diff_clus(1:max_idx) = max(new_diff_clus);
upidx = find(new_diff_clus<up_thres_k,1,'first');
upsigma = upidx;
downsigma = stableidx;
%% 
sigma = upsigma;
prec = 0.01;
[image_much,XX_much,YY_much,embed_img_much] = data_density(zscore_embed, sigma, prec);
[idx_much,L_much] = watershed_cluster(image_much,zscore_embed,embed_img_much);
sigma = downsigma;
prec = 0.01;
[image_little,XX_little,YY_little,embed_img_little] = data_density(zscore_embed, sigma, prec);
[idx_little,L_ittie] = watershed_cluster(image_little,zscore_embed,embed_img_little);
if show_flag
    showimg = labeloverlay(image_much,L_ittie);
    showimg1 = showimg(:,:,1);
    showimg2 = showimg(:,:,2);
    showimg3 = showimg(:,:,3);
    showimg1(L_much==0) = 100;
    showimg2(L_much==0) = 100;
    showimg3(L_much==0) = 100;
    allshowimg = showimg;
    allshowimg(:,:,1) = showimg1;
    allshowimg(:,:,2) = showimg2;
    allshowimg(:,:,3) = showimg3;
    imshow(allshowimg)
    axis square
end
%% data_sample_cell add data
for k = 1:size(data_sample_cell,1)
    data_sample_cell{k,8} = [idx_little(k,1),idx_much(k,1)];
    data_sample_cell{k,9} = embedding(k,:);
end
%% save wc_struct
wc_struct.image_much = image_much;
wc_struct.XX_much = XX_much;
wc_struct.YY_much = YY_much;
wc_struct.embed_img_much = embed_img_much;
wc_struct.idx_much = idx_much;
wc_struct.L_much = L_much;
wc_struct.image_little = image_little;
wc_struct.XX_little = XX_little;
wc_struct.YY_little = YY_little;
wc_struct.embed_img_little = embed_img_little;
wc_struct.idx_little = idx_little;
wc_struct.L_ittie = L_ittie;















