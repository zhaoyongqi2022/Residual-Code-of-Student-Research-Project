%% This function aims to convert velocity from v_ib_i to v_eb_e
% Autor Yongqi Zhao
% Datum 28.6.2021

function [v_eb_e] = velocity_ECI_to_ECEF(t,r_eb_e,v_ib_i)
% ECI_to_ECEF - Converts velocity from ECI- to
% ECEF-frame referenced and resolved

% Inputs:
%   t             time (s)
%   r_eb_e        Cartesian position of body frame w.r.t. ECEF frame, resolved
%                 along ECEF-frame axes (m)
%   v_ib_i        velocity of body frame w.r.t. ECI frame, resolved along
%                 ECI-frame axes (m/s)
%
% Outputs:
%   v_eb_e        velocity of body frame w.r.t. ECEF frame, resolved along
%                 ECEF-frame axes (m/s)

% Parameters
omega_ie = 7.292115E-5;  % Earth rotation rate (rad/s)



% Begins

% Calculate ECI to ECEF coordinate transformation matrix using (2.145)
C_i_e = [cos(omega_ie * t), sin(omega_ie * t), 0;...
        -sin(omega_ie * t), cos(omega_ie * t), 0;...
                         0,                 0, 1];

                     
% Calculate ECEF to ECI coordinate transformation matrix
C_e_i=C_i_e';
                 
                     
% r_ib_i calculation using (2.146)
r_ib_i=C_e_i.*r_eb_e;


% Transform velocity using (2.147)
v_eb_e = C_i_e * (v_ib_i - omega_ie * [-r_ib_i(2);r_ib_i(1);0]);

end
% Ends