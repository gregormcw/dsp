function sineSweepFFT()
% q3 - Answer to question 3
% -------------------------
% Generates fft of sine sweep [f0, f1], stepped at interval ivl, 
% producing animated and static frequency-domain visualizations
% -------------------------
% Gregor McWilliam


% Clear screen

clc
close all

% Use text() function on points at which aliasing begins, or any other 
% such areas of interest?

% SET INITIAL VARIABLES ----------|

fs = 44100;
dur = 1;

% Total number of samples to be evaluated
N = fs * dur;

% Set lowest and highest frequency of sine sweep
f0 = 0;
f1 = 80000;

% Sweep interval, in Hz
ivl = 100;

% GENERATE TIME-DOMAIN SIGNALS ----------|

% Create index array
n = linspace(0, N-1, N);

% Scale each index by the range f1 - f0
w = (n / N) * (f1 - f0);

% Increase frequency by ivl Hz only once the next interval is reached
f = floor(w / ivl) * ivl;

% Plug arrays into sine function
y = sin(2*pi * f .* n / fs);

% Generate a window each interval
% window = blackman(N / ivl);
% window = repmat(window, floor(N/ivl), 1);

% Or generate a window for the whole signal
% window = blackman(N);

% Scale the signal by the desired window
% y = y .* window';

% FREQUENCY-DOMAIN TRANSFORMATION ----------|

% Compute DFT of y
Y = fft(y);
% Compute the magnitude of DFT(y)
Y = abs(Y);
% Normalize in frequency domain
Y = Y / length(Y);
% Convert amplitude into dB
Y = 20 * log10(Y);

% PREPARE PLOT ----------|

% Set figure dimensions and location
x0 = 50;
y0 = 50;
width = 1100;
height = 900;
set(gcf,'position',[x0,y0,width,height])

% STATIC PLOTS ----------|

% Plot with bin number on x-axis
figure(1)
subplot(411)
plot((n(1 : floor(N)) / ivl) / dur, Y(1 : floor(N)))
xlim([0 floor(N/2/ivl)/dur])
t1 = sprintf("1. Sine Sweep DFT, Bin Number");
title(t1);
xlabel("Frequency ( Bin #, Frequency Output )");
ylabel("Magnitude ( dB )");
% text(floor(f1/ivl/2), y(floor(f1/ivl/2)), "Nyquist Frequency");
grid on

% Plot with unit-circle position (radians) on x-axis
subplot(412)
plot((n(1 : floor(N)) * 2*pi / fs) / dur, Y(1 : floor(N)))
xlim([0 (floor(N/2)/fs) * (2*pi)/dur])
t2 = sprintf("2. Sine Sweep DFT, Radians");
title(t2);
xlabel("Frequency ( rad )");
ylabel("Magnitude ( dB )");
grid on

% Plot with frequency (Hz) on x-axis
subplot(413)
plot(n/dur, Y(1 : floor(N)))
xlim([0 (N/dur)/2])
t3 = sprintf("1. Sine Sweep DFT: %d to %d Hz", f0, f1);
title(t3);
xlabel("Frequency ( Hz )");
ylabel("Magnitude ( dB )");
% Label point at which f > = fs/2
% text(floor(fs/2), y(floor(fs/2)), "Nyquist Frequency");
grid on

% ANIMATED PLOTS ----------|

% Plot animated visualization of DFT
subplot(414)
h = animatedline("Color", "m");
axis([0 n(floor(N/2)) min(Y) max(Y)])
t4 = sprintf("Sine Sweep DFT, Animated: %d to %d Hz", f0, f1);
title(t4);
xlabel("Frequency ( Hz )");
ylabel("Magnitude ( dB )");
grid on

for x = n
    addpoints(h, n(x+1), Y(x+1))
    drawnow limitrate
end

% Plot spectrogram representation
figure(2)
t6 = sprintf("Spectrogram: Sine Sweep, %d to %d Hz", f0, f1);
spectrogram(y, rectwin(441), 0, 441, fs, "yaxis"); drawnow limitrate
title(t6);
grid on

% ------------------------------------------------------------

% Plot animated visualization of time-domain signal (optional)
% figure(1)
% subplot(515)
% h = animatedline("Color", "m");
% axis([0 n(floor(N)) min(y) max(y)])
% t5 = sprintf("Time-Domain Sine Sweep, Animated: %d to %d Hz", f0, f1);
% title(t5);
% xlabel("Frequency ( Hz )");
% ylabel("Magnitude ( dB )");
% grid on
% 
% for x = n
%     addpoints(h, n(x+1), y(x+1))
%     drawnow limitrate
% end

end
