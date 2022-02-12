%% This function aims to convert velocity from v_ib_n to v_ib_i
% Autor Yongqi Zhao
% Datum 28.6.2021
%
% Input: Latitude in degree, Longitude in degree, time, v_ib_n (North,East,Down) (Google Earth)
%
% Output: v_ib_i

function[v_ib_i]=velocity_NED_ECI(la,long,t,v_ib_n)

% The WGS84 value of the Earth's angular rate defining using page 67
w_ie=7.292115e-5; % rad/s

% degree to rad
L_b=deg2rad(la);
Lambda=deg2rad(long);

% coordinate transformation matrix defining from NED to ECI using (2.154)

C_n_i=[-sin(L_b)*cos(Lambda+w_ie*t),-sin(Lambda+w_ie*t),-cos(L_b)*cos(Lambda+w_ie*t);...
       -sin(L_b)*sin(Lambda+w_ie*t), cos(Lambda+w_ie*t),-cos(L_b)*sin(Lambda+w_ie*t);...
                           cos(L_b),                  0,                   -sin(L_b)];
                       
% velocity conversion from v_ib_n to v_ib_i using (2.73)
v_ib_i=C_n_i*v_ib_n;
end

