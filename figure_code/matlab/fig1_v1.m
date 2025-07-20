%{
    show raw image and 3D reconstruction
%}
clear all
close all
addpath(genpath(pwd))
%% set path
rootpath = 'D:\paper\jove_20250321\data\raw_data';
rootname = 'free-seg1-3tpmss-5wt-20220227';
%% load data
vidobj_cell = cell(2,4);

for k = 1:4
    vidobj = VideoReader([...
        rootpath,'\',rootname,'-camera-',...
        num2str(k),'_labeled_tpm.avi']);
    vidobj_cell{1,k} = vidobj;
    vidobj = VideoReader([...
        rootpath,'\',rootname,'-camera-',...
        num2str(k),'_labeled_free.avi']);
    vidobj_cell{2,k} = vidobj;
end

traj3d = load([rootpath,'\',rootname,'-rot3d.mat']);

%% plot canvas
hall = figure(1);
set(hall,'Position',[1000,50,800,800])
set(hall,'color','white');

%% show frames
start_x = 0.05;
start_y = 0.7;

box_x = 0.1;
box_y = box_x*480/640;

inter_x = 0.001;
inter_y = 0.001;

sel_frame_num = 1230;

for m = 1:size(vidobj_cell,1)
    for n = 1:size(vidobj_cell,2)
        subplot('Position',[...
            start_x+(n-1)*(inter_x+box_x),...
            start_y-(m-1)*(inter_y+box_y),...
            box_x,box_y])
        frame = read(vidobj_cell{m,n},sel_frame_num);
        imshow(frame)
    end
end

% show 3D
start_x = 0.28;
start_y = 0.8;

box_x = 0.16;
box_y = 0.16;

setcolor = cbrewer2('Spectral',11);
mouse_tpm_c = setcolor(3,:);
mouse_free_c = setcolor(9,:);

alpha_c = 0.05;
drawline = [ 1 2; 1 3;2 3; 4 5;4 6;5 7;6 8;7 14;8 14;...
    5 9;7 11;6 10; 8 12;14 15; 15 16;5,13;6,13;7,13;8,13;...
    2 4;3 4;5,6;7,8];

sel_poses = traj3d.coords3d(sel_frame_num,:);

traj_tpm_frame = sel_poses(1:48);
traj_free_frame = sel_poses(49:end);

tempx_tpm = traj_tpm_frame(1:3:end)';
tempy_tpm = traj_tpm_frame(2:3:end)';
tempz_tpm = traj_tpm_frame(3:3:end)';

tempx_free = traj_free_frame(1:3:end)';
tempy_free = traj_free_frame(2:3:end)';
tempz_free = traj_free_frame(3:3:end)';

min_axis_x = min([tempx_tpm;tempx_free]);
min_axis_y = min([tempy_tpm;tempy_free]);
min_axis_z = min([tempz_tpm;tempz_free]);
max_axis_x = max([tempx_tpm;tempx_free]);
max_axis_y = max([tempy_tpm;tempy_free]);
max_axis_z = max([tempz_tpm;tempz_free]);

subplot('Position',[start_x,start_y,box_x,box_y])
new_mesh_mouse(traj_tpm_frame,alpha_c,mouse_tpm_c)
hold on
plot_skl_dl(tempx_tpm(:,1),tempy_tpm(:,1),tempz_tpm(:,1),...
    'k','k',drawline)
hold on
new_mesh_mouse(traj_free_frame,alpha_c,mouse_free_c)
hold on
plot_skl_dl(tempx_free(:,1),tempy_free(:,1),tempz_free(:,1),...
    'k','k',drawline)
hold off

grid on
axis([...
    min_axis_x,max_axis_x,...
    min_axis_y,max_axis_y,...
    min_axis_z,50])

view(-69,37)

set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])
set(gca,'ZTickLabel',[])
set(gca,'TickLength',[0,0])

xlabel('x')
ylabel('y')
zlabel('z')

set(gca,'FontSize',6)













