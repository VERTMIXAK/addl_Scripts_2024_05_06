function [datout]=highpass(dat,fhi,delt,n)
%
% [d]=highpass(dat,fhpi,delt,n)
%
% highpass a time series with a n order butterworth filter
%
% dat  = input time series
% fhi  = highpass corner frequency
% delt = sampling interval of data
% n    =  butterworth filter order
%n=2;      
fnq=1/(2*delt);  % Nyquist frequency
Wn=[fhi/fnq];    % butterworth bandpass non-dimensional frequency
[b,a]=butter(n,Wn,'high'); % construct the filter
datout=filtfilt(b,a,dat); % zero phase filter the data
return;
