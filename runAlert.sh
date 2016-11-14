source ~/bin/pipelineConfig.sh
echo
hiseqRunsFile="$HOME/completedHiSeqRuns.txt"
nextseqRunsFile="$HOME/completednextseqRuns.txt"
miseqRunsFile="$HOME/completedMiSeqRuns.txt"

#Check for new RTAComplete files indicating newly finished HISEQ Runs
for nextseqRunComplete in $(find $runLocationNextseq -maxdepth 2 -name RTAComplete.txt); do 
	runName=`basename $(dirname $nextseqRunComplete)`
	if ! grep $nextseqRunComplete $nextseqRunsFile > /dev/null; then
		RTAContent=`cat $nextseqRunComplete`
		date=`echo $RTAContent | sed 's/^\(.*\),.*,.*/\1/'`
		time=`echo $RTAContent | sed 's/^.*,\(.*\),.*/\1/'`
		echo "Completed: $runName on $date at $time"
		echo "$nextseqRunComplete" >> $nextseqRunsFile
	fi
done

#check for nextseq runs in progress
for nextseqRunFolder in $(ls -d $runLocationNextseq --ignore="JJ_RNA_SEQ"); do
	runName=`basename $nextseqRunFolder`
		if [ ! -e ~/SampleSheets/$runName ]; then
			mkdir -p ~/SampleSheets/$runName
			sh get_sample_sheet.sh -r $runName > ~/SampleSheets/$runName/SampleSheet.csv 2> /dev/null
		fi
		if ! grep $runName $nextseqRunsFile > /dev/null; then 
			if [ `hostname` != "ngs-miso.cluster.lifesci.dundee.ac.uk" ]; then
				echo "In Progress: $runName"
				projects=`awk -F',' 'NR>1 { print $10 }' ~/SampleSheets/$runName/SampleSheet.csv | uniq`
				echo "Projects:"
				echo $projects
				echo
			else
				echo "Sample sheet needs fetching but this can't be done on the misoVM"
			fi 
		fi
done

##Check for new RTAComplete files indicating newly finished HISEQ Runs
#for hiseqRunComplete in $(find $runLocationHiseq -maxdepth 2 -name RTAComplete.txt); do 
#	runName=`basename $(dirname $hiseqRunComplete)`
#	if ! grep $hiseqRunComplete $hiseqRunsFile > /dev/null; then
#		RTAContent=`cat $hiseqRunComplete`
#		date=`echo $RTAContent | sed 's/^\(.*\),.*,.*/\1/'`
#		time=`echo $RTAContent | sed 's/^.*,\(.*\),.*/\1/'`
#		echo "Completed: $runName on $date at $time"
#		echo "$hiseqRunComplete" >> $hiseqRunsFile
#	fi
#done
#
##check for hiseq runs in progress
#for hiseqRunFolder in $(ls $runLocationHiseq); do
#	runName=`basename $hiseqRunFolder`
#		if [ ! -e ~/SampleSheets/$runName ]; then
#			mkdir -p ~/SampleSheets/$runName
#			sh get_sample_sheet.sh -r $runName > ~/SampleSheets/$runName/SampleSheet.csv 2> /dev/null
#		fi
#		if ! grep $runName $hiseqRunsFile > /dev/null; then 
#			if [ `hostname` != "ngs-miso.cluster.lifesci.dundee.ac.uk" ]; then
#				echo "In Progress: $runName"
#				projects=`awk -F',' 'NR>1 { print $10 }' ~/SampleSheets/$runName/SampleSheet.csv | uniq`
#				echo "Projects:"
#				echo $projects
#				echo
#			else
#				echo "Sample sheet needs fetching but this can't be done on the misoVM"
#			fi 
#		fi
#done
#
##Check for new RTAComplete files indicating newly finished MISEQ Runs
#for miseqRunComplete in $(find $runLocationMiseq -maxdepth 2 -name RTAComplete.txt); do 
#	runName=`basename $(dirname $miseqRunComplete)`
#	if ! grep $miseqRunComplete $miseqRunsFile > /dev/null; then
#		echo "Completed: $runName"
#		echo "$miseqRunComplete" >> $miseqRunsFile
#	fi
#
#done
##check for miseq runs in progress
#for miseqRunFolder in $(ls $runLocationMiseq); do
#	runName=`basename $miseqRunFolder`
#	if ! grep $runName $miseqRunsFile > /dev/null; then 
#		echo "In Progress: $runName"
#		echo
#	fi 
#done

#lastHiseq=`basename $(dirname $(tail -n 1 $hiseqRunsFile))`
#lastMiseq=`basename $(dirname $(tail -n 1 $miseqRunsFile))`
lastNextseq=`basename $(dirname $(tail -n 1 $nextseqRunsFile))`

#echo "Last Hiseq Completed: $lastHiseq"
#echo "Last Miseq Completed: $lastMiseq"
echo "Last Nextseq Completed: $lastNextseq"
#check for runs over a year old
#curDate=$(date +%y%m%d -d "1 year ago")
#for hiseqRun in $(ls /cluster/gsu/data/hiseq/); do 
#	runDate=$(echo $hiseqRun | awk -F "_" '{print $1}') 
#	if [[ "$runDate" -le "$curDate" ]]; then
#		echo "Run $hiseqRun is over a year old"
#	fi
#done
#
#for miseqRun in $(ls /cluster/gsu/data/miseq/); do 
#	runDate=$(echo $miseqRun | awk -F "_" '{print $1}') 
#	if [[ "$runDate" -le "$curDate" ]]; then
#		echo "Run $miseqRun is over a year old"
#	fi
#done
#
