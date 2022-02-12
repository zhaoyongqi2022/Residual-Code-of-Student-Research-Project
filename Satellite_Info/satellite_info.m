%% Calculate the satellite position
% Autor Yongqi Zhao
% Datum 16.6.2021
% This code is based on the function 'get_eph' and 'calc_gnss_crd', which
% were developed by Dr. Jakobsen and Herr Lan.
close all;
clear all;
clc;

% In order to calculate the coordinate and velocity of the corresponding
% satellites, the ephemeris file(11th December.2017; GPS Week No.: 1979; Gps Day: 345.), first of all, need to be loaded and
% readed with function 'get_eph'. Then the satellite informations(coordinates and velocities) can be
% calculated with function 'calc_gnss_crd'.

% citation of the available function to calculate the satellite information
% input: t: GPS time of a week in seconds
% filename: ephemeris data of corresponding satellite system

% GPS time of a week in seconds
% This time id derived from the MessDaten of IFF. In this file GPS time can
% be read from GNSS-->GPSSec.
t=118249; % not sure!!! this should be a VECTOR, because a TRAJECTORY supposed to be calculated.

% filename 
filename='eph_gal';

[crd_gnss, vel_gnss]=calc_gnss_crd(t, filename);

% satellite coordinate
save('crd_gnss.mat','crd_gnss');
% satellite velocity
% save('vel_gnss');
