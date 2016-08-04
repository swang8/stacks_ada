#!/bin/bash
#BSUB -W 70:05                    # wall-clock time (hrs:mins)
#BSUB -L /bin/bash                # login shell    
#BSUB -n 20                        # number of tasks in job
#BSUB -R "span[ptile=20]"          # run one MPI task per node
#BSUB -R "rusage[mem=2000]"     # memory to reserve, in MB
#BSUB -J PROC                    # job name
#BSUB -o PROC.%J.out             # output file name in which %J is replaced by the job ID
#BSUB -e PROC.%J.err             # error file name in which %J is replaced by the job ID

module load Stacks/1.37-intel-2015B
module load parallel/20151222-intel-2015B

INPUT_DIR=./raw_data/combined

SAMPLE_DIR=samples
mkdir $SAMPLE_DIR
OUTPUT_DIR=stacks
mkdir $OUTPUT_DIR

names=`cat accession_names.txt`

## step 1
cmds=""
for name in $names;
do
  cmd="process_radtags -1 $INPUT_DIR/${name}_R1.fastq.gz  -2 $INPUT_DIR/${name}_R2.fastq.gz -o $SAMPLE_DIR -c -q --disable_rad_check -i gzfastq"
  cmds+="$cmd;"
done

echo $cmds |tr ";" "\n" |parallel -j 20 

