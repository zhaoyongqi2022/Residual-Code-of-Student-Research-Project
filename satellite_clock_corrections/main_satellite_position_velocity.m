%% this is the main script to calculate the position and velocity of satellites
%
% Input: 
% t: gps time in seconds
% filename: name of navigation file
%
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
[crd_gnss, vel_gnss]=calc_gnss_crd_correct(t, eph);

% the given GPS signals are pseudo-range measurements of 1,3,10,14,17,21,22,27,28,32-th
% satellites. So, pseudorange measurements must match with position and
% velocity of satellites
crd_gnss=crd_gnss([1,2,4,5,6,7,8,11,12,13],:);
vel_gnss=vel_gnss([1,2,4,5,6,7,8,11,12,13],:);

% warning, if the computed position and velocity of satellites not matching
if (length(crd_gnss)~=10||length(vel_gnss)~=10)
    warning('error: check the matching of pseudo-range and position of satellites');
    return;
end
% program end
end
