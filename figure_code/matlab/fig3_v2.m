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

load_field_list = {...
    '-pose-tpm-cebra.mat';...
    '-pose-free-cebra.mat';...
    '-rel_dist-cebra.mat';...
    '-mov-tpm-cebra.mat';...
    '-mov-free-cebra.mat';...
    '-sbea-cebra.mat';...
    '-neu-cebra.mat';...
    '-pose-tpm-cebra-reconstruction_error.mat';...
    '-pose-free-cebra-reconstruction_error.mat';...
    '-rel_dist-cebra-reconstruction_error.mat';...
    '-mov-tpm-cebra-reconstruction_error.mat';...
    '-mov-free-cebra-reconstruction_error.mat';...
    '-sbea-cebra-reconstruction_error.mat';...
    '-pose-tpm.mat';...
    '-pose-free.mat';...
    '-rel_dist.mat';...
    '-mov-tpm.mat';...
    '-mov-free.mat';...
    '-sbea.mat';...
    };


%%
data_cell = cell(...
    size(load_field_list,1),...
    size(rootname_list,1)+1);

for m = 1:size(data_cell,1)
    for n = 1:(size(data_cell,2)-1)
        %%
        rootname = rootname_list{n,1};
        fieldname = load_field_list{m,1};

        tempdata = load([rootpath,'\',...
            rootname,...
            fieldname]);

        data_cell{m,n} = tempdata;
    end
end

data_cell(:,4) = load_field_list;

cebra_data_cell = cellfun(@(x) x.cebra,...
    data_cell(1:7,1:3),'UniformOutput',false);

pos_cell = [cellfun(@(x) x.coords3d,...
    data_cell(14:15,1:3),'UniformOutput',false);...
    cellfun(@(x) x.rel_dist,...
    data_cell(16,1:3),'UniformOutput',false)];

mov_cell = cellfun(@(x) x.mov_list,...
    data_cell(17:19,1:3),'UniformOutput',false);

prec_list = cell2mat(cellfun(@(x) x.dist_error,...
    data_cell(8:13,1:3),'UniformOutput',false));

pose_prec_list = prec_list(1:3,:)';
mov_prec_list = 1-prec_list(4:6,:)';
%% get unique_mov_bea and unique_mov_sbea
cmap = flipud(cbrewer2('Spectral',256));

cmap_bea = flipud(cbrewer2('Spectral',40));
cmap_sbea = flipud(cbrewer2('Spectral',18));
%% plot canvas
hall = figure(1);
set(hall,'Position',[1100,100,800,800])
set(hall,'color','white');

%% show cebra
start_x = 0.05;
start_y = 0.85;

box_x = 0.12;
box_y = box_x;

inter_x = 0.01;
inter_y = 0.01;

down_sample_idx = 1;

title_list = {...
    'S1-subject poses';...
    'S1-object poses';...
    'S1-body distances';...
    'S1-subject motifs';...
    'S1-object motifs';...
    'S1-Social motifs';...
    'S1 embedding';...
    };

mouse_name_list = {...
    'Mice pair 1';...
    'Mice pair 2';...
    'Mice pair 3';...
    };

cmap_title_list = {...
    'Position';...
    'Position';...
    'Distance';...
    'BeA Categories';...
    'BeA Categories';...
    'SBeA Categories';...
    'Time (min)'};

cmap_min_max_list = {...
    'min','max';...
    'min','max';...
    'min','max';...
    '0','40';...
    '0','40';...
    '0','18';...
    '0','15';...
    };

dot_size = 0.5;

cebra_label_cell = cell(size(cebra_data_cell));

