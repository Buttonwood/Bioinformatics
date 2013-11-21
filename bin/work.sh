bin="/home/tanh/pro/00.DUZH/01.soap/01.update/02.OLC/00.data/04.map_allpath_soap/bin";
cat *.fa.tab >tab.all;
rm -f *.fa.tab nohup.out;

perl $bin/solar-by-tar.pl tab.all tab.all.solar >tab.all.trim; 
perl $bin/update_table.pl -fromtable /home/tanh/pro/00.DUZH/01.soap/01.update/02.OLC/00.data/03.length/allpath.len -fkclum 1 -fvclum 2 -tkclum 1 -tvclum 2 tab.all.solar  >tab.all.solar.1;
perl $bin/update_table.pl -fromtable /home/tanh/pro/00.DUZH/01.soap/01.update/02.OLC/00.data/03.length/soap.len.tab -fkclum 1 -fvclum 2,3 -tkclum 5 -tvclum 6 tab.all.solar.1 >tab.all.solar.12;
perl $bin/add_iden_all.pl -blast tab.all -solar tab.all.solar.12 -out tab.all.solar.12.iden;
awk '$5>99||$12>99||$17>=50||$19>=50' tab.all.solar.12.iden >tab.all.solar.12.iden.best;

les tab.all.solar.12.iden.best |sort -k1,1 -k3,3n -k4,4rn >tab.all.solar.12.iden.best.sort.tab;
