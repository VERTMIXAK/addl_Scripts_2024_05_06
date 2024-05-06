function y=setup_cdf_file_time_plus_3d(outfile,varname,tvar,zvar,yvar,xvar,sz)
mode = bitor ( nc_clobber_mode, nc_64bit_offset_mode );
nc_create_empty ( outfile, mode )
nc_add_dimension ( outfile, zvar, sz(1) )
nc_add_dimension ( outfile, yvar, sz(2) )
nc_add_dimension ( outfile, xvar, sz(3) )
nc_add_dimension ( outfile, tvar, 0 )
zl_varstruct.Name       =  zvar    ;zl_varstruct.Dimension    = {zvar};
xh_varstruct.Name       =  xvar    ;xh_varstruct.Dimension    = {xvar};
yh_varstruct.Name       =  yvar    ;yh_varstruct.Dimension    = {yvar};
Time_varstruct.Name     =  tvar    ;Time_varstruct.Dimension  = {tvar};
zl_varstruct.Nctype     =  nc_float; 
xh_varstruct.Nctype     =  nc_float;
yh_varstruct.Nctype     =  nc_float;
Time_varstruct.Nctype   =  nc_float;
varname_varstruct.Name=varname;varname_varstruct.Nctype=nc_float;
varname_varstruct.Dimension = {tvar,zvar,yvar,xvar};
nc_addvar(outfile,varname_varstruct)
nc_addvar(outfile,Time_varstruct)
nc_addvar(outfile,zl_varstruct)
nc_addvar(outfile,xh_varstruct)
nc_addvar(outfile,yh_varstruct)
