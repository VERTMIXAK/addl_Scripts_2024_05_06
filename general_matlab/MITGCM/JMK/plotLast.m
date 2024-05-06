% create a structure containing filenames (etc) for variable you want to look at
datpath='../../../';
d = dir([datpath '0000/S.*.data']);

% check the timestamp in the last filename
n = str2num(d(end).name(3:12));

%  I don't know what Last is since it is set interactively before the
%  script is run.
if n>Last;
  figure(1);clf  % clear the current figure
  for i=1:4
    try
    
      subplot(2,2,i);% make 2x2 figures, and select i-th axes for the current plot
      N = n-(4-i)*100*6*3
      slice = ReadTime(N,datpath)

      pcolor(slice.x/1e3,slice.z,slice.V);shading flat;caxis([-1 1]/4);
      axis ij;ylim([0 2000]);drawnow;
      set(gca,'color',[1 1 1]*0.5);
      xlim([min(slice.x)/1e3 max(slice.x)/1e3]);
      title(sprintf('%1.2f',N*12.4/3600));
  end;
  end;
  %colormap(colCog);  ELD: don't have this one

  suptitle(['Made ' datestr(now) ]);
  %print -djpeg95 ~/Sites/latest.jpg
  return;


  if ~exist('V')
    for i=0:900:n
      slice = ReadTime(i,datpath)
      V(i/900+1,:)=slice.V(1,:);
      eta(i/900+1,:)=slice.eta(1,:);
    end;
  end

  V(n/900,:)=slice.V(1,:);
  eta(n/900,:)=slice.eta(1,:);
  t = 0:size(V,1)-1;
  t = t*900*4.13333/3600;


  figure(2);clf

  pcolor(slice.x,t,V);shading flat;
  caxis([-1 1]/4);
  %colormap(colCog);  ELD: don't have this one
  suptitle(['Made ' datestr(now) ]);

  %print -djpeg95 ~/Sites/latestHov.jpg

  Last = n;

end;
