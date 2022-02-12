function [eph] = get_orb_pars_full(fid)
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
% a_f0      =eph(20,:)';   SV clock bias 
% a_f1      =eph(21,:)';   SV clock drift
% a_f2      =eph(22,:)';   SV clock drift rate
% t         =eph(23,:)';   Transmission time of message



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

eph=NaN*ones(23,32);  
ready=0;
while ready==0
  s=fgets(fid);
  if length(s)>7
    sat=sscanf(s,'%d',1);
    
    s([38 57 76])='eee';
    eph(20,sat)=str2num(s(23:41)); % a_f0
    eph(21,sat)=str2num(s(42:60)); % a_f1
    eph(22,sat)=str2num(s(61:79)); % a_f2
    
    s=fgets(fid);
    s([19 38 57 76])='eeee';
    eph(01,sat)=str2num(s(23:41)); %C_rs
    eph(02,sat)=str2num(s(42:60)); %dn
    eph(03,sat)=str2num(s(61:79)); %M_0   

    s=fgets(fid);
    s([19 38 57 76])='eeee';
    eph(04,sat)=str2num(s(1:22));   %C_uc  
    eph(05,sat)=str2num(s(23:41));  %e
    eph(06,sat)=str2num(s(42:60));  %C_us 
    eph(07,sat)=str2num(s(61:79));  %sqtA 

    s=fgets(fid);
    s([19 38 57 76])='eeee';
    eph(08,sat)=str2num(s(1:22));   %t_oe 
    eph(09,sat)=str2num(s(23:41));  %C_ic 
    eph(10,sat)=str2num(s(42:60));  %Omega_0
    eph(11,sat)=str2num(s(61:79));  %C_is 

    s=fgets(fid);
    s([19 38 57 76])='eeee';
    eph(12,sat)=str2num(s(1:22));   %i_0
    eph(13,sat)=str2num(s(23:41));  %C_rc 
    eph(14,sat)=str2num(s(42:60));  %omega   
    eph(15,sat)=str2num(s(61:79));  %Omega_dot

    s=fgets(fid);
    s([19 38 57 76])='eeee';
    eph(16,sat)=str2num(s(1:22));   %i_dot
    eph(17,sat)=str2num(s(42:60));  %week_n

    s=fgets(fid);
    s([19 38 57 76])='eeee';
    eph(18,sat)=str2num(s(42:60));  %Tgd
    
    s=fgets(fid);
    s(19)='e';
    eph(23,sat)=str2num(s(1:22));  % Transmission time of message
    
    eph(19,sat)=sat; % Satellite PRN no
    
%     s=fgets(fid);
  else
    ready=1;
  end
end

















