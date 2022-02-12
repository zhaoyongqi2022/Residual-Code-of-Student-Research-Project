%% This function aims to transform ENU to NED
% Input: coordinate of ENU [x;y;z]
%
% Output: Coordinate of NED [x;y;z]

function [Cor_NED]=enu2ned(Cor_ENU)

% transformation matrix
CTM=[0 1 0;1 0 0;0 0 -1];

Cor_NED=CTM*Cor_ENU;

end