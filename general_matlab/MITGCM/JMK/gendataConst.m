% This is a matlab script that generates the input data
% variable x resolution
clear
transfer = 1;

prec='real*8';
ieee='l';


ny=600;
nx=1;
nz=200; % same as Sonya....

% Nominal depth of model (meters)
H=2000;

Ly = 200*ny;


%% Horizontal resolution (m)
dy = ones(1,ny);
dy(ny/3+[1:ny/3]) = 200;
dy(ny/3*2+[1:ny/3]) = linspace(200,2000,ny/3);
dy(1:ny/3) = linspace(2000,200,ny/3);

y = cumsum(dy);
y = y-mean(y);


z = linspace(-2000,0,nz);
dz = diff(z);

[sprintf('delZ =') sprintf(' %7.6g,',-dz)]


% use N = 5.3e-3
gravity=9.81;
talpha=2.0e-4;

N2 = 5.2e-3.^2;

dT = -dz*N2/gravity/talpha;
Tref = cumsum([0;-dT']);
Tref = flipud(Tref);


[sprintf('Tref =') sprintf(' %8.6g,',Tref)]
t=zeros([nx,ny,nz]);
for k=1:nz
  t(:,:,k) = t(:,:,k) + Tref(k);
end
fid=fopen('../T.init20','w',ieee); fwrite(fid,t,prec); fclose(fid);

%% HOME

fid=fopen('../delYvar','w',ieee); fwrite(fid,dy,prec); fclose(fid);
fid=fopen('../delZvar','w',ieee); fwrite(fid,dz,prec); fclose(fid);

for w = 55
  d = -H*ones(nx,ny);
  d=d+2000*exp(-y.^2/(1000*w).^2)-1000;
  d(d<-2000)=-2000;
  plot(y/1000,d);hold on;
  fid=fopen(sprintf('../topog.w%02d',w),'w',ieee); fwrite(fid,d,prec); fclose(fid);  
end;
% d(d<-1300)=-1300;

figure(2)
clf
pcolor(y,z,squeeze(t)');colorbar;shading flat;hold on
plot(y,d,'k-')


