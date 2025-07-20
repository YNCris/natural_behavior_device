%{
    calculate relative distance of two mice
%}
clear all
close all
%% set path
rootpath = 'D:\paper\jove_20250321\data_revise';
%% load data
rootname_list = {'free-seg1-1tpmss-1wt-20220226';...
                 'free-seg4-2tpmss-4wt-20220226';...
                 'free-seg1-3tpmss-5wt-20220227'};

%% run batch
for m = 1:size(rootname_list,1)
    tempdata = load([rootpath,'\',...
        rootname_list{m},'-pose-tpm.mat']);
    pose_tpm = tempdata.coords3d;
    tempdata = load([rootpath,'\',...
        rootname_list{m},'-pose-free.mat']);
    pose_free = tempdata.coords3d;
    %% calculate
    rel_dist = zeros(size(pose_tpm,1),size(pose_tpm,2)/3);
    
    for k = 1:size(rel_dist,2)
        %%
        sel_pose_tpm = pose_tpm(:,(3*(k-1)+1):(3*k));
        sel_pose_free = pose_free(:,(3*(k-1)+1):(3*k));
    
        tempdist = sqrt(sum((sel_pose_tpm-sel_pose_free).^2,2));
    
        rel_dist(:,k ) = tempdist;
    end
    
    %% save
    save([rootpath,'\',...
        rootname_list{m},...
        '-rel_dist.mat'],'rel_dist');
    disp('save!')
end