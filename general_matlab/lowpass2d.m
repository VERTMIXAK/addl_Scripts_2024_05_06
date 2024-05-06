function y = lowpass2d(x,window1,window2);
% this function uses lowpass to filter in two directions

y = lowpass(lowpass(x,window1)',window2)';

