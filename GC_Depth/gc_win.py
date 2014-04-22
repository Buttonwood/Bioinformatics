def fasta_parse(infile):
	from Bio import SeqIO
	seq = {}
	for seq_record in SeqIO.parse(infile, "fasta"):
		seq[str(seq_record.id)] = seq_record.seq
	return seq

def gc_parse(infile,bin=5000):
	from Bio import SeqIO
	seq = {}
	for seq_record in SeqIO.parse(infile, "fasta"):
		res = []
		idx = 0
		while(idx<len(seq_record.seq)):
			res.append(gc_rate(seq_record.seq[idx:idx+bin]))
			idx += bin
		seq[str(seq_record.id)] = res
	return seq

def gc(seq):
	gc = 0
	bs = len(seq)
	for s in seq:
		if s == 'G' or s == 'g' or s == 'C' or s == 'c':
			gc += 1
		if s == 'N' or s == 'n':
			bs -= 1
	if bs == 0 or gc == 0:
		return 0
	else:
		return float(gc)/float(bs)

def gc_rate(seq):
	gc = seq.count("C") + seq.count("c") + seq.count("G") + seq.count("g")
	bs = len(seq) - seq.count("N") - seq.count("n")
	if bs == 0 or gc == 0:
		return 0
	else:
		return float(gc)/float(bs)

# dic[name] = [1,2,3]
def cout(dic=None):
	if dic == None:
		print "No sequence dic in"
	else:
		for k in dic:
			print ">" + str(k)
			#print dic[k]
			for x in dic[k]:
				if x > 0 :
					print "%.3f" % x,
				else:
					print 0,
			print

'''
def main():
	from optparse import OptionParser
	usage = "usage: %prog [options] arg"
	parser = OptionParser(usage)
	parser.add_option("-f", "--file", dest="filename",action="store", type="string",
		help="read data from fasta file")
	parser.add_option("-v", "--verbose",action="store_true", dest="verbose")
	parser.add_option("-w", "--window",dest="binsize",action="store",
		help="set the gc window")
	(options, args) = parser.parse_args()

    #if len(args) != 1:
    #    parser.error("incorrect number of arguments")
    #if options.verbose:
    #    print "reading %s..." % options.filename

    seq = fasta_parse(options.f)
    for (k,v) in seq:
        print k,v[0:100]
'''

if __name__ == '__main__':
    #main()
    import sys
    usage = "usage:\t\n gc_win.py in.fasta 5000(bin)"
    if len(sys.argv) < 2:
    	print usage
    	exit(1)
    elif len(sys.argv) == 2:
    	seq = gc_parse(sys.argv[1])
    	#for (k,v) in seq: print k,v
    	cout(seq)
    else:
    	seq = gc_parse(sys.argv[1],int(sys.argv[2]))
    	#for (k,v) in seq: print k,v
    	cout(seq)
    '''
    seq = fasta_parse(sys.argv[1])
    for (k,v) in seq:print k,v[0:100]
    '''
