function y = fastConv()
% Fast-convolution algorithm, computed via frequency-domain multiplication 
% of time-domain input signals x and h
% -------------------------
% Gregor McWilliam


% Clear screen

clc
close all

% Preconfigured input arguments for ease of use

[x, xx] = audioread("snare.wav");
[h, fs] = audioread("ir.wav");
x = x(:, 1);
h = h(:, 1);
x = x';
h = h';

% Define N as length of longest array, x or h, then zero-pad shorter 
% signal to length N so that element-wise multiplication can be computed

if length(x) >= length(h)
    N = length(x);
    
    h = [h, zeros(1, N - length(h))];
else
    N = length(h);
    x = [x, zeros(1, N - length(x))];
end

% Generate window
win = rectwin(N)';

% Apply window to input x
x = x .* win;

% % Optional: custom DFT calculation
% % Generate zero-valued arrays for frequency-domain conversion
% X = zeros(1, N);
% H = zeros(1, N);
% 
% % Compute the DFT of x and h
% for m = 0 : N-1
%     for n = 0 : N-1
%         X(m+1) = X(m+1) + x(n+1) * (exp(-1j * 2*pi * m/N * n));
%         H(m+1) = H(m+1) + h(n+1) * (exp(-1j * 2*pi * m/N * n));
%     end
% end

X = fft(x);
H = fft(h);

% Multiply DFT(x) with DFT(h), equivalent to time-domain convolution
Y = X .* H;

% Compute the IDFT of Y, returning the equivalent of the time-domain
% convolution of x and h
y = ifft(Y);

% Remove 0i imaginary unit for readabilty
y = real(y);

sound(y, fs);

end

