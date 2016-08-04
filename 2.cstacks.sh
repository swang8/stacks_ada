#!/bin/bash
#BSUB -W 70:05                    # wall-clock time (hrs:mins)
#BSUB -L /bin/bash                # login shell    
#BSUB -n 20                        # number of tasks in job
#BSUB -R "span[ptile=20]"          # run one MPI task per node
#BSUB -R "rusage[mem=2000]"     # memory to reserve, in MB
#BSUB -J CS                    # job name
#BSUB -o CS.%J.out             # output file name in which %J is replaced by the job ID
#BSUB -e CS.%J.err             # error file name in which %J is replaced by the job ID

module load Stacks/1.37-intel-2015B
module load parallel/20151222-intel-2015B

INPUT_DIR=./raw_data/combined

SAMPLE_DIR=samples
mkdir $SAMPLE_DIR
OUTPUT_DIR=stacks
mkdir $OUTPUT_DIR

names=`cat accession_names.txt`


## step 3. cstack, build catelog
samp=""
for name in $names;
do
  samp+="-s $OUTPUT_DIR/${name} "
done

date
echo "cstacks is started"
## use "-n 3" to build the catalog, modify this if you want
batch_id=1
cstacks -b $batch_id $samp -o $OUTPUT_DIR -n 3  -p 20 
echo "cstacks is done!"
date
