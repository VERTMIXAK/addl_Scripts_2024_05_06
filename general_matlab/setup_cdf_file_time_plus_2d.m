function y=setup_cdf_file_time_plus_2d(outfile,varname,tvar,yvar,xvar,sz)
mode = bitor ( nc_clobber_mode, nc_64bit_offset_mode );
nc_create_empty ( outfile, mode )
nc_add_dimension ( outfile, yvar, sz(1) )% was 2 why?
nc_add_dimension ( outfile, xvar, sz(2) )% was 3 why?
nc_add_dimension ( outfile, tvar, 0 ) 
xh_varstruct.Name       =  xvar    ;xh_varstruct.Dimension    = {xvar};
yh_varstruct.Name       =  yvar    ;yh_varstruct.Dimension    = {yvar};
Time_varstruct.Name     =  tvar    ;Time_varstruct.Dimension  = {tvar};
xh_varstruct.Nctype     =  nc_float;
yh_varstruct.Nctype     =  nc_float;
Time_varstruct.Nctype   =  nc_float;
varname_varstruct.Name=varname;varname_varstruct.Nctype=nc_float;varname_varstruct.Dimension = {tvar,yvar,xvar};
nc_addvar(outfile,varname_varstruct)
nc_addvar(outfile,Time_varstruct)
nc_addvar(outfile,xh_varstruct)
nc_addvar(outfile,yh_varstruct)
