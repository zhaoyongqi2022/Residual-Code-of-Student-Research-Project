%% this is the main function to correct pseudo-range measurement
% Input:
% filename: filename of ephemeris data
% sat: satellite number that used
% rohl_measured: pseudo-range observation (meters)
% t_m: the time at which the measurement was made by the receiver
% Output:
% rohl_corrected: the pseudo-range after correcting satellite clock offset

function[rohl_corrected]=main_satellite_clock_correction(filename,sat,rohl_measured,t_m)

% get full of parameters from ephemeris data
eph = get_eph(filename);

% t_oc: clock data reference time (sec)
t_oc=eph(20:25,sat);

% a_f0: satellite clock offset (sec)
a_f0=eph(26,sat);

% a_f1: fracational frequency offset (sec/sec)
a_f1=eph(27,sat);

% a_f2: fractional frequency drift (sec/sec^2)
a_f2=eph(28,sat);

% ecc: eccentricity of the satellite's oribit
ecc=eph(05,sat);

% a: semimajor axis
a=eph(7,sat)^2;

% E_k: eccentric anomaly
% extract information from ephemeris
det_n      =eph(2,sat);
M0         =eph(3,sat);
t_oe       =eph(8,sat);

% WGS 84 value of the earth's gravitational constant for GPS user
mu=3.986005e14;

% Computed mean motion
n0=sqrt(mu./a.^3);

% Time from ephemeris reference epoch
tk=t_m-t_oe;

% Estimated travelling time
t_off=-0.05;
tk=tk+t_off;

% correted mean motion
n=n0+det_n;

% Mean anomaly
Mk=M0+n.*tk;

% Eccentric anomaly 
E=Mk+ecc.*sin(Mk);
for i=1:20
    E=Mk+ecc.*sin(E);
end
E_k=E;

% conversion of yyyy/mm/dd/hh/mm/ss to GPS second
t_oc=cal2gps(t_oc');
t_oc=t_oc(:,2);

% final satellite clock correction to pseudo-range
rohl_corrected=satellite_clock_correction(rohl_measured,t_m,t_oc,a_f0,a_f1,a_f2,ecc,a,E_k);

% program end
end

