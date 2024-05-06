function MODEL=MITGCM_regrid_topo(MODEL)

eval(['load ',MODEL.toposrcfile,' TOPO'])

MODEL.lat2km=111.3171;
MODEL.lon2km=sw_dist([MODEL.reflat MODEL.reflat],[0 1],'km')     ;

delX = MODEL.dX0*ones(1,MODEL.Nx);MODEL.X=cumsum(delX);
delY = MODEL.dY0*ones(1,MODEL.Ny);MODEL.Y=cumsum(delY);

% Rotate coordinates and determine lat and lon
ii=complex(0,1);

[xi yi]=meshgrid(MODEL.X*1e-3,MODEL.Y*1e-3); xi=xi'; yi=yi';
coord=xi+ii*yi;
coord=coord*exp(ii*pi*MODEL.rotate_angle/180);
coord=real(coord)./MODEL.lon2km+ii*imag(coord)/MODEL.lat2km;
coord=coord+MODEL.lon0+ii*MODEL.lat0;
MODEL.Lon=real(coord)'; MODEL.Lat=imag(coord)';

% Interpolate bathymetry onto grid 
%%
MODEL.H=interp2(TOPO.lon',TOPO.lat',TOPO.H,MODEL.Lon,MODEL.Lat);
%
%%
