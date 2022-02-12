%% this function aims to generate GNSS measurements
% Caution: time factor must be considered!!!
% Input:
% t                       current GPS time
% GPS                     
%    GPS.GPS_1              [GPS time,pseudo-range measurement,Doppler frequency]
%    GPS.GPS_3                           .
%    GPS.GPS_10                          .
%    GPS.GPS_14                          .
%    GPS.GPS_17                          .
%    GPS.GPS_21                          .
%    GPS.GPS_22                          .
%    GPS.GPS_27                          .
%    GPS.GPS_28                          .
%    GPS.GPS_32             [GPS time,pseudo-range measurement,Doppler frequency]
% sate_position           satellite ECEF position [x,y,z]
% sate_velocity           satellite ECEF velocity [x,y,z]
% L                       Frequency of signal carrier
%
% Outputs:
%   GNSS_measurements     GNSS measurement data:
%     Column 1              Pseudo-range measurements (m)
%     Column 2              Pseudo-range rate measurements (m/s)
%     Columns 3-5           Satellite ECEF position (m)
%     Columns 6-8           Satellite ECEF velocity (m/s)
%   no_GNSS_meas          Number of satellites for which measurements are supplied

function [GNSS_measurements,no_GNSS_meas]=Add_GNSS_measurement(t,GPS,sate_position,...
    sate_velocity,L)
% velocity of light spped m/s
c=299792458;

% size of satellite position
[x_p,y_p]=size(sate_position);

% size of satellite velocity
[x_v,y_v]=size(sate_velocity);

% check the size of position and velocity
if x_p~=x_v||y_p~=y_v
    warning('the sizes of satellite position and velocity are different');
    return;
end

% get corresponding number of satellites
sate_no=sate_position(:,4);
sate_no_v=sate_velocity(:,4);

% check if number identical
if ~isequal(sate_no,sate_no_v)
    warning('check the calculation of satellite');
    return;
end


% find the corresponding index according to current GPS time
index=t-GPS.GPS_1(1,1)+1;

% define index to control row of GNSS_measurements
j=0;

% GPS_1
if (GPS.GPS_1(index,2)~=0&&GPS.GPS_1(index,3)~=0) % NLOS not used by judge pseudorange and doppler frequency
    % if LOS, j=j+1
    j=j+1;
    % add pseudo-range
GNSS_measurements(j,1)=GPS.GPS_1(index,2);

% calculate and add pseudo-range rate
% Reference: [Nouredin et al. 2013: 105]
% Formula: Rohl=-D*c/L;
GNSS_measurements(j,2)=-1*GPS.GPS_1(index,3)*c/L;

% add satellite position and PRN number
GNSS_measurements(j,3:5)=sate_position(1,1:3);

% add satellite velocity and PRN number
GNSS_measurements(j,6:9)=sate_velocity(1,:);
end


% GPS_3
if (GPS.GPS_3(index,2)~=0&&GPS.GPS_3(index,3)~=0)
    j=j+1;
% add pseudo-range
GNSS_measurements(j,1)=GPS.GPS_3(index,2);

% calculate and add pseudo-range rate
% Reference: [Nouredin et al. 2013: 105]
% Formula: Rohl=-D*c/L;
GNSS_measurements(j,2)=-1*GPS.GPS_3(index,3)*c/L;

% add satellite position and PRN number
GNSS_measurements(j,3:5)=sate_position(2,1:3);

% add satellite velocity and PRN number
GNSS_measurements(j,6:9)=sate_velocity(2,:);
end

% GPS_10
if (GPS.GPS_10(index,2)~=0&&GPS.GPS_10(index,3)~=0)
    j=j+1;
% add pseudo-range
GNSS_measurements(j,1)=GPS.GPS_10(index,2);

% calculate and add pseudo-range rate
% Reference: [Nouredin et al. 2013: 105]
% Formula: Rohl=-D*c/L;
GNSS_measurements(j,2)=-1*GPS.GPS_10(index,3)*c/L;

% add satellite position and PRN number
GNSS_measurements(j,3:5)=sate_position(3,1:3);

% add satellite velocity and PRN number
GNSS_measurements(j,6:9)=sate_velocity(3,:);
end

% GPS_14
if (GPS.GPS_14(index,2)~=0&&GPS.GPS_14(index,3)~=0)
    j=j+1;
% add pseudo-range
GNSS_measurements(j,1)=GPS.GPS_14(index,2);