for m = 1:size(cebra_data_cell,1)
    for n = 1:size(cebra_data_cell,2)
        %% show
        subplot('Position',[...
            start_x+(m-1)*(box_x+inter_x),...
            start_y-(n-1)*(box_y+inter_y),...
            box_x,box_y])
        

        if 1<=m && m<=3
            temp_show_label = mean(pos_cell{m,n},2);
            show_label = round(...
                    255*mat2gray(temp_show_label))+1;

            cmaplist = cmap(show_label,:);

            show_cmap = cmap;

            tempcebra = cebra_data_cell{m,n};

            scatter3(...
            tempcebra(1:down_sample_idx:end,1),...
            tempcebra(1:down_sample_idx:end,2),...
            tempcebra(1:down_sample_idx:end,3),...
            dot_size*ones(size(...
            tempcebra(1:down_sample_idx:end,:),1),1),...
            cmaplist(1:down_sample_idx:end,:),'filled')

            cmap_label = 1:size(cmap,1);

            cebra_label_cell{m,n} = show_label;

        elseif 4<=m && m<=5
            show_label = mov_cell{m-3,n};
            cmaplist = cmap_bea(show_label,:);

            tempcebra = cebra_data_cell{m,n};

            show_cmap = cmap_bea;

            scatter3(...
            tempcebra(1:down_sample_idx:end,1),...
            tempcebra(1:down_sample_idx:end,2),...
            tempcebra(1:down_sample_idx:end,3),...
            dot_size*ones(size(...
            tempcebra(1:down_sample_idx:end,:),1),1),...
            cmaplist(1:down_sample_idx:end,:),'filled')

            cmap_label = 1:size(cmap_bea,1);

            cebra_label_cell{m,n} = show_label;

        elseif m==6
            show_label = mov_cell{m-3,n};
            cmaplist = cmap_sbea(show_label,:);

            tempcebra = cebra_data_cell{m,n};

            show_cmap = cmap_sbea;

            scatter3(...
            tempcebra(1:down_sample_idx:end,1),...
            tempcebra(1:down_sample_idx:end,2),...
            tempcebra(1:down_sample_idx:end,3),...
            dot_size*ones(size(...
            tempcebra(1:down_sample_idx:end,:),1),1),...
            cmaplist(1:down_sample_idx:end,:),'filled')

            cmap_label = 1:size(cmap_sbea,1);

            cebra_label_cell{m,n} = show_label;

        else
            time_cmap = flipud(cbrewer2('Spectral',27000));

            show_cmap = time_cmap;

            neu_cebra = cebra_data_cell{m,n};

            scatter3(...
            neu_cebra(1:down_sample_idx:end,1),...
            neu_cebra(1:down_sample_idx:end,2),...
            neu_cebra(1:down_sample_idx:end,3),...
            dot_size*ones(size(...
            neu_cebra(1:down_sample_idx:end,:),1),1),...
            show_cmap,'filled')

            cmap_label = 1:size(time_cmap,1);

            cebra_label_cell{m,n} = (1:27000)';
        end

        set(gca,'FontSize',6)
        set(gca,'XTickLabel',[])
        set(gca,'YTickLabel',[])
        set(gca,'ZTickLabel',[])
        set(gca,'TickLength',[0,0])
        
        if n == 1
            title(title_list{m})
        end

        if m == 1
            zlabel(mouse_name_list{n})
        end

        % colormap

        if n == 3
            
            cmap_inter_y = 0.008;
            cmap_box_y = 0.005;

            temph = subplot('Position',[...
            start_x+(m-1)*(box_x+inter_x)+box_x/4,...
            start_y-(n-1)*(box_y+inter_y)-cmap_inter_y,...
            box_x/2,cmap_box_y]);

            imagesc(cmap_label)

            colormap(temph,show_cmap)
            
            xlabel(cmap_title_list{m})
            
            set(gca,'XTick',[1,length(cmap_label)])
            set(gca,'XTickLabel',cmap_min_max_list(m,:))
            set(gca,'FontSize',6)
        end
    end
end

%% Procrustes analysis for consistent analysis
pro_cell = cell(size(cebra_data_cell,1),3);

