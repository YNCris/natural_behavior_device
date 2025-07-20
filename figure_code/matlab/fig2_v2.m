%{
    cebra embedding and correlation
%}
clear all
close all
addpath(genpath(pwd))
%% set path
rootpath = 'D:\paper\jove_20250321\data_revise';
%% load data
rootname_list = {'free-seg1-1tpmss-1wt-20220226';...
                 'free-seg4-2tpmss-4wt-20220226';...
                 'free-seg1-3tpmss-5wt-20220227'};

data_cell = cell(7,size(rootname_list,1));


for k = 1:size(rootname_list,1)
    
    rootname = rootname_list{k};
    
    tempdata = load([rootpath,'\',...
        rootname,...
        '-neu.mat']);
    
    data_cell{1,k} = tempdata.dff_smo_Fc;
    
    tempdata = load([rootpath,'\',...
        rootname,...
        '-pose-tpm.mat']);
    
    data_cell{2,k} = tempdata.coords3d';
    
    tempdata = load([rootpath,'\',...
        rootname,...
        '-pose-free.mat']);
    
    data_cell{3,k} = tempdata.coords3d';
    
    tempdata = load([rootpath,'\',...
        rootname,...
        '-rel_dist.mat']);
    
    data_cell{4,k} = tempdata.rel_dist';
    
    tempdata = load([rootpath,'\',...
        rootname,...
        '-mov-tpm.mat']);
    
    data_cell{5,k} = tempdata.mov_list';
    
    tempdata = load([rootpath,'\',...
        rootname,...
        '-mov-free.mat']);
    
    data_cell{6,k} = tempdata.mov_list';
    
    tempdata = load([rootpath,'\',...
        rootname,...
        '-sbea.mat']);
    
    data_cell{7,k} = tempdata.mov_list';

    disp(k)
end

