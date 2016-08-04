#!/bin/bash
#BSUB -W 10:05                    # wall-clock time (hrs:mins)
#BSUB -L /bin/bash                # login shell    
#BSUB -n 5                        # number of tasks in job
#BSUB -R "span[ptile=5]"          # run one MPI task per node
#BSUB -R "rusage[mem=2000]"     # memory to reserve, in MB
#BSUB -J US[38-288]                    # job name
#BSUB -o US.%J.%I.out             # output file name in which %J is replaced by the job ID
#BSUB -e US.%J.%I.err             # error file name in which %J is replaced by the job ID

module load Stacks/1.37-intel-2015B
module load parallel/20151222-intel-2015B

INPUT_DIR=./raw_data/combined

SAMPLE_DIR=samples
mkdir $SAMPLE_DIR
OUTPUT_DIR=stacks
mkdir $OUTPUT_DIR

names=`cat accession_names.txt`
cmd_file="ustacks.cmds"
if [ ! -s $cmd_file ]; then
  counter=1
  for name in $names;
  do
    echo "counter: $counter"
    cmd="ustacks -t fastq -f $SAMPLE_DIR/${name}.fq -r -o $OUTPUT_DIR -i $counter -m 5 -M 2 -p 5"
    echo $cmd >>$cmd_file
    let "counter+=1"
  done
fi

tobe_run=`sed -n ${LSB_JOBINDEX}p $cmd_file`
echo "Running: $tobe_run" 
date
$tobe_run
date
