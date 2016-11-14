#!/bin/bash
# OPTIONS FOR GRID ENGINE ==============================================================
#
#$ -S /bin/bash
#$ -N GSUFastQC
#$ -cwd
#$ -j y
#$ -V
#$ -m beas
#$ -M gsupipe-x@dundee.ac.uk
#$ -R y
#$ -pe smp 4
#$ -l ram=500M
# OPTIONS FOR GRID ENGINE=================================================================

#Script to run FastQC on the fastq file provided as input
#putputs to a folder locared where the fastq file is.

#input is an array
#must specify -t for qsub in the qsub command used to launch this

echo "Running on `hostname`"
#########################################################################################
#### Load the file containing the configs
#source $HOME/bin/pipelineConfig.sh
# sets the location of the output folder and where the scripts to run 
#########################################################################################
fastQC="/homes/gsupipe-x/bin/FastQC/fastqc"

#arg 1 text file containing the list of files to be submitted with that task array. 
#Loops over this file and submits fastqc with arguements contained in each line
seedFile=$1
arguements=$(awk "NR==$SGE_TASK_ID" $seedFile)

$fastQC $arguements -t 4 -k 8 
echo "$fastQC $arguements -t 4 -k 8 "
#=$fastQC $1 -t 8 -k 8 -o $2 
echo "Task Complete!"
