les blastp.m8.solar.12.aln |sort -k1,1 -k11,11rn - |perl chose_first.pl - |perl stat_num.pl - >best.stat.2
grep KOG0258 blastp.m8.solar.12.aln.best.sort.iden |grep At >check.socre
grep KOG0276 blastp.m8.solar.12.aln.best.sort.iden |grep At >>check.socre
grep KOG0394 blastp.m8.solar.12.aln.best.sort.iden |head -1 >>check.socre
grep KOG0898 blastp.m8.solar.12.aln.best.sort.iden |grep At >>check.socre
grep KOG1350 blastp.m8.solar.12.aln.best.sort.iden |grep Hs >>check.socre
grep KOG1750 blastp.m8.solar.12.aln.best.sort.iden |grep Hs >>check.socre
grep KOG2930 blastp.m8.solar.12.aln.best.sort.iden |head -1 >>check.socre
grep KOG3361 blastp.m8.solar.12.aln.best.sort.iden |grep At >>check.socre
grep KOG3405 blastp.m8.solar.12.aln.best.sort.iden |grep At >>check.socre
