%% This is a function to generate the skew-symmetric matrix of Earth rotation vector
% Autor Yongqi Zhao
% Datum 23.6.2021

% Input:w_i_e is the Earth's angular rate 7.292115*10^(-5) rad/s [Groves GNSS page67]
% Output: skew-symmetric matrix of Earth-rotation vector(15 degree/hour)

% The detail of Earth's Rotation see the Groves GNSS page 67: For
% navigation purpose,a constant rotation rate os assumed, ......

function [M_earth]=skew_symm_earth(w_ie)

% The WGS84 value of the Earth's angular rate is w_ie=7.292115*e-5 rad/s;
% according page 67 
% w_ie=7.292115*e-5;

M_earth=[0 -w_ie 0
         w_ie  0 0
         0  0 0];
end
