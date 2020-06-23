#! /bin/sh
echo "Script usage bowtie2-alignment-pe.sh input prefix fastq1 fastq2"

# Read input file

#echo "Enter the input reference filename:"
input="$1"

#echo "Enter the output prefix"
prefix="$2"

#echo "Enter the fastq file 1"
fastq1="$3"

#echo "Enter the fastq file 2"
fastq2="$4"

#gzipping
#gzip -d *.gz ;

# Bowtie2 alignment
bowtie2-build $input $prefix ;
bowtie2 -x $prefix -1 $fastq1 -2 $fastq2 -S $prefix.sam ;


#convert sam to bam
samtools view -Sb $prefix.sam -o $prefix.bam ;


#sort the bam file
samtools sort $prefix.bam -o "$prefix"-sorted.bam ;

#index the bam file
samtools index "$prefix"-sorted.bam ;


echo "Computation succeded ! Thanks Francesca... :)"

exit 0
