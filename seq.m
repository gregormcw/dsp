function seq()
% Simple, array-based MATLAB audio sequencer, employing the use of custom 
% helper functions kick.m, hiHat.m, snare.m and bass.m
% -------------------------
% Suggested initial input:
% seq = [1, 2, 3, 2, 1, 2, 3, 2];
% tempo = 100;
% -------------------------
% Gregor McWilliam


% Clear screen

clc
close all

% Preconfigured input arguments for ease of use

seq = [1, 2, 3, 2, 1, 2, 3, 2];
tempo = 100;

% Set initial fs and grid values
fs = 44100;
bar = 60 * (4 / tempo); % == 93.75 bpm == 60 s * (4 beats / 2.56 s)
sixt = bar / 8;
% eight = bar / 32; % == 0.08s == 1 / 12.5
sixtf = bar / 128;

k = 1 * kick(fs, 80, sixtf, 6, 0);
h = 0.15 * hiHat(fs, 9000, sixtf, 0);
s = 0.5 * snare(fs, [380 15000], sixtf, 0);
si = zeros(floor(sixtf), 1);
N = length(seq);

for n = 1:N
    pause(sixt);
    
    if seq(n) == 1
        sound(k);
        
    elseif seq(n) == 2
        sound(h);
            
    elseif seq(n) == 3
        sound(s);
                
    elseif seq(n) == 0
        sound(si, fs);
                    
    end
    
end

end

function kick = kick(fs, f0, dur, ovr, play)
% kick - Helper function for q2.m
% -------------------------
% Combines sine waves, noise, filters, and decay to synthesize the sound 
% of a kick drum
% -------------------------
% Gregor McWilliam -- gbm5862


% Generate initial sine wave with desired f0, fs, and duration
kick = sin(2*pi * f0 * [1, 1:fs*dur] / fs);
N = length(kick);

% Generate noise to signal as further transient
noiseN = floor(fs*0.01);
noise = zeros(1, N);
noise(1:noiseN, 1) = (2 * rand(noiseN, 1) - 1);

% Add kick sound derived from noise, using low-pass Cheby1 filter
[b, a] = cheby1(19, 10, 0.1);

% Convolve noise with filter
noise = noise + 0.1 * filter(b, a, noise);

% Add as many integer-multiple overtones as desired
for n = 2:ovr
    kick = kick + (0.97^n) * sin(2*pi * n*f0 * [1, 1:fs*dur] / fs);
end

% Combine sine waves and noise
kick(1, 1:noiseN) = kick(1, 1:noiseN) + 1.5 * noise(1, 1:noiseN);

% Normalize amplitude of signal
kick = kick * 1 / max(abs(kick));

% If desired, trigger audio playback
if play == 1
    sound(kick, fs);
end

end

function hiHat = hiHat(fs, pb, dur, play)
% hiHat - Helper function for q2.m
% -------------------------
% Combines noise, a highpass filter, and decay to synthesize the sound of 
% a hi-hat, snare, or any other instrument whose timbre can be approximated
% with random noise
% -------------------------
% Gregor McWilliam -- gbm5862


% Generate initial noise [-1, 1]
noise = 2 .* rand(floor(fs*dur), 1) - 1;

% Generate filter with desired passband
[b, a] = butter(19, (pb/(fs/2)), "high");

% Convolve noise with filter
hiHat = filter(b, a, noise);

% Add amplitude decay to signal
decay = logspace(1, 0, length(hiHat));
hiHat = hiHat .* decay;

% Normalize amplitude
hiHat = hiHat * 1 / max(abs(hiHat));

% If desired, trigger audio playback
if play == 1
    sound(hiHat, fs);
end

end

function bass = bass(fs, f0, dur, ovr, play)
% bass - Helper function for q2.m
% -------------------------
% Combines sine waves, noise, filters, and decay to synthesize the sound 
% of a bass instrument
% -------------------------
% Gregor McWilliam -- gbm5862


% fs = 44100;
% dur = 1;
% f0 = 110;
% ovr = 3;

% Generate initial sine wave with desired f0, fs, and duration
bass = sin(2*pi * f0 * [1, 1:fs*dur] / fs);
N = length(bass);

% Generate noise to signal as further transient
noiseN = floor(fs*0.01);
noise = zeros(1, N);
noise(1:noiseN, 1) = (2 .* rand(noiseN, 1) - 1);

% Generate filter with desired passband
[b, a] = cheby1(19, 10, 0.5);

noise = filter(b, a, noise);

% Add as many integer-multiple overtones as desired
for n = 2:ovr
    bass = bass + (0.6^n) * sin(2*pi * n*f0 * [1, 1:fs*dur] / fs);
end

% Combine sine waves and noise
bass(1, 1:noiseN) = bass(1, 1:noiseN) + 1.7 * noise(1, 1:noiseN);

decay = logspace(1, 0, length(bass)/2);
decay = [decay zeros(1, length(bass) - length(decay))];
bass = bass .* decay;

% Normalize amplitude of signal
bass = bass * 1 / max(abs(bass));

if play == 1
    sound(bass, fs);
end

end

function snare = snare(fs, pb, dur, play)
% snare - Helper function for q2.m
% -------------------------
% Combines noise, a passband filter, and decay to synthesize the sound of 
% a snare, hi-hat, or any other instrument whose timbre can be approximated
% with random noise
% -------------------------
% Gregor McWilliam -- gbm5862


% Generate initial noise [-1, 1]
noise = 2 .* rand(floor(fs*dur), 1) - 1;

% Generate filter with desired passband
[b, a] = butter(5, (pb/(fs/2)));

% Convolve noise with filter
snare = filter(b, a, noise);

% Add decay to signal
decay = logspace(1, 0, length(snare));
snare = snare .* decay';

% Normalize amplitude
snare = snare * 1 / max(abs(snare));
snare = 0.95 * snare;

% If desired, trigger audio playback
if play == 1
    sound(hiHat, fs);
end

end
