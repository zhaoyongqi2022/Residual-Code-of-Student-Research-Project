%%  This script is mean to calculate the location of satellite from navigation file
% Autor Yongqi Zhao
% Datum 19.6.2021
close all;
clear all;
clc;

% filename='ptbb3450.17n';
eph=get_eph('ptbb3450.17n');

filename='eph';
t=118284;
[crd_gnss, vel_gnss]=calc_gnss_crd(t, filename);

save('crd_gnss_ptbb.mat','crd_gnss');
save('vel_gnss_ptbb.mat','vel_gnss');