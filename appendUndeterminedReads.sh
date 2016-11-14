#!/bin/bash
# OPTIONS FOR GRID ENGINE ==============================================================
#
#$ -S /bin/bash
#$ -N GSUFastQC
# -l h_rt=1:00:00
# -l h_vmem=2G
# -l h_stack=8M
# -l cputype=amd
#$ -cwd
#$ -j y
#$ -t  1-1
#$ -V
# OPTIONS FOR GRID ENGINE=================================================================

undeterminedFile=$1

targetSeq=$2

targetFile=$3

readNumber=$4

outputFile=$5
tempOutFile=~/temp/$(basename $outputFile).temp

gunzip -c $undeterminedFile | grep -A 3 $readNumber:N:0:$targetSeq$ | sed ':a;N;$!ba;s/--\n//g' > $tempOutFile
gzip $tempOutFile

cat $targetFile $tempOutFile.gz > $outputFile
rm $tempOutFile.gz

