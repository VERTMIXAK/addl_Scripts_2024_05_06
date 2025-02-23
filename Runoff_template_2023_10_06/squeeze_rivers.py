import re
import numpy as np
import netCDF4
import sys
import pdb

# Warning this script has Lm, Mm and N (50) all hardcoded
# for the ROMS domain.

infile = sys.argv[1]
outfile = sys.argv[2]

#pdb.set_trace()

nc_rivers = netCDF4.Dataset(infile, 'r')
sign = nc_rivers.variables['river_sign'][:]
xi = nc_rivers.variables['river_Xposition'][:]
eta = nc_rivers.variables['river_Eposition'][:]
dir = nc_rivers.variables['river_direction'][:]
runoff = nc_rivers.variables['river_transport'][:]
time = nc_rivers.variables['river_time'][:]

run_180 = np.abs(runoff[180,:])
print('Sum 5', np.sum(run_180))

Nr = sign.shape[0]
Nt = time.shape[0]
count = 0

year_sum = np.sum(runoff, axis=0)
all_sum = np.sum(np.abs(year_sum))
print(year_sum.shape, all_sum)

for i in range(Nr):
    if np.abs(year_sum[i]) > 0.:
        count += 1

river2 = np.zeros((count))
sign2 = np.zeros((count))
xi2 = np.zeros((count))
eta2 = np.zeros((count))
dir2 = np.zeros((count))
runoff2 = np.zeros((Nt, count))

print('Squeezing down to', count, 'rivers')
it = 0
for i in range(Nr):
    if np.abs(year_sum[i]) > 0.:
        sign2[it] = sign[i]
        xi2[it] = xi[i]
        eta2[it] = eta[i]
        dir2[it] = dir[i]
        runoff2[:,it] = runoff[:,i]
        river2[it] = it+1
        it += 1

# create file with all the objects
out = netCDF4.Dataset(outfile, 'w', format='NETCDF3_64BIT')
out.type = 'ROMS RIVERS file'
out.title = 'hydroflow'
out.source = 'David Hill and Jordan Beamer'

out.createDimension('river_time', None)
out.createDimension('river', count)
out.createDimension('s_rho', 50)

times = out.createVariable('river_time', 'f8', ('river_time'))
times.units = 'days'
#times.cycle_length = 365.25
times.units = 'days since 1900-01-01 00:00:00'
times.long_name = 'river runoff time'

river = out.createVariable('river', 'i4', ('river'))
river.long_name = 'river runoff identification number'

flag = out.createVariable('river_sign', 'f8', ('river'))
flag.long_name = 'river directional sign'

xi = out.createVariable('river_Xposition', 'i4', ('river'))
xi.long_name = 'river XI-position at RHO-points'
xi.valid_min = 1
xi.valid_max = 778    # WARNING - hardcoded Lm+1

eta = out.createVariable('river_Eposition', 'i4', ('river'))
eta.long_name = 'river ETA-position at RHO-points'
eta.valid_min = 1
eta.valid_max = 1184    # WARNING - hardcoded Mm+1

dirs = out.createVariable('river_direction', 'i4', ('river'))
dirs.long_name = 'river runoff direction'

vshape = out.createVariable('river_Vshape', 'f8', ('s_rho', 'river'))
vshape.long_name = 'river runoff mass transport vertical profile'

trans = out.createVariable('river_transport', 'f8', ('river_time', 'river'))
trans.long_name = 'river runoff vertically integrated mass transport'
trans.units = 'meter3 second-1'
trans.time = 'river_time'

#pdb.set_trace()
out.variables['river'][:] = river2
out.variables['river_sign'][:] = sign2
out.variables['river_Xposition'][:] = xi2
out.variables['river_Eposition'][:] = eta2
out.variables['river_direction'][:] = dir2
out.variables['river_transport'][:] = runoff2
out.variables['river_time'][:] = time

run_180 = np.abs(runoff2[180,:])
print('Sum 6', np.sum(run_180))

year_sum = np.sum(runoff2, axis=0)
all_sum = np.sum(np.abs(year_sum))
print(year_sum.shape, all_sum)

out.close()
