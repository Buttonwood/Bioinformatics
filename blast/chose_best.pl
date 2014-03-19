#=============================================================================
#     FileName: chose_best.pl
#         Desc: A short script for choosing the best alignment block.
#       Author: tanhao
#        Email: tanhao2013@gmail.com
#     HomePage: http://buttonwood.github.io
#      Version: 0.0.1
#   LastChange: 2014-03-19 15:18:02
#      History:
#=============================================================================
#!/usr/bin/perl -w

die("perl $0 solar.aln >block.best\n") if (@ARGV==0 && -t STDIN);
my $s_curr;
my @t;
my @m;
while (<>) {
	@t = split;
	if ($s_curr eq $t[0]) {
		push(@m, $_);
	} else {
		if (@m) {
			&sort_alignment(\@m);
		}
		$s_curr = $t[0];
		@m = ();
		push(@m, $_);
	}
}

&sort_alignment(\@m) if (@m);

sub sort_alignment {
	my $r_a = shift;
	if (length(@$r_a) < 1){
		print $r_a->[0];
	}else{
		my @s_a = map  { $_->[0] } 
				  sort { #(($b->[10])/($b->[9])) <=> ($a->[10])/($a->[9]) 
			  		#$b->[12] <=> $a[12]
			  		$b->[14] <=> $a[14]
			  		or $b->[13] <=> $a[13]
			  		or $b->[16] <=> $a[16]
			  		or $b->[15] <=> $a[15]
			  		}	
			  map  { [$_,(split(/\s+/,$_))]} @$r_a;
		#print "$#$r_a\t$#s_a\n";
		foreach my $x (@s_a) {
			print $x;
		}
		#print $s_a->[0];
	}
}

=pod
my $file = shift @ARGV;
my $ifh;

my $is_stdin = 0;
if (defined $file){
  open $ifh, "<", $file or die $!;
  print "Parsering $file ... \n";
} else {
  $ifh = *STDIN;
  $is_stdin++;
  print "Parsering STDIN ... \n";
}

while (<$ifh>){
   print $_;
}
close $ifh unless $is_stdin;
=cut
