%% this function aims to generate GNSS measurements
% Caution: time factor must be considered!!!
% Input:
% t                       current GPS time
% pseudo_range            column vecotor from real data [time,value] (raw: time; column:satellite number)
% column number corresponds the satellite number; NaN denotes no satellite available 
% sate_position           satellite ECEF position [x,y,z]
% sate_velocity           satellite ECEF velocity [x,y,z]
% doppler_frequency       doppler frequency from real data (column vector) [GPS time,value]
% wavelength              wave length of satellite signal which can be obtained from real data
%
% Outputs:
%   GNSS_measurements     GNSS measurement data:
%     Column 1              Pseudo-range measurements (m)
%     Column 2              Pseudo-range rate measurements (m/s)
%     Columns 3-5           Satellite ECEF position (m)
%     Columns 6-8           Satellite ECEF velocity (m/s)
%   sate_no          Number of satellites for which measurements are supplied

function [GNSS_measurements,no_GNSS_meas]=Add_GNSS_measurement(t,pseudo_range,sate_position,...
    sate_velocity,doppler_frequency,wavelength)

% size of satellite position
[x_p,y_p]=size(sate_position);

% size of satellite velocity
[x_v,y_v]=size(sate_velocity);

% check the size of position and velocity
if x_p~=x_v||y_p~=y_v
    warning('the sizes of satellite position and velocity are different');
    break;
end

% get corresponding number of satellites
sate_no=sate_position(:,4);
sate_no_v=sate_velocity(:,4);

% check if number identical
if ~isequal(sate_no,sate_no_v)
    warning('check the calculation of satellite');
    break;
end

% Number of satellites for which measurements are supplied
no_GNSS_meas=length(sate_no);

% get the size of pseudo range and doppler frequency
[r_pr,c_pr]=size(pseudo_range);
[r_df,c_df]=size(doppler_frequency);

% find the corresponding pseudo range according to GPS time
for j=1:r_pr
    if pseudo_range(:,1)==t
        index_pr=j;
    end
end

% find the corresponding doppler frequency according to GPS time
for k=1:r_df
    if doppler_frequency(:,1)==t
        index_df=k;
    end
end
    
% generate measurements 
for i=1:length(sate_no)
    
    % add pseudo-range measurement
    GNSS_measurements(i,1)=pseudo_range(index_pr,sate_no(i));
    
    % pseudo-range rate calculation und addition
     GNSS_measurements(i,2)=pseudo_range_rate(doppler_frequency(index_df,2),wavelength(sate_no,2));
     
    % add satellite ECEF position
    GNSS_measurements(i,3:5)=sate_position(i,1:3);
    
    % add satellite ECEF velocity 
    GNSS_measurements(i,6:8)=sate_velocity(i,1:3);
end
    
% program end    

    
    
    
    
    
    
    
    
    
    
    
    

