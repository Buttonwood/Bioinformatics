#!/usr/bin/env python
'''
#=============================================================================
#     FileName: parser_m8_solar.py
#         Desc: A script for parsering a blast m8 file to solared blocks;
#       Author: tanhao
#        Email: tanhao2013@gmail.com
#     HomePage: http://buttonwood.github.io
#      Version: a.0.1
#   LastChange: 2014-03-19 09:22:07
#      History: 2013-12-27 20:37:43
#=============================================================================
'''

import os
import argparse

def total_score(s = [], t = 1):
	if t == 1:
		return sum([abs(float(i)) for i in s])
	else:
		return sum([float(i) for i in s])

def print_list(l=[]):
	#return ";".join([repr(i) for i in l])
	s = ''
	for x in l:
		s += x +";"
	return s

def print_list_tuple(lt):
	# l = [(1, 3), (2, 3), (3, 8), (5, 7), (7, 9)]
	# print_list_tuple(l) will be 1,3;2,3;3,8;5,7;7,9;
	s = ''
	for x,y in lt:
		s += repr(x)+","+repr(y)+";"
	return s

"""
def find_overlap(at,bt):
    (a,b) = at
    (c,d) = bt
    l1 = abs(b-a) + 1
    l2 = abs(d-c) + 1
"""

def get_st_ed_list_tuple(lt):
	# l = [(1, 3), (2, 3), (3, 8), (5, 7), (7, 9)]
	# get_st_ed_list_tuple(l) will return [1,9]
	(a,b) = lt[0]
	for x,y in lt:
		if a > min(x,y):
			a = min(x,y)
		if b < max(x,y):
			b = max(x,y)
	return [a,b]

def main(args):
	writer	 = open(args.output, "w")
	query 	 = ""
	subject  = ""
	score    = []
	iden     = []
	q_block  = []
	s_block  = []
	with open(args.input,'r') as reader:
		for line in reader:
			fields = line.rstrip("\n").split("\t")
			if query == fields[0]:
				if subject == fields[1]:
					if (int(fields[8]) < int(fields[9])):
						score.append("+"+repr(float(fields[-1])))
					else:
						score.append("-"+repr(float(fields[-1])))
					iden.append(fields[2])
					q_block.append([int(fields[6]),int(fields[7])])
					s_block.append([int(fields[8]),int(fields[9])])
				else:
					if subject:
						# print out
						text  = ''
						a, b  = get_st_ed_list_tuple(q_block)
						text += query   + "\t" + repr(a) + "\t" + repr(b) + "\t"
						if total_score(score,0) < 0:
							text += "-\t"
						else:
							text += "+\t"
						a, b  = get_st_ed_list_tuple(s_block)
						text += subject + "\t" + repr(a) + "\t" + repr(b) + "\t"
						c     = len(iden)
						text += repr(c) + "\t" + "%.1f" % (total_score(score)) + "\t"
						#print text,
						#print "%.2f" % (total_score(iden)/c),
						text += "%.2f" % (total_score(iden)/c)
						text += "\t" + print_list_tuple(q_block) + "\t" + print_list_tuple(s_block) + "\t"
						text += print_list(score) + "\t" + print_list(iden)
						#print text
						#print "\n"
						writer.write(text)
						writer.write("\n")
					subject = fields[1]
					score    = []
					iden     = []
					q_block  = []
					s_block  = []
					if (int(fields[8]) < int(fields[9])):
						score.append("+"+repr(float(fields[-1])))
					else:
						score.append("-"+repr(float(fields[-1])))
					iden.append(fields[2])
					q_block.append([int(fields[6]),int(fields[7])])
					s_block.append([int(fields[8]),int(fields[9])])
			else:
				if query:
					text  = ''
					a, b  = get_st_ed_list_tuple(q_block)
					text += query   + "\t" + repr(a) + "\t" + repr(b) + "\t"
					if total_score(score,0) < 0:
						text += "-\t"
					else:
						text += "+\t"
					a, b  = get_st_ed_list_tuple(s_block)
					text += subject + "\t" + repr(a) + "\t" + repr(b) + "\t"
					c     = len(iden)
					text += repr(c) + "\t" + "%.1f" % (total_score(score)) + "\t"
					#print text,
					#print "%.2f" % (total_score(iden)/c),
					text += "%.2f" % (total_score(iden)/c)
					text += "\t" + print_list_tuple(q_block) + "\t" + print_list_tuple(s_block) + "\t"
					text += print_list(score) + "\t" + print_list(iden)
					#print text
					#print "\n"
					writer.write(text)
					writer.write("\n")
				query = fields[0]
				subject = fields[1]
				score    = []
				if (int(fields[8]) < int(fields[9])):
					score.append("+"+repr(float(fields[-1])))
				else:
					score.append("-"+repr(float(fields[-1])))
				iden     = []
				iden.append(fields[2])
				q_block  = []
				q_block.append([int(fields[6]),int(fields[7])])
				s_block  = []
				s_block.append([int(fields[8]),int(fields[9])])
	if query:
		text  = ''
		a, b  = get_st_ed_list_tuple(q_block)
		text += query   + "\t" + repr(a) + "\t" + repr(b) + "\t"
		if total_score(score,0) < 0:
			text += "-\t"
		else:
			text += "+\t"
		a, b  = get_st_ed_list_tuple(s_block)
		text += subject + "\t" + repr(a) + "\t" + repr(b) + "\t"
		c     = len(iden)
		text += repr(c) + "\t" +  "%.1f" % (total_score(score)) + "\t"
		#print text,
		#print "%.2f" % (total_score(iden)/c),
		text += "%.2f" % (total_score(iden)/c)
		text += "\t" + print_list_tuple(q_block) + "\t" + print_list_tuple(s_block) + "\t"
		text += print_list(score) + "\t" + print_list(iden)
		#print text
		#print "\n"
		writer.write(text)
		writer.write("\n")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
    	formatter_class=argparse.RawTextHelpFormatter,
        description="""
A script for parsering a blast m8 file to solared blocks.

input  ->  blast.m8:
	contig-550123   contig-550123   100.00  991     0       0       1       991     1       991     0.0     1875
	contig-550123   contig-5207937  96.70   454     15      0       537     990     1       454     0.0      741

output ->  blast.m8.solar:
	contig-999996   332     272     332     -       contig-5473656  351     291     351     1       121     272,332;
    """)
    parser.add_argument(
    	"-i", "--input",
    	required=True,
    	help="input a blast m8 file")
    parser.add_argument(
    	"-o", "--output",
    	required=True,
    	help="output a solared file")
    args = parser.parse_args()
    main(args)
