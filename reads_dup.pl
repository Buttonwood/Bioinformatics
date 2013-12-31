#/*******************************************************************************
# * Author : HaoTan
# * Email  : tanhao2013@gmail.com
# * Last modified : 2013-12-25 13:01
# * Filename : read_dup.pl
# * Description: It's a script for checking fastq duplication reads.
# * *****************************************************************************/

use Getopt::Long;
my ($clean_file,$raw_file1,$raw_file2,$help);
GetOptions(
        "clean:s"  => \$clean_file,
        "raw1:s"   => \$raw_file1,
        "raw2:s"   => \$raw_file2,
        "help:s"   => \$help
);

sub usage{
        print STDERR <<USAGE;

Description: This is a short script for  checking fastq duplication reads.
Version:        1.0
Date:   2012-02-14
Author: HaoTan
Email:  tanhao2013\@foxmail.com

Options:
        -clean <s>: the *.clean.dup.clean.fq1
        -raw1  <s>: the *.fq1
        -raw2  <s>: the *.fq2

        -help  <s>: show this help

Examples:
        perl read_dup.pl -clean clean.dup.clean1 -raw1 fq1 -raw2 fq2

USAGE
}


my %hash;
while (<IN>) {
        chomp;
        my @t = split;
        my $a = substr($t[0],1);
        $hash{$a} = 1;
}
close IN;

open(OUT1,">dup_read1.fq");
open(OUT2,">dup_read2.fq");

if ($raw_file1 =~ /.gz$/) {
        open(IN1,"gzip -dc $raw_file1 | ") or die ("Can not open $raw_file1\n$!");
} else {
        open(IN1,"<$raw_file1") or die ("Can not open $raw_file1\n$!");
}

if ($raw_file2 =~ /.gz$/) {
        open(IN2,"gzip -dc $raw_file2 | ") or die ("Can not open $raw_file2\n$!");
} else {
        open(IN2,"<$raw_file2") or die ("Can not open $raw_file2\n$!");
}

my $s = "";
while (<IN1>) {
        my @t = split;
        my $a = substr($t[0],1);
        if (exists $hash{$a}) {
                           <IN2>;
                <IN1>; <IN2>;
                <IN1>; <IN2>;
                <IN1>; <IN2>;
        } else {
                print OUT1 $_;
                $s = <IN1>; print OUT1 $s;
                $s = <IN1>; print OUT1 $s;
                $s = <IN1>; print OUT1 $s;

                $s = <IN2>; print OUT2 $s;
                $s = <IN2>; print OUT2 $s;
                $s = <IN2>; print OUT2 $s;
                $s = <IN2>; print OUT2 $s;
        }
}
close IN1;
close IN2;
close OUT1;
close OUT2;


if(defined($help) || !defined($clean_file)){
        &usage;
    die("Usage:\n\t$0 -clean clean.dup.clean1 -raw1 fq1 -raw2 fq2 \n");
}

if ($clean_file =~ /.gz$/) {
        open(IN,"gzip -dc $clean_file | ") or die ("Can not open $clean_file\n$!");
} else {
        open(IN,"<$clean_file") or die ("Can not open $clean_file\n$!");
}
