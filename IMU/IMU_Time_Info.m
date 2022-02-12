%% Car_IMU time info
% Autor Yongqi Zhao
% Datum 29.6.2021
close all;
clear all;
clc;

load('20190815_100104_20171211_091939_Record.mat')

IMU_UnixTime=Car_IMU.UnixTime;
IMU_GpsTime=Car_IMU.GpsTime;
j=1;
for i=1:length(IMU_UnixTime)-1
    delta_UnixTime(j,:)=IMU_UnixTime(i+1)-IMU_UnixTime(i);
    delta_GpsTime(j,:)=IMU_GpsTime(i+1,1)-IMU_GpsTime(i,1);
    j=j+1;
end

delta_60=delta_UnixTime/60;