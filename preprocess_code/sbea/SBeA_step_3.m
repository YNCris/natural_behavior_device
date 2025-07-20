%{
    3. Social behavior segmentation
%}
clear all
close all
genPath = genpath('./');
addpath(genPath)
%% Set path
rootpath = ['D:\paper\jove_20250321\data_revise\bea'];
BeA_struct_path = [rootpath,'\struct'];
save_path = [rootpath,'\social_struct'];
mkdir(save_path)
%% create social_names
social_names = {...
    'A',...
    'free-seg1-1tpmss-1wt-20220226-pose-tpm_struct.mat',...
    'free-seg1-1tpmss-1wt-20220226-pose-free_struct.mat';...
    'B',...
    'free-seg1-3tpmss-5wt-20220227-pose-tpm_struct.mat',...
    'free-seg1-3tpmss-5wt-20220227-pose-free_struct.mat';...
    'C',...
    'free-seg4-2tpmss-4wt-20220226-pose-tpm_struct.mat',...
    'free-seg4-2tpmss-4wt-20220226-pose-free_struct.mat';...
    };
%% Social behavior segmentation
for iData = 1:size(social_names,1)
    %% Import dataset
    tempdataname = social_names(iData,:);
    BeA_cell = cell(size(tempdataname,1),1);
    for k = 2:size(tempdataname,2)
        %%
        tempname = tempdataname{1,k};
        %% 
        tempdata = load([BeA_struct_path,'\',tempname]);
        %%
        BeA_cell{k-1,1} = tempdata.BeA;
    end
    %% create SBeA struct
    clear global
    global SBeA
    create_SBeA(social_names,BeA_struct_path,BeA_cell);
    %% Social behavior decomposition
    social_behavior_decomposing(SBeA);
    %% Save data
    save([save_path,'\', tempdataname{2},'_',tempdataname{3},...
        '_',tempdataname{1}(1,1:(end-11)),'_social_struct.mat'], 'SBeA', '-v7.3')
    disp(iData)
end























