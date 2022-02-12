function [pos_local_error_b, pos_local_error_l] = calc_local_error(pos_n, pos_ref_n, yaw)
% this function calculates the local position error in both local tangent frame and body frame based on
% the calculated position and reference position in local navigation frame

if isnan(pos_n)
    pos_local_error_b = NaN * ones(1, 3);
    return;
end

% first calculate the position in ECEF-frame
pos_e = geo2cart(pos_n);
pos_ref_e = geo2cart(pos_ref_n);

% position error in ECEF-frame
pos_local_error_e = pos_e - pos_ref_e;

% transformation matrix frome ECEF-frame to local tangent frame
lat = pos_ref_n(1);
lon = pos_ref_n(2);
R_ne = R3(-lon) * R2(lat + 90);
R_en = R_ne';

% position error in local tangent frame
pos_local_error_l = R_en * pos_local_error_e';

% position error in body frame (assuming only yaw angle)
R_nb = R3(yaw);
pos_local_error_b = R_nb * pos_local_error_l;
pos_local_error_b = pos_local_error_b';