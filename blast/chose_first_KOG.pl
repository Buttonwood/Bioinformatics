#=============================================================================
#     FileName: chose_first.pl
#         Desc: 
#       Author: tanhao
#        Email: tanhao2013@gmail.com
#     HomePage: http://buttonwood.github.io
#      Version: 0.0.1
#   LastChange: 2014-03-20 14:18:07
#      History:
#=============================================================================

my $curr = "";
my @t;
my $line = "";
while(<>){
    @t = split;
    if ($t[0] =~ /(KOG\d+)/){
        if($curr eq $1){
        	next;
        }else{
            print $line if ($line);
            $curr = $1;
            $line = $_;
        }
    }
}

print $line if ($line);

#*************  Float like a butterfly! Stay like a buttonwood!  *************
