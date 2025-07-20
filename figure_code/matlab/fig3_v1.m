%{
    cebra embedding and correlation
%}
clear all
close all
addpath(genpath(pwd))
%% set path
rootpath = 'D:\paper\jove_20250321\data';
%% load data
data_cell = cell(6,3);

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-pose-tpm-cebra.mat']);

data_cell{1,1} = tempdata.cebra;

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-pose-free-cebra.mat']);

data_cell{2,1} = tempdata.cebra;

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-rel_dist-cebra.mat']);

data_cell{3,1} = tempdata.cebra;

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-mov-tpm-cebra.mat']);

data_cell{4,1} = tempdata.cebra;

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-mov-free-cebra.mat']);

data_cell{5,1} = tempdata.cebra;

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-sbea-cebra.mat']);

data_cell{6,1} = tempdata.cebra;


tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-pose-tpm-cebra-reconstruction_error.mat']);

data_cell{1,2} = tempdata;

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-pose-free-cebra-reconstruction_error.mat']);

data_cell{2,2} = tempdata;

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-rel_dist-cebra-reconstruction_error.mat']);

data_cell{3,2} = tempdata;

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-mov-tpm-cebra-reconstruction_error.mat']);

data_cell{4,2} = tempdata;

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-mov-free-cebra-reconstruction_error.mat']);

data_cell{5,2} = tempdata;

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-sbea-cebra-reconstruction_error.mat']);

data_cell{6,2} = tempdata;

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-pose-tpm.mat']);

data_cell{1,3} = tempdata.coords3d;

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-pose-free.mat']);

data_cell{2,3} = tempdata.coords3d;

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-rel_dist.mat']);

data_cell{3,3} = tempdata.rel_dist;

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-mov-tpm.mat']);

data_cell{4,3} = tempdata.mov_list;

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-mov-free.mat']);

data_cell{5,3} = tempdata.mov_list;

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-sbea.mat']);

data_cell{6,3} = tempdata.mov_list;

tempdata = load([rootpath,'\free-seg1-3tpmss-5wt-20220227-neu-cebra.mat']);

neu_cebra = tempdata.cebra;
%% get unique_mov_bea and unique_mov_sbea
cmap = flipud(cbrewer2('Spectral',256));

all_mov_bea = [data_cell{4,3};data_cell{5,3}];
unique_mov_bea = unique(all_mov_bea);
unique_mov_sbea = unique(data_cell{6,3});

cmap_bea = cbrewer2('Spectral',length(unique_mov_bea));
cmap_sbea = cbrewer2('Spectral',length(unique_mov_sbea));
%% plot canvas
hall = figure(1);
set(hall,'Position',[0,30,800,800])
set(hall,'color','white');

%% show cebra
start_x = 0.01;
start_y = 0.75;

box_x = 0.2;
box_y = box_x;

inter_x = 0.03;
inter_y = 0.02;

cmap_inter_x = 0.002;
cmap_box_x = 0.005;
cmap_box_y = 0.05;

pos_cell = data_cell(1:3,:);
mov_cell = data_cell(4:6,:);

down_sample_idx = 1;

dot_size = 0.5;

title_list = {...
    'S1-subject poses';...
    'S1-subject motifs';...
    'S1-object poses';...
    'S1-object motifs';...
    'S1-body distances';...
    'S1-Social motifs'};

cmap_title_list = {...
    'Position';...
    'Categories';...
    'Position';...
    'Categories';...
    'Distance';...
    'Categories'};

count = 1;

