#! /bin/sh
echo "Script usage bowtie2-alignment-se.sh input prefix fastq1"

# Read input file

#echo "Enter the input reference filename:"
input="$1"

#echo "Enter the output prefix"
prefix="$2"

#echo "Enter the fastq file"
fastq1="$3"


#gzipping
#gzip -d *.gz ;

# Bowtie2 alignment
bowtie2-build $input $prefix ;
bowtie2 -p 10 -x $prefix -U $fastq1 -S $prefix.sam ;


#convert sam to bam
samtools view -Sb $prefix.sam -o $prefix.bam ;


#sort the bam file
samtools sort $prefix.bam -o "$prefix"-sorted.bam 

#index the bam file
samtools index "$prefix"-sorted.bam


echo "Done"

exit 0
