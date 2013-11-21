#!/usr/bin/perl
use strict;
use warnings;
use Switch;

die(qq/
    Examples:
        perl $0 tab.all.solar.12.iden.best >overlap.case
\n/)unless(@ARGV==1);

open(INSP,">inside.ctg.soap");
open(INAP,">inside.ctg.allpath");
#open(OUT,">other.tmp");

while(<>){
    my @t = split(/\s+/,$_);
    next if($t[4]  < 100 || $t[11] < 100);
    next if($t[15] < 75  || $t[17] < 75); #aln_rate
    
    my $tar = &LOCAL($t[1],$t[2],$t[3]);
    my $que = &LOCAL($t[8],$t[9],$t[10]);
    my $stat = &STATE($t[5],$tar,$que);

    switch ($stat){
        case 1 { # +HH
            if($t[12]<=10 && $t[11] == $t[8]){
                print INSP $_;
            }else{  #coverage
                if ($t[12]<=10 && $t[4] == $t[1]) {
                    print INAP $_;
                }else{
                    if($t[8] > 300 && $t[3] != $t[1]){  
                        print  "1\t$_" if($t[16] > 50  || $t[18] > 50); 
                    }
                }
                #if($t[3] != $t[1]){    print  "+HH\t$_"; }
            }
        }

        # push the array and chose the best!
        case 2 { # +HT *
            if($t[12]<=10 && $t[4] == $t[1]){
                print INAP $_;
            }else{
                print  "2\t$_" if($t[8] > 300 && $t[4] > 150 && $t[11] > 150);
            }
        }

        case 3 { # +HM
            if($t[12]<=10 && $t[4] == $t[1]){
                print INAP $_;
            }else{
                my $ttail = $t[1] - $t[3];
                my $qtail = $t[8] - $t[10];
                if($t[8] > 300){    
                    if($ttail > $qtail){    print  "3\t$_" if($t[9] >= $qtail);   }   
                }
            }
        }
        
        # push the array and chose the best!
        case 4 { # +TH *
            if($t[12]<=10 && $t[8] == $t[11]){
                print INSP $_;
            }else{
                print  "4\t$_" if($t[8] > 300 && $t[4] > 150 && $t[11] > 150);
            }
        }

        case 5 { # +TT
            if ($t[8] > 300 && $t[4] > 150 && $t[11] > 150) {
                print "5\t$_" if($t[16] > 50  || $t[18] > 50);
            }
        }

        case 6 { # +TM
            if ($t[2] > $t[9] && $t[9]<($t[8] - $t[10])){
                print "6\t$_";
            }
        }

        case 7 { # +MH
            if($t[12]<=20 && ($t[8] - $t[11])< 50 ){
                print INSP $_;
            }else{
                print "7\t$_" if($t[16] > 50  || $t[18] > 50);
            }
        }

        case 8 { # +MT
            if($t[12]<=20 && ($t[8] - $t[11])< 50 ){
                print INSP $_;
            }else{
                print "8\t$_" if($t[16] > 50  || $t[18] > 50);
            }
        }

        case 9 {
            print "9\t$_" if($t[16] > 50  || $t[18] > 50);
        }

        case 10 { # -HH
            if($t[12]<=20 && $t[8] == $t[11]){
                print INSP $_;
            }else{
                if($t[12]<=20 && $t[4] == $t[1]) {
                    print INAP $_;                
                } else {
                    print  "10\t$_" if($t[16] > 50  || $t[18] > 50); 
                }
            }
        }

        case 11 { # -HT
            if ($t[12]<=20 && $t[8] == $t[11]) {
                print INSP $_;
            } else {
                if ($t[9] < ($t[1]-$t[3])) {
                    print  "11\t$_" if($t[16] > 50  || $t[18] > 50);
                }
            } 
        }

        case 12{ # -HM
            if ($t[12]<=20 && $t[8] == $t[11]) {
                print INSP $_;
            } else {
                if ($t[9] < ($t[1]-$t[3])){
                    print  "12\t$_" if($t[16] > 50  || $t[18] > 50);
                }
            }
        }

        case 13{ # -TH
            if($t[12]<=10 && $t[8] == $t[11]){
                print INSP $_;
            }else{
                #print  "-TH\t$_" if($t[8] > 300 && $t[4] > 150 && $t[11] > 150);
                print  "13\t$_" if($t[8] > 300 && ($t[16] > 50  || $t[18] > 50));
            } 
        }

        case 14{ # -TT *
            print  "14\t$_" if($t[16] > 50  || $t[18] > 50); 
        }

        case 15{ # -TM
            if ($t[2] < ($t[8] - $t[10])) {
                print  "15\t$_" if($t[16] > 50  || $t[18] > 50);
            }
        }

        case 16{ # -MH
            if ($t[12]<=20 && $t[8] == $t[11]) {
                print INSP $_;
            } else {
                if ($t[9] < ($t[1]-$t[3])){
                    print  "16\t$_" if($t[16] > 50  || $t[18] > 50);
                }
            }
        }

        case 17{ # -MT
            if (($t[1]-$t[3]) < $t[9]) {
                print  "17\t$_" if($t[16] > 50  || $t[18] > 50);
            }
        }

        case 18 {  # -MM
            print "18\t$_" if($t[16] > 50  || $t[18] > 50);
        }

        #else { print OUT $_ ;   }
    }

=pod
    switch($stat){
        case 1 { print "1\t$_"; }
        case 2 { print "2\t$_"; }
        case 3 { print "3\t$_"; }
        case 4 { print "4\t$_"; }
        case 5 { print "5\t$_"; }
        case 6 { print "6\t$_"; }
        case 7 { print "7\t$_"; }
        case 8 { print "8\t$_"; }
        case 9 { print "9\t$_"; }
        case 10 { print "10\t$_"; }
        case 11 { print "11\t$_"; }
        case 12 { print "12\t$_"; }
        case 13 { print "13\t$_"; }
        case 14 { print "14\t$_"; }
        case 15 { print "15\t$_"; }
        case 16 { print "16\t$_"; }
        case 17 { print "17\t$_"; }
        case 18 { print "18\t$_"; }
        else { print "19\t$_"; }
    }
=cut   
}

