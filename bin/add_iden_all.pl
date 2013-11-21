#! /usr/bin/perl -w
use strict;
use Getopt::Long;

my($blast,$solar,$out,$help,%idehash,%lenhash,@inf,@tmp);
GetOptions(
    "blast:s"   => \$blast,
    "solar:s"   => \$solar,
    "out:s"     => \$out,
    "help"      => \$help,
);

if(!defined($blast) || !defined($solar) || !defined($out) || defined($help)){  
    &usage;
    die("Usage:\n\t perl $0 -blast\tlastz.tab\t -solar\tlastz.solar.ck\t -out\tlastz.solar.ck.iden\n");
    exit;
}

open(BL,"$blast");
while(<BL>){
	chomp;
	@inf = split /\t+/;
    $inf[13] =~ s/%//g;
    $idehash{"$inf[1],$inf[6],$inf[3],$inf[4]"}= $inf[13];
}
close BL;

open (SL,"$solar");
open (OUT,">$out");
while(<SL>){
	chomp;
	@tmp = split /\t+/;
    my ($block,$qtag,$ttag) = @tmp[9,11,12];
    my @score = (split /\;/, $tmp[13]);
    my $ture_score = 0;
    foreach my $ele (@score){   
        $ture_score += $ele;
    }
    my $symbol = ($ture_score >=0) ? "+" : "-";

	my @qcor = (split /\;/,$qtag); #  Qstart to Qend
	my $iden=0;
	foreach my $id (@qcor){
		$id =~ /(\d+)\,(\d+)/;
        $iden += $idehash{"$tmp[0],$tmp[4],$1,$2"};
    }

    my $aveid = $iden/$block; # blocks
    my $avscore = abs($ture_score)/$block;
    my $qlen  = &sum_len($qtag);
    my $tlen  = &sum_len($ttag);
    my $qconcov = ($qlen/($tmp[1]))*100; # sca ture  len 
    #my $qalncov = ($qlen/($tmp[5] - $tmp[4] + 1))*100;
    my $qalncov = ($qlen/($tmp[3] - $tmp[2]))*100;
    #my $qnogap  = ($qlen/($tmp[1] - $tmp[2]))*100;
    my $tconcov = ($tlen/($tmp[6]))*100; # tar ture  len
    #my $talncov = ($tlen/($tmp[11] - $tmp[10] + 1))*100;
    my $talncov = ($tlen/($tmp[8] - $tmp[7] ))*100;
    #my $tnogap  = ($tlen/($tmp[7] - $tmp[8] ))*100;

	my $ave = sprintf("%6.2f",$aveid);
    my $asc = sprintf("%6.2f",$avscore);
	my $qcon = sprintf("%6.2f",$qconcov);
    #my $qgap = sprintf("%6.2f",$qnogap);
	my $qaln = sprintf("%6.2f",$qalncov);
    my $tcon = sprintf("%6.2f",$tconcov);
    my $taln = sprintf("%6.2f",$talncov);
    #my $tgap = sprintf("%6.2f",$tnogap);

    $tmp[3]  = "$tmp[3]\t$qlen\t$symbol";
    $tmp[8] = "$tmp[8]\t$tlen";
    #$line2[10]="$line2[10]\t$ave\t$aln\t$con\t";
    $tmp[10] = "$asc\t$ave\t$qaln\t$qcon\t$taln\t$tcon\t";
	
    foreach my $ele (@tmp){ print OUT "$ele\t"; }
	print OUT "\n";
}
close SL;
close OUT;

sub usage{
    print STDERR <<USAGE;
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Version:2.0    2012-02-14       tanhao\@genomics.org.cn  || tanhao2013\@foxmail.com
    Options:
        -blast  <s> :input  blast out file (m8) [must] 
        -solar  <s> :input  solar out file      [must]
        -out    <s> :output file  name          [must] 

        -help   <s> :show this help

    Examples:

        perl add_iden_all.pl -blast blast.out.m8 -solar blast.out.m8.ture.solar -out blast.out.m8.ture.solar.iden

        Then 12-16: av_iden qaln(%) qconcov(%) taln(%) tconcov(%)
             less -S blast.out.m8.ture.solar.iden | sort -k1,1 -k14,14rn -k16,16rn  

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
USAGE
}

=pod
my $text = "791,1573;1,76;796,859;111,141;111,140;";
my $temp = "249203,248485;290637,289941;168371,167932;277873,277434;1693,2126;250692,250260;249532,249964;";
my $re   = &sum_len($text);
print "$text\n$re\n";
my $ra   = &sum_len($temp);
print "$temp\n$ra\n";
=cut

sub sum_len{
    my $tt  = shift;
    my @inf = (split /\;/,$tt);

    my (%hash,%sum) ;
    foreach my $ele (@inf){
        $ele =~ /(\d+)\,(\d+)/;
        if( $1 < $2 ){
            push (@{$hash{$1}},$2);
        }else{
            push (@{$hash{$2}},$1);
        }
    }

    foreach my $key (sort {$a <=> $b} (keys %hash)){
        my @loh = sort {$a <=> $b} ( @{$hash{$key}} );
        $hash{$key} = $loh[-1]; 
        #print "=>$key\t$loh[-1]\n";
    }

    my @st_sort = (sort {$a <=> $b} (keys %hash));
    my $len = $hash{$st_sort[0]} - $st_sort[0] + 1;
    my $lasted = $hash{$st_sort[0]};

    foreach my $t (@st_sort){
        my $st = $t ; my $ed = $hash{$t};# check for overlap
        if ($st <= $lasted ){
            if ($lasted <= $ed){
                $st = $lasted  + 1;
                #$len += $ed - $st + 1 ;
                $len += $ed - $st;
                $lasted = $ed ;
                #print "$st\t$lasted\n";
            }else{
                $len += 0;
            }
        }else{
            #$len += ($ed - $st) +1 ;
            $len += $ed - $st;
            $lasted = $ed  ; 
            #print "$st\t$lasted\n";
        }
    }
    return $len;
}
