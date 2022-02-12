%% main script to get full eph-data
close all;
clear all;
clc;

filename='ptbb345i.17n';

eph = get_eph_full(filename);

num=eph(19,:);

% save('eph_full.mat','eph');