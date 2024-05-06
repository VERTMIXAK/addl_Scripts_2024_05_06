clear;

fid=fopen('delXvar','r','b');delx=fread(fid,500,'real*8');fclose(fid);
fid=fopen('delYvar','r','b');dely=fread(fid,500,'real*8');fclose(fid);
fid=fopen('delZvar','r','b');delz=fread(fid,500,'real*8');fclose(fid);
Nx=length(delx);Ny=length(dely);Nz=length(delz);

fid=fopen('topog.init','r','b');
datafile=fread(fid,[Nx Ny],'real*8');
fclose(fid);
% 
% fid=fopen('vXfm10.init','r','b');
% datafile=fread(fid,Nx*Ny*Nz,'real*8');
% fclose(fid);
% datafile=reshape(datafile,[Nx Ny Nz]);

length(datafile)
%surf(datafile);
%contour(datafile);
[min(min(datafile)) max(max(datafile))];

%fid=fopen('bathy_zoom.mat','r','b');bath=fread(fid,500,'real*4');fclose(fid);
