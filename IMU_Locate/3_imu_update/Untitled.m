%% test euler2ctm

close all
clear all
clc


euler=deg2rad([0.47246;-0.86630;360-246.33816]);
C=Euler_to_CTM(euler);

r_b=[0;10;0];

r_n=C*r_b;