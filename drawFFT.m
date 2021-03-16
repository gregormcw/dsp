function drawFFT(fs, wL)
% Function that plots an animated, frequency-domain representation of
% aliasing
% Inputs: fs = sample rate, wL = window length
% -------------------------
% Gregor McWilliam

% fs = 44100;
% wL = 1024;
wd = hann(wL);

h = plot(zeros(1, 44100));

for f = 0 : 20 : 100000
    x = sin(2*pi * f * [0:fs]/fs);
%     x = x .* wd;
    ft = abs(fft(x, wL));
    set(h, "ydata", ft);
    
    ylim([0 1000])
    drawnow

end