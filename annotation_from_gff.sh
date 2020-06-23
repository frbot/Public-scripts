#!/bin/sh

#Extract annotation from a gff file 
#Usage  annotation_from_gff.sh input

input=$1

grep "CDS" $input > $input-annotation.txt ;
sed -i "s/.*locus_tag=//g" $input-annotation.txt ;
sed -i "s/.*ID=//g" $input-annotation.txt ;
sed -i "s/;product=/\t/g" $input-annotation.txt ;
sed -i "s/;.*$//g" $input-annotation.txt ;

exit 0
