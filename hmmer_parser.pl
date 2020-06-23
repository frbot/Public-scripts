#!/usr/bin/perl -w

use strict;
use Bio::SearchIO;

my $in = Bio::SearchIO->new( -file => $ARGV[0], -format => 'hmmer' );
while ( my $result = $in -> next_result ) {
    ## this is a Bio::Search::Result::HMMERResult object:
    print "Query name: ".$result->query_name."\n";
    ## this should be a Bio::Search::Hsp::HMMERHSP object (but it doesn't behave like one):
    while( my $hit = $result->next_hit ) {
        while( my $hsp = $hit->next_hsp ) {            
            my $percent_id = sprintf("%.2f", $hsp->percent_identity);
            my $percent_q_coverage = sprintf("%.2f", ((($hsp->length('query')/($result->query_length)))*100));
            print "\tHit name: ".$hit->name()."\n";
            print "\tIdentity: ".$percent_id."\%\n";
            print "\tFraction identical: ".$hsp->frac_identical('total')."\n";
            print "\tNumber conserved residues: ".$hsp->num_conserved."\n";
            print "\tQuery length: ".$result->query_length."\n";
            print "\tAlignment length: ".$hsp->length('query')."\n";
            print "\tQuery coverage: $percent_q_coverage\%\n";
            
            ## schema:
            if ( ($percent_id >= 80) and ($percent_q_coverage >= 80) ) {
                print "\t** Result: PRESENT\n\n";
            } elsif ( ($percent_id >= 80) and ($percent_q_coverage < 80) ) {
                print "\t** Result: TRUNCATED\n\n";
            } else {
                print "\t** Result: ABSENT\n\n";
            }
        }
    }
}
