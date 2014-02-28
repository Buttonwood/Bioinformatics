#! /usr/bin/perl -w

use strict;
die "usage:\n\tperl $0 <blast.m8>\t<blast.m8.solar>\n" unless (@ARGV == 2);

open BL, "<$ARGV[0]" or die "can not open $ARGV[0]\n$!";
open OUT,">$ARGV[1]" or die "can not open $ARGV[1]\n$!";

my (@inf,@ele,%hash,@loh);
my ($Qname,$Qlen,$Qstart,$Qend,$symbol,$Sname,$Slen,$Sstart,$Send,$block,$total_score);#,@Se,@Ss,@Qe,@Qs,@defen);

while(<BL>){
    chomp;
    @inf = split;
    push (@{$hash{"$inf[0],$inf[1]"}},$_);
}
close BL;

foreach my $key (sort {$b cmp $a } (keys %hash)){
    ($Qname,$Sname) = split /\,/,$key; 
    @loh = @{$hash{$key}};
    $block = $#loh + 1;
    $total_score = 0;
    my (@Se,@Ss,@Qe,@Qs,@defen);

    foreach my $temp (@loh) {
        @ele = split /\s+/ , $temp;
        my $score = $ele[11];
        $total_score += $ele[11];
        push (@Qs,$ele[6]);
        push (@Qe,$ele[7]);
        push (@Ss,$ele[8]);
        push (@Se,$ele[9]);
        if ( $ele[8] < $ele[9] ){
             $symbol = "+";
             $score = "+".$score;
        }else{
             $symbol = "-";
             $score = "-".$score;
        }
        push @defen,$score;
    }
    ($Qstart,$Qend) = &min_max(@Qs,@Qe);
    my($Qmin,$Qmax) = &min_max($Qstart,$Qend);
    $Qlen = $Qmax;
    ($Sstart,$Send) = &min_max(@Ss,@Se);
    my($Smin,$Smax) = &min_max($Sstart,$Send);
    $Slen = $Smax;
    print OUT "$Qname\t$Qlen\t$Qstart\t$Qend\t$symbol\t$Sname\t$Slen\t$Sstart\t$Send\t$block\t$total_score\t";
    for (my $i=0;$i<$block;$i++){
        print OUT "$Qs[$i],$Qe[$i];";
        }
    print OUT "\t";
    for (my $i=0;$i<$block;$i++){
        print OUT "$Ss[$i],$Se[$i];";
    }
    print OUT "\t";
    for (my $i=0;$i<$block;$i++){
        print OUT  "$defen[$i];";
    }
    print OUT "\n";
}
close OUT;

sub min_max{
    my @arr = sort {$a <=> $b} @_;
    my $min = $arr[0];
    my $max = $arr[-1];
    return ($min,$max); 
}
