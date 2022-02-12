function[C] = geo2cart(geo)
% This function geographic coordinates to cartesin ecef coordinates
% Input in one vektor geo = [lat long h]
% Latitude in the interval [-90;90]
% Longitude in the interval [-180;180]
% Ellipsoidal height

% Output
% Cartesian coordinates in one vector [X Y Z]

% Initialize output variable
C = [];

% Initialise input
lat = geo(1,1);
long = geo(1,2);
h = geo(1,3);

% Verify and correct input coordinates
if (lat > 90 | lat < -90 )
    %return
    f = errordlg('Error, function geo2cart: Lattiude value is outside limits.', 'Error dialog box');
end

if (long <= -180) 
    long = long + 360;
end
     
if (long > 180)
    long = long - 360
end

% Definition of constants
a=6378137;
f=1/298.257222101;

% Calculate the eccentricity
e=((2*f)-f^2)^(0.5);

% Calculate N
N = a/(1-e^2*(sind(lat)^2))^(0.5);

% Calculation of the cartesian coordinates
X = (N+h)*cosd(lat)*cosd(long);
Y = (N+h)*cosd(lat)*sind(long);
Z = (N*(1-e^2)+h)*sind(lat);

% Prepare for the output
C = [X Y Z];
