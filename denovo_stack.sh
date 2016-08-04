#!/bin/bash
#BSUB -W 70:05                    # wall-clock time (hrs:mins)
#BSUB -L /bin/bash                # login shell    
#BSUB -n 20                        # number of tasks in job
#BSUB -R "span[ptile=20]"          # run one MPI task per node
#BSUB -R "rusage[mem=2000]"     # memory to reserve, in MB
#BSUB -J stacks                    # job name
#BSUB -o stacks.%J.out             # output file name in which %J is replaced by the job ID
#BSUB -e stacks.%J.err             # error file name in which %J is replaced by the job ID

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

##echo $cmds |tr ";" "\n" |parallel -j 20 

samp=""
for name in $names;
do
  ## cat $SAMPLE_DIR/${name}_R*fq.gz |gunzip - >$SAMPLE_DIR/${name}.fq
  samp+="-s $SAMPLE_DIR/${name}.fq "
done


date
echo "Step 1 is done."

## step 2, run denovo_map.pl
#echo "-m 3 -M 3 -n 0"
#denovo_map.pl -m 3 -M 3 -n 0 -T 20 -b 1 -o $OUTPUT_DIR $samp

for i in `seq 0 3`;
do
date
let "batch=i+1"
echo "run batch $batch \" -m 3 -M 3 -n $i \""
cmd="denovo_map.pl -m 3 -M 3 -n $i -T 20 -b $batch -o $OUTPUT_DIR $samp -S -X \"populations:--genomic --fasta --vcf --structure --phylip\" "
echo $cmd
denovo_map.pl -m 3 -M 3 -n $i -T 20 -b $batch -o $OUTPUT_DIR $samp -S -X "populations:--genomic --fasta --vcf --structure --phylip "
date
echo "done batch $batch"
done
