#!/usr/bin/env python
"""
@@ Name: 		parser_m8_solar.py
@@ Description: A script for pasering a blast m8 file to solar blocks;
@@ Author: 		HaoTan
@@ Email:		tanhao2013@gmail.com
@@ Date: 		2013-12-27 20:37:43
@@ Version: 	1.0
"""

import os
import argparse

def total_score(s=[]):
	t = 0
	for i in s:
		t += abs(float(i))
	return t

def print_list_tuple(lt):
	# l = [(1, 3), (2, 3), (3, 8), (5, 7), (7, 9)]
	# print_list_tuple(l) will be 1,3;2,3;3,8;5,7;7,9;
	s = ''
	for x,y in lt:
		s += repr(x)+","+repr(y)+";"
	return s

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
				#else:	
			else:
				if query:
					text = ''
					text += repr(query) + "\t" + repr(get_st_ed_list_tuple(q_block)) + "\t"
					text += repr(subject) + "\t" + repr(get_st_ed_list_tuple(s_block)) + "\t"
					text += repr(total_score(score)) + "\t" + repr(total_score(iden)) + "\t"
					text += print_list_tuple(q_block) + "\t" + print_list_tuple(s_block) + "\t"
					text += repr(score) + "\t" + repr(iden)
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

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
    	formatter_class=argparse.RawTextHelpFormatter,
        description="""
A Script for pasering a blast m8 file to solar blocks;

blast.m8:
	contig-550123   contig-550123   100.00  991     0       0       1       991     1       991     0.0     1875
	contig-550123   contig-5207937  96.70   454     15      0       537     990     1       454     0.0      741

blast.m8.solar:
	contig-999996   332     272     332     -       contig-5473656  351     291     351     1       121     272,332;
    """)
    parser.add_argument(
    	"-i", "--input",
    	required=True,
    	help="input a blast m8 file")
    parser.add_argument(
    	"-o", "--output",
    	required=True,
    	help="output solar result file")
    args = parser.parse_args()
    main(args)
