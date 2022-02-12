%% This function aims to calculate the satellite clock corrections
% Reference: [Noureldin 2013]: Fundamentals of inertial navigation, satellite-based positioning and their integration
% Input:
% rohl_measured: pseudo-range observation (meters)
% t_m: the time at which the measurement was made by the receiver
% t_oc: clock data reference time (sec)
% a_f0: satellite clock offset (sec)
% a_f1: fracational frequency offset (sec/sec)
% a_f2: fractional frequency drift (sec/sec^2)
% ecc: eccentricity of the satellite's oribit
% a: semimajor axis
% E_k: eccentric anomaly
% 
% Output:
% rohl_corrected: final correction to pseudo-range 

function[rohl_corrected]=satellite_clock_correction(rohl_measured,t_m,t_oc,a_f0,a_f1,a_f2,ecc,a,E_k)
% speed of light
c=299792458; % m/s

% t_t is the satellite to receiver transit time using (3.15)
t_t=rohl_measured/c;

% the nominal time at which the satellite sent the signal using (3.16)
t_sv=t_m-t_t;

% (t_sv-t_ov) correction for the end of week crossover 
quantity=(t_sv-t_oc);

if quantity>302400
    quantity=quantity-604800;
elseif quantity<-302400
    quantity=quantity+604800;
end

% satellite clock correction using (3.17)
delta_t_sv=a_f0+a_f1*quantity+a_f2*(quantity^2);

% relativistic correction using (3.19)
delta_t_r=(-4.442807633e-10)*ecc*sqrt(a)*E_k;

% defining the satellite clock offset using (3.20)
delta_t_s=delta_t_sv+delta_t_r;

% the final correction to pseudo-range using (3.21)
rohl_corrected=rohl_measured+c*delta_t_s;

% program end

end


