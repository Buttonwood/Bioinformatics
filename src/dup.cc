/* 

*/

#include <bitset>
#include <string>
#include <iostream>  
#include <functional>
#include <unordered_set>
#include <unistd.h>
#include <stdio.h>
#include <time.h>
#include <cstdlib>

using namespace std;

void usage ()
{	
	cout << "This is a little program for duplication reads removing!" << endl;
	cout << "If two PE reads are the same (read1+read2 or complementary strand),"
		 << "we'll treat them the same and discard one!" << endl;
	cout << "Finished date: 2013-11-26\n";
	cout << "By Hao Tan， tanhao2013@gmail.com" << endl;
	
    cout << "\nUsage: duplication [options] read_1.fq read_2.fq <raw_reads_stat> <read_1.clean> <read_2.clean>\n"
         << "  -a <int>  trimed length at 5' end  of read1, default " << Start_trim1 << "\n"
         << "  -b <int>  trimed length at 3' end of read1, default " << End_trim1 << "\n"
         << "  -c <int>  trimed length at 5' end of read2, default " << Start_trim2 << "\n"
         << "  -d <int>  trimed length at 3' end of read2, default " <<End_trim2 << "\n"
         << "  -q <int>  input file type: fq:0 ,fq.gz:1, default " <<file_type <<"\n"
         << "  -m <int>  buffSize ,default " <<buffSize <<"\n"
         << "  -B <int>  filter reads with many low quality bases,set a cutoff, default " << Qual_rate << "\n"
         << "  -l <int>  library insert size, default " <<insert_size << "\n"
         << "  -w <int>  filter reads with >X percent base is N,set a cutoff, default 10" << endl
         << "  -y        filter reads with adapter " << endl
         << "  -z        filter reads with small size " << endl
         << "  -h        output help information\n" << endl;
    exit(1);
}
