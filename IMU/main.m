%% This script is the main script to calculate position according to IMU-Info
% this script is based on the chapter 5.3 Earth-Frame Navigation Equations
% Autor Yongqi Zhao
% Datum 24.6.2021

% this calculation is executed only ONE step. 
close all;
clear all;
clc;

% delta defining
t_interval=importdata('t_interval.mat');

% importdata angular rate of IMU (Gyroscope)
IMU_Ang_Rat=importdata('IMU_Ang_Rat.mat');

% importdata specific force of IMU (Accelerometer)
IMU_Accel=importdata('IMU_Accel.mat');


% C_b_e_1: C_b_e(-), value at the begining of the navigation equations processing cycle
C_b_e_1=cale_trans_matrix_b_e(); % coordinate transformation matrix from body frame to ecef


% NOT sure about the velocity in GPS, assumed that it is V_eb_n.

% with the available MATLAB-function NED_ECEF, V_eb_e and r_eb_e can be derived.

% initial position of vehicle is GPS_Time 118248
% latitude:52 16 13.47222	longitude:10 32 02.84336	height:117.647
la=deg2rad(52+16/60+13.47222/3600);
lo=deg2rad(10+32/60+2.84336/3600);
height=117.647;

% initial position in Cartesian coordinate
r_eb_e_1=geo2cart([rad2deg(la),rad2deg(lo),height]);
r_eb_e_1=r_eb_e_1';

% initial velocity
v_ib_n=[-3.622;-7.919;-0.024]; % caution: column vector; North East Down

% velocity conversion from v_ib_n to v_ib_i
v_ib_i=velocity_NED_ECI(rad2deg(la),rad2deg(lo),0,v_ib_n);

% velocity conversion from v_ib_i to v_eb_e
v_eb_e_1=velocity_ECI_to_ECEF(0,r_eb_e_1,v_ib_i);

% % position and velocity conversion: resolving axes: n-->e,  1: before
% % update; 2: after update
% [r_eb_e_1,v_eb_e_1] = NED_to_ECEF(la,lo,height,v_eb_n);
% 
% gravity model 
g_b_e= Gravity_ECEF(r_eb_e_1);

% skew-symmtric matrix of the Earth-rotation vector using (5.25) :Om_e_ie

%%
for i=1:length(IMU_Ang_Rat)-1

% Attitude Update


% C_b_e_2:C_b_e(+), value at the end of the navigation equations processing cycle

% based on equation (2.17), where I_n is the n*n identity or unit matrix
I3=eye(3); 

% the skew-symmetric matrix of IMU's angular-rate measurement (function:skew_symm_ang)
Om_b_ib=skew_symm_ang(IMU_Ang_Rat(i,:)); 

% the skew-symmetric matrix of IMU's Earth-rotation vector
% The WGS84 value of the Earth's angular rate: page67
w_i_e=7.292115e-5;
Om_e_ie=skew_symm_earth(w_i_e);

% delta defining
delta=t_interval(i);

C_b_e_2=C_b_e_1*(I3+Om_b_ib*delta)-Om_e_ie*C_b_e_1*delta;  % based on equation (5.27)


%% Specific-Force Frame Transformation

% This part of work is based on the formula 5.28 

% f_ib_b defining: Specific force is the quantity measured by accelerometers. The measurements 
% are made in the body frame of the accelerometer triad; thus, the sensed specific force is f_ib_b.

% f_ib_b value assignment
f_ib_b=IMU_Accel(i,:)'; % caution: column vector

f_ib_e=0.5*(C_b_e_1+C_b_e_2)*f_ib_b;  

%% Velocity Update


% velocity update using (5.36)
v_eb_e_2=v_eb_e_1+(f_ib_e+g_b_e.*r_eb_e_1-2*Om_e_ie*v_eb_e_1)*delta;


%% Position Update

r_eb_e_2=r_eb_e_1+(v_eb_e_1+v_eb_e_2)*(delta/2);


%% initial conditions/values update


% initial body-to-earth-frame coordinate transformation matrix update
C_b_e_1=C_b_e_2;

% initial velocity update
v_eb_e_1=v_eb_e_2;

% position storage
Pos_IMU(i,:)=r_eb_e_2;

% initial position update
r_eb_e_1=r_eb_e_2;
end



