%% This script is main script to update imu data
% Author Yongqi Zhao
% Date July 13, 2021

close all;
clear all;
clc;

% initial point 118247.5
% [52 16 13.47222	10 32 02.84336	117.647]

% specific force of body frame w.r.t. ECEF frame, resolved
% along body-frame axes, averaged over time interval (m/s^2)    
f_ib_b=importdata('w_ib_b_traj.mat');

% angular rate of body frame w.r.t. ECEF frame, resolved
% about body-frame axes, averaged over time interval (rad/s)
omega_ib_b=importdata('f_ib_b_traj.mat');

% time interval between epochs (s)
counter=1;
for i=2:length(f_ib_b)
    tor_i(counter,1)=f_ib_b(i,4)-f_ib_b(i-1,4);
    counter=counter+1;
end

% previous latitude (rad)
old_L_b=deg2rad(52+16/60+13.47222/3600);

%  previous longitude (rad)
old_lambda_b=deg2rad(10+32/60+02.84336/3600);

%  previous height (m)
old_h_b=117.647;

% previous body-to-NED coordinate transformation matrix
euler=deg2rad([0.47246;-0.86630;360-246.33816]); % r;p;y
old_C_b_n=Euler_to_CTM(euler);

%  previous velocity of body frame w.r.t. ECEF frame, resolved
%  along north, east, and down (m/s)
v_enu=[-7.919;-3.622;-0.024	]; % ENU
old_v_eb_n=[v_enu(2);v_enu(1);-v_enu(3)]; % NED   


for j=1:length(f_ib_b)-1
    
[L_b,lambda_b,h_b,v_eb_n,C_b_n] = Nav_equations_NED(tor_i(j),...
        old_L_b,old_lambda_b,old_h_b,old_v_eb_n,old_C_b_n,f_ib_b(j,1:3)',omega_ib_b(j,1:3)');


% position store
pos_geo(j,:)=[rad2deg(L_b),rad2deg(lambda_b),h_b];
    
% position update
old_L_b=L_b;
old_lambda_b=lambda_b;
old_h_b=h_b;

% velocitiy update
old_v_eb_n=v_eb_n;

% CTM update
old_C_b_n=C_b_n;

end
    
    
    
    