%% this function aims to convert 'time of clock'to GPS time in seconds
% Author Yongqi Zhao
% Date 8.7.2021
%
% Input: 
% toc:      time of clock from navigation file
%    * first column:    year in four bits
%    * second column:   month
%    * third column:    day
%    * fourth column:   hour
%    * fifth column:    minute
%    * sixth column:    second
%
% Output: 
% GPS Time:
%    * Week number
%    * Seconds in this week


function gpst=cal2gps(cal)


if length(cal) < 6
	cal(6)=0;
end

mjd=cal2mjd(cal);

% GPS start from MJD44244
elapse=mjd-44244;
week=floor(elapse/7);
elapse=elapse-week*7;	% day in this week
gpst=[week round(elapse*86400)];
