#=============================================================================
#     FileName: cegma_train.sh
#         Desc: A short script for training a cegma annotation for SNP hmm set!
#       Author: tanhao
#        Email: tanhao2013@gmail.com
#     HomePage: http://buttonwood.github.io
#      Version: 0.0.1
#   LastChange: 2013-03-21 10:13:08
#      History:
#=============================================================================

if [ $# != 2 ];then
    echo "sh $0 cegma.gff genome.fa";
    exit;
fi

SNP_BIN=""
MAKER_BIN=""

mkdir 0.Trainning
mkdir 1.SNP
time
cd 0.Trainning
$MAKER_BIN/cegma2zff $1 $2;
$SNP_BIN/fathom genome.ann genome.dna -categorize 1000;
$SNP_BIN/fathom -export 1000 -plus uni.ann uni.dna;
$SNP_BIN/forge export.ann export.dna;
$SNP_BIN/hmm-assembler.pl $2 . > $2.cegmasnap.hmm;
time
echo "Trainning Done!"
cd ../1.SNP
$SNP_BIN/snap 0.Trainning/$2.cegmasnap.hmm $2 -gff;
cd ../
time
echo "SNPA Done!"
