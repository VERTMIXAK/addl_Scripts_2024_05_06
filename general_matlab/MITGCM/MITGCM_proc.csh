#! /bin/csh
# shell script to get model output ready for processing by matlab
# usage:
# /home/hsimmons/matlab/MITGCM/MITGCM_proc.csh /home/hsimmons/PROJ/MODELS/MITgcm/EXP/TASMAN/test/results/output0005/

set echo
set base = $1

cd $base

foreach i (UVEL VVEL THETA RHOAnoma ETAN)
ls -lh $i.*.t001.nc 
if (! -e $i.t001.nc)     ncrcat -O $i.*.t001.nc $i.t001.nc
end

#mv *[A-Z,a-z].t001.nc ..
