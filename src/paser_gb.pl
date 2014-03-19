
use strict;
use Bio::SeqIO;

my $in = Bio::SeqIO->new(-format => 'genbank',
						 -file => 'seqs.gb'); 

while( my $seq = $in->next_seq ) {
	print $seq->accession;   	# X95560
	print $seq->description; 	# B.napusmRNAforoleosin-likeprotein(209bp).
	print $seq->length; 		# 209
	print $seq->display_id; 	# X95560
	print $seq->seq; 			# TTCAGTCCGATTCTCGTGCCAGCAACTATAGCCAC etc
	my $species = $seq->species->binomial;
	#my $species_obj = $seq->species;
	#my $species = $species_obj->binomial;
}