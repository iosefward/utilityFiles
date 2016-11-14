#Launcher for QSubbing the runHiSeqPipeline.sh file

#Basically this is so that the qsub output fole is dumped in the ~/qsuOutput folder rather
#than whereever it is you were when you ran it
#########################################################################################
#### Load the file containing the configs
source pipelineConfig.sh
# sets the location of the output folder and where the scripts to run 
# fastqc, fastqscreen, casava, md5hashing script, etc
#########################################################################################


#use -h or see the getHelp function for usage
runPath=""
casavaCustomFolder=""
customSampleSheet=""
NOW=`date +"%y%m%d-%H%M"`

function getHelp {
	echo "This file runs the HiSeq Pipeline."
	echo "Mandatroy Arguements:"
	echo "-r <runFolderPath>"
	echo ""
	echo "Optional Arguements:"
	echo "-s sample sheet to use - not sure if this works!"
	echo "-h Display this help"
	echo "-f casava output directory (name only, not path)"
	echo "-b use bases mask to use."
	echo "-i ignore missing bcl files"
	echo "-q only run fastQC and fastQScreen. No casava"
	echo ""
	echo "example 1: running casava using defaul output (/cluster/gsu/data/processed/hiseq/<runfolder>)"
	echo "sh runHiSeqPipeline.sh -r /cluster/gsu/data/hiseq/<runfolder> -s GSU_AG_Worm2";echo ""
	echo "example 2: running casava using custom output folder and custom sample sheet"
	echo "sh runHiSeqPipeline.sh -r /cluster/gsu/data/hiseq/<runfolder> -f exampleOutputFolder -s ~/customeSampleSheet.csv -b Y*,I6n*,Y*"
	exit 1;
}

while getopts hiqr:f:s:b: OPTION
do
	case $OPTION in
		h) getHelp;;
		r) runPath="-r $OPTARG";runFolder=`basename $OPTARG`;;
		f) casavaOutputDir="-f $OPTARG";;
		s) sampleSheet="-s $OPTARG";;
#		b) useBasesMask="-b $OPTARG";;
		i) ignoreMissingBCL="-i";;
		q) fastQCOnly="-q";;
	esac
done

if [ ! -e $qsubOutputFolderBase/$runFolder ];
	then mkdir $qsubOutputFolderBase/$runFolder
fi

qsub -o $qsubOutputFolderBase/$runFolder/$NOW-$runFolder.o \
	 -e $qsubOutputFolderBase/$NOW-$runFolder.e \
	 -js 10 \
			$runNextSeqPipeline $runPath $casavaOutputDir \
			$sampleSheet $ignoreMissingBCL \
			$fastQCOnly
#sh $HOME/bin/runHiSeqPipeline.sh $runPath $casavaOutputDir $sampleSheet $useBasesMask

