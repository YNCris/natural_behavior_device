function savelist_cell = recluster_savelist_3(ReMap_move_cell,Seglist_move_cell,...
    ReMap_speed_cell,Seglist_speed_cell,...
    ReMap_dist_cell,Seglist_dist_cell)
%%
savelist_move_cell = recluster_savelist(Seglist_move_cell,ReMap_move_cell);
savelist_speed_cell = recluster_savelist(Seglist_speed_cell,ReMap_speed_cell);
savelist_dist_cell = recluster_savelist(Seglist_dist_cell,ReMap_dist_cell);
%% merge savelist_cell
savelist_cell = cell(size(savelist_move_cell));
for k = 1:size(savelist_cell,1)
    %%
    tempmove = savelist_move_cell{k,1};
    tempspeed = savelist_speed_cell{k,1};
    tempdist = savelist_dist_cell{k,1};
    %% unique list
    unique_start = unique([tempmove(:,1);tempspeed(:,1);tempdist(:,1)]);
    unique_end = unique([tempmove(:,2);tempspeed(:,2);tempdist(:,2)]);
    tempsavelist = [unique_start,unique_end,zeros(size(unique_end,1),3)];
    savelist_cell{k,1} = tempsavelist;
end