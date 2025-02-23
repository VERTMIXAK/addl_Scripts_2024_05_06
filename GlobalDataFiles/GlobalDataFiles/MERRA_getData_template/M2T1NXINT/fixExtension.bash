oldDir="originalDownloads"
newDir="data"

if [ -d $newDir ]
then
	\rm -r $newDir
fi
mkdir $newDir

for file in `ls $oldDir/MERR*`
do

source ~/.runROMSintel

	echo $file
	oldFile=`echo $file | cut -d '/' -f2`
	echo $oldFile
		
	echo "old name: " $oldFile

    fileDate=`echo $oldFile | rev | cut -d '.' -f3 | rev`

	newFile="MERRA_"$fileDate".nc"

	echo "new name: " $newFile


	date=`ncdump -h $oldDir/$oldFile | grep time:units | rev | cut -d " " -f3 | rev`
	echo "date $date"

	seconds=`grep $date ~/arch/addl_Scripts/dayConverterCommas.txt | cut -d ',' -f5`
	echo "seconds $seconds"

	minutes=`expr $seconds / 60 `



    ncks --mk_rec_dmn time $oldDir/$oldFile $newDir/$newFile

    ncatted -a units,time,o,c,"minutes since 1900-01-01 00:00:00" $newDir/$newFile

	python settime.py $newDir/$newFile $minutes

done

