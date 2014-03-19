#!/usr/bin/perl -w
#=============================================================================
#     FileName: gtf_stat_cds.pl
#         Desc: 
#       Author: tanhao
#        Email: tanhao2013@gmail.com
#     HomePage: http://buttonwood.github.io
#      Version: 0.0.1
#   LastChange: 2014-03-13 16:34:50
#      History:
#=============================================================================

die ("perl $0 genome.fa *.stat >cds.fa\n") unless (@ARGV==2);
#print ("perl $0 @ARGV\n");

my $fastafile = shift;
my $statfile = shift;

use Bio::SeqIO;
my %hash;
my $inseq = Bio::SeqIO->new(
	-file   => "<$fastafile",
	-format => "fasta",);
while (my $seq = $inseq->next_seq()) {
	$hash{$seq->id} = $seq->seq;
}

=pod
my $hash;
open (IN,"<$fastafile") or die ("Can not open $fastafile $!\n");
$/=">";<>;$/="\n";
while (<IN>) {
	my $title = $_;
	my $seq_name = $1 if($title =~ /^(\S+)/);

	$/=">";
	my $seq=<IN>;
	chomp $seq;
	$seq=~s/\n//g;
	$hash{$seq_name} = $seq;
=pod	
	print ">$seq_name\n";
	Display_seq(\$seq);
	print "$seq\n";
	reverse_and_complement(\$seq);
	Display_seq(\$seq);
	print ">reverse\n$seq\n";
#=cut
	$/="\n";
}
close IN;
=cut

#=pod
$/="\n";
#open(TB,"$ARGV[1]") or die ("Can not open $ARGV[1] $!\n");
open(TB,"<$statfile") or die ("Can not open $statfile $!\n");
#my @t = "";
while (<TB>) {
	chomp;
	my @t = split;
	print ">$t[0]\tloc:$t[1]($t[3]) $t[4]-$t[5] cds:$t[-1]\n";
	my @a = split(/;/,$t[-1]);
	my $seq = "";
	for (my $var = 0; $var < @a; $var++) {
		if ($a[$var] =~ /(\d+),(\d+)/) {
			$seq .= substr($hash{$t[1]},$1-1,($2-$1+1));
		}
	}
	if ($t[3] eq "+") {
		Display_seq(\$seq);
		print $seq;
	}else{
		reverse_and_complement(\$seq);
		Display_seq(\$seq);
		print $seq;
	}
}
close TB;
#=cut

#display a sequence in specified number on each line
#usage: disp_seq(\$string,$num_line);
#               disp_seq(\$string);
#############################################
sub Display_seq{
        my $seq_p=shift;
        my $num_line=(@_) ? shift : 60; ##set the number of charcters in each line
        my $disp;

        $$seq_p =~ s/\s//g;
        for (my $i=0; $i<length($$seq_p); $i+=$num_line) {
                $disp .= substr($$seq_p,$i,$num_line)."\n";
        }
        $$seq_p = ($disp) ?  $disp : "\n";
}
#############################################

#reverse and complement this sequence;
#usage: reverse_and_complement(\$sequence);
#############################################
sub reverse_and_complement {
	my $seq_p = shift;
	$$seq_p = reverse $$seq_p;
	$$seq_p =~ tr/AGCTagct/TCGAtcga/;
	#return $seq_p;
}
#############################################