for k = 1:size(pro_cell,1)

    selidx = k;
    
    raw_M1 = cebra_data_cell{selidx,1};
    raw_M2 = cebra_data_cell{selidx,2};
    raw_M3 = cebra_data_cell{selidx,3};
    
    label_M1 = cebra_label_cell{selidx,1};
    label_M2 = cebra_label_cell{selidx,2};
    label_M3 = cebra_label_cell{selidx,3};

    [M1_1,M2_1] = label_match(raw_M1,raw_M2,label_M1,label_M2);
    [M1_2,M3_2] = label_match(raw_M1,raw_M3,label_M1,label_M3);
    [M2_3,M3_3] = label_match(raw_M2,raw_M3,label_M2,label_M3);
    
    % Procrustes analysis
    [d_1,Z_1,transform_1]= procrustes(M1_1,M2_1,"scaling",false);
    [d_2,Z_2,transform_2]= procrustes(M1_2,M3_2,"scaling",false);
    [d_3,Z_3,transform_3]= procrustes(M2_3,M3_3,"scaling",false);

    % Z_1 = transform_1.b * M2_1 * transform_1.T + transform_1.c;
    % Z_2 = transform_2.b * M3_2 * transform_2.T + transform_2.c;
    % Z_3 = transform_3.b * M3_3 * transform_3.T + transform_3.c;

    Z_1 = transform_1.b * M2_1 * transform_1.T;
    Z_2 = transform_2.b * M3_2 * transform_2.T;
    Z_3 = transform_3.b * M3_3 * transform_3.T;
    
    rmse_xz_1 = mean(sqrt(sum((M1_1-Z_1).^2,2)));
    rmse_xy_1 = mean(sqrt(sum((M1_1-M2_1).^2,2)));

    rmse_xz_2 = mean(sqrt(sum((M1_2-Z_2).^2,2)));
    rmse_xy_2 = mean(sqrt(sum((M1_2-M3_2).^2,2)));

    rmse_xz_3 = mean(sqrt(sum((M2_3-Z_3).^2,2)));
    rmse_xy_3 = mean(sqrt(sum((M2_3-M3_3).^2,2)));

    pro_cell{k,1} = [...
        rmse_xy_1,rmse_xz_1;...
        rmse_xy_2,rmse_xz_2;...
        rmse_xy_3,rmse_xz_3;...
        ];

    pro_cell{k,2} = raw_M1;
    pro_cell{k,3} = Z_1;
    pro_cell{k,4} = Z_2;

    disp(k)

    %% temp show
    % figure
    % subplot(131)
    % plot3(M1_1(:,1),M1_1(:,2),M1_1(:,3),'bo')
    % hold on
    % plot3(M2_1(:,1),M2_1(:,2),M2_1(:,3),'g*')
    % hold on
    % plot3(Z_1(:,1),Z_1(:,2),Z_1(:,3),'r+')
    % hold off
    % title({d_1,...
    %     rmse_xz_1,...
    %     rmse_xy_1})
    % 
    % 
    % subplot(132)
    % plot3(M1_2(:,1),M1_2(:,2),M1_2(:,3),'bo')
    % hold on
    % plot3(M3_2(:,1),M3_2(:,2),M3_2(:,3),'g*')
    % hold on
    % plot3(Z_2(:,1),Z_2(:,2),Z_2(:,3),'r+')
    % hold off
    % title({d_2,...
    %     rmse_xz_2,...
    %     rmse_xy_2})
    % 
    % 
    % subplot(133)
    % plot3(M2_3(:,1),M2_3(:,2),M2_3(:,3),'bo')
    % hold on
    % plot3(M3_3(:,1),M3_3(:,2),M3_3(:,3),'g*')
    % hold on
    % plot3(Z_3(:,1),Z_3(:,2),Z_3(:,3),'r+')
    % hold off
    % title({d_3,...
    %     rmse_xz_3,...
    %     rmse_xy_3})

    
    % pause
end

%% 和Neu相关性, procrustes+cosine similarity
inter_p = 1800;
data_len = 27000;

cos_sim_mat = zeros(3*data_len/inter_p,6);

for k = 1:6
    %%
    tempcebra_1 = data_cell{k,1}.cebra;
    tempcebra_2 = data_cell{k,2}.cebra;
    tempcebra_3 = data_cell{k,3}.cebra;

    neu_cebra_1 = data_cell{7,1}.cebra;
    neu_cebra_2 = data_cell{7,2}.cebra;
    neu_cebra_3 = data_cell{7,3}.cebra;

    % procrustes对齐
    % [d_1, Z_1, transform_1] = procrustes(...
    %     neu_cebra_1, tempcebra_1);
    % [d_2, Z_2, transform_2] = procrustes(...
    %     neu_cebra_2, tempcebra_2);
    % [d_3, Z_3, transform_3] = procrustes(...
    %     neu_cebra_3, tempcebra_3);

    [d_1, Z_1, transform_1] = procrustes(...
        neu_cebra_1, tempcebra_1,"scaling",false);
    [d_2, Z_2, transform_2] = procrustes(...
        neu_cebra_2, tempcebra_2,"scaling",false);
    [d_3, Z_3, transform_3] = procrustes(...
        neu_cebra_3, tempcebra_3,"scaling",false);

    Z_1 = transform_1.b * tempcebra_1 * transform_1.T;
    Z_2 = transform_2.b * tempcebra_2 * transform_2.T;
    Z_3 = transform_3.b * tempcebra_3 * transform_3.T;
    
    cos_sim_1 = zeros(size(neu_cebra_1,1),1);
    cos_sim_2 = zeros(size(neu_cebra_2,1),1);
    cos_sim_3 = zeros(size(neu_cebra_3,1),1);

    for m = 1:size(neu_cebra_1,1)
        cos_sim_1(m,1) = cossim(neu_cebra_1(m,:),Z_1(m,:));
        cos_sim_2(m,1) = cossim(neu_cebra_2(m,:),Z_2(m,:));
        cos_sim_3(m,1) = cossim(neu_cebra_3(m,:),Z_3(m,:));
    end
    
    for m = 1:(size(cos_sim_mat,1)/3)
        temp1 = cos_sim_1(...
            (((m-1)*inter_p)+1):(m*inter_p));
        temp2 = cos_sim_2(...
            (((m-1)*inter_p)+1):(m*inter_p));
        temp3 = cos_sim_3(...
            (((m-1)*inter_p)+1):(m*inter_p));
        cos_sim_mat(...
            (((m-1)*3)+1):(m*3),k) = [...
            mean(temp1);...
            mean(temp2);...
            mean(temp3)];
    end
