function [utm_crd] = geo2utm(input, zone_number)

% Function for converting geodetic latitude and longitude to UTM
%
% Input: [latitude [degrees] longitude [degrees] Ellipsoid height [meter]], zone number
% Output: Northing [meter], Easting [meter] Ellipsoid height [meter]
%
% All references of equations are to Poder and Engssager, "Some 
% Conformal Mappings and Transformations for Geodesy and Topographic 
% Cartography", 1998.
%

% return zero if input coordinates are zero
if (input(1,1) == 0 && input(1,2) == 0 && input(1,3) == 0)
    utm_crd = [0 0 0];
    return
end

% Number of input points
no_points = size(input,1);
lat_input = input(:,1);
lon_input = input(:,2);
height = input(:,3);

% Set ellipsoid constants
a = 6378137.0;             % Ellipsoidal semimajor axis, GRS80
f = 1 / 298.257222100883;  % Ellipsoidal flattening, GRS80
b = a*(1 - f);          % Ellipsoidal semiminor axis
n = (a - b) / (a + b);  % Third flattening

% Set UTM constants
fe = 500000;            % False Easting
fn = 0.0;               % False Northing

% Find central meridian of UTM zone in degrees 
cm = ((zone_number -1) * 6) + (-177);

N=[]; E=[];
% Loop through input vectors
for j=1:no_points

    lat_deg = lat_input(j,1);
    lon_deg = lon_input(j,1);
    
    % Check if coordinates are inside limits of UTM 
    if (lat_deg<-80 | lat_deg>84) | (lon_deg<-180 | lon_deg>180)
        f = errordlg('Error, function geo2utm: Coordinates not within UTM limits.', 'Error dialog box');
    end

    % Longitude difference to central meridian
    delta_lon_deg = lon_deg - cm;

    % Convert from degrees to radians
    lat = lat_deg*pi/180;
    lon = lon_deg*pi/180;
    delta_lon = delta_lon_deg*pi/180;
    
    % Geodetic coordinates to Gaussian coordinates, eq. (3.6)
    e2 = (-2*n) + ((2/3)*n^2) + ((4/3)*n^3) - ((82/45)*n^4);
    e4 = ((5/3)*n^2) - ((16/15)*n^3) - ((13/9)*n^4);
    e6 = ((-26/15)*n^3) + ((34/21)*n^4);
    e8 = ((1237/630) * n^4);

    sum_e = (e2*sin(2*lat)) + (e4*sin(4*lat)) + (e6*sin(6*lat)) + (e8*sin(8*lat));

    phi = lat + sum_e;
    lambda = delta_lon;

    % Gaussian coordinates to complex gaussian coordinates, equation (3.8)
    sin_phi = sin(phi);
    cos_phi = cos(phi);
    sin_lambda = sin(lambda);
    cos_lambda = cos(lambda);

    phi_r = atan2(sin_phi,(cos_phi*cos_lambda));
    hypot = sqrt( (sin_phi*sin_phi) + (cos_phi*cos_lambda*cos_phi*cos_lambda) );
    t = atan2((cos_phi*sin_lambda), hypot);
    y = phi_r;
    x = log(tan((pi/4) + (t/2)));

    % Complex Gaussian coordinates
    complex_u = y + i*x;

    % Check on t. Transformation will be inaccurate if t > 40-50 degrees
    % because point is too far away from central meridian of UTM zone
    t_deg = t *180/pi;
    if abs(t_deg) > 50,
         error('Error: Coordinates too far outside UTM zone limits')
    end

    % Complex gaussian coordinates to transversal coordinates, equation (4.3.A)
    u2 = ((1/2)*n) - ((2/3)*n^2) + ((5/16)*n^3) + ((41/180)*n^4);
    u4 = ((13/48)*n^2) - ((3/5)*n^3) + ((557/1440)*n^4);
    u6 = ((61/240)*n^3) - ((103/140)*n^4);
    u8 = ((49561/161280)*n^4);

    sum_u = (u2*sin(2*complex_u)) + (u4*sin(4*complex_u)) + (u6*sin(6*complex_u)) + (u8*sin(8*complex_u));

    % Normalized transversal coordinates
    u = complex_u + sum_u;

    % Scaled meridian arc length unit, equation (III,4,A)
    m0 = 0.9996;    
    q_m = (m0*(a / (1 + n))) * (1 + ((1/4)*n^2) + ((1/64)*n^4));

    % Normalized transversal coordinates to metric scaled transversal
    % coordinates
    utm = u*q_m + fn + i*fe;

    N(j,1) = real(utm);
    E(j,1) = imag(utm);  
end

utm_crd = [N E height];
