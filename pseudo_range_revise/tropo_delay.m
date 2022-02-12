%% This function aims to calculate the tropospheric delay
% Author: Yongqi Zhao
% Date 9.7.2021
%
% Reference : Principle of GPS and Receiver Design, page: 86-87
%
% Input: 
% cita: elevation angle of satellites
%
% Output: 
% T: tropospheric delay in [m]

function [T]=tropo_delay(cita)

% deg2rad
cita=deg2rad(cita);

% estimate dry component of tropospheric delay
T_zd=2.3; % m

% estimate wet component of tropospheric delay
T_zw=T_zd/9;

% calculate the inclination of dry component using (4.68)
b_d=sqrt(cita^2+(2.5*pi/180)^2);
F_d=1/b_d;

% calculate the inclination of wet component using (4.69)
b_w=sqrt(cita^2+(1.5*pi/180)^2);
F_w=1/b_w;

% tropospheric delay in signal transmission direction using (4.67)
T=T_zd*F_d+T_zw*F_w;




