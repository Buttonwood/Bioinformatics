#/*******************************************************************************
# * Author : HaoTan
# * Email  : tanhao2013@gmail.com
# * Last modified : 2013-12-26 13:01
# * Filename : split_reads.pl
# * Description: It's a script for spliting a sam file -->
#						into different chr files with fastq reads.
# * *****************************************************************************/

#!/usr/bin/perl
use Switch;
use FileHandle;
use Getopt::Long;
use Data::Dumper;


my ($chr_file,$sam_file,$outdir,$help);
GetOptions(
	"chr:s"    => \$chr_file,
	"sam:s"    => \$sam_file,
	"out:s"    => \$outdir,
	"help:s"   => \$help
);

sub usage{
	print STDERR <<USAGE;

 Description: This is a short script for spliting a sam file -->
			into different chr files with fastq reads.
 Date:	2013-12-26       
 Author:	HaoTan
 Email:	tanhao2013\@foxmail.com

 Options:
	-chr   <s>: the *chr file list as -->
			chr1
			chr2
			unmap

	-sam   <s>: the sam file as or unsorted bam file -->  
			HWI-ST1269:221:D21BEACXX:7:1101:1217:2096       163     ST4.03ch12      ....
	
	-out   <s>: set outdir [./]

	-help  <s>: show this help
    
 Examples:
    	perl split_reads.pl -chr list -sam map.sam 

USAGE
}

if(defined($help) || !defined($chr_file) || !defined($sam_file)){
	&usage;
    die("Usage:\n\t$0 -chr list -sam map.sam  \n");
}

my %fh = ();
if (defined($outdir)) {
	system("mkdir -p $outdir") unless(-e "$outdir");
} else {
	$outdir = `pwd`;
	chomp $outdir;
	system("mkdir -p $outdir");
}

open(CS,"<$chr_file") || die("Input chromsome info file $chr_file can't open $!\n");
while (<CS>) {
	chomp;
    my @inf = split;
    my $chr = $inf[0];
    system("mkdir -p $outdir/$chr") unless(-e "$outdir/$chr");
    # r1 and r2 mapped same chr/unmap chr
    $fh{$chr}{1} = FileHandle->new(">$outdir/$chr/mapped_pe1"); 
    $fh{$chr}{2} = FileHandle->new(">$outdir/$chr/mapped_pe2"); 
    # r1 mapped and r2 unmapped
    $fh{$chr}{3} = FileHandle->new(">$outdir/$chr/mapped_pe_se1"); 
    $fh{$chr}{4} = FileHandle->new(">$outdir/$chr/unmap_pe_se2"); 
    # r2 mapped and r1 unmapped
    $fh{$chr}{6} = FileHandle->new(">$outdir/$chr/mapped_pe_se2");
    $fh{$chr}{5} = FileHandle->new(">$outdir/$chr/unmap_pe_se1"); 
    # r1 mapped and r2 mapped into another chr or not mapped any chr 
    $fh{$chr}{7} = FileHandle->new(">$outdir/$chr/mapped_se_se1"); 
    # r2 mapped and r1 mapped into another chr or not mapped any chr
    $fh{$chr}{8} = FileHandle->new(">$outdir/$chr/mapped_se_se2"); 

}
close CS;

#print Dumper(%fh);

if ($sam_file =~ /.bam/) {
	open(IN,"/usr/bin/samtools view $sam_file |");
} else {
	open(IN,"<$sam_file") or die("Input sam info file $sam_file can't open $!\n");
}

