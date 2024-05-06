function y = lowpassconv(dat,win1,win2,nanfix)
%        y = lowpassconv(dat,win1,win2,nanfix)
% make a 1 or 2d convolution. if 1D data, win2 = 1;
% nanfix = 0 or 1 to optionally keep original data where it got 'nanned' -- Thanks to Jonathan Nash 

% test for 1D data
sz = size(dat);
  A = ones(win1,win2)/(win1*win2);
%  A = hanning(win1)/sum(hanning(win1));
if     sz(1)==1;
  y=conv2(dat',A,'same')';
else 
  sz(2)==1;y=conv2(dat,A,'same');
end

if nanfix;tmp=find(isnan(y)); y(tmp)=dat(tmp);end

