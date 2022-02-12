%% This function aims to calculate satellite clock error
% Author: Yongqi Zhao
% Date: 7.7.2021
% Reference: 
% Principle of GPS and Receiver Design, 2009,  page:78-79
%
% Input:
% pseudorange_measure:              pseudorange from measurement without correction 
% t:                                GPS Time (second), when the signal is received
% eph:                              eph matrix including parameters from the navigation file
% year      =eph(24,:)';
% month     =eph(25,:)';
% day       =eph(26,:)';
% hour      =eph(27,:)';
% minute    =eph(28,:)';
% second    =eph(29,:)';
% prn no    =eph(19,:)';   sat
% a_f0      =eph(20,:)';   SV clock bias 
% a_f1      =eph(21,:)';   SV clock drift
% a_f2      =eph(22,:)';   SV clock drift rate
% e         =eph(05,:)';
% sqtA      =eph(07,:)';   sqrt(a_s)
% det_n     =eph(02,:)';
% t_oe      =eph(08,:)';
% M_0       =eph(03,:)';
% Tgd       =eph(18,:)';
%
%
% Output: 
% Delta_t: satellite clock error in [m]


function [Delta_t]=sate_clock_error(t,sat,filename)

load(filename);

% speed of light
c=299792458;   % m/s

% time conversion: from toc to gps time in seconds
toc=cal2gps([eph(24,sat)+2000,eph(25:29,sat)']);  % input is 6 columns: [years+2000, month, day, hour, minute, second]

% check gps week rollover with function 'gpsCheckWeekRollover'
% b=t-t_oc
b=gpsCheckWeekRollover(t,t_oc); % t: receive time or transmitte time

% satellite clock error using (4.22)
% delta_t=a_f0+a*f_1*(t-t_oc)+a_f2*(t-t_oc)^2;
delta_t=eph(20,sat)+eph(21,sat)*b+eph(22,sat)*b^2;

% constant value F=-2*sqrt(mu)/(c^2); using (4.24)
F=-4.442807633e-10;  % [s/m^(1/2)];

% WGS 84 value of the earth's gravitational constant for GPS user
mu=3.986005e14;

% Semi-major axis
% A=sqrt(a_s)^2
A=eph(07,sat).^2;

% Computed mean motion
n0=sqrt(mu./A.^3);

% correted mean motion
% det_n     =eph(02,:)';
n=n0+eph(02,sat);

% Time from ephemeris reference epoch
% t_oe      =eph(08,:)
% tk=t-t_oe;
tk=t-eph(08,sat);

% Estimated travelling time
t_off=-0.078;
tk=tk+t_off;

% Mean anomaly
% M_0       =eph(03,:)';
Mk=eph(03,sat)+n.*tk;

% e         =eph(05,:)';
% Eccentric anomaly 
E=Mk+eph(05,sat).*sin(Mk);
for i=1:20
    E=Mk+eph(05,sat).*sin(E);
end
Ek=E;

% correction based on theory of relativity using (4.23)
% delta_tr=F*e_s*sqrt(a_s)*sin(E_k);
% sqtA      =eph(07,:)';   sqrt(a_s)

delta_tr=F*eph(05,sat)*eph(07,sat)*sin(E_k);

% group wave delay correction T_GD
% Tgd       =eph(18,:)';

% total correction of satellite clock error 
% Delta_t=(delta_t+delta_tr-T_GD)*c;
Delta_t=(delta_t+delta_tr-eph(18,sat))*c;

% end
end








