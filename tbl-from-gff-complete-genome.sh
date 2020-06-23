
#! /bin/sh
#Francesca Bottacini
#f.bottacini@umail.ucc.ie

#specify input
input="$1"
proteinID="$2"


#Prepare directory
mkdir tmp ;
cp $input* tmp/ ;
cd tmp ;

cp $input.nucleotide $input.fsa ;

#Extract features without sequence from gff file
grep "ID" $input.gff > sequintmp ;
sed -i "/ID/ s/ /:/g" sequintmp ;

#Process forward and reverse strans ORFs
awk '$7 == "+"' sequintmp > sequinfw ;
awk '$7 == "-"' sequintmp > sequinrv ;

awk '{print $4,$5,$3,$9}'  sequinfw > sequintblfw ;
awk '{print $5,$4,$3,$9}'  sequinrv > sequintblrv ;
cat sequintblfw sequintblrv > sequintbl ;
sed -i "/ / s/ /\t/" sequintbl ;
sed -i "/ / s/ /\t/" sequintbl ;
sed -i "/ / s/ /\t/" sequintbl ;
sed -i "/ / s/ \t/\t/g" sequintbl ;

#Process products and insert proteinID
sed -i "/ID/ s/:/ /g" sequintbl ;

sed -i "/CDS/ s/CDS\tID=/CDS\tprotein_id=gnl\|${proteinID}\|/g" sequintbl ;
sed -i "/;/ s/;/\n\t\t\t\t\t/g" sequintbl ;

sed -i "/ID=/ s/ID\=/\n\t\t\t\t\tID\=/g" sequintbl ;
sed -i "/protein_id\=/ s/protein_id\=/\n\t\t\t\t\tprotein_id\=/g" sequintbl ;
sed -i "/=/ s/=/\t/g" sequintbl ;

#Format tbl file with tabs and returns
mv sequintbl $input.sequin ;

sed ':a;{N;s/\n/;/};ba' $input.sequin > $input.tmptbl ;
sed -e "s/CDS\n\t\t\t\t\tID\t/CDS\t;\t\t\t\t\tprotein_id\tgnl\|${proteinID}\|/g" $input.tmptbl > $input.tbl ;
sed -i "/;/ s/;/\n/g" $input.tbl ;
sed -i "/ID/ s/ID/locus_tag/g" $input.tbl ;
sed -i "/\t/ s/\t\t\t\t\t/\t\t\t/g" $input.tbl ;
sed -i "/>/ s/>.*//g" $input.tbl ;
sed -i "1i >Feature ${input}" $input.tbl ;

#Add hypotheticals to non predicted proteins (altho there should be none)

sed -i "/product/ s/product\t$/product\thypothetical protein/g" $input.tbl ;
sed -i "/CDS/ s/CDS\t$/CDS/g" $input.tbl ;
sed -i "/gene/ s/gene\t$/gene/g" $input.tbl ;
sed -i "/tRNA/ s/tRNA\t$/tRNA/g" $input.tbl ;
sed -i "/rRNA/ s/rRNA\t$/rRNA/g" $input.tbl ;
sed -i "s/ \+/ /g" $input.tbl ;
sed -i "s/ \t/\t/g" $input.tbl ;

#Move files and cleanup
mv $input.tbl ../ ;
mv $input.fsa ../ ;
cd .. ;

rm -fr tmp ;
