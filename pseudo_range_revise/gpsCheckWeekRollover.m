%% This function aims to check gps time week rollover
% Author Yongqi Zhao
% Date 8.7.2021
%
% Reference: GPS Clock Corrections and Orbit Computations using RINEX 2.11
% GPS Navigation Message Files, 2015. Antonio Pestana
%
% Input: t: GPS time of signal transmission
%        t_oc: time of clock
% Output: b=t-t_oc

function [b]=gpsCheckWeekRollover(t,t_oc)

if t-t_oc<-302400
    b=t-t_oc+604800;
elseif t-t_oc>302400
    b=t-t_oc-604800;
else
    b=t-t_oc;
end

end
    
    