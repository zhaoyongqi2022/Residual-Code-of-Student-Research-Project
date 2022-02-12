%% test satellite coordinate

close all
clear 
clc

% light speed
c=299792458;

% load raw gnss measurement: uncorrected pseudo range, unaccuracte satellite position 
load('GNSS_mea.mat');

% signal transmission time
t_off=GNSS_mea(:,1)/c;

% filename 
filename='ptbb345i.17n';

% satellite number
sat=GNSS_mea(:,9);

% actual pseudo range measurement (uncorrected)
rohl_measured=GNSS_mea(:,1);

% gps time of receiver
t_m=116397;

% satellite clock offset
for i=1:length(sat)
    [rohl_corrected(i,:),delta_t_s(i,:)]=main_satellite_clock_correction(filename,sat(i),rohl_measured(i),t_m,t_off(i));
end

% true gps time of satellite
t_true_s=t_m-t_off-delta_t_s;
t_true_s(:,2)=GNSS_mea(:,9);

t_off(:,2)=GNSS_mea(:,9);
sat=GNSS_mea(:,9);

% main satellite script
[crd_gnss,vel_gnss]=main_satellite_position_velocity(t_true_s,filename,t_off,sat);

GNSS_mea(:,3:5)=crd_gnss(:,1:3);
GNSS_mea(:,6:8)=vel_gnss(:,1:3);

no_GNSS_meas=length(GNSS_mea(:,9));
% LS PVT
[old_est_r_eb_e,old_est_v_eb_e,est_clock] = GNSS_LS_position_velocity(...
    GNSS_mea,no_GNSS_meas,[0,0,0],[0,0,0]);

[old_est_L_b,old_est_lambda_b,old_est_h_b,old_est_v_eb_n] =...
    pv_ECEF_to_NED(old_est_r_eb_e,old_est_v_eb_e);

la=rad2deg(old_est_L_b);
lo=rad2deg(old_est_lambda_b);

    



