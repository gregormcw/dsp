function dynCompAn()
% Calls dynComp(), a dynamic compression function, and plots a time-domain
% represenation of its input and output signals and the differences between
% them
% --------------------------
% Gregor McWilliam

% Set initial parameters
fs = 44100;
x = linspace(0, 1, fs);
threshold = 0.5;
slope = 0.3;

N = length(x);
n = 0 : N-1;
t = n / fs;

% Retrieve compressed signal y from dynComp()
y = dynComp(threshold, slope, 0, x);

% Retrieve compressed and gain-matched signal yMatch from dynComp()
yMatch = dynComp(threshold, slope, 1, x);

x0 = 50;
y0 = 50;
width = 1100;
height = 900;
set(gcf, "position", [x0, y0, width, height]);

% Plot input x, post-compression output y, and gain-matched
% post-compression output yMatch
figure(1);
subplot(211);
plot(t, x, "Color", "Blue", "LineWidth", 3);
xlim([0, 1]);
hold on
plot(t, y, "Color", "Red", "LineWidth", 3);
plot(t, yMatch, "Color", "Magenta", "LineWidth", 3);
hold off
title("Signal, Before and After Compression");
xlabel("Time (Seconds)");
ylabel("Amplitude");
grid on

% Calcuate amplitude difference between x and y
diff = x - y;

% Calculate amplitude difference between x and gain-matched yMatch
diffMatch = x - yMatch;

% Plot the amplitude differences
figure(1);
subplot(212);
plot(t, diff, "Color", "Blue", "LineWidth", 3);
xlim([0, 1]);
ylim([-0.5, 0.5]);
hold on
plot(t, diffMatch, "Color", "Red", "LineWidth", 3);
hold off
title("Difference between input and output signals (x - y)");
xlabel("Time (Seconds)");
ylabel("Amplitude");
grid on


end

