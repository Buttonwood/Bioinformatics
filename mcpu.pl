#!/usr/bin/perl -w
## Author : Hao Tan
## Email  : tanhao2013@foxmail.com
## Version: 0.1.1
## Date   : 2013-12-19
## Description: It's a useful script for mutiple job submition!

die "Usage:\n$0 cpu_umber shell_file\n" if (@ARGV!=2);
my $cpu=$ARGV[0];
my $shell_file=$ARGV[1];
my @cmd;

open (IN,"<$shell_file") or die "Something is wrong here! Please checking!\n";
while(<IN>){
        chomp;
        s/&$//g;
        next if(/^$/);
        next if(/#/);
        push @cmd,$_;
}
close IN;

for (my $i=0; $i<=$#cmd; $i++) {
        my $cmd=$cmd[$i];
    #print "$i\n";
        defined (my $id=fork ()) || die "Can not fork:$!";
        if ( $id !=0 ) {
                wait if($i+1 >= $cpu);
        }else{
                exec $cmd;
                exit 0;
        }
}

waitpid (-1,0);