% calculate and add pseudo-range rate
% Reference: [Nouredin et al. 2013: 105]
% Formula: Rohl=-D*c/L;
GNSS_measurements(j,2)=-1*GPS.GPS_14(index,3)*c/L;

% add satellite position and PRN number
GNSS_measurements(j,3:5)=sate_position(4,1:3);

% add satellite velocity and PRN number
GNSS_measurements(j,6:9)=sate_velocity(4,:);
end

% GPS_17
if (GPS.GPS_17(index,2)~=0&&GPS.GPS_17(index,3)~=0)
    j=j+1;
% add pseudo-range
GNSS_measurements(j,1)=GPS.GPS_17(index,2);

% calculate and add pseudo-range rate
% Reference: [Nouredin et al. 2013: 105]
% Formula: Rohl=-D*c/L;
GNSS_measurements(j,2)=-1*GPS.GPS_17(index,3)*c/L;

% add satellite position and PRN number
GNSS_measurements(j,3:5)=sate_position(5,1:3);

% add satellite velocity and PRN number
GNSS_measurements(j,6:9)=sate_velocity(5,:);
end

% GPS_21
if (GPS.GPS_21(index,2)~=0&&GPS.GPS_21(index,3))
    j=j+1;
% add pseudo-range
GNSS_measurements(j,1)=GPS.GPS_21(index,2);

% calculate and add pseudo-range rate
% Reference: [Nouredin et al. 2013: 105]
% Formula: Rohl=-D*c/L;
GNSS_measurements(j,2)=-1*GPS.GPS_21(index,3)*c/L;

% add satellite position and PRN number
GNSS_measurements(j,3:5)=sate_position(6,1:3);

% add satellite velocity and PRN number
GNSS_measurements(j,6:9)=sate_velocity(6,:);
end

% GPS_22
if (GPS.GPS_3(index,2)~=0&&GPS.GPS_3(index,3)~=0)
    j=j+1;
% add pseudo-range
GNSS_measurements(j,1)=GPS.GPS_3(index,2);

% calculate and add pseudo-range rate
% Reference: [Nouredin et al. 2013: 105]
% Formula: Rohl=-D*c/L;
GNSS_measurements(j,2)=-1*GPS.GPS_3(index,3)*c/L;

% add satellite position and PRN number
GNSS_measurements(j,3:5)=sate_position(7,1:3);

% add satellite velocity and PRN number
GNSS_measurements(j,6:9)=sate_velocity(7,:);
end

% GPS_27
if (GPS.GPS_27(index,2)~=0&&GPS.GPS_27(index,3)~=0)
    j=j+1;
% add pseudo-range
GNSS_measurements(j,1)=GPS.GPS_27(index,2);

% calculate and add pseudo-range rate
% Reference: [Nouredin et al. 2013: 105]
% Formula: Rohl=-D*c/L;
GNSS_measurements(j,2)=-1*GPS.GPS_27(index,3)*c/L;

% add satellite position and PRN number
GNSS_measurements(j,3:5)=sate_position(8,1:3);

% add satellite velocity and PRN number
GNSS_measurements(j,6:9)=sate_velocity(8,:);
end

% GPS_28
if (GPS.GPS_28(index,2)~=0&&GPS.GPS_28(index,3)~=0)
    j=j+1;
% add pseudo-range
GNSS_measurements(j,1)=GPS.GPS_28(index,2);

% calculate and add pseudo-range rate
% Reference: [Nouredin et al. 2013: 105]
% Formula: Rohl=-D*c/L;
GNSS_measurements(j,2)=-1*GPS.GPS_28(index,3)*c/L;

% add satellite position and PRN number
GNSS_measurements(j,3:5)=sate_position(9,1:3);

% add satellite velocity and PRN number
GNSS_measurements(j,6:9)=sate_velocity(9,:);
end

% GPS_32
if (GPS.GPS_32(index,2)~=0&&GPS.GPS_32(index,3)~=0)
    j=j+1;
% add pseudo-range
GNSS_measurements(j,1)=GPS.GPS_32(index,2);

% calculate and add pseudo-range rate
% Reference: [Nouredin et al. 2013: 105]
% Formula: Rohl=-D*c/L;
GNSS_measurements(j,2)=-1*GPS.GPS_32(index,3)*c/L;

% add satellite position and PRN number
GNSS_measurements(j,3:5)=sate_position(10,1:3);

% add satellite velocity and PRN number
GNSS_measurements(j,6:9)=sate_velocity(10,:);
end

% Number of satellites for which measurements are supplied
no_GNSS_meas=j;


end
% program end    

    
    
    
    
    
    
    
    
    
    
    
    

