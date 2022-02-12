%% this is the main script to calculate the position and velocity of satellites
%
% Input: 
% t: true gps time of satellite in seconds
% filename: name of navigation file
% t_off: signa travel time 
% Output:
% crd_gnss: coordinate of satellites [x,y,z,sate_no]
% vel_gnss: velocity of satellites [x,y,z,sate_no]]

function [crd_gnss_new,vel_gnss_new]=main_satellite_position_velocity(t,filename,t_off,sat)

% get ephemerides
eph=get_eph(filename);

% find the column index where the elements are valuable
A=~isnan(eph(1,:));

% update eph
eph=eph(:,A);

% add true gps time of satellite

for i=1:length(eph(19,:))
    for j=1:length(t)
        if eph(19,i)==t(j,2)
            eph(29,i)=t(j,1);
        end
    end
end

for i=1:length(eph(19,:))
    for j=1:length(t_off)
        if eph(19,i)==t_off(j,2)
            eph(30,i)=t_off(j,1);
        end
    end
end

t=eph(29,:)';

t_off=eph(30,:)';

% coordinates and velocity calculation
[crd_gnss, vel_gnss]=calc_gnss_crd_correct(t, eph,t_off);

k=1;
for i=1:length(crd_gnss(:,4))
    for j=1:length(sat)
        if crd_gnss(i,4)==sat(j)
            crd_gnss_new(k,:)=crd_gnss(i,:);
            vel_gnss_new(k,:)=vel_gnss(i,:);
            k=k+1;
        end
    end
end
    
% % the given GPS signals are pseudo-range measurements of 1,3,10,14,17,21,22,27,28,32-th
% % satellites. So, pseudorange measurements must match with position and
% % velocity of satellites
% crd_gnss=crd_gnss([1,2,4,5,6,7,8,11,12,13],:);
% vel_gnss=vel_gnss([1,2,4,5,6,7,8,11,12,13],:);

% warning, if the computed position and velocity of satellites not matching
% if (length(crd_gnss)~=10||length(vel_gnss)~=10)
%     warning('error: check the matching of pseudo-range and position of satellites');
%     return;
% end
% program end
end
