%% this script aims to calculate the info of satellites

close all;
clear all;
clc;

t=118284;

filename='eph_full';

[crd_gnss, vel_gnss]=calc_gnss_crd(t, filename);

save('crd_gnss.mat','crd_gnss');
save('vel_gnss.mat','vel_gnss');