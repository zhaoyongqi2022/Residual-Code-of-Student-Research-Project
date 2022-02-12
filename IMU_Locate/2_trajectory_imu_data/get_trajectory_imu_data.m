%% this script aims to take imu data of trajectory from original data
% Author Yongqi Zhao
% Date July 12, 2021

close all;
clear all;
clc;

load('w_ib_b.mat');
load('f_ib_b.mat');

% trajectory from 118248 to 118372 (gps time)

% get specific force
for i=1:length(f_ib_b)
    if f_ib_b(i,4)==118248
        index_begin_f=i;
    elseif f_ib_b(i,4)==118372
        index_end_f=i;
    end
end

f_ib_b_traj=f_ib_b(index_begin_f:index_end_f,:);
    
    
% get angular rate
for j=1475513:length(w_ib_b)
    if w_ib_b(j,4)==118248
        index_begin_w=j;
    elseif w_ib_b(j,4)==118372
        index_end_w=j;
    end
end


w_ib_b_traj=w_ib_b(index_begin_w:index_end_w,:);

save f_ib_b_traj f_ib_b_traj;

save w_ib_b_traj w_ib_b_traj;
