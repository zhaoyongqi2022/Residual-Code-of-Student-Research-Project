%% test to correct pseudo-range

close all
clear
clc

t=117305;
GNSS_measurements=importdata('GNSS_measurements.mat');
filename='ptbb263i.21n';
sat=GNSS_measurements(:,9);
t_m=t;
rohl_measured=GNSS_measurements(:,1);

rohl_corrected=ones(length(sat),1)*NaN;

for i=1:length(sat)
    rohl_corrected(i,:)=main_satellite_clock_correction(filename,sat(i),rohl_measured(i),t_m);
end

% add corrected pseudorange
GNSS_measurements(:,1)=rohl_corrected;

