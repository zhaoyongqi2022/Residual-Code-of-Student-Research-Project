%% this is the main script to read correpsonding information from kml-file
close all
clear all
clc

% get information by using matlab-function developed in this thesis
input_profile=get_kml('Epochs.kml');

% save the mat-file
% save input_profile input_profile;