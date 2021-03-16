function quantAn()
% Calls quantizer(), a quantization function, and plots results
% --------------------------
% Gregor McWilliam

% Set initial parameters
fs = 512;
n = 0 : fs-1;
t = n ./ fs;
f0 = 4;
A = 0.5;

% Set bit resolution
bitRes = 3;

% Generate sinusoidal input signal
x = A * sin(2*pi * f0 * n / fs);

% Retrieve quantized output y from quantizer()
y = quantizer(x, bitRes);

% Plot input x and quantized output y
figure(1);
subplot(211);
plot(t, x);
hold on
plot(t, y);
hold off
xlim([0, 1]);
ylim([-0.6, 0.6]);
title("Original and Quantized Signals");
xlabel("Time (Seconds)");
ylabel("Amplitude");
grid on

% Calculate error between original and quantized signals
err = x - y;

x0 = 50;
y0 = 50;
width = 1100;
height = 900;
set(gcf, "position", [x0, y0, width, height]);

% Plot error between original and quantized signals
subplot(212);
plot(t, err);
xlim([0, 1]);
ylim([-0.6, 0.6]);
title("Error between original and quantized signals");
xlabel("Time (Seconds)");
ylabel("Amplitude");
grid on

end