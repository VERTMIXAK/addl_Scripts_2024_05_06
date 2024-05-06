function [f,Gxx]=spectra(x)
%function [f,Gxx]=spectra(x)
% uses hanning window of data
% and returns half the spectra
% Harper Simmons, 1995

x=x(:);
f=(1:(length(x)/2))/(length(x));
f=f';
N=length(x);
win = hanning(N);             %  make the Hanning window
data1=x;
data1=data1 - mean(data1);    %  remove the mean
data1 = detrend(data1);       %  and trend
data2=win .* data1;           %  multiply the data window times the data

%
pg1=fft(data2,N);             %  now compute the fft
pg2=pg1 .* conj(pg1);         %  take the abs value
lp=fix(N/2);
%
Gxx = pg2(2:(lp+1)) ./ N;     % remove first point (mean) and take
                              % the first half. is symmetrical

% enforce Parsevals Theorem so that the one sided spectrum has half
% the power of the DETRENDED input signal (2 sided would be equal).
% this will corect for the effect of the Hanning window

% sum(detrend(x).^2)
% sum(Gxx)

fac = sum(detrend(x).^2)/sum(Gxx); % Gxx is already squared
Gxx = 0.5*fac*Gxx;



