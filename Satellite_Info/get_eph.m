% This function will grab the ephemerides from a GPS navigation file and
% output the listed ephemerides.
%
% copied from QualiSIM, with some changes
% developer: Dr. Jakob Jakobsen



% There will be a check whether the file exist or not
% Input: Filename for the navigation file, the filename (pathname and file) are relative
% to matlab/running directory
clc,clear
filename='WTZZ00DEU_R_20173450000_01D_GN.rnx';

if(exist(filename,'file'))
   fid_eph = fopen(filename);
   eph = get_orb_pars(fid_eph);
   fclose(fid_eph);
else
   eph = [];
end

save eph_gal eph