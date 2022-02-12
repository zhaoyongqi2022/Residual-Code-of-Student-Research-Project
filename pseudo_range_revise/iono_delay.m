%% this is an ionospheric delay model
% Author Yongqi Zhao
% Date 7.7.2021
% Reference: 
% Principle of GPS and Receiver Design, 2009, page:82 using (4.44)
% 
% Input:
% A: Amplitude
% t: local time in second
% T: Period
% cita: elevation angle of satellites
%
% Output:
% I: ionospheric delay

function [I]=iono_delay(A,T,t,cita)

% ionospheric delay in zenith direction
if abs(t-50400)<T/4
    I_z=5e-9+A*cos(((t-50400)/T)*2*pi);
elseif abs(t-50400)>=T/4
    I_z=5e-9;
end

% inclination rate
F=1+16*((0.53-cita/pi)^3);

% ionospheric delay
I=F*I_z;

end

