%% This function aims to calculate the body-to-Earth-frame coordinate transformation matrix
% Autor Yongqi Zhao
% Datum 24.6.2021
% This script is based on the formula (2.12) page 36 and the idea of Andreas' paper
% The conversion is carried out by placing three reference points in
% GoogleEarth. Then we can create two matrix, which contain infos of body-frame and ecef-frame respectively 

% Process to get the coordinate in body frame: 
% Origin of body frame: 118248_0(GPS Time 118248) 
% diatance between origin of body frame and reference points will be measured: Length
% Pos_1: 118244.5_1 (GPS Time 118244.5)  Length: 26.36   Azimuth:56.78  H: 117.812
% Pos_2: 118243_2 (GPS Time 118243) Length: 34.91  Azimuth: 49.67  H: 117.858
% Pos_3: 118245.5_3 (GPS Time 118245.5) Length: 19.82  Azimuth: 61.04 H: 117.779
% Origin of body frame: 118248_0      Azimuth: 66.41 H: 117.647

function [ C ] = cale_trans_matrix_b_e(  )

% Transformation of coordinates


% Defining the transformation matrix
% Pos_1: -26.36*cos(66.41-56.78), 26.36*sin(66.41-56.78), (117.647-117.812)
% Pos_2: -34.91*cos(66.41-49.67), 34.91*sin(66.41-49.67),  (117.647-117.858)
% Pos_3: -19.82*cos(66.41-61.04), 19.82*sin(66.41-61.04),  (117.647-117.779)
% Caution: all X-axes are negative; Z-Axes heading down  


% angle of Pos_1
delta_1=deg2rad(66.41-56.78);
% Pos_1 coordinate
x1=-26.36*cos(delta_1);
y1=26.36*sin(delta_1);
z1=117.647-117.812;

% angle of Pos_2
delta_2=deg2rad(66.41-49.67);
% Pos_2 coordinate
x2=-34.91*cos(delta_2);
y2=34.91*sin(delta_2);
z2=117.647-117.858;

% angle of Pos_3
delta_3=deg2rad(66.41-61.04);
%Pos_3 coordinate
x3=-19.82*cos(delta_3);
y3=19.82*sin(delta_3);
z3=117.647-117.779;


% Defining the coordinate in ecef-frame (Latitude, Longitude, Height)
% Pos_1: 52+16/60+13.94047/3600, 10+32/60+4.01135/3600, 117.812
% Pos_2: 52+16/60+14.19835/3600, 10+32/60+4.24707/3600, 117.858	
% Pos_3: 52+16/60+13.78393/3600, 10+32/60+3.75762/3600, 117.779

Pos_1_e=geo2cart([52+16/60+13.94047/3600,10+32/60+4.01135/3600,117.812]);
Pos_2_e=geo2cart([52+16/60+14.19835/3600,10+32/60+4.24707/3600,117.858]);
Pos_3_e=geo2cart([52+16/60+13.78393/3600,10+32/60+3.75762/3600,117.779]);


X_b = [x1 x2 x3;...
     y1 y2 y3;...
     z1 z2 z3];

% X_st = [x1_st x2_st x3_st;...
%         y1_st y2_st y3_st;...
%         z1_st z2_st z3_st];

X_e=[Pos_1_e',Pos_2_e',Pos_3_e'];

% result of transformation matrix : 
% formula: X_e=C_b_e*X_b (2.12); calculation process: Modellierung in der
% Fahrzeugtechnik, Folie 30,Kapitel 2: X*A=b --> x=b*inv(A) 
C=X_e*inv(X_b);

end

