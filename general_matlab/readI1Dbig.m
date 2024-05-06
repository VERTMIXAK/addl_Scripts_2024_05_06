fid=fopen('delY
var','r','b');
datafile=fread(fid,[2001],'real*8')
length(datafile)
fclose(fid);
plot(datafile)