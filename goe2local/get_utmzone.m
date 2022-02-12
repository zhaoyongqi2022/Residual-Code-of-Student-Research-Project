function [zone_no] = get_utmzone(lon)

% get_utmzone(lon)
% returns the UTM zone number for the given geographic coordinates.
%
% Input: longitude in degrees. If lon is a vector, the zone containing 
% the mean of the data set is returned.  
% Output: UTM zone number 
%
% Note: If coordinates are located on the boundary of a zone, the zone 
% corresponding to the lower/left coordinate it used, except for 
% the case of the upper/right boundaries.
% For example: boundary between zone 31 and 32 is 6 degrees longitude. With
% this function, positions at longitude 6 degrees are given zone number 32.

% Check input variables
if nargin ~= 1
	error('Incorrect number of arguments');
end

% Find geographic mean of longitude if input is a vector
if length(lon)>1
   	lon = lon(~isnan(lon));
	lon = mean(lon);
end

% Check that longitude is inside limits of UTM 
if (lon<-180 || lon>180)
	error('Error: Coordinates not within UTM limits');
end

% Set array with zone limits
lon_limits = [-180:6:180]';

% Find index for zone number 
index = find(lon_limits<=lon);  lon_index = index(max(index));

% Check boundary conditions
if lon_index<1 || lon_index>61,	
    lon_index = [];
elseif lon_index==61,			
    lon_index = 60;	
end

% Return zone number 
zone_no = lon_index;
