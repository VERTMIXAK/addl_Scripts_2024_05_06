fid=fopen('delZvar','r','b');
datafile=fread(fid,[10000001],'real*8');
%sprintf('ha ha')
length(datafile)
fclose(fid);
plot(datafile)
[min(datafile),max(datafile)]