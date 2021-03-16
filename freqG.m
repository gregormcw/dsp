function freqG = q1()
% Frequency and phase response of 1-pole IIR filter, computed 
% by sweeping the system with input x[n] = e^(j*theta*n)
% -------------------------
% Suggested input:
% b = [1];
% a = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, -0.96];
% -------------------------
% Gregor McWilliam


% Clear screen

clc
close all

% Input arguments requested in Question 1, for ease of use

b = [1];
a = zeros(1, 11);
a(1) = 1;
a(end) = -0.96;

% Number of samples (selected as 2^10 for efficient computation)
N = 1024;

% Generate initial x-axis frequency vector
w = linspace(0, pi, N+1);
w(end) = [];

% Generate input
x = exp(1j * w);

% Find zeros of numerator and denominator (zeros and poles of filter)
H = polyval(b, x) ./ polyval(a, x);

% Calculate magnitude of H, then convert to dB
H_db = 20 * log10( abs(H) );

% Calculate phase response of filter, converting from radians to degrees
% (to better match MATLAB's freqz() function), and matching +- signs 
% preceding filter coefficients
theta = 180/pi * atan2(imag(H), (1+real(H)));

% Normalize x-axis frequency vector
wn = w / pi;

% Plot the filter's frequency response
figure(1)
subplot(211);
plot(wn, H_db);
title("Frequency Response");
xlabel("Normalized Frequency ( x π rad/sample )");
ylabel("Magnitude ( dB )");
grid on;

% Plot the filter's phase response
subplot(212);
plot(wn, theta);
title("Phase Response");
xlabel("Normalized Frequency ( x π rad/sample )");
ylabel("Phase (degrees)");
grid on;

% Plot the output from freqz() for comparison
% figure(2)
% freqz(b, a, N)

end
