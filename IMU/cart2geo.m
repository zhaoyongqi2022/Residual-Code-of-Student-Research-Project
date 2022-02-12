function[C] = cart2geo(crd)
% This function transform cartesian ecef coordinates to geographic
% Input
% Cartesian coordinates crd = [X, Y, Z]

% Output
% Geographic coordinates latitude, longitude and ellipsiodal height in one
% vector [lat long h]


% Return (0,0,0) if input coordinate is zero
if (crd(1,1) == 0 && crd(1,2) == 0 && crd(1,3) == 0)
    C = [0 0 0];
    return;
end


% Definition of constants
a=6378137;
f=1/298.257222101;

% Calculate the eccentricity
e=(2*f-f^2)^(0.5);

% Initialise input coordinates
X = crd(1,1);
Y = crd(1,2);
Z = crd(1,3);

%Initialize the output matrix
C = [];

% Define p
p = (X^2+Y^2)^(0.5);

% Checking inputcoordinates if latitude are 90 degrees, return with longitude = 0 if true
if p == 0
   % Calculate the semiminor axis
   b = a*(1-f);
   
   % Checking which pole
    if Z<0
        % The South pole
        lat = [-90];
        h = -Z -b;
    else
        % The North pole
        lat = [90];
        h = Z-b;
    end

    C = [lat 0 h];
    % Return the coordinates
    return;
end

% Input coordinates are fine
%Calculate the longitude
longitude = radians2degrees(atan2(Y,X));

% First guess at the latitude
latitude = radians2degrees(atan2(Z,p));

% Initialize the Startlatitude temp variable to an unrealistic number
Startlatitude = [999];

% Initialize the ellipsoidal height
h = [];

% Iteration until criteria is met
while (abs(latitude - Startlatitude) > 1e-10)
    % Set the Startlatitude
    Startlatitude = latitude;
   
    % Calculate N
    N = a/(1-e^2*(sind(latitude)^2))^(0.5);
    
    % Calculate h
    h = p/cosd(latitude)-N;
    
    % Calculate next guess at the latitude
    latitude = radians2degrees(atan2(Z,p*(1-e^2*(N/(N+h)))));
end

% Output the result
C = [latitude longitude h];