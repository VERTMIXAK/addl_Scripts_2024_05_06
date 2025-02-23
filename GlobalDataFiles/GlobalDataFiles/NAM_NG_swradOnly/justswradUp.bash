#!/bin/bash

source ~/.runROMSintel

# The dates are specified in the dates.txt file

window=23
hours=( $(seq -w 0 $window))
#hours=( $(seq -w 6 $window))
echo "hours" $hours
nSnapshots=${#hours[@]}
echo "nSnapshots = $nSnapshots"

urlFile=url.txt

year=`head -1 dates.txt | cut -d '-' -f1`
echo "year = " $year

\rm NAM* out* url*


names=("swrad_up" "swrad_down" "Uwind" "Vwind" "albedo" "cloud")
times=("srf_time" "srf_time" "wind_time" "wind_time" "albedo_time" "cloud_time")

longNames=names
longNames[0]="Upward_Short-Wave_Radiation_Flux_surface"
longNames[1]="Downward_Short-Wave_Radiation_Flux_surface"
longNames[2]="u-component_of_wind_height_above_ground"
longNames[3]="v-component_of_wind_height_above_ground"
longNames[4]="Albedo_surface"
longNames[5]="Total_cloud_cover_entire_atmosphere_single_layer"

latMin=30
latMax=50
lonMin=-80
lonMax=-65



#for nn in `seq 0 9`
#do
#    echo "first element" ${names[$nn]} ${times[$nn]} ${longNames[$nn]}
#done




#for nn in `seq 0 8`
for nn in `seq 0 1`
do
    name=${names[$nn]}
    time=${times[$nn]}
    longName=${longNames[$nn]}

    echo ${names[$nn]} ${times[$nn]} ${longNames[$nn]}

    while read line
    do

        dum=`echo $line | cut -d ',' -f1`
        now=`date -d $dum "+%Y%m%d"`
		month=`echo $now | cut -c 1-6`
        echo $now $month

        for ((ii=0;ii<$nSnapshots;ii+=1));
        do
            outFile="out_"$now"_${hours[$ii]}.nc"

            part1="https://www.ncei.noaa.gov/thredds/ncss/model-nam218/$month/"
            part2="$now/nam_218_"
            part3=$now"_0000_0"${hours[$ii]}".grb2?"
            part4="var=$longName&north=$latMax&west=$lonMin&east=$lonMax&south=$latMin&disableProjSubset=on&horizStride=1&time_start="
            datePlus=`date -d "$now" +%Y-%m-%d`"T"${hours[$ii]}"%3A00%3A00"
            part5=$datePlus"Z&time_end="
            part6=$datePlus"Z&timeStride=1&vertCoord=&addLatLon=true"
            echo $part1$part2$part3$part4$part5$part6 > $urlFile
            echo $part1$part2$part3$part4$part5$part6 

#            part1="https://rda.ucar.edu/thredds/ncss/grid/files/g/ds084.1/$year/"
#            part2="$now/NAM.0p25."
#            part3=$now"00.f0"
#            part4="${hours[$ii]}.grib2?var=$longName&north=$latMax&west=$lonMin&east=$lonMax&south=$latMin&horizStride=1&time_start="
#            datePlus=`date -d "$now + ${hours[$ii]} hours" "+%Y-%m-%dT%H:%M:%S"`
#            part5=$datePlus"Z&time_end="
#            part6=$datePlus"Z&timeStride=1&vertStride=1&accept=netcdf3&addLatLon=true"
#            echo $part1$part2$part3$part4$part5$part6 > $urlFile

			echo $ii " of " $nSnapshots

#: <<'BLOCK'
            wget -O $outFile -i $urlFile

            if [ -s $outFile ];then
                timeVar=`ncdump -h $outFile | grep time | head -1 |   tr -d '\t' | cut -d ' ' -f1`
                boundsVar=`ncdump -h $outFile | grep double | grep _ | cut -d '(' -f1 | rev | cut -d ' ' -f1 | rev`
                echo "time_bounds variable " $boundsVar
                echo "length" ${#boundsVar}

                if [ ${#boundsVar} -gt 0 ];then

                    echo "found extra dimension"
                    ncks -O -x -v $boundsVar $outFile $outFile
                fi    

                   ncrename -O -h -d $timeVar,$time               $outFile
                ncrename -O -h -v $timeVar,$time             $outFile
                ncrename -O -h -v $longName,$name            $outFile
#                ncks -O -v $time,$name,latitude,longitude     $outFile $outFile

                ncks    --mk_rec_dmn $time -O               $outFile $outFile
                echo "good download"

            else
                \rm $outFile
            fi
#BLOCK
        done
    done < dates.txt

    outName="NAM_"$name"_"$year".nc_ORIG"

    ncrcat out*.nc                            $outName
    ncrename -O -h -d y,lat           	$outName
    ncrename -O -h -d x,lon          	$outName
#    ncrename -O -h -v latitude,lat           $outName
#    ncrename -O -h -v longitude,lon           $outName
    \rm out*.nc

done


/bin/bash fixNamesTimes.bash


