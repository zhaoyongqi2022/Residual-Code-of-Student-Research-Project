%% this script aims to find imu corresponding data
% Author Yongqi Zhao
% Date July 12, 2021

close all;
clear all;
clc;

load('20190815_100104_20171211_091939_Record.mat');

% gps time
GPS_Time=Car_IMU.GpsTime;

% Acceleraion: specific force [X,Y,Z,gps_time];
f_ib_b(:,1:3)=[Car_IMU.AccelX(:,1),Car_IMU.AccelY(:,1),Car_IMU.AccelZ(:,1)];
f_ib_b(:,4)=GPS_Time(:,1);

% angular rate : [X,Y,Z,gps_time];
w_ib_b(:,1:3)=[Car_IMU.AngleRateX(:,1),Car_IMU.AngleRateY(:,1),Car_IMU.AngleRateZ(:,1)];
w_ib_b(:,4)=GPS_Time(:,1);

save f_ib_b f_ib_b;
save w_ib_b w_ib_b;




