%% This function is transformation matrix C_b_n: from body frame to local navigation frame
% Author Yongqi Zhao
% Date July 13,2021
%
% Reference: Groves GNSS: page 34 using (2.22)
% 
% Input : Euler angle [phi;cita;Phi]; Euler angles describing rotation from "beta to alpha"; 
% phi: rolling 
% cita: pitching
% Phi: yawing (Caution!!)
%
% Output: C_b_n: transformation matrix from body frame to local navigation frame

function [C_b_n]=trans_matrix_body_navi(euler)

% roll
r=deg2rad(euler(1));


% pitch
p=deg2rad(euler(2));

% yaw
y=deg2rad(euler(3));

% transformation matrix from body frame to local navigation frame
C_b_n=[cos(p)*cos(y)                           cos(p)*sin(y)                         -sin(p)
       -cos(r)*sin(y)+sin(r)*sin(p)*cos(y)     cos(r)*cos(y)+sin(r)*sin(p)*sin(y)    sin(r)*cos(p)
       sin(r)*sin(y)+cos(r)*sin(p)*cos(y)      -sin(r)*cos(y)+cos(r)*sin(p)*sin(y)   cos(r)*cos(p)];
   
% program end
end



