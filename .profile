

module() { eval `/usr/bin/modulecmd bash $*`; }
export -f module
umask 0020
case "$(hostname)" in
	"gjb-www-1.cluster.lifesci.dundee.ac.uk")
		currentHost="www1"
	;;
	"gjb-www-1.cluster.lifesci.dundee.ac.uk")
		currentHost="www2"
	;;
	"ningal.cluster.lifesci.dundee.ac.uk")
		currentHost="ningal"
	;;
	"ngs-miso.cluster.lifesci.dundee.ac.uk")
		currentHost="miso"
#		export PATH=/sw/opt/python/2.7.3/bin/:$PATH
		#source ~/galaxy/environmentSetup.sh
	;;
	*)
		currentHost=`hostname`
esac
PS1="\t-\!-$currentHost-\W$"
HISTFILESIZE=2500
source /gridware/sge/default/common/settings.sh
#PYTHONPATH="$PYTHONPATH:/sw/opt/python/2.6.6/:/homes/gsupipe-x/djangoProjects/almostSignificant/gsuStats/" 
if [[ `hostname` == "gjb-www-1.cluster.lifesci.dundee.ac.uk" ]]; then
	PYTHONPATH=/homes/gsupipe-x/py-lib/:/sw/opt/python/2.7.3/:/homes/gsupipe-x/djangoProjects/almostSignificant_prod/:/homes/gsupipe-x/djangoProjects/almostSignificant_prod/almostSignificant_prod/:$PYTHONPATH
	#PYTHONPATH="/homes/gsupipe-x/py-lib/:/sw/opt/python/2.7.3/:/homes/gsupipe-x/djangoProjects/almostSignificant_dev/gsuStats/:/homes/gsupipe-x/galaxy/lib64/:/homes/gsupipe-x/galaxy/galaxy-dist/scripts/api/:$PYTHONPATH" 
	PATH="/homes/gsupipe-x/lib:/homes/gsupipe-x/bin/tools/samtools/bcftools/:/homes/gsupipe-x/bin/tools/samtools/samtools/://sw/java/jdk7/bin:/usr/bin:/sw/bin:/homes/gsupipe-x/bin/bwa/bwa-0.7.5a:homes/gsupipe-x/bin/pipelineConfig.sh:/homes/gsupipe-x/bin:/sw/opt/casava/bin:/homes/gsupipe-x/bin/FastQC:/homes/gsupipe-x/bin/fastq_screen_v0.4:/sw/NOBACK/bin/convert:$PATH"
elif [[ `hostname` == "ngs-miso.cluster.lifesci.dundee.ac.uk" ]]; then
	PYTHONPATH=/homes/gsupipe-x/py-lib/:/sw/opt/python/2.7.3/:/homes/gsupipe-x/djangoProjects/almostSignificant_prod/:/homes/gsupipe-x/djangoProjects/almostSignificant_prod/almostSignificant_prod/:$PYTHONPATH
	#PYTHONPATH="/homes/gsupipe-x/py-lib/:/sw/opt/python/2.7.3/:/homes/gsupipe-x/djangoProjects/almostSignificant_dev/gsuStats/:/homes/gsupipe-x/galaxy/lib64/:/homes/gsupipe-x/galaxy/galaxy-dist/scripts/api/:$PYTHONPATH" 
	PATH="/homes/gsupipe-x/lib/:/sw/opt/python/2.7.3/bin/:/homes/gsupipe-x/bin/tools/samtools/bcftools/:/homes/gsupipe-x/bin/tools/samtools/samtools/://sw/java/jdk7/bin:/usr/bin:/sw/bin:/homes/gsupipe-x/bin/bwa/bwa-0.7.5a:homes/gsupipe-x/bin/pipelineConfig.sh:/homes/gsupipe-x/bin:/sw/opt/casava/bin:/homes/gsupipe-x/bin/FastQC:/homes/gsupipe-x/bin/fastq_screen_v0.4:/sw/NOBACK/bin/convert:$PATH"
else
	PYTHONPATH=/homes/gsupipe-x/py-lib/:/sw/opt/python/2.7.3/:/homes/gsupipe-x/djangoProjects/almostSignificant_prod/:/homes/gsupipe-x/djangoProjects/almostSignificant_prod/almostSignificant_prod/:$PYTHONPATH
	#PYTHONPATH="/homes/gsupipe-x/py-lib/:/sw/opt/python/2.7.3/:/homes/gsupipe-x/djangoProjects/almostSignificant/gsuStats/:/homes/gsupipe-x/galaxy/lib64/:/homes/gsupipe-x/galaxy/galaxy-dist/scripts/api/:$PYTHONPATH" 
	PATH="/homes/gsupipe-x/lib/:/sw/opt/python/2.7.3/bin/:/homes/gsupipe-x/bin/tools/samtools/bcftools/:/homes/gsupipe-x/bin/tools/samtools/samtools/://sw/java/jdk7/bin:/usr/bin:/sw/bin:/homes/gsupipe-x/bin/bwa/bwa-0.7.5a:homes/gsupipe-x/bin/pipelineConfig.sh:/homes/gsupipe-x/bin:/sw/opt/casava/bin:/homes/gsupipe-x/bin/FastQC:/homes/gsupipe-x/bin/fastq_screen_v0.4:/sw/NOBACK/bin/convert:$PATH"
fi
#PYTHONPATH="$PYTHONPATH:/sw/opt/python/2.7.3/:/homes/gsupipe-x/galaxy/lib64/:/homes/gsupipe-x/galaxy/galaxy-dist/scripts/api/" 
export PYTHONPATH
export DRMAA_LIBRARY_PATH=/gridware/sge/lib/lx-amd64/libdrmaa.so

#PATH="/sw/java/jdk7/bin:/sw/opt/python/2.7.3/bin:/usr/bin:/homes/ccole/bin:/sw/opt/samtools-0.1.18:/sw/bin:/homes/gsupipe-x/bin/bwa/bwa-0.7.5a:/sw/opt/R/2.15.1/bin/Rscript:/sw/opt/python/2.7.3/bin:/homes/gsupipe-x/bin/pipelineConfig.sh:/homes/gsupipe-x/bin:/sw/opt/casava/bin:/homes/gsupipe-x/bin/FastQC:/homes/gsupipe-x/bin/fastq_screen_v0.4:/sw/NOBACK/bin/convert:$PATH"
PATH="/homes/gsupipe-x/bin/tools/samtools/bcftools/:/homes/gsupipe-x/bin/tools/samtools/samtools/:/sw/java/jdk7/bin:/usr/bin:/sw/bin:/homes/gsupipe-x/bin/bwa/bwa-0.7.5a:homes/gsupipe-x/bin/pipelineConfig.sh:/homes/gsupipe-x/bin:/sw/opt/casava/bin:/homes/gsupipe-x/bin/FastQC:/homes/gsupipe-x/bin/fastq_screen_v0.4:/sw/NOBACK/bin/convert:$PATH" 
#Adding Kraken to path

PATH="$PATH:/cluster/gsu/data/ont/tools/Kraken/"
PATH="$PATH:/cluster/gsu/data/ont/tools/Jellyfish_1.10_install/bin/"
export PATH

export TMPDIR=$HOME/tmp
GSUPATH=/cluster/gsu/data/
source ~/.bashrc

module load gcc boost python/2.7.3 #samtools/1.1

checkRuns
