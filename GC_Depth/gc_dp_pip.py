'''
#=============================================================================
#     FileName: gc_dp_pip.py
#         Desc: A script for gc content and coverage statistics by windows;
                a genome fasta file and soap coverage file needs.
#       Author: tanhao
#        Email: tanhao2013@gmail.com
#     HomePage: http://buttonwood.github.io
#      Version: 0.0.1
#   LastChange: 2014-04-14 15:29:14
#      History:
#=============================================================================
'''
# dic[name] = [1,2,3]
def get_point(dol1={}, dol2={}):
    p = ''
    for s in dol1:
        #print ">" + str(s)
        #print dol1[s]
        #print dol2[s]
        for i in xrange(len(dol1[s])):
            if dol1[s][i] > 0:
                p += "%.3f" % dol1[s][i] + '\t'
            else:
                p += '0' + '\t'
            if dol2[s][i] > 0:
                p += "%.3f" % dol2[s][i] + '\n'
            else:
                p += '0' + '\n'
    return p

# dic[name] = [1,2,3]
def cout(dic=None):
	msg = ''
	if dic == None:
		print "No sequence in diction! Please check your files!"
	else:
		for k in dic:
			msg += ">" + str(k) + '\n'
			for x in dic[k]:
				if x > 0 :
					msg += "%.3f" % x + ' '
				else:
					msg += '0' + ' '
			msg += '\n'
	return msg


if __name__ == '__main__':
    import sys
    import os
    usage = "Usage:\n\t gc_dp_pip.py in.genome.fasta all.coverage [5000](bin)\nExmaples:\n\t gc_dp_pip.py in.genome.fasta all.coverage 1000\n"

    #print "basename", os.path.basename(sys.argv[0])
    #print "abspath",os.path.abspath(sys.argv[0])
    #print "dirname",os.path.dirname(os.path.abspath(sys.argv[0]))

    dirname = os.path.dirname(os.path.abspath(sys.argv[0]))
    sys.path.append(dirname)
    import gc_win as gw
    import cov_win as cw

    if len(sys.argv) < 3:
    	print usage
    	exit(1)
    elif len(sys.argv) == 3:
    	gc_seq = gw.gc_parse(sys.argv[1])
    	cv_seq = cw.cov_parse(sys.argv[2])
        prefix = "5000.bin"
        gc_dat = prefix + ".gc.dat"
        cv_dat = prefix + ".cv.dat"
        dp_dat = prefix + ".dp.dat"
        plot_R = prefix + ".plot.R"
    	pdf    = prefix + ".plot.R.pdf"
        f1 = open(gc_dat,'w')
    	f2 = open(cv_dat,'w')
    	f3 = open(dp_dat,'w')
        f4 = open(plot_R,'w')

        f1.write(cout(gc_seq))
    	f2.write(cout(cv_seq))
    	f3.write(get_point(gc_seq,cv_seq))

        f4.write("pdf(\"%s\");\n" % pdf)
        f4.write("a <- read.table(\"%s\");\n" % dp_dat)
        f4.write("plot(a, xlim=c(0,1), xlab=\"GC Content\", ylab=\"Average Depth (X)\");\ndev.off();\n")

    	f1.close()
    	f2.close()
    	f3.close()
        f4.close()
        os.system('R -f %s' % plot_R)
    elif len(sys.argv) == 4:
    	gc_seq = gw.gc_parse(sys.argv[1],int(sys.argv[3]))
    	cv_seq = cw.cov_parse(sys.argv[2],int(sys.argv[3]))
        prefix = sys.argv[3] + ".bin"
        gc_dat = prefix + ".gc.dat"
        cv_dat = prefix + ".cv.dat"
        dp_dat = prefix + ".dp.dat"
        plot_R = prefix + ".plot.R"
        pdf    = prefix + ".plot.R.pdf"
    	f1 = open(gc_dat,'w')
    	f2 = open(cv_dat,'w')
    	f3 = open(dp_dat,'w')
        f4 = open(plot_R,'w')

        f1.write(cout(gc_seq))
    	f2.write(cout(cv_seq))
    	f3.write(get_point(gc_seq,cv_seq))

        f4.write("pdf(\"%s\");\n" % pdf)
        f4.write("a <- read.table(\"%s\");\n" % dp_dat)
        f4.write("plot(a, xlim=c(0,1), xlab=\"GC Content\", ylab=\"Average Depth (X)\");\ndev.off();\n")

    	f1.close()
    	f2.close()
    	f3.close()
        f4.close()
        os.system('R -f %s' % plot_R)
    else:
        print usage
        exit(1)
