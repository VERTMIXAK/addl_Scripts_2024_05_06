% 20-layer system and 3500m max depth
Nz=20;
Dmax=3500.0;

% write the grid elevations (negative numbers here, just to be clear)
dz =  Dmax/Nz;
z  = -dz/2:-dz:-Dmax

% assume salinity and temperature are constant
salinity    = 35.*ones(1,Nz);
temperature = 0. *ones(1,Nz);

% calculating the density in the sw_pres routine requires the pressure, which 
% doesn't make any sense because water is assumed incompressible.  But, well OK.
pressures   = sw_pres(-z,salinity)

% now calculate the density as a function of depth.
% !!! for constant temp and salinity the pressure
% varies all over the place
sw_dens(salinity, temperature, pressures)