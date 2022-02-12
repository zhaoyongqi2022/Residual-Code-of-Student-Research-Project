%% Function to generate the skew-symmetric matrix of angular rate vector 
% this function is based on the theory of Groves book, page 45, formula (2.50)
% Autor Yongqi Zhao
% Datum 23.6.2021
% Caution: the given angular rate need to be transformed firstly.(frame transformation)
% Input: a row vector of angular, which contains the x-,y-,z-axes of the resloving axes.
% Output: skew-symmetric matrix of angular rate.
function [M]=skew_symm_ang(w)
M=[0 -w(3) w(2)
   w(3) 0 -w(1)
   -w(1) w(1) 0];
end
