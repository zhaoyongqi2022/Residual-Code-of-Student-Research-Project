%% test satellite temp

close all
clear 
clc

t=116397;
filename='ptbb345i.17n';

[crd_gnss,vel_gnss]=main_satellite_position_velocity(t,filename);