function y = dynComp(threshold, slope, gainMatch, x)
% Homework 2, Question 2
%
% A dynamic compression function: takes input x and outputs signal y,
% compressed as desired
% --------------------------
% Gregor McWilliam - gbm5862

close all
clc

fs = 44100;
N = length(x);
n = 0 : N-1;
t = n / fs;

xMax = max(x);
y = zeros(1, N);

% plot(t, x);

% xSign = sign(x);
% x = abs(x);

for n = 1 : N
    if abs(x(n)) >= threshold
        y(n) = slope * x(n) + (threshold - slope * threshold);
    else
        y(n) = x(n);
    end
end

if gainMatch == 1
    y = y .* (xMax / max(y));
end

end