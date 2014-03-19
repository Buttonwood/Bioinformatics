my @a = ("128     3       93","128     3       93","128     3       93");
my @b = map{[$_,split(/\s+/,$_)]} @a;
print @a;
print "\n";
print @{$b->[0]}[0];
foreach (@b){
    print $_->[0];
    print "*";
    print $_->[1];
    print "%";
    print $_->[2];
    print "#";
    print $_->[3];
    print "!\n";
}
