#=============================================================================
#     FileName: add_rate.pl
#         Desc: A short script for adding the aln rate and coverage rate info. 
#       Author: tanhao
#        Email: tanhao2013@gmail.com
#     HomePage: http://buttonwood.github.io
#      Version: 0.0.1
#   LastChange: 2014-03-19 12:50:35
#      History:
#=============================================================================
#!/usr/bin/perl -w

use Data::Dumper;

die("perl $0 *blast.m8.solar > solar.aln\n")unless(@ARGV == 1);
open(IN,"<$ARGV[0]");

while(<IN>){
	chomp;
	my @t = split /\s+/;
	my ($sc,$qc,$sa,$qa,$sl,$ql) = (0,0,0,0,0);
	$ql = $t[3]-$t[2] + 1;
	$qc = sprintf("%.2f",$ql*100/$t[1]);
    $sl = $t[8]-$t[7] + 1;
    $sc = sprintf("%.2f",$sl*100/$t[6]);
    if($t[9] == 1){
        $sa = $sc;
        $qa = $qc;
    }else{
        $qa = sprintf("%.2f",block_sort($t[12])*100/$ql);
        $sa = sprintf("%.2f",block_sort($t[13])*100/$sl);
    }
	$t[11] .= "\t$qc\t$qa\t$sc\t$sa";
	my $s = join("\t",@t);
	print "$s\n";
}
close IN;

#=============================================================================
#   my $tmp = "11,139;20,136;194,430;599,781;1,24;";
#   &block_sort($tmp);
#=============================================================================
sub block_sort{
    my $p= shift;
    my @a = split(/;/,$p);
    my @aoa;
    
    foreach (@a){   push @aoa, [$1,$2] if(/(\d+),(\d+)/);   }
    #print Dumper(\@aoa);

    my @sorted = sort{$a->[0] <=> $b->[0] or $a->[1] <=> $b->[1]} @aoa;
    #print Dumper(\@sorted);
    
    my $a = $sorted[0]->[0];
    my $b = $sorted[0]->[1];
    my $s = $b - $a + 1;
    #print "****$a#\t!$b****\n";
    foreach (@sorted) {
        #print "$_->[0]\t$_->[1]";
        # [a,b,c,d]
        if($_->[0] <= $a){
            if($_->[1] > $b){
                $s += $_->[1] - $b;
                $b  = $_->[1];
                #print "\t$a\t$b\t$s\ta,b < c,d\n";
            }else{
                #print "\t$a\t$b\t$s\tc,d < a,b\n";
            }
            #print "\t$a\t$b\t$s\n";
        }else{
        	if($_->[0] > $b){
        		$a  = $_->[0];
        		$s += $_->[1] - $a + 1;
        		$b  = $_->[1];
                #print "\t$a\t$b\t$s\ta,b << c,d\n";
        	}
            else{
            	$a  = $_->[0];
                if($_->[1] > $b){
                    $s += $_->[1] - $b;
                    $b  = $_->[1];
                    #print "\t$a\t$b\t$s\ta < c < b < d\n";
                }else{
                    #print "\t$a\t$b\t$s\ta < c < d < b\n";
                }
            }
            #print "\t$a\t$b\t$s\n";
        }
    }
    return $s;
}

#*************  Float like a butterfly! Stay like a buttonwood!  *************
