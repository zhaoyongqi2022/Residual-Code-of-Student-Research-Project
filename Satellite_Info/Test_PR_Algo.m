%% a test to the pseudorange location algorithm
% Autor Yongqi Zhao
% Datum 17.6.2021

close all;
clear all;
clc;

%% get the corresponding satellite location

% get the corresponding satellite number
pseu_range=importdata('pseudorange_LOS_118249.mat');
sate_number=pseu_range(:,2);

% read all the ssatellite location
coordinate=importdata('crd_gnss.mat');

% find useful satellites
sate_LOS_location=[coordinate(sate_number(1:end),1:3),sate_number];


save('sate_LOS_location.mat','sate_LOS_location');