while (<IN>) {
	next if (/^@/);
	my @t = split;
	my $line = <IN>;
	my @a = split(" ",$line);
	$t[2] = ($t[2] eq "*") ? 'unmap' : $t[2];
	$a[2] = ($a[2] eq "*") ? 'unmap' : $a[2];

	switch ($t[1]) {
		case 65 { 
			# This is first read in pair and both reads aligned the forward strand.
			switch ($a[1]){
				case 129 {
					if ($t[2] eq $a[2]) { # same chr
						$fh{$t[2]}{1}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
						$fh{$a[2]}{2}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
					} else { #different chr		
						$fh{$t[2]}{7}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
						$fh{$a[2]}{8}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
					}
				}
			}
		}
		case 69 { 
			#First read in pair. This read is unmapped but its mate is mapped.
			switch ($a[1]){
				case 137 {#second in pair. Read is mapped but mate is unmapped.
					if ($t[2] eq $a[2]) { # same chr
						$fh{$t[2]}{5}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
						$fh{$a[2]}{6}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
					}else{
						$fh{$t[2]}{7}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
						$fh{$a[2]}{8}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
					}	
				}
				case 141 {
					#Second in pair and "all bad".
					#if ($t[2] eq $a[2]) { # same chr 
					#	$fh{$t[2]}{1}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					#	$fh{$a[2]}{2}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
					#}else{
					#	$fh{$t[2]}{7}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					#	$fh{$a[2]}{8}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
					#}	
					$fh{unmap}{1}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{unmap}{2}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
					print "$_\n$line\n";		
				}
			}
		}
		case 73 { 
			#First read in pair. This read is mapped but its mate is not.
			switch ($a[1]){
				case 133 {
					#2nd in pair. Read unmapped but mate is mapped.
					if ($t[2] eq $a[2]) { 
						# same chr
						$fh{$t[2]}{3}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
						$fh{$a[2]}{4}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
					}else{
						$fh{$t[2]}{7}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
						$fh{$a[2]}{8}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
					}	
				}
			}
		}
		case 77 { 
			#First in pair, both reads in pair unmapped. "All bad"
			switch ($a[1]){
				case 141 { 
					# Second in pair and "all bad".
					$fh{unmap}{1}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{unmap}{2}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				}
				case 133 { 
					#2nd in pair. Read unmapped but mate is mapped.
					$fh{unmap}{1}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{unmap}{2}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
					print "$_\n$line\n";
				}
			}
		}
		case 81 { 
			#"this is the first read of pair, both reads mapped, 
			#we had to flip this read, but mate is in forward orientation".
			if ($a[1] eq 161) { 
				# "this is second read, this one is forward 
			    # but we flipped its mate and both reads mapped".
				$t[9] = reverse($t[9]);
				$t[9] =~ tr/AGCTagct/TCGAtcga/;
				$t[10] = reverse($t[10]);
				if ($t[2] eq $a[2]) { # same chr
					$fh{$t[2]}{1}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{$a[2]}{2}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				} else { #different chr		
					$fh{$t[2]}{7}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{$a[2]}{8}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				}
			}   
		}
		case 83 { 
			#163 (0010100011) and 83 (0001010011) are the same as 161 and 81 except 
			#"it is in a proper pair".
			$t[9] = reverse($t[9]);
			$t[9] =~ tr/AGCTagct/TCGAtcga/;
			$t[10] = reverse($t[10]);
			switch ($a[1]){
				case 163 {
					if ($t[2] eq $a[2]) { 
						# same chr
						$fh{$t[2]}{1}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
						$fh{$a[2]}{2}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
					} else { 
						#different chr		
						$fh{$t[2]}{7}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
						$fh{$a[2]}{8}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
					}
				}
				case 167 { 
					#read paired;read mapped in proper pair;
					#read unmapped;mate reverse strand;second in pair
                    $fh{unmap}{1}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{unmap}{2}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
					my $s = join("\t",@t[0..10]);	
					print "$s\n$line\n";
				}
			}	  
		}
		case 85 { 
			#read paired;read unmapped;read reverse strand;first in pair
			if ($a[1] eq 161) { 
				# "this is second read, this one is forward 
			    # but we flipped its mate and both reads mapped".
				$t[9] = reverse($t[9]);
				$t[9] =~ tr/AGCTagct/TCGAtcga/;
				$t[10] = reverse($t[10]);
				$fh{unmap}{1}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
				$fh{unmap}{2}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				my $s = join("\t",@t[0..10]);	
				print "$s\n$line\n";
			}
		}
		case 87 { 
			#read paired;read mapped in proper pair;
			#read unmapped;read reverse strand;first in pair
			if ($a[1] eq 163){ #"this is second read, this one is forward 
							   #but we flipped its mate and both reads mapped".
				$t[9] = reverse($t[9]);
				$t[9] =~ tr/AGCTagct/TCGAtcga/;
				$t[10] = reverse($t[10]);
				if ($t[2] eq $a[2]) { # same chr
					$fh{$t[2]}{1}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{$a[2]}{2}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				} else { #different chr		
					$fh{$t[2]}{7}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{$a[2]}{8}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				}
				my $s = join("\t",@t[0..10]);	
				print "$s\n$line\n";
			}
		}
		case 89 { 
			#read paired;mate unmapped;read reverse strand;first in pair
			if ($a[1] eq 181) { 
				  #read paired;read unmapped;read reverse strand;mate reverse strand;second in pair
				$t[9] = reverse($t[9]);
				$t[9] =~ tr/AGCTagct/TCGAtcga/;
				$t[10] = reverse($t[10]);
				if ($t[2] eq $a[2]) { # same chr
					$fh{$t[2]}{3}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{$a[2]}{4}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				} else { #different chr		
					$fh{$t[2]}{7}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{$a[2]}{8}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				}
			}
		}
		case 93 { 
			#read paired;read unmapped;mate unmapped;read reverse strand;first in pair
			if ($a[1] eq 181) { 
				  #read paired;read unmapped;read reverse strand;mate reverse strand;second in pair
				$t[9] = reverse($t[9]);
				$t[9] =~ tr/AGCTagct/TCGAtcga/;
				$t[10] = reverse($t[10]);
				if ($t[2] eq $a[2]) { # same chr
					$fh{$t[2]}{3}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{$a[2]}{4}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				} else { #different chr		
					$fh{$t[2]}{7}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{$a[2]}{8}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				}
				my $s = join("\t",@t[0..10]);	
				print "$s\n$line\n";
			}
		}
		case 97 { 
			#"this is first read, its mate is flipped but this is forward. Both mapped".
			if ($a[1] eq 145) {
				#"this is second read. it is flipped but its mate is not. Both mapped".
				$a[9] = reverse($a[9]);
				$a[9] =~ tr/AGCTagct/TCGAtcga/;
				$a[10] = reverse($a[10]);
				if ($t[2] eq $a[2]) { # same chr
					$fh{$t[2]}{1}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{$a[2]}{2}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				} else { #different chr		
					$fh{$t[2]}{7}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{$a[2]}{8}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				}
			}
			if ($a[1] eq 149) { #read paired;read unmapped;read reverse strand;second in pair
				$a[9] = reverse($a[9]);
				$a[9] =~ tr/AGCTagct/TCGAtcga/;
				$a[10] = reverse($a[10]);
				if ($t[2] eq $a[2]) { # same chr
					$fh{$t[2]}{1}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{$a[2]}{2}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				} else { #different chr		
					$fh{$t[2]}{7}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{$a[2]}{8}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				}
				my $s = join("\t",@t[0..10]);	
				print "$s\n$line\n";
			}
		}
		case 99 { 
			# 99 (0001100011) and 147 (0010010011) are the same as 
			# 97 and 145 except with "proper mapping in pair".
			if ($a[1] eq 147) {
				#"this is second read. it is flipped but its mate is not. Both mapped".
				$a[9] = reverse($a[9]);
				$a[9] =~ tr/AGCTagct/TCGAtcga/;
				$a[10] = reverse($a[10]);
				if ($t[2] eq $a[2]) { # same chr
					$fh{$t[2]}{1}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{$a[2]}{2}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				} else { #different chr		
					$fh{$t[2]}{7}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{$a[2]}{8}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				}
			}
			if ($a[1] eq 151) { #read paired;read mapped in proper pair;read unmapped;read reverse strand;second in pair
				$a[9] = reverse($a[9]);
				$a[9] =~ tr/AGCTagct/TCGAtcga/;
				$a[10] = reverse($a[10]);
				if ($t[2] eq $a[2]) { # same chr
					$fh{$t[2]}{1}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{$a[2]}{2}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				} else { #different chr		
					$fh{$t[2]}{7}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{$a[2]}{8}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				}
				my $s = join("\t",@t[0..10]);	
				print "$s\n$line\n";
			}
		}
		case 103 { 
			#read paired;read mapped in proper pair;
			#read unmapped;mate reverse strand;first in pair
			if ($a[1] eq 147) { #read paired;read mapped in proper pair;
								#read unmapped;read reverse strand;second in pair
				$a[9] = reverse($a[9]);
				$a[9] =~ tr/AGCTagct/TCGAtcga/;
				$a[10] = reverse($a[10]);
				if ($t[2] eq $a[2]) { # same chr
					$fh{$t[2]}{1}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{$a[2]}{2}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				} else { #different chr		
					$fh{$t[2]}{7}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{$a[2]}{8}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				}
				my $s = join("\t",@t[0..10]);	
				print "$s\n$line\n";
			}
		}
		case 113 { 
			#"this is the first read of a pair, 
			#both reads in pair were flipped and both mapped".
			$t[9] = reverse($t[9]);
			$t[9] =~ tr/AGCTagct/TCGAtcga/;
			$t[10] = reverse($t[10]);
			$a[9] = reverse($a[9]);
			$a[9] =~ tr/AGCTagct/TCGAtcga/;
			$a[10] = reverse($a[10]);
			if ($a[1] eq 177) {
				#"this is the second read of a pair, 
				#both reads in pair were flipped and both mapped"	
				if ($t[2] eq $a[2]) { # same chr
					$fh{$t[2]}{1}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{$a[2]}{2}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				} else { #different chr		
					$fh{$t[2]}{7}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{$a[2]}{8}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				}
			}
			if ($a[1] eq 181) { 
				#read paired;read unmapped;read reverse strand;mate reverse strand;second in pair
				if ($t[2] eq $a[2]) { # same chr
					$fh{$t[2]}{1}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{$a[2]}{2}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				} else { #different chr		
					$fh{$t[2]}{7}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
					$fh{$a[2]}{8}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
				}
				my $s = join("\t",@t[0..10]);
				my $p = join("\t",@a[0..10]);
				print "$s\n$p\n";
			}
		}
		case 117 {
			#read paired ; read unmapped ;read reverse strand ; mate reverse strand ;first in pair
			$t[9] = reverse($t[9]);
			$t[9] =~ tr/AGCTagct/TCGAtcga/;
			$t[10] = reverse($t[10]);
			$a[9] = reverse($a[9]);
			$a[9] =~ tr/AGCTagct/TCGAtcga/;
			$a[10] = reverse($a[10]);
			switch ($a[1]) {
				case 153 {
					#read paired; mate unmapped ; read reverse strand ; second in pair
					if ($t[2] eq $a[2]) { 
						# same chr
						$fh{$t[2]}{5}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
						$fh{$a[2]}{6}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
					} else { 
						#different chr		
						$fh{$t[2]}{7}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
						$fh{$a[2]}{8}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
					}
				}
				case 157 {
					#read paired;read unmapped;mate unmapped;read reverse strand;second in pair
					if ($t[2] eq $a[2]) { 
						# same chr
						$fh{$t[2]}{5}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
						$fh{$a[2]}{6}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
					} else { 
						#different chr		
						$fh{$t[2]}{7}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
						$fh{$a[2]}{8}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
					}
					my $s = join("\t",@t[0..10]);
					my $p = join("\t",@a[0..10]);
					print "$s\n$p\n";
				}
				case 177 {
					#"this is the second read of a pair, both reads in pair were flipped and both mapped"
					if ($t[2] eq $a[2]) { 
						# same chr
						$fh{$t[2]}{5}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
						$fh{$a[2]}{6}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
					} else { 
						#different chr		
						$fh{$t[2]}{7}->print("\@$t[0] 1:N:0\n$t[9]\n+\n$t[10]\n");
						$fh{$a[2]}{8}->print("\@$a[0] 2:N:0\n$a[9]\n+\n$a[10]\n");
					}
					my $s = join("\t",@t[0..10]);
					my $p = join("\t",@a[0..10]);
					print "$s\n$p\n";
				}
			}
		}	
	}
}
close IN;

foreach my $x (keys %fh) {
	foreach my $y (keys %{$fh{$x}}){
		$fh{$x}{$y}->close;
	}
}