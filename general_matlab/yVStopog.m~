fid=fopen('T.init','r','b');
topog=fread(fid,[640,80000],'real*8');
length(topog)
fclose(fid);
fid=fopen('delYvar','r','b');
delY=fread(fid,[2001],'real*8');
length(delY)
fclose(fid);
y=cumsum(delY+zeros(length(delY),1));

plot(y,topog)