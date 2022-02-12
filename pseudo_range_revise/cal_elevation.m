%% this function aims to calculate elevation angle
% Author Yongqi Zhao
% Date 8.7.2021
%
% Reference: Principle of GPS and Receiver Design, page 48-49
%
% Input: 
% user_loc_ecef: [x;y;z] in ecef
% sate_loc_ecef: [x_s;y_s;z_s] in ecef
% user_loc_geo: [latitude;longitude]
% 
% Output:
% elevation angle: cita

function [cita]=cal_elevation(user_loc_ecef,sate_loc_ecef,user_loc_geo)

% observation vector using (3.13)
delta_ecef=sate_loc_ecef-user_loc_ecef;

% geo position deg2rad
la=deg2rad(user_loc_geo(1));
lo=deg2rad(user_loc_geo(2));

% transformation matrix from ECEF to ENU using (3.17)
C_e_n=[-sin(lo)          cos(lo)                 0;
       -sin(la)*cos(lo)  -sin(la)*sin(lo)  cos(la);
       cos(la)*sin(lo)   cos(la)*sin(lo)   sin(la)];
   
% calculate [delta_e;delta_n;delta_u] using (3.15)
delta_enu=C_e_n*delta_ecef;

% elevation angle calculation in [rad] using (3.18)

% delta_u (numerator)
delta_u=delta_enu(3);

% denominator 
deno=sqrt(delta_enu(1)^2+delta_enu(2)^2+delta_enu(3)^2);

cita= asin(delta_u/deno);

% program end
end








