function [y, fs] = ksString(f0, ir, dur, conv)
% Implementation of Karplus-Strong plucked-string algorithm
% Frequency-dependent dampening via LPF
% =================================
% Input arguments: 
% fundamental frequency,
% impulse response, type WAV file
% output duration
% Convolution, type boolean (1 or 0)
% =================================
% Outputs:
% audio signal array y
% sample rate fs
% =================================
% Gregor McWilliam

% Set sample rate
[ir, fs] = audioread(ir);

% Allocate memory for signal x
x = zeros(fs*dur, 1);

% Set N as length of x
N = length(x);

% Calculate delay values in samples
dly = round(fs / f0);

b  = firls(24, [0, 1/dly, 2/dly, 1], [1, 0.5, 0.25, 0]);
a  = [1, zeros(1, dly), -0.5, -0.5];

% Define initial conditions for filter delays zi
zi = rand(max(length(b), length(a))-1, 1);

% Retrieve audio from input and filter coefficients
y = filter(b, a, x, zi);

% Calculate offset and subtract from output y
y = y - mean(y);

% Set output value and amplitude
y = y / max(abs(y));

% Set N to length of output y
N = length(y);

% If convolution is selected, convolve output in frequency domain with
% desired impulse response
if conv == 1
    
    % Set impulse response ir to length of y
    ir = [ir; zeros(N - length(ir), 1)];

    % Calculate FFT of output y
    Y = fft(y);
    
    % Calculate FFT of impulse response ir
    H = fft(ir);
    
    % Multiply Y and H in frequency domain
    Y = Y .* H;
    
    % Return convoled output to time domain
    y = ifft(Y);
    
end

% Normalize output amplitude
y = y * 1 / max(abs(y));

% Call sound() function, triggering playback
sound(y, fs);

end