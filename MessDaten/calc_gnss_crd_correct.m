function [crd_gnss, vel_gnss]=calc_gnss_crd_correct(t, eph,t_off)
% This function intends to calculate the satellite position and velocity
% according to the navigation file

% References:
% 1. IS-GPS-200F 2013, p.103-104
% 2. Fundamentals of Inertial Navigation, Satellite-based Positioning and
% their Integration

% input: 
% t: gps time of a week in seconds
% filename: ephemeris data of corresponding satellite system

% output:
% crd_gnss: coordinates of satellites
% vel_gnss: velocity of satellites


% % Read the navigation file on the day of Messfahrt 13
% load(filename)


% extract information from ephemeris

c_rs       =eph(1,:)';
det_n      =eph(2,:)';
M0         =eph(3,:)';
c_uc       =eph(4,:)';
e          =eph(5,:)';
c_us       =eph(6,:)';
sqrt_A     =eph(7,:)';
t_oe       =eph(8,:)';
c_ic       =eph(9,:)';
Omega      =eph(10,:)';
c_is       =eph(11,:)';
i0         =eph(12,:)';
c_rc       =eph(13,:)';
omega      =eph(14,:)';
Omega_dot  =eph(15,:)';
IDOT       =eph(16,:)';


% t=3*86400+12*3600;

% Necessary data
% WGS 84 value of the earth's gravitational constant for GPS user
mu=3.986005e14;
% WGS 84 value of the earth's rotation rate
Omega_e_dot=7.2921151467e-5;

% Semi-major axis
A=sqrt_A.^2;

% Computed mean motion
n0=sqrt(mu./A.^3);

% Time from ephemeris reference epoch
tk=t-t_oe;

% % Estimated travelling time
% t_off=-0.05;
% tk=tk+t_off;

% % Estimated travelling time
% t_off=-0.078; % s: 78ms
% tk=tk+t_off;


% correted mean motion
n=n0+det_n;

% Mean anomaly
Mk=M0+n.*tk;

if Mk<0|Mk>2*pi
    Mk=Mk+2*pi;
end

% Eccentric anomaly 
E=Mk+e.*sin(Mk);
for i=1:20
    E=Mk+e.*sin(E);
end
Ek=E;

% true anomaly
nu_k=atan2(sqrt(1-e.^2).*sin(Ek)./(1-e.*cos(Ek)), (cos(Ek)-e)./(1-e.*cos(Ek)));

% Argument of Laitude
Phi_k=nu_k+omega;

% Second Harmonic Pertubations
det_uk=c_us.*sin(2*Phi_k)+c_uc.*cos(2*Phi_k);
det_rk=c_rs.*sin(2*Phi_k)+c_rc.*cos(2*Phi_k);
det_ik=c_is.*sin(2*Phi_k)+c_ic.*cos(2*Phi_k);

% Corrected Argument of Latitude
u_k=Phi_k+det_uk;

% Corrected radius
r_k=A.*(1-e.*cos(Ek))+det_rk;

% Corrected Inclination
i_k=i0+det_ik+IDOT.*tk;

% Positions in orbital plane
x_ks=r_k.*cos(u_k);
y_ks=r_k.*sin(u_k);

% Corrected longitude of ascending node
Omega_k=Omega+(Omega_dot-Omega_e_dot).*tk-Omega_e_dot.*t_oe;

% Earth_fixed coordinates
x_k=x_ks.*cos(Omega_k)-y_ks.*cos(i_k).*sin(Omega_k);
y_k=x_ks.*sin(Omega_k)+y_ks.*cos(i_k).*cos(Omega_k);
z_k=y_ks.*sin(i_k);

% Reference: Principle of GPS and Receiver Design
% ecef position in signal received time (earth rotation correction) using
% (4.28)
x_k=x_k.*cos(Omega_e_dot.*t_off)+y_k.*sin(Omega_e_dot.*t_off);
y_k=-x_k.*sin(Omega_e_dot.*t_off)+y_k.*cos(Omega_e_dot.*t_off);
z_k=z_k;

crd_gnss=[x_k y_k z_k eph(19,:)'];



% calculate the satellite velocity
% Rate of change of the eccentric anomaly
Ek_dot=n./(1-e.*cos(Ek));

% Rate of change of the argument of latitude
Phi_k_dot=sqrt(1-e.^2).*Ek_dot./(1-e.*cos(Ek));

% Rate of change of the corrected argument of latitude
u_k_dot=(1+2*c_us.*cos(2*Phi_k)-2*c_uc.*sin(2*Phi_k)).*Phi_k_dot;

% Rate of change of the corrected radius
r_k_dot=2*(c_rs.*cos(2*Phi_k)-c_rc.*sin(2*Phi_k)).*Phi_k_dot+A.*e.*sin(Ek).*Ek_dot;

% Rate of change of the satellite's position in its orbital plane
x_ks_dot=r_k_dot.*cos(u_k)-r_k.*sin(u_k).*u_k_dot;
y_ks_dot=r_k_dot.*sin(u_k)+r_k.*cos(u_k).*u_k_dot;

% Rate of change of the corrected inclination
i_k_dot=2*(c_is.*cos(2*Phi_k)-c_ic.*sin(2*Phi_k)).*Phi_k_dot+IDOT;

% Rate of the change of the corrected longitude of the ascending node
Omega_k_dot=Omega_dot-Omega_e_dot;

% Velocity of satellites
x_k_dot=x_ks_dot.*cos(Omega_k)-y_ks_dot.*cos(i_k).*sin(Omega_k)+...
        y_ks.*sin(i_k).*sin(Omega_k).*i_k_dot-y_k.*Omega_k_dot;
y_k_dot=x_ks_dot.*sin(Omega_k)+y_ks_dot.*cos(i_k).*cos(Omega_k)-...
        y_ks.*sin(i_k).*cos(Omega_k).*i_k_dot+x_k.*Omega_k_dot;
z_k_dot=y_ks_dot.*sin(i_k)+y_k.*cos(i_k).*i_k_dot;

vel_gnss=[x_k_dot, y_k_dot, z_k_dot, eph(19,:)'];









