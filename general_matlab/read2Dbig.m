cefid=fopen('EV.ob','r','b');
datafile=fread(fid,[360 36000000],'real*8');
size(datafile)
fclose(fid);
[ min(min(datafile)) max(max(datafile))]
%surf(datafile);
%contour(datafile);