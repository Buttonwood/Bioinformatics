#!/usr/bin/perl -w
## Contact: tanhao2013@foxmail.com
## Version: 0.1.1

use strict;
use warnings;
use Getopt::Long;
my ($ftb,$fk,$fval,$tk,$tval,$adval,$help,%hash,@inf);
GetOptions(
    "fromtable:s" => \$ftb,
    "fkclum:i"    => \$fk,
    "fvclum:s"    => \$fval,
    "tkclum:i"    => \$tk,
    "tvclum:i"    => \$tval,
    "adclum:i"    => \$adval,
    "help:s"      => \$help
);

sub usage{
    print STDERR <<USAGE;
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Version:1.1.1    2012-02-14       tanhao\@genomics.org.cn  || tanhao2013\@foxmail.com
    Options:
        -fromtable  <s> :from table (the ture list)                  [must]
        -fkclum     <i> :from table key clum (form 1)                [1]
        -fvclum     <s> :from table value clum                       [ ]
                        1,3,5 or 1:5; 
                        Notes: default the whole line (except key clum)

        -tkclum     <i> :to table key clum (same key as fromtable 1) [1]
        -tvclum     <i> :to table value clum update(change to)       [2]
        -adclum     <i> :to table value clum update(add to)          []

        -help       <s> :show this help
    
    Examples:
        perl update_table.pl -fromtable in.table [out.table] > update.table
        perl update_table.pl -fromtable in.table -fkclum 1 -fvclum 2      [out.table] > update.table
        perl update_table.pl -fromtable in.table -fkclum 1 -fvclum 2:4    [out.table] > update.table
        perl update_table.pl -fromtable in.table -fkclum 1 -fvclum 2,3,5  [out.table] > update.table
        perl update_table.pl -fromtable in.table -tkclum 1 -tvclum 2      [out.table] > update.table 
        perl update_table.pl -fromtable in.table -adclum 2                [out.table] > update.table
        perl update_table.pl -fromtable in.table -tkclum 1 -adclum 2      [out.table] > update.table

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
USAGE
}

$fk ||= 1; $tk ||= 1; 
if(!defined($adval)){
    $tval  ||= 2;
}else{
    $adval ||= 2;
}

if (@ARGV == 0 && -t STDIN || defined($help) ||!defined($ftb)){
    &usage;
    die("Usage:\n\t$0 -fromtable in.table [out.table]\n")
}

open(FT,"$ftb") or die "can not open $ftb\n$!";
while(<FT>){
    chomp;
    @inf = split ;
    if(defined($fval)){
        my @fk; my @rest; my $temp;
        if($fval =~ /\,/){
            @fk = split(/\,/,$fval);
            foreach my $i (@fk){
                push @rest, $inf[$i - 1];
            }
            $temp = join("\t",@rest);
            $hash{$inf[$fk - 1]} = $temp;
        }elsif($fval =~ /\:/){
            @fk = split(/\:/,$fval);
            my $st = $fk[0] - 1;
            my $ed = $fk[1] - 1;
            @rest = @inf[$st..$ed];
            $temp = join("\t",@rest);
            $hash{$inf[$fk - 1]} = $temp;
        }else{
            $hash{$inf[$fk - 1]} = $inf[$fval - 1];
        }
    }else{
        my @rest;
        foreach my $i (0..$#inf){
            if($i != $fk - 1){
                push @rest, $inf[$i];
            }
        }
        my $temp = join("\t",@rest);
        $hash{$inf[$fk - 1]} = $temp;
    }
}
close FT;

while(<>){
    chomp;
    @inf = split ;
    if (exists $hash{$inf[$tk - 1]}){
        $inf[$tval - 1] = $hash{$inf[ $tk - 1]} if (defined($tval));
        $inf[$adval - 2] .= "\t".$hash{$inf[ $tk - 1]} if (defined($adval));
    }
    my $line = join ("\t",@inf);
    print "$line\n";
}
