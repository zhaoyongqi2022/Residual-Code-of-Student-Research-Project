%% this is the calculation of pseudo-range rate
% Reference: https://gnss-sdr.org/docs/sp-blocks/observables/#doppler-shift-measurement
%
% Input:
% doppler_frequency: doppler frequency [GPS time,value]
% wavelength: length of wave [sate_no,value]
% Output:
% pseudo_range_hat: pseudo range rate

function [pseudo_range_hat]=pseudo_range_rate(doppler_frequency,wavelength)

pseudo_range_hat=-1*doppler_frequency*wavelength;

end