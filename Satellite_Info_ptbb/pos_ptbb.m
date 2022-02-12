%% This script is mean to calculate the sation location with all available function
% Autor Yongqi Zhao
% Datum 19.6.2021
close all;
clear all;
clc;
load('pseudorange_LOS_118249.mat');
load('crd_gnss_ptbb.mat');

% select the LOS Satellite
crd_gnss_LOS=crd_gnss(test_PR_revise(:,2),:);

% fitted in function: satelitte=[prn x y z];
sv_crd=[crd_gnss_LOS(:,4),crd_gnss_LOS(:,1:3)];

pr=test_PR_revise;

pos=calc_pos_test (sv_crd, pr);

% pos_geo=cart2geo(pos);

pos_refer=geo2cart([52+16/60+13.35682/3600,10+32/60+2.41458/3600,117.621]);

delta=pos-pos_refer;
