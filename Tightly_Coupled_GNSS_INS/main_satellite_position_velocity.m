%% this is the main script to calculate the position and velocity of satellites
%
% Input: 
% t: gps time in seconds
% filename: name of navigation file
% Output:
% crd_gnss: coordinate of satellites [x,y,z,sate_no]
% vel_gnss: velocity of satellites [x,y,z,sate_no]]

function [crd_gnss,vel_gnss]=main_satellite_position_velocity(t,filename)

% get ephemerides
eph=get_eph(filename);

% find the column index where the elements are valuable
A=~isnan(eph(1,:));

% update eph
eph=eph(:,A);


% coordinates and velocity calculation
[crd_gnss, vel_gnss]=calc_gnss_crd(t, eph);

% program end
end
