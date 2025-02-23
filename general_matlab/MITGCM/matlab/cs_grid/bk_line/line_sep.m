function [x3b,xPA,yPA,xAI,yAI,xIP,yIP]=line_sep(yIn);

% $Header: /u/gcmpack/MITgcm/utils/matlab/cs_grid/bk_line/line_sep.m,v 1.1 2005/09/15 16:46:28 jmc Exp $
% $Name: checkpoint62l $

%-sep. line Pac - Atl (y increasing order):
xPA=[ -70  -59  -70  -70  -62  -90 -104 -104  -88];
yPA=[ -70  -64  -52  -40  -10   17   21   64   72];
%-sep. line Atl - Ind (y increasing order):
xAI=[  21   60  105];
yAI=[  12   50   75];
%-sep. line Ind - Pac (y increasing order):
xIP=[ 146  106  106];
yIP=[ -34    6   90];

if yPA(end) < 90, yPA(end+1)=90; xPA(end+1)=xPA(end); end
if yAI(end) < 90, yAI(end+1)=90; xAI(end+1)=xAI(end); end
if yIP(end) < 90, yIP(end+1)=90; xIP(end+1)=xIP(end); end
%if yPA(1) > -90, yPA(end+1)=0; yPA(2:end)=yPA(1:end-1); 
if yPA(1) > -90,  yPA(2:end+1)=yPA(1:end); xPA(2:end+1)=xPA(1:end); yPA(1)=-90; end
if yAI(1) > -90,  yAI(2:end+1)=yAI(1:end); xAI(2:end+1)=xAI(1:end); yAI(1)=-90; end
if yIP(1) > -90,  yIP(2:end+1)=yIP(1:end); xIP(2:end+1)=xIP(1:end); yIP(1)=-90; end

n=length(yIn);
x3b=zeros(3,n);
for i=1:n,

 y=yIn(i);
%-sep. line Pac - Atl :
 i2=min(find(y<yPA)); i1=i2-1;
 if i1 < 1, x3b(1,i)=xPA(i2) ; else
  x3b(1,i)=xPA(i2)+(xPA(i1)-xPA(i2))*(y-yPA(i2))/(yPA(i1)-yPA(i2));
 end
 if n==1, fprintf(' i2(PA)= %i ',i2); end
%-sep. line Atl - Ind :
 i2=min(find(y<yAI)); i1=i2-1;
 if i1 < 1, x3b(2,i)=xAI(i2) ; else
  x3b(2,i)=xAI(i2)+(xAI(i1)-xAI(i2))*(y-yAI(i2))/(yAI(i1)-yAI(i2));
 if n==1, fprintf(' i2(AI)= %i ',i2); end
 end
%-sep. line Ind - Pac :
 i2=min(find(y<yIP)); i1=i2-1;
 if i1 < 1, x3b(3,i)=xIP(i2) ; else
  x3b(3,i)=xIP(i2)+(xIP(i1)-xIP(i2))*(y-yIP(i2))/(yIP(i1)-yIP(i2));
 end
 if n==1, fprintf(' i2(IP)= %i \n',i2); end

end
return
