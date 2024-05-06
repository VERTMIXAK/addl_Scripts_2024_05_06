function y = lowpass(x,window);
% this function makes an all purpose
% lowpass hanning filter for unit sampled data
% script by Harper Simmons

if window > 1
b=hanning(window)/sum(hanning(window));
y=filtfilt(b,1,x);
else
%disp([' No Filter performed!'])
y=x;
end


