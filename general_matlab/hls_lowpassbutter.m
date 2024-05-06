function [datout]=lowpassbutter(dat,flo,delt,n)
%
% [d]=lowpass(dat,flo,delt,n)
%
% lowpass a time series with a n order butterworth filter
%
% dat  = input time series
% flo  = highpass corner frequency
% delt = sampling interval of data
% n    =  butterworth filter order
%n=2;
fnq=1/(2*delt);  % Nyquist frequency
Wn=[flo/fnq];    % butterworth bandpass non-dimensional frequency
[b,a]=butter(n,Wn,'low'); % construct the filter
datout=filtfilt(b,a,dat); % zero phase filter the data
return;


