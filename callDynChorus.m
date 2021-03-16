function callDynChorus()
% Calls dynChorus, a function that outputs a chorus with fractional delay by
% means of linear interpolation
% --------------------------
% Gregor McWilliam

% Set initial parameters
x = "gtr.wav";
dlyCoeff = 0.75;
dlyRange = [0.012, 0.017];
lfoFreq = 1;

% Retrieve signal and sample rate data from ch3()
[y, fs] = ch3(x, dlyCoeff, dlyRange, lfoFreq);

% Play the filtered output, if desired
sound(y, fs);

end