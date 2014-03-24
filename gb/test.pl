#*************  Float like a butterfly! Stay like a buttonwood!  *************
#=============================================================================
#     FileName: test.pl
#         Desc: 
#       Author: tanhao
#        Email: tanhao2013@gmail.com
#     HomePage: http://buttonwood.github.io
#      Version: 0.0.1
#   LastChange: 2014-03-19 22:16:40
#      History:
#=============================================================================
#! /usr/local/bin/perl -w


# Homemade Genbank report parser using regular expressions.
# Once desired data is captured, it can be printed in any format.
# WI Bioinformatics course - Feb 2002 - Lecture 6

$gb_report = "Desktop/sequence.gb";

open (GB, $gb_report) || die "cannot open $gb_report for reading: $!";

# Flag for multiline translation; 1 means translation "in preogress"  
$trans = 0;

while (<GB>)
{
   if (/(LOCUS\s*)(\w*)(.*)/)
   {
       #print "Locus: $2\n";
      print ">$2\n";
   }
   elsif (/(VERSION.*GI:)(\d*)/)  
   { 
       #print "GI: $2\n";
   }
   elsif (/(DEFINITION\s*)(.*)(\.)/)
   {
       #print "Sequence name: $2\n";
   }   
   elsif (/(ORGANISM\s*)(.*)/)
   {
       #print "Organism: $2\n";
   }   
   elsif(/(gene)(\s*)(\d*)(\.\.)(\d*)/)
   {
       #print "Gene length: $5\n";
   }
   elsif (/(CDS\s*)(\d*)(\.\.)(\d*)/)   
   # ex: CDS             357..1541
   {
       #$cds_start = $2;
       #$cds_end = $4;
       #print "CDS: $cds_start - $cds_end\n";
   }
   elsif (/(\/translation=")(.*)/)   # protein product begins
   {
       #print "Translation: ";
      $protein = $2;
      $trans = 1;
   }   
   elsif ($trans)   # translation still going on
   {
      if (!/"/)   # no terminal quote; translation continues
      {
         $protein .= $_;
      }
      elsif (/(.*)(")/)   # terminal quote; end of translation
      {
         $protein .= $1;
         $protein =~ s/\s*//g;
         print "$protein\n";
         $trans = 0;
      }
      else
      {
          print "Problems: end of translation product not found.\n";
      }
   }
   else
   {
      # Skip this data
   }
}
