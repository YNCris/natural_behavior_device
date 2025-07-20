%{
    cebra embedding and correlation
%}
clear all
close all
addpath(genpath(pwd))
%% set path
rootpath = 'D:\paper\jove_20250321\data';
%% load data
data_cell = cell(7,1);

tempdata = load([rootpath,'\free-seg1-3tpmss-5wt-20220227-neu.mat']);

data_cell{1,1} = tempdata.dff_smo_Fc;

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-pose-tpm.mat']);

data_cell{2,1} = tempdata.coords3d';

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-pose-free.mat']);

data_cell{3,1} = tempdata.coords3d';

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-rel_dist.mat']);

data_cell{4,1} = tempdata.rel_dist';

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-mov-tpm.mat']);

data_cell{5,1} = tempdata.mov_list';

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-mov-free.mat']);

data_cell{6,1} = tempdata.mov_list';

tempdata = load([rootpath,...
    '\free-seg1-3tpmss-5wt-20220227-sbea.mat']);

data_cell{7,1} = tempdata.mov_list';

%% plot canvas
hall = figure(1);
set(hall,'Position',[0,30,800,800])
set(hall,'color','white');

%% show trajectories
start_x = 0.09;
start_y = 0.8;

box_x = 0.9;
box_y = 0.12;

inter_y = 0.012;

setcolor = cbrewer2('Spectral',11);
mouse_tpm_c = setcolor(3,:);
mouse_free_c = setcolor(9,:);

show_time_tick = 0:1800:27000;

for k = 1:4
    %%
    temph = subplot('Position',[...
        start_x,...
        start_y-(k-1)*(box_y+inter_y),...
        box_x,box_y]);
    tempdata = data_cell{k,1};

    if k == 1
        clim_min = 0;
        clim_max = 2;

        imagesc(tempdata,[clim_min,clim_max])
        colormap(temph,cbrewer2('Blues',256))

        axis_y_min = 1;
        axis_y_max = size(tempdata,1);

        set(gca,'YTick',[1,size(tempdata,1)])
        ylabel('Neurons')
    else
        if k == 2
            cmap = mouse_tpm_c;
        elseif k == 3
            cmap = mouse_free_c;
        else
            cmap = (mouse_tpm_c+mouse_free_c)/2;
        end


        for m = 1:size(tempdata,1)
            plot(1:size(tempdata,2),...
                m-1+10*smooth(mat2gray(tempdata(m,:)),30)-5,...
                '-','Color',cmap)
            hold on
        end
        hold off

        axis_y_min = -6;
        axis_y_max = size(tempdata,1)+6;

        set(gca,'YTick',[axis_y_min,axis_y_max])
        set(gca,'YTickLabel',{'Nose','Tail tip'})

        if k == 2
            ylabel('Subject poses')
        elseif k == 3
            ylabel('Object poses')
        else
            ylabel('Body distances')
        end
    end

    axis([0,size(tempdata,2),axis_y_min,axis_y_max])

    set(gca,'XTick',show_time_tick)
    set(gca,'XTickLabel',[])

    box off
    set(gca,'TickDir','out')
    set(gca,'FontSize',6)
end

%% get unique_mov_bea and unique_mov_sbea
cmap = flipud(cbrewer2('Spectral',256));

all_mov_bea = [data_cell{5,1},data_cell{6,1}];
unique_mov_bea = unique(all_mov_bea);
unique_mov_sbea = unique(data_cell{7,1});

cmap_bea = cbrewer2('Spectral',length(unique_mov_bea));
cmap_sbea = cbrewer2('Spectral',length(unique_mov_sbea));
   
%% show motifs
start_x = 0.09;
start_y = 0.36;

box_x = 0.9;
box_y = 0.02;

inter_y = 0.012;

motif_cell = data_cell(5:end,:);

ylabel_list = {...
    'Subject motifs';...
    'Object motifs';...
    'Social motifs'};

for k = 1:3
    %%
    temph = subplot('Position',[...
        start_x,...
        start_y-(k-1)*(box_y+inter_y),...
        box_x,box_y]);
    tempdata = motif_cell{k,1};

    imagesc(tempdata)

    if k<3
        cmap = cmap_bea;
    else
        cmap = cmap_sbea;
    end
    colormap(temph,cmap)

    axis([0,27000,0.5,1])

    ylabel(ylabel_list{k},'Rotation',0)

    set(gca,'FontSize',6)

    set(gca,'YTick',[])
    set(gca,'XTick',show_time_tick)

    if k<3
        set(gca,'XTickLabel',[])
    else
        set(gca,'XTickLabel',0:15)
        xlabel('Time (min)')
    end

    set(gca,'TickDir','out')
    box off
    
end

%% colorbar全放最上面
start_x = 0.09;
start_y = 0.93;

box_x = 0.06;
box_y = 0.006;

inter_x = 0.05;

title_list = {...
    'ΔF/F';...
    'Individual motifs';...
    'Social motifs'};

for k = 1:3
    temph = subplot('Position',[...
        start_x+(k-1)*(box_x+inter_x),start_y,...
        box_x,box_y]);

    if k == 1
        cmap = cbrewer2('Blues',256);
    end

    if k == 2
        cmap = cmap_bea;
    end

    if k == 3
        cmap = cmap_sbea;
    end
    
    imagesc(1:size(cmap,1))
    colormap(temph,cmap)

    title(title_list{k})

    set(gca,'FontSize',6)

    set(gca,'XTick',[1,size(cmap,1)])

    if k == 1
        set(gca,'XTickLabel',[0,2])
    end
end
