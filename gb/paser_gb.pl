#=============================================================================
#     FileName: paser_gb.pl
#         Desc: 
#       Author: tanhao
#        Email: tanhao2013@gmail.com
#     HomePage: http://buttonwood.github.io
#      Version: 0.0.1
#   LastChange: 2014-03-10 09:55:24
#      History:
#=============================================================================

#!/usr/local/bin/perl -w
use strict;

use Bio::SeqIO;
use Data::Dumper;
my $seqobj;

#print "please type in the name of a file\n";
my $file = "Desktop/sequence.gb";

my $seqio  = Bio::SeqIO->new (-format => 'GenBank',
                              -file =>   $file);
while ($seqobj = $seqio->next_seq())
{
  printf "Sequence: %s\n",$seqobj->seq;
  #print Dumper($seqobj);
  # I'm not sure what you need other than the
  # sequence - here's some examples:
  #printf "Display ID:  %s\n",$seqobj->display_id;
  #printf "Description: %s\n",$seqobj->desc;
  #printf "Division:    %s\n",$seqobj->division;
  #printf "Accession:   %s\n",$seqobj->accession;
  printf "Accession:   %s\n",$seqobj->translate(-complete => 1)->seq;
}