end


%% show alignment
start_x = 0.05;
start_y = 0.43;

box_x = 0.12;
box_y = box_x;

inter_x = 0.01;
inter_y = 0.01;

ds_idx = 30;

mk_size = 2;
mk_width = 0.25;

view_1 = 90-37;
view_2 = 22;

mouse_c = [0.85*ones(1,3);...
    cbrewer2('Set2',2)];

for k = 1:size(pro_cell,1)
    %% load data
    m1 = pro_cell{k,2}(1:ds_idx:end,:);
    z_m2 = pro_cell{k,3}(1:ds_idx:end,:);
    z_m3 = pro_cell{k,4}(1:ds_idx:end,:);
    %% show
    subplot('Position',[...
        start_x+(k-1)*(box_x+inter_x),...
        start_y,...
        box_x,box_y])

    plot3(m1(:,1),m1(:,2),m1(:,3),...
        'o','Color',mouse_c(1,:),...
        'LineWidth',mk_width,...
        'MarkerSize',mk_size)
    hold on
    plot3(z_m2(:,1),z_m2(:,2),z_m2(:,3),...
        '+','LineWidth',mk_width,...
        'Color',mouse_c(2,:),...
        'MarkerSize',mk_size)
    hold on
    plot3(z_m3(:,1),z_m3(:,2),z_m3(:,3),...
        'x','LineWidth',mk_width,...
        'Color',mouse_c(3,:),...
        'MarkerSize',mk_size)
    hold off

    view(view_1,view_2)

    grid on

    set(gca,'FontSize',6)
    set(gca,'XTickLabel',[])
    set(gca,'YTickLabel',[])
    set(gca,'ZTickLabel',[])
    set(gca,'TickLength',[0,0])

    if k == 1
        zlabel('Procrustes analysis')
    end

    if k == 1
        legend({'Mice pair 1','Mice pair 2','Mice pair 3'},...
            'Position',[0.05,0.37,0.1,0.05],...
            'Box','off')
    end

end

%% show quantification
% RMSE for pose
start_x = 0.05;
start_y = 0.23;

box_x = 0.09;
box_y = 0.12;

bar_c = 0.8*ones(1,3);

bar_w = 0.6;

cap_size = 2;

x_bias = 0.3;

subplot('Position',[start_x,start_y,box_x,box_y])
mean_pose_prec = mean(pose_prec_list);
std_pose_prec = std(pose_prec_list)/sqrt(size(pose_prec_list,1));

x_list = 1:3;

x_tick_label = {...
    'Subject';...
    'Object';...
    'Social'};

bar(x_list,mean_pose_prec,bar_w,'FaceColor',bar_c);
hold on
errorbar(x_list,mean_pose_prec,...
    std_pose_prec,'LineStyle','none',...
    'CapSize',cap_size,...
    'Color','k');
hold on
for k = 1:size(pose_prec_list,1)
    tempy = pose_prec_list(k,:);
    plot(x_list+x_bias,tempy,'-o',...
        'LineWidth',0.25,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','w',...
        'Color','k',...
        'MarkerSize',2)
    hold on
end
hold off

box off

set(gca,'FontSize',6)
set(gca,'TickDir','out')

set(gca,'XTickLabel',x_tick_label)

axis([0.3,3.7,0,8])

ylabel('RMSE of poses')

% motif accuracy
start_x = 0.2;

box_x = 0.09;
box_y = 0.12;

subplot('Position',[start_x,start_y,box_x,box_y])

mean_mov_prec = mean(mov_prec_list);
std_mov_prec = std(mov_prec_list)/sqrt(size(mov_prec_list,1));

