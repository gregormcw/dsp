function [y, fs] = fmChowning(fc, fm, modIdx, modA, dcy, A, dur)
% Implementation of John Chowning's frequency-modulation algorithm
% =================================
% Input arguments: 
% carrier frequency, 
% modulator frequency, 
% modulation index,
% modulation amplitude
% decay
% max output amplitude
% output duration
% =================================
% Outputs:
% audio signal array y
% sample rate fs
% =================================
% Gregor McWilliam

% Set sample rate
fs = 44100;

% Derive time T from reciprocal of sample rate
T = 1 / fs;

% Generate time vector
t = 0 : T : dur;

% Scale time vector by maximum modulation value
i = t .* modIdx / dur + modIdx;

% Calculate amplitude of carrier frequency component
carA = abs(1-modA);

% Generate output y by combining carrier and modulation frequencies
y = carA * cos(2*pi * fc * t + (modA * i .* sin(2*pi * fm * t)));

% Assign to N length of output y
N = length(y);

% Generate N-point line from 0 to 1
n = linspace(0, 1, N);

% Calculate exponential decay based on input argument
y = y .* exp(-dcy * n);

% Set output y to desired amplitude
y = y * A / max(abs(y));

% Playback of output y at sample rate fs
sound(y, fs);

end