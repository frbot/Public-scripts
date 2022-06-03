#! /bin/sh
echo "Script usage bowtie2-alignment-for-coverage.sh input prefix"

# Read input file

#echo "Enter the input reference filename:"
input="$1"

#echo "Enter the output prefix"
prefix="$2"

mkdir -p $input ;
cp $input.fna $input/$input-contigs.fa ;
cat *.fastq > $input/input ;
cd $input ;

#gzipping
#gzip -d *.gz ;

# Bowtie2 alignment
bowtie2-build $input-contigs.fa $prefix ;
bowtie2 -x $prefix -U input -S $prefix.sam ;


#convert sam to bam
samtools view -Sb $prefix.sam -o $prefix.bam ;


#sort the bam file
samtools sort $prefix.bam -o "$prefix"-sorted.bam 

#index the bam file
samtools index "$prefix"-sorted.bam

#Obtain statistics
samtools depth $prefix-sorted.bam |  awk '{sum+=$3} END { print "Average = ",sum/NR}' > assembly_coverage ;
var=$(samtools view -c -F 260 $prefix-sorted.bam); echo "Number of mapped reads = $var" >> assembly_coverage ;

#cat assembly_coverage $prefix-stats > assembly_statistics ;

#Cleanup
rm assembly_coverage ;
rm $prefix.bam ;
rm $prefix.sam;
rm input ;

echo "Done!"

exit 0