x_list = 1:3;

x_tick_label = {...
    'Subject';...
    'Object';...
    'Social'};

bar(x_list,mean_mov_prec,bar_w,'FaceColor',bar_c);
hold on
errorbar(x_list,mean_mov_prec,...
    std_mov_prec,'LineStyle','none',...
    'CapSize',cap_size,...
    'Color','k');
hold on
for k = 1:size(mov_prec_list,1)
    tempy = mov_prec_list(k,:);
    plot(x_list+x_bias,tempy,'-o',...
        'LineWidth',0.25,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','w',...
        'Color','k',...
        'MarkerSize',2)
    hold on
end
hold off

box off

set(gca,'FontSize',6)
set(gca,'TickDir','out')

set(gca,'XTickLabel',x_tick_label)

axis([0.3,3.7,0,1.2])

ylabel('Accuracy of motifs')
% Procrustes analysis distance, compare rmse before and after
start_x = 0.36;

box_x = 13*0.03;
box_y = 0.12;

subplot('Position',[start_x,start_y,box_x,box_y])

pro_mat = cell2mat(pro_cell(:,1)');

mean_pro_mat = mean(pro_mat);
std_pro_mat = std(pro_mat)./sqrt(size(pro_mat,1));

raw_x_list = 1:size(pro_cell,1);

x_bias = 0.2;

x_list_left = raw_x_list-x_bias;
x_list_right = raw_x_list+x_bias;

x_list = zeros(size(mean_pro_mat));

x_list(1:2:end) = x_list_left;
x_list(2:2:end) = x_list_right;

bias_x_list = x_list;

bias_x_list(1:2:end) = x_list(1:2:end)+0.125;
bias_x_list(2:2:end) = x_list(2:2:end)-0.125;

x_tick_label = title_list;

bar(x_list,mean_pro_mat,bar_w,'FaceColor',bar_c);
hold on
errorbar(x_list,mean_pro_mat,...
    std_pro_mat,'LineStyle','none',...
    'CapSize',cap_size,...
    'Color','k');
hold on
for k = 1:size(pro_mat,1)
    tempy = pro_mat(k,:);
    % drawline
    for m = 1:(size(pro_mat,2)/2)
        tt_x = x_list((((m-1)*2)+1):(m*2));
        tt_y = tempy((((m-1)*2)+1):(m*2));

        plot(tt_x+[0.125,-0.125],tt_y,'-',...
            'LineWidth',0.25,...
            'Color','k')
        hold on
        plot(tt_x,[1.7,1.7],'-',...
            'LineWidth',0.25,...
            'Color','k')
        hold on
    end
    plot(bias_x_list,tempy,'o',...
        'LineWidth',0.25,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','w',...
        'MarkerSize',2)
    hold on
end
hold off

box off

set(gca,'FontSize',6)
set(gca,'TickDir','out')

set(gca,'XTick',raw_x_list)
set(gca,'XTickLabel',x_tick_label)

axis([0.3,7.7,0,2])

ylabel({'RMSE before and after','Procrustes alignment'})

% Cosine similarity between 6 and neural embeddings
start_x = 0.8;

box_x = 5*0.03;
box_y = 0.12;

subplot('Position',[start_x,start_y,box_x,box_y])
mean_cos_sim_mat = mean(cos_sim_mat);
std_cos_sim_mat = std(cos_sim_mat)./sqrt(size(cos_sim_mat,1));

x_list = 1:6;

x_tick_label = title_list(1:6);

bar(x_list,mean_cos_sim_mat,bar_w,'FaceColor',bar_c);
hold on
plot([0.3,6.7],[mean_cos_sim_mat(1),mean_cos_sim_mat(1)],...
    'k--')
hold on
errorbar(x_list,mean_cos_sim_mat,...
    std_cos_sim_mat,'LineStyle','none',...
    'CapSize',cap_size,...
    'Color','k');
hold on
for k = 1:size(cos_sim_mat,1)
    tempy = cos_sim_mat(k,:);
    plot(x_list+0.3,tempy,'o',...
        'LineWidth',0.25,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','w',...
        'MarkerSize',2)
    hold on
end
hold off

box off

set(gca,'FontSize',6)
set(gca,'TickDir','out')

set(gca,'XTickLabel',x_tick_label)

axis([0.3,6.7,-0.5,1])

ylabel('RMSE of poses')

%% save stat
stat_cell = {...
    pose_prec_list;...
    mov_prec_list;...
    pro_mat;...
    cos_sim_mat};

















