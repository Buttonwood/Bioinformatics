#/*******************************************************************************
# * Author : HaoTan
# * Email  : tanhao2013@gmail.com
# * Last modified : 2013-12-30 13:01
# * Filename : primer3_in.pl
# * Description: It's a script for creating a PRIMER3 input file 
# *													  based on SSR search results. 
# * *****************************************************************************/

#!/usr/bin/perl
use Bio::SeqIO;
use Data::Dumper;

die("\n\tperl $0 Bee.scafSeq.misa genome.fa\n")unless(@ARGV == 2);
=pod --> A result file from misa.pl
ID      SSR nr. SSR type        SSR     size    start   end
scaffold1__8.6  1       p2      (AT)9   18      10674   10691
scaffold1__8.6  2       p1      (A)11   11      11852   11862
scaffold1__8.6  3       p1      (T)10   10      14539   14548
scaffold2__7.5  1       p1      (T)16   16      72      87
scaffold3_12.0  1       p1      (A)10   10      2711    2720
scaffold3_12.0  2       p1      (A)10   10      2978    2987
scaffold3_12.0  3       p1      (A)10   10      8222    8231
=cut

open (IN,"<$ARGV[0]") || die ("\nError: Couldn't open misa.pl results file (*.misa) !\n\n");

my $filename = $ARGV[0];
$filename =~ s/\.misa//;
open (FH,"<$ARGV[1]") || die ("\nError: Couldn't open source file containing original FASTA sequences !\n\n");
open (OUT,">$filename.p3in");

my %hash;
my $i_seq = Bio::SeqIO->new( -format => 'Fasta', -fh => \*FH );
while((my $seq_obj = $i_seq->next_seq())){
    my $id  = $seq_obj->id;
    my $seq = $seq_obj->seq;
    $seq =~ s/[\d\s>]//g;#remove digits, spaces, line breaks,...
    $seq =~ s/[\n>]//g;
    $seq_hash{$id} = \$seq;
}
close FH;

while (<IN>) {
	my @t = split;
	if (exists $hash{$t[0]}) {
		my ($id,$ssr_nr,$size,$start) = ($t[0],$t[1],$t[4],$t[5]);
		my $seq = ${$seq_hash{$id}};
		print OUT "SEQUENCE_ID=$id"."_$ssr_nr\nSEQUENCE_TEMPLATE=$seq\n";
    	print OUT "PRIMER_PRODUCT_SIZE_RANGE=100-300\n";
    	print OUT "PRIMER_MIN_SIZE=18\n";
    	print OUT "PRIMER_MAX_SIZE=25\n";
    	print OUT "PRIMER_MAX_GC=60.0\n";
    	print OUT "PRIMER_MIN_GC=40.0\n";
    	print OUT "PRIMER_MAX_POLY_X=2\n";
    	print OUT "SEQUENCE_TARGET=",$start-3,",",$size+6,"\n";
    	print OUT "PRIMER_MAX_END_STABILITY=9.0\n=\n"
	}
}

=pod
print Dumper(%seq_hash);
foreach my $x (keys %seq_hash) {
	print ">$x\n";
	print ${$seq_hash{$x}};
	print "\n";
}
=cut
