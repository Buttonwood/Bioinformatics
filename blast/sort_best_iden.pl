die ("perl $0 *.aln.best 12 > aln.best.sort") unless (@ARGV == 2);
open(IN,"<$ARGV[0]");

my $curr;
my @text;
while(<IN>){
	my @t = split;
	if ( $t[0] =~ /(KOG\d+)/ ){
		if ($curr eq $1){
	        push(@text,$_);
	    }else{
	    	if (@text){
	    	    &sort_col(\@text,$ARGV[1]);
	    	}
	    	$curr = $1;
	    	@text = ();
	        push(@text,$_);
	    }
	}
}
close IN;

&sort_col(\@text,$ARGV[1]) if (@text);

sub sort_col{
    my $r_a = shift;
    my $col = shift;

    my @sort = map  { $_->[0]}
               sort { $b->[$col] <=> $a->[$col] }
               map  { [$_,(split(/\t/,$_))]} @$r_a;
    
    print @sort;
}
