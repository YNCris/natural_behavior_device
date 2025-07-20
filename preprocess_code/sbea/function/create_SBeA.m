function create_SBeA(social_names,BeA_struct_path,BeA_cell)
%{
    create SBeA_struct
    SBeA:
        -DataInfo
        --path
        --social_name
        --fs

        -Param
        --center_idx
        --SDSDimens
        --SDSize
        --selection
        --segpar
        ---redL
        ---ralg
        ---calg
        ---k
        ---kF
        ---tMi
        ---tMa
        ---nMi
        ---nMa
        ---ini
        ---nIni
        ---kerType
        ---kerBand
        ---sigma

        -RawData
        --traj
        --centered
        --selseg
        --speed
        --dist

        -SBeA_DecData
%}
%%
global SBeA
SBeA.DataInfo.path = BeA_struct_path;
SBeA.DataInfo.social_name = social_names;
SBeA.DataInfo.fs = 30;%BeA_cell{1,1}.DataInfo.VideoInfo.FrameRate;

SBeA.Param.center_idx = BeA_cell{1, 1}.BeA_DecParam.BA.CenIndex;
SBeA.Param.SDSDimens = BeA_cell{1, 1}.BeA_DecParam.BA.SDSDimens;
SBeA.Param.SDSize = BeA_cell{1, 1}.BeA_DecParam.BA.SDSize;
SBeA.Param.selection = [1,1,1,1,1,1,1,1,...
                1,1,1,1,1,1,1,1,...
                1,1,1,1,1,1,1,1,...
                1,1,1,1,1,1,1,1,...
                1,1,1,1,0,0,1,1,...
                0,1,0,0,0,0,0,0];
SBeA.Param.segpar.redL = 5;
SBeA.Param.segpar.ralg = 'merge';
SBeA.Param.segpar.calg = 'density';
SBeA.Param.segpar.k = 40;
SBeA.Param.segpar.kF = 96;
SBeA.Param.segpar.tMi = 2000;%ms
SBeA.Param.segpar.tMa = 5000;%ms
SBeA.Param.segpar.nMi = round((SBeA.DataInfo.fs*SBeA.Param.segpar.tMi/1000) / SBeA.Param.segpar.redL);
SBeA.Param.segpar.nMa = round((SBeA.DataInfo.fs*SBeA.Param.segpar.tMa/1000) / SBeA.Param.segpar.redL);
SBeA.Param.segpar.ini = 'p';
SBeA.Param.segpar.nIni = 1;
SBeA.Param.segpar.kerType = 'g';
SBeA.Param.segpar.kerBand = 'nei';
SBeA.Param.segpar.sigma = 30;

%%
tempdatacell = BeA_cell;
rawtrajcell = cell(size(tempdatacell));
centeredcell = cell(size(tempdatacell));
selsegcell = cell(size(tempdatacell));
speedcell = cell(size(tempdatacell));

center_idx = SBeA.Param.center_idx;
SDSDimens = SBeA.Param.SDSDimens;
SDSize = SBeA.Param.SDSize;
selection = SBeA.Param.selection;
fs = SBeA.DataInfo.fs;

for m = 1:size(tempdatacell,1)
    %%
    rawtrajcell{m,1} = [...
        tempdatacell{m,1}.PreproData.X,...
        tempdatacell{m,1}.PreproData.Y,...
        tempdatacell{m,1}.PreproData.Z];
    %% body centralized and size correction
    tempx = tempdatacell{m,1}.PreproData.X-tempdatacell{m,1}.PreproData.X(:,center_idx);
    tempy = tempdatacell{m,1}.PreproData.Y-tempdatacell{m,1}.PreproData.Y(:,center_idx);
    tempz = tempdatacell{m,1}.PreproData.Z-tempdatacell{m,1}.PreproData.Z(:,center_idx);
    centeredcell{m,1} = zeros(size(rawtrajcell{m,1}));
    centeredcell{m,1}(:,1:3:end) = tempx;
    centeredcell{m,1}(:,2:3:end) = tempy;
    centeredcell{m,1}(:,3:3:end) = tempz;
    centeredcell{m,1} = centeredcell{m,1}';
    temp_XYZ = centeredcell{m,1};
    body_size = ((temp_XYZ(SDSDimens(1,1),:)-temp_XYZ(SDSDimens(1,1)-3,:)).^2+...
        (temp_XYZ(SDSDimens(1,2),:)-temp_XYZ(SDSDimens(1,2)-3,:)).^2+...
        (temp_XYZ(SDSDimens(1,3),:)-temp_XYZ(SDSDimens(1,3)-3,:)).^2).^0.5;
    median_index = median(body_size);
    corr_prop = SDSize./median_index;
    centeredcell{m,1} = temp_XYZ*corr_prop;
    %%
    selsegcell{m,1} = centeredcell{m,1}(selection==1,:);
    %%
    speedcell{m,1} = ...
        (sqrt(([zeros(1,size(tempdatacell{m,1}.PreproData.X(:,:),2));...
        diff(tempdatacell{m,1}.PreproData.X(:,:))]).^2+...
        ([zeros(1,size(tempdatacell{m,1}.PreproData.X(:,:),2));...
        diff(tempdatacell{m,1}.PreproData.Y(:,:))]).^2+...
        ([zeros(1,size(tempdatacell{m,1}.PreproData.X(:,:),2));...
        diff(tempdatacell{m,1}.PreproData.Z(:,:))]).^2)*fs)';
end
seglist = cell2mat(selsegcell);
%% calculate distance, all
temp1 = rawtrajcell{1,1};
temp2 = rawtrajcell{2,1};
tempdistlist = (temp1-temp2).^2;
steplen = size(tempdistlist,2)/3;
distlist = zeros(steplen,size(tempdistlist,1));
for k = 1:size(distlist,1)
    %%
    seldata = tempdistlist(:,[k,k+steplen,k+2*steplen])';
    %%
    distlist(k,:) = sqrt(sum(seldata,1))';
end
%% calculate centered body dist
seglist1 = seglist(1:round(size(seglist,1)/2),:);
seglist2 = seglist((1+round(size(seglist,1)/2)):end,:);
subseglist = (seglist1-seglist2).^2;
newseglist = sqrt(subseglist(1:3:end,:) + subseglist(2:3:end,:) + subseglist(3:3:end,:));
%% save data
SBeA.RawData.traj = rawtrajcell;
SBeA.RawData.centered = centeredcell;
SBeA.RawData.selseg = newseglist;
SBeA.RawData.speed = speedcell;
SBeA.RawData.dist_body = distlist;

SBeA.SBeA_DecData = [];



