for m = 1:3
    for n = 1:2
        subplot('Position',[...
            start_x+(m-1)*(box_x+inter_x),...
            start_y-(n-1)*(box_y+inter_y),...
            box_x,box_y])

        if n == 1
            temp_show_label = mean(pos_cell{m,3},2);
            show_label = round(...
                    255*mat2gray(temp_show_label))+1;

            cmaplist = cmap(show_label,:);

            show_cmap = cmap;

            tempcebra = pos_cell{m,1};

            scatter3(...
            tempcebra(1:down_sample_idx:end,1),...
            tempcebra(1:down_sample_idx:end,2),...
            tempcebra(1:down_sample_idx:end,3),...
            dot_size*ones(size(...
            tempcebra(1:down_sample_idx:end,:),1),1),...
            cmaplist(1:down_sample_idx:end,:),'filled')

        else
            if m < 3
                show_label = mov_cell{m,3};
                cmaplist = cmap_bea(show_label,:);

                tempcebra = mov_cell{m,1};

                show_cmap = cmap_bea;

                scatter3(...
                tempcebra(1:down_sample_idx:end,1),...
                tempcebra(1:down_sample_idx:end,2),...
                tempcebra(1:down_sample_idx:end,3),...
                dot_size*ones(size(...
                tempcebra(1:down_sample_idx:end,:),1),1),...
                cmaplist(1:down_sample_idx:end,:),'filled')

            else
                show_label = mov_cell{m,3};
                cmaplist = cmap_sbea(show_label,:);

                tempcebra = mov_cell{m,1};

                show_cmap = cmap_sbea;

                scatter3(...
                tempcebra(1:down_sample_idx:end,1),...
                tempcebra(1:down_sample_idx:end,2),...
                tempcebra(1:down_sample_idx:end,3),...
                dot_size*ones(size(...
                tempcebra(1:down_sample_idx:end,:),1),1),...
                cmaplist(1:down_sample_idx:end,:),'filled')
            end
        end

        title(title_list{count})
        
        set(gca,'FontSize',6)
        set(gca,'XTickLabel',[])
        set(gca,'YTickLabel',[])
        set(gca,'ZTickLabel',[])
        set(gca,'TickLength',[0,0])
        %% show cmap
        temph = subplot('Position',[...
            start_x+(m-1)*(box_x+inter_x)+box_x+cmap_inter_x,...
            start_y-(n-1)*(box_y+inter_y)+box_y-cmap_box_y,...
            cmap_box_x,cmap_box_y]);
        
        imagesc((1:size(show_cmap,1))')
        colormap(temph,show_cmap)

        ylabel(cmap_title_list{count})
        
        set(gca,'FontSize',6)
        set(gca,'YTick',[0,size(show_cmap,1)])

        count = count+1;
    end
end

% neu cebra
time_cmap = cbrewer2('Spectral',27000);
subplot('Position',[...
            start_x+(4-1)*(box_x+inter_x),...
            start_y,...
            box_x,box_y])
scatter3(...
    neu_cebra(1:down_sample_idx:end,1),...
    neu_cebra(1:down_sample_idx:end,2),...
    neu_cebra(1:down_sample_idx:end,3),...
    dot_size*ones(size(...
    neu_cebra(1:down_sample_idx:end,:),1),1),...
    cmaplist(1:down_sample_idx:end,:),'filled')

title('S1 embedding')

set(gca,'FontSize',6)
        set(gca,'XTickLabel',[])
        set(gca,'YTickLabel',[])
        set(gca,'ZTickLabel',[])
        set(gca,'TickLength',[0,0])

temph = subplot('Position',[...
            start_x+(4-1)*(box_x+inter_x)+box_x+cmap_inter_x,...
            start_y+box_y-cmap_box_y,...
            cmap_box_x,cmap_box_y]);

show_cmap = time_cmap;

imagesc((1:size(show_cmap,1))')
colormap(temph,show_cmap)

ylabel('Time')

set(gca,'FontSize',6)
set(gca,'YTick',[0,size(show_cmap,1)])        
%% 解码精度, pose
start_x = 0.72;
start_y = 0.65;

box_x = 0.06;
box_y = 0.08;

bar_cmap = 0.8*ones(1,3);

prec_list = cell2mat(cellfun(@(x) x.dist_error,...
    data_cell(:,2),'UniformOutput',false));

pose_prec_list = prec_list(1:3);
mov_prec_list = 1-prec_list(4:6);

subplot('Position',[start_x,start_y,box_x,box_y])
bar(pose_prec_list,'FaceColor',bar_cmap)

box off

set(gca,'FontSize',6)
set(gca,'TickDir','out')
set(gca,'XTickLabel',[])
ylabel('RMSE')

% 解码精度, mov

xtick_label = {'Subject','Object','Social'};

inter_y = 0.01;

subplot('Position',[start_x,start_y-box_y-inter_y,box_x,box_y])
bar(mov_prec_list,'FaceColor',bar_cmap)

box off

set(gca,'FontSize',6)
set(gca,'TickDir','out')
set(gca,'YTick',[0,1])
set(gca,'XTickLabel',xtick_label)
ylabel('Motif accuracy')
%% 和Neu相关性
cos_sim_mat = zeros(3,size(data_cell,1));

for k = 1:size(data_cell,1)
    %%
    tempcebra = data_cell{k,1};

    % procrustes对齐
    [d, Z, transform] = procrustes(neu_cebra, tempcebra);

    cos_sim_1 = cossim(neu_cebra(:,1),Z(:,1));
    cos_sim_2 = cossim(neu_cebra(:,2),Z(:,2));
    cos_sim_3 = cossim(neu_cebra(:,3),Z(:,3));

    cos_sim_mat(:,k) = [cos_sim_1,cos_sim_2,cos_sim_3];
end
%% plot
start_x = 0.82;
start_y = 0.56;

box_x = 0.1;
box_y = 0.17;

bar_w = 0.6;

xlist = 1:6;

mean_cos_sim_mat = mean(cos_sim_mat);
std_cos_sim_mat = std(cos_sim_mat)./(sqrt(size(cos_sim_mat,1)));

subplot('Position',[start_x,start_y,box_x,box_y])
bar(xlist,mean_cos_sim_mat,bar_w,'FaceColor',bar_cmap)
hold on
errorbar(xlist,mean_cos_sim_mat,std_cos_sim_mat,'LineStyle','none',...
    'CapSize',2,'Color','k')
hold on
for k = 1:size(cos_sim_mat,1)
    plot(xlist+bar_w/2,cos_sim_mat(k,:),'o',...
        'MarkerFaceColor','w',...
        'MarkerEdgeColor','k',...
        'LineWidth',0.25,...
        'MarkerSize',2)
    hold on
end
hold off

box off

xtick_label = {...
    'S1-subject poses';...
    'S1-object poses';...
    'S1-body distances';...
    'S1-subject motifs';...
    'S1-object motifs';...
    'S1-Social motifs'};

axis([0.3,6.7,0,0.4])

set(gca,'FontSize',6)
set(gca,'TickDir','out')
set(gca,'XTickLabel',xtick_label)
ylabel('Cosine similarity')

