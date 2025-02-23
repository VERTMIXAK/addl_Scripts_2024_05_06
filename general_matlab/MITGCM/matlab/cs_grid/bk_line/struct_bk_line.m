
% $Header: /u/gcmpack/MITgcm/utils/matlab/cs_grid/bk_line/struct_bk_line.m,v 1.1 2005/09/15 16:46:28 jmc Exp $
% $Name: checkpoint62l $

%- output arrays:
% ylat=-87:3:87;
% if ydim > 1,  ydim=length(ylat); end
% savFlg=zeros(6*nc,ydim);
% savIuv=zeros(6*nc,ydim); savJuv=zeros(6*nc,ydim);
% savXsg=zeros(6*nc,ydim); savYsg=zeros(6*nc,ydim);
% savNpts=zeros(ydim);  

j=1;

BK_LINE = struct('bk_Ylat',ylat(j), ...
                 'bk_Npts',savNpts(j), ...
                 'bk_Flag',savFlg(:,j), ...
                 'bk_Iuv',savIuv(:,j), ...
                 'bk_Juv',savJuv(:,j), ...
                 'bk_Xsg',savXsg(:,j), ...
                 'bk_Ysg',savYsg(:,j)
                 )
