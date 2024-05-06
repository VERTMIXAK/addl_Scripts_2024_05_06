function tmp=rwb(n)
% script to make red white blue colormap for hovmuller's

tmp=0*ones(n,3);
tmp(1:n/2,3)= 1;

endv=1;
tmp(endv:n/2,1)= [((0:(n/2-endv))/(n/2-endv)) ]';
tmp(endv:n/2,2)= [((0:(n/2-endv))/(n/2-endv)) ]';

tmp(n/2:end,1)= 1;
tmp((n/2 + 1):end,2)= [(((n/2 -1):-1:0)/(n/2-1)) ]';
tmp((n/2 + 1):end,3)= [(((n/2 -1):-1:0)/(n/2 -1)) ]';

colormap(tmp)

