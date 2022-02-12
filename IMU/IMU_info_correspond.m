%% This script aims to find the corresponding infos of IMU: angular rate and acceleration
% Autor Yongqi Zhao
% Datum 25.6.2021
% Corresponding GPS Time: 118248---118372 according to 'Messdaten' from Google Earth

close all;
clear all;
clc;

% Import Messdaten
Car_IMU=importdata('20190815_100104_20171211_091939_Record.mat');

% Length of the IMU data
L_data=length(Car_IMU.GpsTime);

% find the corresponding index according to GPS Time
for i=1:L_data
    
    % index at the begining of the trajectory
    if Car_IMU.GpsTime(i)==118248
        index_begin=i;
     % index at the end of the trajectory
    elseif Car_IMU.GpsTime(i)==118372
        index_end=i;
    end
end

% sort out the corresponding IMU infos

% Acceleration of IMU in X, Y, Z-Axis respectively
IMU_Accel=[Car_IMU.AccelX(index_begin:index_end,1),...
    Car_IMU.AccelY(index_begin:index_end,1),Car_IMU.AccelZ(index_begin:index_end,1)];
    

% Angular rate of IMU in X, Y, Z-Axis respectively
IMU_Ang_Rat=[Car_IMU.AngleRateX(index_begin:index_end,1),...
    Car_IMU.AngleRateY(index_begin:index_end,1),Car_IMU.AngleRateZ(index_begin:index_end,1)];

% sort out the corresponding GPS Time
GPS_Time=Car_IMU.GpsTime(index_begin:index_end,1);

% time interval calculation
% empty vector defining to store time interval
t_interval=zeros(length(GPS_Time)-1,1);
k=1;
for j=1:length(GPS_Time)-1
    t_interval(k)=GPS_Time(j+1)-GPS_Time(j);
    k=k+1;
end

% % save acceleration and angular rate of trajectory
% save('IMU_Accel.mat','IMU_Accel');
% save('IMU_Ang_Rat.mat','IMU_Ang_Rat');


% % save time interval 
% save('t_interval.mat','t_interval');


        