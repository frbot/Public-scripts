#! /bin/sh

#TOOL FOR RNAseq DATA ANAYSIS USING SINGLE READS (requires a file specifying the gene lengths)
# Usage Bowtie2-alignment-for-RNA-seq.sh <input> <prefix> <fastq1> 
# Read input file

#echo "Enter the input reference filename:"
input="$1"

#echo "Enter the output prefix"
prefix="$2"

#echo "Enter the fastq file"
fastq="$3"

# Bowtie2 alignment
bowtie2-build $input $prefix ;
bowtie2  -p 10 -x $prefix -U $fastq -S $prefix.sam ;

#convert sam to bam
samtools view -Sb $prefix.sam -o $prefix.bam ;

#sort the bam file
samtools sort $prefix.bam -o "$prefix"-sorted.bam ;

#index the bam file
samtools index "$prefix"-sorted.bam ;


#Mapping statistics
var=$(samtools view -c -F 260 "$prefix"-sorted.bam); echo "Number of mapped reads = $var" > "$prefix"-assembly_coverage ;

#Cleanup

rm $prefix.bam ;
rm $prefix.sam ;