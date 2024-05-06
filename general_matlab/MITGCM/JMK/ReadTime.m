function slice = ReadTime(n,datpath);
% function slice = ReadTime(n,datpath);

dt = 3.125/24/3600; % days

%warning off;
addpath('~/matlab/MITGCM/matlab')
%warning on;
datapath=datpath;



slice.T = squeeze(rdmdsJmk([datpath], 'T',n))';
if isempty(slice.T)
  slice = [];
  return;
end;

slice.U = squeeze(rdmdsJmk([datapath], 'U',n))';
slice.V = squeeze(rdmdsJmk([datapath], 'V',n))';
slice.W = squeeze(rdmdsJmk([datapath], 'W',n))';
slice.Kr = squeeze(rdmdsJmk([datapath], 'PPviscAr-T',n))';
slice.eta = squeeze(rdmdsJmk([datapath], 'Eta',n))';
slice.Dep = squeeze(rdmdsJmk([datapath], 'Depth'))';
slice.P = squeeze(rdmdsJmk([datapath], 'PH',n))';

% get x....

x = rdmdsJmk([datapath], 'YC');
slice.x = x-mean(x);

slice.time = n*dt;
dz = rdmdsJmk([datapath], 'DRF');
if isempty(dz);
  dz = rdmdsJmk([datapath '_Model/input/'], 'DRF');
end;
%keyboard
slice.z = cumsum(squeeze(dz));

slice.T0 = slice.T(:,1);

bad = find(slice.T==0);
slice.T(bad)=NaN;
slice.V(bad)=NaN;
slice.U(bad)=NaN;


if 0;
  for i=1:size(slice.T,2);
    good = find(abs(slice.T(:,i))>0);
    slice.zeta(good,i)=interp1(slice.T0,slice.z,slice.T(good,i),'linear','extrap')-slice.z(good);
  end;
  
  bad = find(slice.T==0);
  slice.zeta(bad) = NaN;
end;


