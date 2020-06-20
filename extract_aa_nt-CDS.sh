#!/bin/sh
#Tools to extract the aminoacidic and nucleotidic multifasta from a genbank file.
#Usage extract_aa_nt-CDS.sh inputfile
#Transeq from EMBOSS package must be installed or in the path

#Francesca Bottacini <f.bottacini@umail.ucc.ie>


input="$1"

cp $input mygbfile.gb ;
sed -i "s/ID=/locus_tag=/g"  mygbfile.gb ;


#Python code
python <<EOF
from Bio import SeqIO
import Bio.SeqIO
import sys
gbk_file = "mygbfile.gb"
fna_file = gbk_file.replace("gb", "fna")
input = open(gbk_file, "r")
geneNC = open(fna_file, "w")
for seq_record in SeqIO.parse(input, "genbank") :
    print "Dealing with GenBank record %s" % seq_record.id
    for seq_feature in seq_record.features :
        geneSeq = seq_feature.extract(seq_record.seq)
        if seq_feature.type == "CDS" :
            assert len(seq_feature.qualifiers['locus_tag'])==1
            geneNC.write(">%s \n%s\n" % (
                seq_feature.qualifiers['locus_tag'][0],
                geneSeq ))
input.close()
geneNC.close()
EOF


#Parsing results

mv myfnafile.fna $input.fna ;

transeq $input.fna myfaafile.faa -frame 1 -table 11 2>/dev/null;

sed -i "s/_1$//"  myfaafile.faa ;
sed -i "s/\*//g"  myfaafile.faa ;

#Generate 2lines aminoacidic multifasta file
cat myfaafile.faa | awk '{if (substr($0,1,1)==">"){if (p){print "\n";} print $0} else printf("%s",$0);p++;}END{print "\n"}' > $input.faa ;

rm mygbfile.gb myfaafile.faa ;

exit 0
