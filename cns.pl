#/*******************************************************************************
# * Author : HaoTan
# * Email  : tanhao2013@gmail.com
# * Last modified : 2013-11-16 13:01
# * Filename : cns.pl
# * Description: It's a script for pacbio reads correction 
# 				 with the use of a vcf snp sites file and fasta reference 
# * *****************************************************************************/

#!/usr/bin/perl
use Bio::SeqIO;
use Data::Dumper;

die("perl $0 in.fasta vcf.tab.pass >out.fasta\n")unless(@ARGV == 2);
open(FH,"<$ARGV[0]") or die "Cann't open $ARGV[0] $!\n";
my %seq_hash;

my $i_seq = Bio::SeqIO->new( -format => 'Fasta', -fh => \*FH|| \*STDIN );
while((my $seq_obj = $i_seq->next_seq())){
    my $id  = $seq_obj->id;
    my $seq = $seq_obj->seq;
    $seq_hash{$id} = \$seq;
}
close FH;

=pod
print Dumper(%seq_hash);
foreach my $x (keys %seq_hash) {
	print ">$x\n";
	print ${$seq_hash{$x}};
	print "\n";
}
=cut

my $c_pos = 0;
my $c_chr = "";
my $c_seq = "";
my $t_seq = "";
open(SNP,"<$ARGV[1]") or die "Cann't open $ARGV[1] $!\n";
while (<SNP>) {
	next if /#/;
	my @t = split;
	if ($t[0] eq $c_chr) {
		if ($c_pos > $t[1] - 1 ) {
			next;
		}else{
			$c_seq .= substr($t_seq, $c_pos + 1, $t[1] - 1 - $c_pos - 1 );
			$c_seq .= $t[4];
			$c_pos = $t[1] - 1 + length($t[3]) - 1;
		}	
	}else{
		if($c_pos){
			$c_seq .= substr($t_seq, $c_pos + 1);
#=pod
			print ">$c_chr\n";
			#print "$t_seq\n";
			print "$c_seq\n";
		}
#=cut
		#last tail;
		$c_pos = 0;                    # a new seq begin
		$c_chr = $t[0];
		$c_seq = "";
		$t_seq = ${$seq_hash{$c_chr}};
		$c_seq .= substr($t_seq, $c_pos, $t[1] - 1 - $c_pos); # $t[1] - 1 site change
		$c_seq .= $t[4]; # change
		$c_pos = $t[1] - 1 + length($t[3]) - 1;  # 0-start;
	}
}
close SNP;

$c_seq .= substr($t_seq, $c_pos + 1);
print ">$c_chr\n";
#print "$t_seq\n";
print "$c_seq\n";
