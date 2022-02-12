%%  
close all
clear
clc

load('20190815_100103_20171211_091939_Record.Obs.mat');
len=length(Observations.GPS.GPS_1.pseudo_range_L1);

% pseudorange
GNSS_measurement=ones(len,32)*NaN;

GNSS_measurement(:,1)=Observations.GPS.GPS_1.pseudo_range_L1;
GNSS_measurement(:,3)=Observations.GPS.GPS_3.pseudo_range_L1;
GNSS_measurement(:,6)=Observations.GPS.GPS_6.pseudo_range_L1;
GNSS_measurement(:,8)=Observations.GPS.GPS_8.pseudo_range_L1;
GNSS_measurement(:,9)=Observations.GPS.GPS_9.pseudo_range_L1;
GNSS_measurement(:,11)=Observations.GPS.GPS_11.pseudo_range_L1;
GNSS_measurement(:,12)=Observations.GPS.GPS_12.pseudo_range_L1;
GNSS_measurement(:,14)=Observations.GPS.GPS_14.pseudo_range_L1;
GNSS_measurement(:,17)=Observations.GPS.GPS_17.pseudo_range_L1;
GNSS_measurement(:,19)=Observations.GPS.GPS_19.pseudo_range_L1;
GNSS_measurement(:,22)=Observations.GPS.GPS_22.pseudo_range_L1;
GNSS_measurement(:,23)=Observations.GPS.GPS_23.pseudo_range_L1;
GNSS_measurement(:,28)=Observations.GPS.GPS_28.pseudo_range_L1;
GNSS_measurement(:,31)=Observations.GPS.GPS_31.pseudo_range_L1;
GNSS_measurement(:,32)=Observations.GPS.GPS_32.pseudo_range_L1;


j=1;
for i=1:length(GNSS_measurement(1,:))
    if (GNSS_measurement(1,i)~=-1)&&(~isnan(GNSS_measurement(1,i)))
         GNSS(j,1)=GNSS_measurement(1,i);
         GNSS(j,2)=i;
         j=j+1;
    end
end

    
% pseudorange rate
GNSS_doppler=ones(len,32)*NaN;

GNSS_doppler(:,1)=Observations.GPS.GPS_1.actual_doppler_freqency_L1;
GNSS_doppler(:,3)=Observations.GPS.GPS_3.actual_doppler_freqency_L1;
GNSS_doppler(:,6)=Observations.GPS.GPS_6.actual_doppler_freqency_L1;
GNSS_doppler(:,8)=Observations.GPS.GPS_8.actual_doppler_freqency_L1;
GNSS_doppler(:,9)=Observations.GPS.GPS_9.actual_doppler_freqency_L1;
GNSS_doppler(:,11)=Observations.GPS.GPS_11.actual_doppler_freqency_L1;
GNSS_doppler(:,12)=Observations.GPS.GPS_12.actual_doppler_freqency_L1;
GNSS_doppler(:,14)=Observations.GPS.GPS_14.actual_doppler_freqency_L1;
GNSS_doppler(:,17)=Observations.GPS.GPS_17.actual_doppler_freqency_L1;
GNSS_doppler(:,19)=Observations.GPS.GPS_19.actual_doppler_freqency_L1;
GNSS_doppler(:,22)=Observations.GPS.GPS_22.actual_doppler_freqency_L1;
GNSS_doppler(:,23)=Observations.GPS.GPS_23.actual_doppler_freqency_L1;
GNSS_doppler(:,28)=Observations.GPS.GPS_28.actual_doppler_freqency_L1;
GNSS_doppler(:,31)=Observations.GPS.GPS_31.actual_doppler_freqency_L1;
GNSS_doppler(:,32)=Observations.GPS.GPS_32.actual_doppler_freqency_L1;

j=1;
for i=1:length(GNSS_doppler(1,:))
    if (GNSS_doppler(1,i)~=-1)&&(~isnan(GNSS_doppler(1,i)))
         dop(j,1)=GNSS_doppler(1,i);
         dop(j,2)=i;
         j=j+1;
    end
end

if (isequal(GNSS(:,2),dop(:,2)))
    GNSS(:,2:3)=dop;
end

%%  satellite position and velocity
filename='ptbb345i.17n';

% gps time of receiver 
t=116397;

% define GNSS measurement
GNSS_mea=ones(9,9)*NaN;

% satellite position and velocity not accuracte, because the GPS time is the receiver  
[crd_gnss,vel_gnss]=main_satellite_position_velocity(t,filename);

%% add pseudorange and doppler freenqucy

k=1;
for i=1:length(GNSS)
    for j=1:length(crd_gnss)
        if GNSS(i,3)==crd_gnss(j,4)
            GNSS_mea(k,1:2)=GNSS(i,1:2);
            GNSS_mea(k,3:5)=crd_gnss(j,1:3);
            GNSS_mea(k,6:8)=vel_gnss(j,1:3);
            GNSS_mea(k,9)=GNSS(i,3);
            k=k+1;
        end
    end
end

%% pseudorange rate calculation
% velocity of light spped m/s
c=299792458;

% frequency of carrier signal L1
L=1575.41e6;

% calculate and add pseudo-range rate
% Reference: [Nouredin et al. 2013: 105]
% Formula: Rohl=-D*c/L;

GNSS_mea(:,2)=-GNSS_mea(:,2)*c/L;



% %% pseudorange correction
% no_GNSS_meas=9;
% 
% sat=GNSS_mea(:,9);
% rohl_corrected=ones(9,1)*NaN;
% rohl_measured=GNSS_mea(:,1);
% t_m=t;
% % satellite clock correction
% for i=1:length(sat)
%     [rohl_corrected(i,1),delta_t_s(i,1)]=main_satellite_clock_correction(filename,sat(i),rohl_measured(i),t_m);
% end
% 
% GNSS_mea(:,1)= rohl_corrected;


% %%  accurate satellite position velocity calculation
% 
% % trval time of signal
% t_off=GNSS_mea(:,1)/c;
% 
% % satellite clock offset are delta_t_s
% 
% % true satellite gps time
% t_true_sat=t-t_off-delta_t_s;
% t_true_sat(:,2)=GNSS_mea(:,9);
% % [crd_gnss,vel_gnss]=main_satellite_position_velocity(t,filename);





% 
% % LS PVT
% [old_est_r_eb_e,old_est_v_eb_e,est_clock] = GNSS_LS_position_velocity(...
%     GNSS_mea,no_GNSS_meas,[0,0,0],[0,0,0]);
% 
% [old_est_L_b,old_est_lambda_b,old_est_h_b,old_est_v_eb_n] =...
%     pv_ECEF_to_NED(old_est_r_eb_e,old_est_v_eb_e);
% 
% la=rad2deg(old_est_L_b);
% lo=rad2deg(old_est_lambda_b);
% 
%     