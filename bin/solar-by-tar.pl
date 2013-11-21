#! /usr/bin/perl -w

use strict;
die "usage:\n\tperl $0 <lastz.tab>\t<lastz.tab.solar> >trim.tab\n" unless (@ARGV == 2);

open BL, "<$ARGV[0]" or die "can not open $ARGV[0]\n$!";
open OUT,">$ARGV[1]" or die "can not open $ARGV[1]\n$!";

my (@inf,@ele,%hash,@loh);
my ($Qname,$Qlen,$Qstart,$Qend,$symbol,$Sname,$Slen,$Sstart,$Send,$block,$total_score);#,@Se,@Ss,@Qe,@Qs,@defen);

while(<BL>){
    chomp;
    next if(/#/);
    next if(/^$/);
    @inf = split;
    $inf[13]=~ s/%//ig;
    if($inf[13] >= 95){
        push (@{$hash{"$inf[1],$inf[6]"}},$_);
    }else{
        print "$_\n";
    }
}
close BL;

foreach my $key (sort {$b cmp $a } (keys %hash)){
    ($Qname,$Sname) = split /\,/,$key; 
    @loh = @{$hash{$key}};
    $block = $#loh + 1;
    $total_score = 0;
    my ($Salen,$Qalen) = (0,0);
    my (@Se,@Ss,@Qe,@Qs,@defen);
    foreach my $temp (@loh) {
        @ele = split /\s+/ , $temp;
        my $score = $ele[0];
        $total_score += $ele[0];
        #$Qalen += $ele[5];
        #$Salen += $ele[10];
        push (@Qs,$ele[3]);
        push (@Qe,$ele[4]);
        push (@Ss,$ele[8]);
        push (@Se,$ele[9]);
        
        $symbol = $ele[7];
        if ($symbol eq "+"){
             $score = "+".$score;
        }else{
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
    #print OUT "$Qname\t$Qlen\t$Qstart\t$Qend\t$Qalen\t$symbol\t$Sname\t$Slen\t$Sstart\t$Send\t$Salen\t$block\t$total_score\t";
    print OUT "$Qname\t$Qlen\t$Qstart\t$Qend\t$Sname\t$Slen\t$Sstart\t$Send\t$block\t$total_score\t";
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
