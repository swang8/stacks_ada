#!/bin/bash
#BSUB -W 10:05                    # wall-clock time (hrs:mins)
#BSUB -L /bin/bash                # login shell    
#BSUB -n 5                        # number of tasks in job
#BSUB -R "span[ptile=5]"          # run one MPI task per node
#BSUB -R "rusage[mem=2000]"     # memory to reserve, in MB
#BSUB -J SS[1-288]                    # job name
#BSUB -o SS.%J.%I.out             # output file name in which %J is replaced by the job ID
#BSUB -e SS.%J.%I.err             # error file name in which %J is replaced by the job ID

module load Stacks/1.37-intel-2015B
module load parallel/20151222-intel-2015B

INPUT_DIR=./raw_data/combined

SAMPLE_DIR=samples
mkdir $SAMPLE_DIR
OUTPUT_DIR=stacks
mkdir $OUTPUT_DIR

names=`cat accession_names.txt`
cmd_file="sstacks.cmds"

batch_id=1
if [ ! -s $cmd_file ]; then
  for name in $names;
  do
    cmd="sstacks -b $batch_id -c $OUTPUT_DIR/batch_${batch_id} -s $OUTPUT_DIR/$name -o $OUTPUT_DIR -p 5"
    echo $cmd >>$cmd_file
  done
fi

tobe_run=`sed -n ${LSB_JOBINDEX}p $cmd_file`
echo "Running: $tobe_run" 
date
$tobe_run
date
