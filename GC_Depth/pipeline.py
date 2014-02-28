import sys
sys.path.append('/project/denovo/02.DuZh/02.scaf/00.soap/00.Fill_gap/01.map/02.soapcov/test')
import gc_win as gw
import cov_win as cw
#import matplotlib
#matplotlib.use("Agg")
#from pylab import *

# dic[name] = [1,2,3]
def get_point(dol1={}, dol2={}):
    p = ''
    for s in dol1:
        print ">" + str(s)
        print dol1[s]
        print dol2[s]
        for i in xrange(len(dol1[s])):
            if dol1[s][i] > 0:
                p += "%.2f" % dol1[s][i] + '\t'
            else:
                p += '0' + '\t'
            if dol2[s][i] > 0:
                p += "%.2f" % dol2[s][i] + '\n'
            else:
                p += '0' + '\n'
    return p

# dic[name] = [1,2,3]
def cout(dic=None):
	msg = ''
	if dic == None:
		print "No sequence dic in"
	else:
		for k in dic:
			msg += ">" + str(k) + '\n'
			for x in dic[k]:
				if x > 0 :
					msg += "%.2f" % x + ' '
				else:
					msg += '0' + ' '
			msg += '\n'
	return msg


if __name__ == '__main__':
    #main()
    import sys
    usage = "usage:\t\n gc_win.py in.fasta all.coverage 5000(bin)"
    if len(sys.argv) < 3:
    	print usage
    	exit(1)
    elif len(sys.argv) == 3:
    	gc_seq = gw.gc_parse(sys.argv[1])
    	cv_seq = cw.cov_parse(sys.argv[2])
    	f1 = open("gc.dat",'w')
    	f2 = open("cov.dat",'w')
    	f3 = open("dth.dat",'w')
    	f1.write(cout(gc_seq))
    	f2.write(cout(cv_seq))
    	f3.write(get_point(gc_seq,cv_seq))
    	f1.close()
    	f2.close()
    	f3.close()
    else:
    	gc_seq = gw.gc_parse(sys.argv[1],int(sys.argv[3]))
    	cv_seq = cw.cov_parse(sys.argv[2],int(sys.argv[3]))
    	f1 = open("gc.dat",'w')
    	f2 = open("cv.dat",'w')
    	f3 = open("dp.dat",'w')
    	f1.write(cout(gc_seq))
    	f2.write(cout(cv_seq))
    	f3.write(get_point(gc_seq,cv_seq))
    	f1.close()
    	f2.close()
    	f3.close()
