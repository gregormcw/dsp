function y = quantizer(x, bitRes)
% Wuantization function: takes input x and outputs bit-limited signal y 
% of resolution bitRes

close all
clc

% Calculate bit-limited representation of input x
y = round(x * 2^(bitRes-1)) / (2^(bitRes-1));

end