
% script to make red white blue colormap for hovmuller's
tmp=0*ones(20,3);
tmp(1:10,3)= 1;

endv=1;
tmp(endv:10,1)= [((0:(10-endv))/(10-endv)) ]';
tmp(endv:10,2)= [((0:(10-endv))/(10-endv)) ]';

endv=18;
tmp(10:20,1)= 1;
tmp(11:20,2)= [((9:-1:0)/9) ]';
tmp(11:20,3)= [((9:-1:0)/9) ]';

colormap(tmp)

