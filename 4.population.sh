#!/bin/bash
#BSUB -W 70:05                    # wall-clock time (hrs:mins)
#BSUB -L /bin/bash                # login shell    
#BSUB -n 20                        # number of tasks in job
#BSUB -R "span[ptile=20]"          # run one MPI task per node
#BSUB -R "rusage[mem=2000]"     # memory to reserve, in MB
#BSUB -J POP                    # job name
#BSUB -o POP.%J.out             # output file name in which %J is replaced by the job ID
#BSUB -e POP.%J.err             # error file name in which %J is replaced by the job ID

module load Stacks/1.37-intel-2015B
module load parallel/20151222-intel-2015B

INPUT_DIR=./raw_data/combined

SAMPLE_DIR=samples
mkdir $SAMPLE_DIR
OUTPUT_DIR=stacks
mkdir $OUTPUT_DIR

date
## step 5. population, Calculate population statistics and export several output files
# generate a population map file
perl -ne 'chomp; print $_, "\t", "pop1", "\n"' accession_names.txt >pop_map.txt

batch_id=1
 
populations -b $batch_id -P $OUTPUT_DIR -M pop_map.txt -p 1 -r 0.5 -m 5 -t 20 --fasta --vcf --structure --phylip

date
