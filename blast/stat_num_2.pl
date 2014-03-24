#=============================================================================
#     FileName: stat_num.pl
#         Desc: 
#       Author: tanhao
#        Email: tanhao2013@gmail.com
#     HomePage: http://buttonwood.github.io
#      Version: 0.0.1
#   LastChange: 2014-03-20 14:43:35
#      History:
#=============================================================================

my %hash;
my %gene;
my @t;
my $curr = "";
while(<>){
    @t = split;
    if($t[0] =~ /__(KOG\d+)/){
        #if($curr eq $1){
        $hash{$1}{$t[5]}++;
        #$gene{$t[5]} = $t[11];
        #push @{$gene{$1}}, $t[0];
            #}else{
            #$curr = $1;
            #$hash{$1}{$t[5]}++;
            #push @{$gene{$1}}, $t[0];
            #}
    }
}

#my @s_k = sort{ $a cmp $b} (keys %hash);

foreach my $x (sort{ $a cmp $b} (keys %hash)){
    my $s .= "$x";
    #$s .= "\t".join(";",@{$gene{$x}});
    my $h_ref = $hash{$x};
    #my @sort_ed = sort{$gene{$b} <=> $gene{$a}} (keys %$h_ref);
    #$s .= "\t$sort_ed[1]";
    foreach my $k (sort{$h_ref->{$b} <=> $h_ref->{$a}} (keys %$h_ref)){
        $s .= "\t$k\t$h_ref->{$k}";
    }
    #$s .= "\t".join("\t",@{$gene{$x}});
    print "$s\n";
}


#*************  Float like a butterfly! Stay like a buttonwood!  *************

