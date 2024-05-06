%fid=fopen('topog.w55','r','l');
fid=fopen('delYvar','r','l');
datafile=fread(fid,[1001],'real*8')
length(datafile)
fclose(fid);
plot(datafile)