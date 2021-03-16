function [y, fs] = dynChorus(x, dlyCoeff, dlyRange, lfoFreq)
% Takes as input title of audio file, returns output filtered with dynamic 
% chorus effect. Incorporates fractional delay via linear interpolation

close all
clc

% Retrieve signal and sample rate data from file
[x, fs] = audioread(x);
N = length(x);

% Extract minimum and maximum delay values
minDly = dlyRange(1);
maxDly = dlyRange(end);

% Set total delay length to variable
K = length(maxDly);

% Generate a sample vector
n = 1 : N + K;

% ------------------------
% Delay modulation via LFO
% ------------------------

% Set LFO amplitude to 0.5 * total delay range
A = (maxDly - minDly) / 2;

% Set LFO center point to mean of maximum and minimum delay value
mean = (maxDly + minDly) / 2;

% Generate LFO
lfo = A * sin(2*pi * lfoFreq * n / fs) + mean;

% Allocate memory for output y
y = zeros(1, N + K);

% Iterate through x
for i = 1 : N + K
    
    % Calculate current delay value based on LFO position
    curDly = lfo(i) * fs;
    
    % Calculate fractional and integer parts of delay, for linear
    % interpolation
    dlyFrac = mod(curDly, 1);
    dlyInt = 1 - dlyFrac;
    
    % Calculate integer floor of current delay value
    curDly = floor(curDly);
    
    % If i > current delay value, combine input and LFO-modulated 
    % delay signal, utilizing linear interpolation to compensate for 
    % integer restriction of MATLAB arrays
    if i > curDly
        y(i) = x(i) + dlyCoeff * (dlyInt * x(i-curDly+1)...
            + dlyFrac * (x(i-curDly)));
    else
        % If i <= current delay value, set y(i)  equal to input sample x(i)
        y(i) = x(i);
    end

end

% Normalize the output signal y
y = y .* 1/max(abs(y));

% Fade out toward end of file
fade = linspace(1, 0, floor(fs / 5));
F = length(fade);
y(end-F+1: end) = y(end-F+1: end) .* fade;

end