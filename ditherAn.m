function ditherAn()
% Function that shows the effects of dithering via various visualizations
% --------------------------
% Gregor McWilliam

% Close all open windows and clear text
close all
clc

% Set initial parameters
fs = 1024;
n = 0 : fs-1;
f0 = 7;
A = 0.15;
t = linspace(1, 0, fs-1);
bd = 3;

f = linspace(f0, 0, fs-1);

% Define the sinusoidal input x
x = A * sin(2*pi * f0 * n / fs);

% Representation of "sampled signal" via quantization
x_bd = round(x * 2^(bd-1)) / (2^(bd-1));

% 1a.
% Plot time-domain representation of original and quantized signal
h1 = figure(1);

x0 = 50;
y0 = 50;
width = 1100;
height = 900;
set(h1, "position", [x0, y0, width, height]);

subplot(211)
plot(n, x, "Color", "Blue");
xlim([0, fs]);
ylim([-0.5, 0.5]);
hold on
plot(n, x_bd, "Color", "Red");
hold off
title("Quantized Signal, No Dithering");
xlabel("Samples");
ylabel("Amplitude");
grid on

% Generate dither
dit = 0.03 * (2 * rand(1, fs) - 1);

% Dither introduced to input x
xDit = x + dit;

% Representation of "sampled signal" via quantization
xDit = round(xDit * 2^(bd-1)) / 2^(bd-1);

% 1b.
% Plot time-domain representation of original and dithered quantized signal
figure(1)
subplot(212)
plot(n, x, "Color", "Blue");
xlim([0, fs]);
ylim([-0.5, 0.5]);
hold on
plot(n, xDit, "Color", "Red");
hold off
title("Quantized Signal, With Dithering");
xlabel("Samples");
ylabel("Amplitude");
grid on

% Update initial parameters for more illustrative FFT visualization
fs = 44100;
n = 0 : fs-1;
f0 = 440;
A = 0.15;
bd = 4;

% Define updated sinusoidal input x
x = A * sin(2*pi * f0 * n / fs);

% Representation of "sampled signal" via quantization
x_bd = round(x * 2^(bd-1)) / 2^(bd-1);

% Generate window
wn = hann(fs);

% Multiply quantized input signal x with window
x_wn = x_bd .* wn';

% Calculate FFT of x
X = fft(x_wn);

% Take absolute value of FFT
X_abs = abs(X);

% Convert to decibels
X_db = 20 * log10(X_abs);

% Calculate FFT of original input x, before deliberate quantization
X_preQuant = 20 * log10(abs(fft(x)));

% Plot frequency-domain representation of quantized, undithered signal x
h2 = figure(2);

x1 = 100;
y1 = 100;
width = 1000;
height = 800;

set(h2, "position", [x1, y1, width, height]);
subplot(411)
plot(n, X_preQuant);
xlim([0, floor(fs/2)]);
title("FFT of Signal Before Quantization, No Dither");
xlabel("Frequency (Hz)");
ylabel("dB");
grid on


% Plot frequency-domain representation of quantized, undithered signal x
figure(2)
subplot(412)
plot(n, X_db);
xlim([0, floor(fs/2)]);
title("FFT of Quantized Signal, No Dither");
xlabel("Frequency (Hz)");
ylabel("dB");
grid on

% Generate a very high level of dither (or, due to its amplitude, noise)
dit = 0.3 * (2 * rand(1, fs) - 1);

% Add this dither to quantized input x
x_dit = x_bd + dit;

% Multiply quantized, dithered input signal x with window
x_wn = x_dit .* wn';

% Calculate FFT of x
X = fft(x_wn);

% Take absolute value of FFT
X_abs = abs(X);

% Convert to decibels
X_db = 20 * log10(X_abs);

% Plot frequency-domain representation of quantized, heavily dithered 
% signal x
figure(2)
subplot(413)
plot(n, X_db);
xlim([0, floor(fs/2)]);
title("FFT of Heavily Dithered Signal, No Filtering");
xlabel("Frequency (Hz)");
ylabel("dB");
grid on

% Frequency gate the FFT data above and below the desired frequency
for i = 1 : fs
    
    % If the frequency is greater than 1.05 * f0 or less than 0.95 * f0, 
    % set its value to 0
    if i > 1.05 * f0 || i < 0.95 * f0
        X(i) = 0;
    end
end

% Calculate the IFFT of X, returning the signal to the time domain
x = ifft(X);

% Take only the real values of x, omitting any imaginary units such as 0i
x = real(x);

% Play the frequency-gated, dithered signal, if desired
% sound(x, fs);

% Take the FFT of the frequency-gated time-domain signal
X = fft(x);

% Take absolute value of FFT
X_abs = abs(X);

% Convert to decibels
X_db = 20 * log10(X_abs);

% 1c.
% Plot frequency-domain representation of dithered signal, gated in the
% frequency domain
figure(2)
subplot(414)
plot(n, X_db);
xlim([0, floor(fs/2)]);
title("FFT of Dithered Signal, Frequency-Gated");
xlabel("Frequency (Hz)");
ylabel("dB");
grid on

end

