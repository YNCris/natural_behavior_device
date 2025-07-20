function social_behavior_decomposing(SBeA)
%{
    social behavior decomposing
%}
%%
global SBeA
para = SBeA.Param.segpar;
seglist = SBeA.RawData.selseg;
speedlist = cell2mat(SBeA.RawData.speed);
distlist = SBeA.RawData.dist_body;
%% body seg
%%
[DP_sR, DP_X, DP_XD, DP_XD0, G1] = decompose_poses(seglist, para);
%%
K = conKnl_DTAK(conDist(DP_X, DP_X), para.kerType, para.kerBand, para.sigma);
%%
segDM = decompose_Movement(K, para);

decBehavior = segDM; % initialize decBehavior
decBehavior(2) = segDM;
decBehavior(1).s = DP_sR;
decBehavior(1).sH = DP_sR;
decBehavior(1).G = G1;
decBehavior(1).tim = [];
decBehavior(1).obj = [];
decBehavior(1).T = K;

Seg_cell = cell(2,1);
Seglist = DP_XD0;
Seg_cell{1,1} = Seglist;

TRL = segDM.s;
MapFL = DP_sR;
TFL = 0.*TRL;
for m = 1:size(TRL,2)
    for n = 1:size(MapFL,2)
        if n == TRL(1,m)
            TFL(1,m) = MapFL(1,n);
        end
    end
end
decBehavior(2).s = TFL;
decBehavior(2).G = segDM.G;
Seglist = SegBarTrans(decBehavior(2));
Seg_cell{2,1} = Seglist;

%%
BeA_DecData.K = K;
BeA_DecData.DP_X = DP_X;
BeA_DecData.L1.ReMap = decBehavior(1).s;
BeA_DecData.L1.Seglist = Seg_cell{1};
BeA_DecData.L1.MedData = decBehavior(1);
BeA_DecData.L2.ReMap = decBehavior(2).s;
BeA_DecData.L2.Seglist = Seg_cell{2};
BeA_DecData.L2.MedData = decBehavior(2);

SBeA.SBeA_DecData = BeA_DecData;
%% speed seg
%%
[DP_sR, DP_X, DP_XD, DP_XD0, G1] = decompose_poses(speedlist, para);
%%
K = conKnl_DTAK(conDist(DP_X, DP_X), para.kerType, para.kerBand, para.sigma);
%%
segDM = decompose_Movement(K, para);

decBehavior = segDM; % initialize decBehavior
decBehavior(2) = segDM;
decBehavior(1).s = DP_sR;
decBehavior(1).sH = DP_sR;
decBehavior(1).G = G1;
decBehavior(1).tim = [];
decBehavior(1).obj = [];
decBehavior(1).T = K;

Seg_cell = cell(2,1);
Seglist = DP_XD0;
Seg_cell{1,1} = Seglist;

TRL = segDM.s;
MapFL = DP_sR;
TFL = 0.*TRL;
for m = 1:size(TRL,2)
    for n = 1:size(MapFL,2)
        if n == TRL(1,m)
            TFL(1,m) = MapFL(1,n);
        end
    end
end
decBehavior(2).s = TFL;
decBehavior(2).G = segDM.G;
Seglist = SegBarTrans(decBehavior(2));
Seg_cell{2,1} = Seglist;

%%
BeA_DecData.K = K;
BeA_DecData.DP_X = DP_X;
BeA_DecData.L1.ReMap = decBehavior(1).s;
BeA_DecData.L1.Seglist = Seg_cell{1};
BeA_DecData.L1.MedData = decBehavior(1);
BeA_DecData.L2.ReMap = decBehavior(2).s;
BeA_DecData.L2.Seglist = Seg_cell{2};
BeA_DecData.L2.MedData = decBehavior(2);

SBeA.SBeA_DecData_speed = BeA_DecData;
%% distance seg
%%
[DP_sR, DP_X, DP_XD, DP_XD0, G1] = decompose_poses(distlist, para);
%%
K = conKnl_DTAK(conDist(DP_X, DP_X), para.kerType, para.kerBand, para.sigma);
%%
segDM = decompose_Movement(K, para);

decBehavior = segDM; % initialize decBehavior
decBehavior(2) = segDM;
decBehavior(1).s = DP_sR;
decBehavior(1).sH = DP_sR;
decBehavior(1).G = G1;
decBehavior(1).tim = [];
decBehavior(1).obj = [];
decBehavior(1).T = K;

Seg_cell = cell(2,1);
Seglist = DP_XD0;
Seg_cell{1,1} = Seglist;

TRL = segDM.s;
MapFL = DP_sR;
TFL = 0.*TRL;
for m = 1:size(TRL,2)
    for n = 1:size(MapFL,2)
        if n == TRL(1,m)
            TFL(1,m) = MapFL(1,n);
        end
    end
end
decBehavior(2).s = TFL;
decBehavior(2).G = segDM.G;
Seglist = SegBarTrans(decBehavior(2));
Seg_cell{2,1} = Seglist;

%%
BeA_DecData.K = K;
BeA_DecData.DP_X = DP_X;
BeA_DecData.L1.ReMap = decBehavior(1).s;
BeA_DecData.L1.Seglist = Seg_cell{1};
BeA_DecData.L1.MedData = decBehavior(1);
BeA_DecData.L2.ReMap = decBehavior(2).s;
BeA_DecData.L2.Seglist = Seg_cell{2};
BeA_DecData.L2.MedData = decBehavior(2);

SBeA.SBeA_DecData_dist = BeA_DecData;






























