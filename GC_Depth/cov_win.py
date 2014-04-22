def ave_stat(arr=[]):
	sum = 0
	for x in arr:
		if int(x): sum += int(x)
	return  float(sum)/float(len(arr))

def bin_split(istr=[], bin=5000):
	res = []
	idx = 0
	while(idx<len(istr)):
		res.append(ave_stat(istr[idx:idx+bin]))
		idx += bin
	return res

def cov_parse(infile,bin=5000):
	dic = {}
	f = open(infile,'r')
	seq = ''
	name = ''
	for l in f:
		if l[0] == '>':
			t = l.rstrip('\n').split(' ')
			if seq:
				dp = []
				for i in seq.split(' '):
					if i != '' or i != '\n' or i != ' ':
						dp.append(i)
				dp.pop()
				dic[str(name)] = bin_split(dp,bin)
			name = t[0][1:-1] + t[0][-1]
			seq = ''
		else:
			seq += l.rstrip('\n')
	# last line
	if seq:
	    dp = []
        for i in seq.split(' '):
            if i != '' or i != '\n' or i != ' ':
                dp.append(i)
        dp.pop()
        dic[str(name)] = bin_split(dp,bin)
	f.close()
	return dic

def main(infile,bin=5000):
	f = open(infile,'r')
	seq = ''
	name = ''
	for l in f:
		if l[0] == '>':
			t = l.rstrip('\n').split(' ')
			if seq:
				dp = []
				for i in seq.split(' '):
					if i != '' or i != '\n' or i != ' ':
						dp.append(i)
				dp.pop()
				print ">" + str(name) + "\t" + repr(len(dp))
				for x in bin_split(dp,bin):
					if x > 0 :
						print "%.3f" % x,
					else:
						print 0,
				print
			name = t[0][1:-1] + t[0][-1]
			seq = ''
		else:
			seq += l.rstrip('\n')
	#last line
	if seq:
	    dp = []
	    for i in seq.split(' '):
	        if i != '' or i != '\n' or i != ' ':
	            dp.append(i)
	    dp.pop()
        print ">" + str(name) + "\t" + repr(len(dp))
        for x in bin_split(dp,bin):
            if x > 0:
                print "%.3f" % x,
            else:
                print 0,
        print
	f.close()

if __name__ == '__main__':
	import sys
	if len(sys.argv) != 3:
	    print "Usage\t\n python cov_win.py all.coverage 5000"
	    exit(1)
	main(sys.argv[1],int(sys.argv[2]))
