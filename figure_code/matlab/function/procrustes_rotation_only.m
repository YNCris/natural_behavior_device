function [Z, R, d] = procrustes_rotation_only(Xref, Y)
% Xref: 参考点集 (N x D)
% Y: 待对齐点集 (N x D)
% 只做旋转，不平移，不缩放
% 输出:
%   Z: 旋转后的 Y 对齐 Xref
%   R: 旋转矩阵
%   d: 匹配误差（归一化平方误差）

    % 先对两者都做中心化，以保证原点匹配
    muX = mean(Xref,1);
    muY = mean(Y,1);
    Xc = Xref - muX;
    Yc = Y - muY;

    % 经典正交 Procrustes 旋转
    [U,~,V] = svd(Yc'*Xc);
    R = V*U';
    if det(R)<0
        V(:,end) = -V(:,end);
        R = V*U';
    end

    % 应用旋转，同时回加中心
    Z = (Yc * R) + muX;

    % 计算归一化误差
    d = sum(sum((Xref - Z).^2)) / sum(sum(Xref.^2));
end