%% show data separately
for p = 1:3
    %% plot canvas
    hall = figure(p);
    set(hall,'Position',[1100,100,800,800])
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
        tempdata = data_cell{k,p};
    
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
    
    all_mov_bea = cell2mat(data_cell(5:6,1:3));
    unique_mov_bea = unique(all_mov_bea);
    unique_mov_sbea = unique(cell2mat(data_cell(7,:)));
    
    cmap_bea = flipud(cbrewer2('Spectral',length(unique_mov_bea)));
    cmap_sbea = flipud(cbrewer2('Spectral',length(unique_mov_sbea)));
       
    %% show motifs
    start_x = 0.09;
    start_y = 0.36;
    
    box_x = 0.9;
    box_y = 0.02;
    
    inter_y = 0.012;
    
    motif_cell = data_cell(5:end,p);
    
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
    %% correlation analysis
    tempneu = data_cell{1,p}';
    tempselfpose = data_cell{2,p}';
    temppartnerpose = data_cell{3,p}';
    tempdist = data_cell{4,p}';

    mean_neu = mean(tempneu,2);
    mean_selfpose = mean(tempselfpose,2);
    mean_partnerpose = mean(temppartnerpose,2);
    mean_dist = mean(tempdist,2);

    corr_selfpose = corr(tempneu,tempselfpose);
    corr_partnerpose = corr(tempneu,temppartnerpose);
    corr_dist = corr(tempneu,tempdist);

    corr_mean_selfpose = corr(mean_neu,mean_selfpose);
    corr_mean_partnerpose = corr(mean_neu,mean_partnerpose);
    corr_mean_dist = corr(mean_neu,mean_dist);

    %% show correlation matrix
    start_x = 0.09;
    start_y = 0.08;

    box_x = 0.15;
    box_y = box_x;

    inter_x = 0.015;
    
    corr_cmap = flipud(cbrewer2('RdBu',256));

    body_name = {...
        'Nose';...
        'Left ear';...
        'Right ear';...
        'Neck';...
        'Left front limb';...
        'Right front limb';...
        'Left hind limb';...
        'Right hind limb';...
        'Left front paw';...
        'Right front paw';...
        'Left hind paw';...
        'Right hind paw';...
        'Back';...
        'Tail base';...
        'Mid tail';...
        'Tail tip'};

    % corr self pose
    temph = subplot('Position',[start_x,start_y,box_x,box_y]);
    imagesc(corr_selfpose')
    colormap(temph,corr_cmap)
    clim([-1,1])
    hold on
    plot([size(corr_partnerpose,1),size(corr_partnerpose,1)],[0,49],'-k',...
        'LineWidth',0.25)
    hold on
    plot([0,size(corr_partnerpose,1)+1],0.5*[1,1],'-k',...
        'LineWidth',0.25)
    hold off

    set(gca,'XTick',[1,size(corr_selfpose,1)])

    set(gca,'YTick',2:3:48)
    set(gca,'YTickLabel',body_name)

    set(gca,'TickDir','out')

    set(gca,'FontSize',6)

    box off

    xlabel('Neurons')

    title('Neural activity & subject poses')


    % corr partner pose
    temph = subplot('Position',[...
        start_x+box_x+inter_x,start_y,box_x,box_y]);
    imagesc(corr_partnerpose')
    colormap(temph,corr_cmap)
    clim([-1,1])

    hold on
    plot([size(corr_partnerpose,1),size(corr_partnerpose,1)],[0,49],'-k',...
        'LineWidth',0.25)
    hold on
    plot([0,size(corr_partnerpose,1)+1],0.5*[1,1],'-k',...
        'LineWidth',0.25)
    hold off

    set(gca,'XTick',[1,size(corr_partnerpose,1)])

    set(gca,'YTick',2:3:48)
    set(gca,'YTickLabel',[])

    set(gca,'TickDir','out')

    set(gca,'FontSize',6)

    box off

    xlabel('Neurons')

    title('Neural activity & object poses')


    % corr dist
    temph = subplot('Position',[...
        start_x+2*(box_x+inter_x),start_y,box_x,box_y]);
    imagesc(corr_dist')
    colormap(temph,corr_cmap)
    clim([-1,1])

    hold on
    plot([size(corr_partnerpose,1),size(corr_partnerpose,1)],[0,17],'-k',...
        'LineWidth',0.25)
    hold on
    plot([0,size(corr_partnerpose,1)+1],0.5*[1,1],'-k',...
        'LineWidth',0.25)
    hold off

    set(gca,'XTick',[1,size(corr_dist,1)])

    set(gca,'YTick',1:16)
    set(gca,'YTickLabel',[])

    set(gca,'TickDir','out')

    set(gca,'FontSize',6)

    box off

    xlabel('Neurons')

    title('Neural activity & body distances')

    %% show colorbar
    bar_box_x = 0.06;
    bar_box_y = 0.006;

    bar_inter_y = 0.02;

    temph = subplot('Position',[start_x,start_y+box_y+bar_inter_y,...
        bar_box_x,bar_box_y]);
    imagesc(1:256)
    colormap(temph,corr_cmap)

    set(gca,'FontSize',6)

    set(gca,'TickLength',[0,0])

    set(gca,'XTick',[1,256])

    set(gca,'XTickLabel',[-1,1])
    
    title('Correlation coefficients')
    %% show corr quantification
    mean_corr_selfpose = mean(corr_selfpose,2);
    mean_corr_partnerpose = mean(corr_partnerpose,2);
    mean_corr_dist = mean(corr_dist,2);

    std_corr_selfpose = std(corr_selfpose,[],2)./sqrt(48);
    std_corr_partnerpose = std(corr_partnerpose,[],2)./sqrt(48);
    std_corr_dist = std(corr_dist,[],2)./sqrt(16);

    [sort_mean_corr_selfpose,sort_i] = sort(mean_corr_selfpose,'descend');
    
    sort_mean_corr_partnerpose = mean_corr_partnerpose(sort_i);

    sort_mean_corr_dist = mean_corr_dist(sort_i);

    sort_std_corr_selfpose = std_corr_selfpose(sort_i);

    sort_std_corr_partnerpose = std_corr_partnerpose(sort_i);

    sort_std_corr_dist = std_corr_dist(sort_i);
    %% show
    start_x = 0.64;
    start_y = 0.2;

    box_x = 0.34;
    box_y = 0.05;

    inter_y = 0.01;

    ylabel_list = {...
        {'N & S',...
        'CC'};...
        {'N & O',...
        'CC'};...
        {'N & B',...
        'CC'};...
        };

    mean_cell = {...
        sort_mean_corr_selfpose;...
        sort_mean_corr_partnerpose;...
        sort_mean_corr_dist};

    std_cell = {...
        sort_std_corr_selfpose;...
        sort_std_corr_partnerpose;...
        sort_std_corr_dist};
    
    xlist = 1:length(sort_mean_corr_selfpose);
    
    for k = 1:3
        subplot('Position',[...
            start_x,...
            start_y-(k-1)*(box_y+inter_y),...
            box_x,box_y])
        bar(xlist,mean_cell{k},...
            'FaceColor',0.7*ones(1,3),...
            'EdgeColor','none')
        hold on
        errorbar(xlist,mean_cell{k},std_cell{k},...
            'CapSize',0,'Color','k',...
            'LineStyle','none')
        
        hold off
        
        axis([0,length(xlist),-0.4,0.4])

        ylabel(ylabel_list{k}, 'Rotation', 0)

        box off
        set(gca,'TickDir','out')
        set(gca,'FontSize',6)

        set(gca,'XTick',[1,length(xlist)])

        set(gca,'YTick',[-0.3,0,0.3])

        if k ~= 3
            set(gca,'XTickLabel',[])
        end

        if k == 3
            xlabel('Sorted neurons')
        end
    end
end