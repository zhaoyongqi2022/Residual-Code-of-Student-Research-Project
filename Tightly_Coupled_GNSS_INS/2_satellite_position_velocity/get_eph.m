function [eph] = get_eph(filename)
% This function will grab the ephemerides from a GPS navigation file and
% output the listed ephemerides.
% There will be a check whether the file exist or not
% Input: Filename for the navigation file, the filename (pathname and file) are relative
% to matlab/running directory

if(exist(filename,'file'))
   fid_eph = fopen(filename);
   eph = get_orb_pars(fid_eph);
   fclose(fid_eph);
else
   eph = [];
end
