%%  test
close all;
clear all;
clc;

load('Simu_GPS.mat');
t=117305;
GPS=Simu_GPS;
filename='ptbb263i.21n';
[crd_gnss,vel_gnss]=main_satellite_position_velocity(t,filename);
sate_position=crd_gnss;
sate_velocity=vel_gnss;

% frequency of carrier signal L1
L=1575.41e6;

[GNSS_measurements,no_GNSS_meas]=Add_GNSS_measurement(t,GPS,sate_position,...
    sate_velocity,L);

% satellite number
sat=GNSS_measurements(:,9);

% psrudo-range measurement
rohl_measured=GNSS_measurements(:,1);

rohl_corrected=ones(length(sat),1)*NaN;

% pseudo-range correction
for i=1:length(sat)
    rohl_corrected(i,:)=main_satellite_clock_correction(filename,sat(i),rohl_measured(i),t);
end

% add corrected pseudorange
GNSS_measurements(:,1)=rohl_corrected;


[old_est_r_eb_e,old_est_v_eb_e,est_clock] = GNSS_LS_position_velocity(...
    GNSS_measurements,no_GNSS_meas,[0;0;0],[0;0;0]);
[old_est_L_b,old_est_lambda_b,old_est_h_b,old_est_v_eb_n] =...
    pv_ECEF_to_NED(old_est_r_eb_e,old_est_v_eb_e);

la=rad2deg(old_est_L_b);
lo=rad2deg(old_est_lambda_b);
% [52.2762799000000][10.5389783000000];

% [3844699.379,715473.654,5021811.338] is from u-blox
% delta_a=(crd_gnss(1,1:3)-[3844699.379,715473.654,5021811.338]);
% r=sqrt(delta_a(1)^2+delta_a(1)^2+delta_a(1)^2)



