function [eph] = get_orb_pars(fid)
% copied from QualiSIM
% developer: Dr. Jakob Jakobsen


% This function reads navigation data from file and return it an ephemrides
% matrix eph
% Input: File pointer from start of file
% Output: eph matrix including parameters from the navigation file
% C_rs      =eph(01,:)';
% dn        =eph(02,:)';
% M_0       =eph(03,:)';
% C_uc      =eph(04,:)';
% e         =eph(05,:)';
% C_us      =eph(06,:)';
% sqtA      =eph(07,:)';
% t_oe      =eph(08,:)';
% C_ic      =eph(09,:)';
% Omega_0   =eph(10,:)';
% C_is      =eph(11,:)';
% i_0       =eph(12,:)';
% C_rc      =eph(13,:)';
% omega     =eph(14,:)';
% Omega_dot =eph(15,:)';
% i_dot     =eph(16,:)';
% week_no   =eph(17,:)';
% Tgd       =eph(18,:)';
% prn no    =eph(19,:)';


% First loop to put the file pointer after the header
n_obs=length(fid);
for i=1:n_obs
  ready=0;
  while ~ready
    s=fgetl(fid(i));
    if length(s)>72
      if s(61:73)=='END OF HEADER'
        ready=1; 
      end
    end
  end
end

eph=NaN*ones(19,32);  
ready=0;
while ready==0
  s=fgets(fid);
  if length(s)>7
    sat=sscanf(s(2:end),'%d',1);
    s=fgets(fid);
    s([20 39 58 77])='eeee';
    eph(01,sat)=str2num(s(24:42)); %C_rs
    eph(02,sat)=str2num(s(43:61)); %dn
    eph(03,sat)=str2num(s(62:80)); %M_0   

    s=fgets(fid);
    s([20 39 58 77])='eeee';
    eph(04,sat)=str2num(s(1:23));   %C_uc  
    eph(05,sat)=str2num(s(24:42));  %e
    eph(06,sat)=str2num(s(43:61));  %C_us 
    eph(07,sat)=str2num(s(62:80));  %sqtA 

    s=fgets(fid);
    s([20 39 58 77])='eeee';
    eph(08,sat)=str2num(s(1:23));   %t_oe 
    eph(09,sat)=str2num(s(24:42));  %C_ic 
    eph(10,sat)=str2num(s(43:61));  %Omega_0
    eph(11,sat)=str2num(s(62:80));  %C_is 

    s=fgets(fid);
    s([20 39 58 77])='eeee';
    eph(12,sat)=str2num(s(1:23));   %i_0
    eph(13,sat)=str2num(s(24:42));  %C_rc 
    eph(14,sat)=str2num(s(43:61));  %omega   
    eph(15,sat)=str2num(s(62:80));  %Omega_dot

    s=fgets(fid);
    s([20 39 58 77])='eeee';
    eph(16,sat)=str2num(s(1:23));   %i_dot
    eph(17,sat)=str2num(s(43:61));  %week_n

    s=fgets(fid);
    s([20 39 58 77])='eeee';
    eph(18,sat)=str2num(s(43:61));  %Tgd
    
    eph(19,sat)=sat; % Satellite PRN no
    
    s=fgets(fid);
  else
    ready=1;
  end
end

















