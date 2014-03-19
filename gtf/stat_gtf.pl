#=============================================================================
#     FileName: stat_gtf.pl
#         Desc: A short script for dealing with gft file statistics!
#       Author: tanhao
#        Email: tanhao2013@gmail.com
#     HomePage: http://buttonwood.github.io
#      Version: 0.0.1
#   LastChange: 2014-03-13 14:03:52
#      History: Get gene locations and cds blocks!
#=============================================================================
#!/usr/bin/perl -w
use Data::Dumper;

die ("perl $0 *.gtf\n" ) unless (@ARGV==1);
open(IN,"<$ARGV[0]") or die ("Can not open $ARGV[0] $!\n");

my %hash     = '';
my $curr_gen = "";
my @arr      = ""; 

while (<IN>) {
	chomp;
	@arr = split/\s|\"|\"|\;/;
	if ($arr[10] eq $curr_gen) {
		if ($arr[2] eq "start_codon") {
			$hash{"start_codon"} = [$arr[3],$arr[4]];
		} elsif ($arr[2] eq "stop_codon") {
			$hash{"stop_codon"}  = [$arr[3],$arr[4]];
		} else {
			push @{$hash{"CDS"}}, [$arr[3],$arr[4]];
		}
	} else {
		if (exists $hash{"ctg"}) {
			print "$curr_gen\t";
			#print Dumper(\%hash);
			deal_with_gene(\%hash);
		}
		$curr_gen = $arr[10];
		#print "ne\t$curr_gen\n";
		%hash     = '';
		$hash{"ctg"} = $arr[0];
		$hash{"strand"} = $arr[6];
		if ($arr[2] eq "start_codon") {
			$hash{"start_codon"} = [$arr[3],$arr[4]];
		} elsif ($arr[2] eq "stop_codon") {
			$hash{"stop_codon"}  = [$arr[3],$arr[4]];
		} else {
			push @{$hash{"CDS"}}, [$arr[3],$arr[4]];
		}
	}
}
close IN;


#-------------------------------------------------------------------------------
# deal_with_gene(\%gene)
sub deal_with_gene{
	my $href = shift;
	#print Dumper($href);
	my $ctg = $href->{"ctg"}; 
	if ($ctg =~ /\_size(\d+)/){
		$ctg .= "\t$1"; 
	}
	my $strand = $href->{"strand"};
	my $st;
	my $ed;
	if ($strand eq "-") { # Notice for - strand;
		if (exists $href->{"start_codon"}) {
			$st =  $href->{"start_codon"}->[1];
		}else{
			$st = "NA"; # May be no strand_codon
		}
		if (exists $href->{"stop_codon"}) {
			$ed =  $href->{"stop_codon"}->[0];
		} else {
			$ed = "NA";
		}
	}else{ # For + strand
		if (exists $href->{"start_codon"}) {
			$st =  $href->{"start_codon"}->[0];
		}else{
			$st = "NA";
		}
		if (exists $href->{"stop_codon"}) {
			$ed =  $href->{"stop_codon"}->[1];
		} else {
			$ed = "NA";
		}
	}
	#my @cds = $href->{"CDS"};
	my $tmp = "";
	my $sum = 0;
	my $num = 0;
	# Deal with cds blocks!
	foreach my $x (@{$href->{"CDS"}}) {
		$num++;
		$sum += abs($x->[1]-$x->[0]) + 1;
		$tmp .= "$x->[0],$x->[1];";
	}
	my $av_len = sprintf("%.2f",$sum/$num);
	print "$ctg\t$strand\t$st\t$ed\t$num\t$sum\t$av_len\t$tmp\n";
}