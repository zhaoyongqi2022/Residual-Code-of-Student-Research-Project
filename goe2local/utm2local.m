function [local] = utm2local(sta_crd, utm, geoid_separation)

% Function for converting from UTM coordinates to local x y coordinate system
%
% Input: Latitude and Longitude of environment centre point, 
% matrix with Northing, Easting, Ellipsoid height in meter, and 
% geoid separation in meter
% Output: Matrix with local x and y coordinates and MSL heights in meter

% Convert environment center point to UTM coordinates
utm_zone = get_utmzone(sta_crd(1,2));
station_utm = geo2utm(sta_crd, utm_zone);

% Subtract center coordinates from all values 
y = utm(:,1) - station_utm(1,1);
x = utm(:,2) - station_utm(1,2);

% Convert heights from ellipsoid heights to MSL heights
msl_h = utm(:,3) - geoid_separation;

% Return local coodinates
local = [x y msl_h];
    