close INSP;
close INAP;

# &LOCAL($len,$st,$ed);
sub LOCAL{
    my($len,$st,$ed) = @_;
    
    my $alan = $ed - $st;
    my $tail = $len - $ed;

    return 1 if(($st == 0) && ($tail >= 0));
    return 2 if(($st >= 1) && ($tail == 0));
    return 3 if(($st >= 1) && ($tail >= 1) && ($alan >=100)); ###
}

# &STATE("+"||"-",$st,$ed)
sub STATE{
    my($signal,$tflag,$qflag) = @_;
    if($signal eq "+" ){
        return 1 if($tflag == 1 && $qflag == 1); # +HH
        return 2 if($tflag == 1 && $qflag == 2); # +HT *
        return 3 if($tflag == 1 && $qflag == 3); # +HM
        return 4 if($tflag == 2 && $qflag == 1); # +TH *
        return 5 if($tflag == 2 && $qflag == 2); # +TT
        return 6 if($tflag == 2 && $qflag == 3); # +TM 
        return 7 if($tflag == 3 && $qflag == 1); # +MH
        return 8 if($tflag == 3 && $qflag == 2); # +MT
        return 9 if($tflag == 3 && $qflag == 3); # +MM
    }else{
        return 10 if($tflag == 1 && $qflag == 1);# -HH * 
        return 11 if($tflag == 1 && $qflag == 2);# -HT
        return 12 if($tflag == 1 && $qflag == 3);# -HM
        return 13 if($tflag == 2 && $qflag == 1);# -TH
        return 14 if($tflag == 2 && $qflag == 2);# -TT *   
        return 15 if($tflag == 2 && $qflag == 3);# -TM
        return 16 if($tflag == 3 && $qflag == 1);# -MH
        return 17 if($tflag == 3 && $qflag == 2);# -MT
        return 18 if($tflag == 3 && $qflag == 3);# -MM
    }
}
