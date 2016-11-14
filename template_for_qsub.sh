#!/bin/bash
# OPTIONS FOR GRID ENGINE ==============================================================
#
#$ -S /bin/bash
#$ -N GSUTemp
#$ -cwd
#$ -j y
#$ -V
# OPTIONS FOR GRID ENGINE=================================================================

#Script to run FastQC on the fastq file provided as input
#putputs to a folder locared where the fastq file is.
echo "Running on `hostname`"

#########################################################################################
#### Load the file containing the configs
source pipelineConfig.sh
# sets the location of the output folder and where the scripts to run 
# fastqc, fastqscreen, casava, md5hashing script, etc
#########################################################################################


echo  "The TASK ID of *this* task is : $SGE_TASK_ID"
date
gunzip $1
date
echo "Task Complete!"
