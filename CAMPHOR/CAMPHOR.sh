#!/bin/bash

BAM=$1
SORTED_BAM=$2
FASTQ=$3
OUTPUT=$4

CONFIG=./pram.config

. $CONFIG

SRC=./src

if [ ! -d $OUTPUT ]; then mkdir $OUTPUT; fi
#echo "$SAMTOOLS view $BAM|python $SRC/read_format.py /dev/stdin $MIN_INDEL_LENGTH 0.3|python $SRC/SV_format.py /dev/stdin 0.05 $MIN_INDEL_LENGTH 0 10 0.3 1000 20 > $OUTPUT/SV_read.txt"
$SAMTOOLS view $BAM|python $SRC/read_format.py /dev/stdin $MIN_INDEL_LENGTH 0.3|python $SRC/SV_format.py /dev/stdin 0.05 $MIN_INDEL_LENGTH 0 10 0.3 1000 20 > $OUTPUT/SV_read.txt

#echo "python $SRC/SV_candidate.py $OUTPUT/SV_read.txt|sort -k2,2g -k3,3 -k4,4g|perl $SRC/SV_format_change.5.pl /dev/stdin > $OUTPUT/SV_read.txt.2"
python $SRC/SV_candidate.py $OUTPUT/SV_read.txt|sort -k2,2g -k3,3 -k4,4g|perl $SRC/SV_format_change.5.pl /dev/stdin > $OUTPUT/SV_read.txt.2

#echo "python $SRC/SV_candidate_INS.py $OUTPUT/SV_read.txt 100000|sort -k2,2g -k3,3 -k4,4g|perl $SRC/SV_format_change.5.pl /dev/stdin|python $SRC/SV_support_read.py /dev/stdin 50 0.2 20 50 1 30 0.3|sort -k1,1 -k2,2g|python $SRC/merge_BP_INS.py /dev/stdin 300 0.8|sort -k1,1 -k2,2g > $OUTPUT/INS_candidate.txt"
python $SRC/SV_candidate_INS.py $OUTPUT/SV_read.txt 100000|sort -k2,2g -k3,3 -k4,4g|perl $SRC/SV_format_change.5.pl /dev/stdin|python $SRC/SV_support_read.py /dev/stdin 50 0.2 20 50 1 30 0.3|sort -k1,1 -k2,2g|python $SRC/merge_BP_INS.py /dev/stdin 300 0.8|sort -k1,1 -k2,2g > $OUTPUT/INS_candidate.txt

#echo "python $SRC/SV_support_read.2.py $OUTPUT/SV_read.txt.2 50 DEL|sort -k1,1 -k2,2g -k3,3 -k4,4g|python $SRC/merge_BP.py /dev/stdin 1000 0.8|sort -k1,1 -k2,2g -k3,3 -k4,4g > $OUTPUT/DEL_candidate.txt"
python $SRC/SV_support_read.2.py $OUTPUT/SV_read.txt.2 50 DEL|sort -k1,1 -k2,2g -k3,3 -k4,4g|python $SRC/merge_BP.py /dev/stdin 1000 0.8|sort -k1,1 -k2,2g -k3,3 -k4,4g > $OUTPUT/DEL_candidate.txt

#echo "python $SRC/SV_support_read.2.py $OUTPUT/SV_read.txt.2 500 CHR > $OUTPUT/CHR_candidate.txt"
python $SRC/SV_support_read.2.py $OUTPUT/SV_read.txt.2 500 CHR > $OUTPUT/CHR_candidate.txt

#echo "python $SRC/SV_support_read.2.py $OUTPUT/SV_read.txt.2 100 DIF|sort -k1,1 -k2,2g -k3,3 -k4,4g|python $SRC/merge_BP.py /dev/stdin 1000 0.8|sort -k1,1 -k2,2g -k3,3 -k4,4g > $OUTPUT/INV_candidate.txt"
python $SRC/SV_support_read.2.py $OUTPUT/SV_read.txt.2 100 DIF|sort -k1,1 -k2,2g -k3,3 -k4,4g|python $SRC/merge_BP.py /dev/stdin 1000 0.8|sort -k1,1 -k2,2g -k3,3 -k4,4g > $OUTPUT/INV_candidate.txt

#echo "python $SRC/SV_support_read.2.py $OUTPUT/SV_read.txt.2 100 TRS|sort -k1,1 -k2,2g -k3,3 -k4,4g|python $SRC/merge_BP.py /dev/stdin 1000 0.8|sort -k1,1 -k2,2g -k3,3 -k4,4g > $OUTPUT/TRS_candidate.txt"
python $SRC/SV_support_read.2.py $OUTPUT/SV_read.txt.2 100 TRS|sort -k1,1 -k2,2g -k3,3 -k4,4g|python $SRC/merge_BP.py /dev/stdin 1000 0.8|sort -k1,1 -k2,2g -k3,3 -k4,4g > $OUTPUT/TRS_candidate.txt

rm $OUTPUT/SV_read.txt $OUTPUT/SV_read.txt.2

python ./src/SV_selection.py $OUTPUT/INS_candidate.txt 2 > $OUTPUT/INS_candidate.txt2
python ./src/SV_selection.py $OUTPUT/DEL_candidate.txt 2 > $OUTPUT/DEL_candidate.txt2
python ./src/SV_selection.py $OUTPUT/CHR_candidate.txt 2 > $OUTPUT/CHR_candidate.txt2
python ./src/SV_selection.py $OUTPUT/INV_candidate.txt 2 > $OUTPUT/INV_candidate.txt2
python ./src/SV_selection.py $OUTPUT/TRS_candidate.txt 2 > $OUTPUT/TRS_candidate.txt2

echo "Filtering deletions"
#echo "python ./src/DEL_filt.py $OUTPUT/DEL_candidate.txt2 30 5000 8|python ./src/DEL_filt2.py /dev/stdin 20 0.1 100 0.3 0.3,1000,0.1 0.1 300 7 7 $MIN_READ_NUMBER 1 1|python ./src/VAF.py /dev/stdin $SORTED_BAM 0 30 1 4 8 > $OUTPUT/DEL_candidate.txt2.VAF"
python ./src/DEL_filt.py $OUTPUT/DEL_candidate.txt2 30 5000 8|python ./src/DEL_filt2.py /dev/stdin 20 0.1 100 0.3 0.3,1000,0.1 0.1 300 7 7 $MIN_READ_NUMBER 1 1|python ./src/VAF.py /dev/stdin $SORTED_BAM 0 30 1 4 8 > $OUTPUT/DEL_candidate.txt2.VAF

#echo "python ./src/SB_CH.py $OUTPUT/DEL_candidate.txt2.VAF 300 $SR $RMSK $FASTQ 11 11|python ./src/DEL_filt3.py /dev/stdin 0,500,1000 $MIN_READ_NUMBER,$MIN_READ_NUMBER,$MIN_READ_NUMBER 11 12 50 0.1 $MIN_VAF 9 15 > $OUTPUT/DEL_candidate.filtered.txt"
python ./src/SB_CH.py $OUTPUT/DEL_candidate.txt2.VAF 300 $SR $RMSK $FASTQ 11 11|python ./src/DEL_filt3.py /dev/stdin 0,500,1000 $MIN_READ_NUMBER,$MIN_READ_NUMBER,$MIN_READ_NUMBER 11 12 50 0.1 $MIN_VAF 9 15 > $OUTPUT/DEL_candidate.filtered.txt

rm $OUTPUT/DEL_candidate.txt2.VAF

echo "Filtering insertions"
#echo "python ./src/INS_filt.py $OUTPUT/INS_candidate.txt2|python ./src/INS_filt2.py /dev/stdin 20 100 0.1 300 1 8 $MIN_READ_NUMBER 1 1|python ./src/INS_VAF.py /dev/stdin $SORTED_BAM 0 30 2 4 7 9 > $OUTPUT/INS_candidate.txt2.VAF"
python ./src/INS_filt.py $OUTPUT/INS_candidate.txt2|python ./src/INS_filt2.py /dev/stdin 20 100 0.1 300 1 8 $MIN_READ_NUMBER 1 1|python ./src/INS_VAF.py /dev/stdin $SORTED_BAM 0 30 2 4 7 9 > $OUTPUT/INS_candidate.txt2.VAF

#echo "python ./src/INS_filt3.py $OUTPUT/INS_candidate.txt2.VAF 1000 $MIN_READ_NUMBER $MIN_READ_NUMBER,$MIN_READ_NUMBER $MIN_VAF 0.8 > $OUTPUT/INS_candidate.filtered.txt"
python ./src/INS_filt3.py $OUTPUT/INS_candidate.txt2.VAF 1000 $MIN_READ_NUMBER $MIN_READ_NUMBER,$MIN_READ_NUMBER $MIN_VAF 0.8 > $OUTPUT/INS_candidate.filtered.txt

rm $OUTPUT/INS_candidate.txt2.VAF

echo "Filtering translocations"
#echo "python ./src/TRS_filt.py $OUTPUT/TRS_candidate.txt2|python ./src/TRS_filt2.py /dev/stdin 20 500 0.1 0.1 800 1 7 $MIN_READ_NUMBER 1 1|python ./src/add_rep.py $SEGDUP /dev/stdin > $OUTPUT/TRS_candidate.txt2.2"
python ./src/TRS_filt.py $OUTPUT/TRS_candidate.txt2|python ./src/TRS_filt2.py /dev/stdin 20 500 0.1 0.1 800 1 7 $MIN_READ_NUMBER 1 1|python ./src/add_rep.py $SEGDUP /dev/stdin > $OUTPUT/TRS_candidate.txt2.2

#echo "python ./src/add_rep2.py $SELF_CHAIN $OUTPUT/TRS_candidate.txt2.2 > $OUTPUT/TRS_candidate.txt2.3"
python ./src/add_rep2.py $SELF_CHAIN $OUTPUT/TRS_candidate.txt2.2 > $OUTPUT/TRS_candidate.txt2.3

#echo "python ./src/rep_filter.py $OUTPUT/TRS_candidate.txt2.3 -4 -3|python ./src/rep_filter.py /dev/stdin -2 -1|python ./src/VAF.py /dev/stdin $SORTED_BAM $MIN_VAF 30 0.5 4 8 > $OUTPUT/TRS_candidate.txt2.4"
python ./src/rep_filter.py $OUTPUT/TRS_candidate.txt2.3 -4 -3|python ./src/rep_filter.py /dev/stdin -2 -1|python ./src/VAF.py /dev/stdin $SORTED_BAM $MIN_VAF 30 0.5 4 8 > $OUTPUT/TRS_candidate.txt2.4

#echo "python ./src/SB_CH2.py $OUTPUT/TRS_candidate.txt2.4 $FASTQ 2 11 11 > $OUTPUT/TRS_candidate.txt2.5"
python ./src/SB_CH2.py $OUTPUT/TRS_candidate.txt2.4 $FASTQ 2 11 11 > $OUTPUT/TRS_candidate.txt2.5

#echo "python ./src/add_rep3.py $SR $OUTPUT/TRS_candidate.txt2.5 2000|python ./src/add_rep3.py $RMSK /dev/stdin 2000 > $OUTPUT/TRS_candidate.txt2.6"
python ./src/add_rep3.py $SR $OUTPUT/TRS_candidate.txt2.5 2000|python ./src/add_rep3.py $RMSK /dev/stdin 2000 > $OUTPUT/TRS_candidate.txt2.6

#echo "python ./src/TRS_filt3.py $OUTPUT/TRS_candidate.txt2.6 0.8 50|python ./src/TRS_filt4.py /dev/stdin 10 0.3 > $OUTPUT/TRS_candidate.filtered.txt"
python ./src/TRS_filt3.py $OUTPUT/TRS_candidate.txt2.6 0.8 50|python ./src/TRS_filt4.py /dev/stdin 10 0.3 > $OUTPUT/TRS_candidate.filtered.txt

rm $OUTPUT/TRS_candidate.txt2.2 $OUTPUT/TRS_candidate.txt2.3 $OUTPUT/TRS_candidate.txt2.4 $OUTPUT/TRS_candidate.txt2.5 $OUTPUT/TRS_candidate.txt2.6

echo "Filtering chromosomal translocations"
#echo "python ./src/TRS_filt.py $OUTPUT/CHR_candidate.txt2|python ./src/TRS_filt2.py /dev/stdin 20 500 0.1 0.1 800 1 7 $MIN_READ_NUMBER 1 1 > $OUTPUT/CHR_candidate.txt2.2"
python ./src/TRS_filt.py $OUTPUT/CHR_candidate.txt2|python ./src/TRS_filt2.py /dev/stdin 20 500 0.1 0.1 800 1 7 $MIN_READ_NUMBER 1 1 > $OUTPUT/CHR_candidate.txt2.2

#echo "python ./src/add_rep.py $SEGDUP $OUTPUT/CHR_candidate.txt2.2 > $OUTPUT/CHR_candidate.txt2.3"
python ./src/add_rep.py $SEGDUP $OUTPUT/CHR_candidate.txt2.2 > $OUTPUT/CHR_candidate.txt2.3

#echo "python ./src/add_rep2.py $SELF_CHAIN $OUTPUT/CHR_candidate.txt2.3 > $OUTPUT/CHR_candidate.txt2.4"
python ./src/add_rep2.py $SELF_CHAIN $OUTPUT/CHR_candidate.txt2.3 > $OUTPUT/CHR_candidate.txt2.4

#echo "python ./src/rep_filter.py $OUTPUT/CHR_candidate.txt2.4 -4 -3|python ./src/rep_filter.py /dev/stdin -2 -1 > $OUTPUT/CHR_candidate.txt2.5"
python ./src/rep_filter.py $OUTPUT/CHR_candidate.txt2.4 -4 -3|python ./src/rep_filter.py /dev/stdin -2 -1 > $OUTPUT/CHR_candidate.txt2.5

#echo "python ./src/VAF.py $OUTPUT/CHR_candidate.txt2.5 $SORTED_BAM $MIN_VAF 30 0.5 4 8 > $OUTPUT/CHR_candidate.txt2.6"
python ./src/VAF.py $OUTPUT/CHR_candidate.txt2.5 $SORTED_BAM $MIN_VAF 30 0.5 4 8 > $OUTPUT/CHR_candidate.txt2.6

#echo "python  ./src/SB_CH2.py $OUTPUT/CHR_candidate.txt2.6 $FASTQ 2 11 11 > $OUTPUT/CHR_candidate.txt2.7"
python  ./src/SB_CH2.py $OUTPUT/CHR_candidate.txt2.6 $FASTQ 2 11 11 > $OUTPUT/CHR_candidate.txt2.7

#echo "python ./src/TRS_filt4.py $OUTPUT/CHR_candidate.txt2.7 10 0.3 > $OUTPUT/CHR_candidate.filtered.txt"
python ./src/TRS_filt4.py $OUTPUT/CHR_candidate.txt2.7 10 0.3 > $OUTPUT/CHR_candidate.filtered.txt

rm $OUTPUT/CHR_candidate.txt2.2 $OUTPUT/CHR_candidate.txt2.3  $OUTPUT/CHR_candidate.txt2.4 $OUTPUT/CHR_candidate.txt2.5 $OUTPUT/CHR_candidate.txt2.6 $OUTPUT/CHR_candidate.txt2.7

echo "Filtering inversions"
#echo "python ./src/TRS_filt.py $OUTPUT/INV_candidate.txt2|python ./src/TRS_filt2.py /dev/stdin 20 500 0.1 0.1 800 1 7 $MIN_READ_NUMBER 1 1 > $OUTPUT/INV_candidate.txt2.2"
python ./src/TRS_filt.py $OUTPUT/INV_candidate.txt2|python ./src/TRS_filt2.py /dev/stdin 20 500 0.1 0.1 800 1 7 $MIN_READ_NUMBER 1 1 > $OUTPUT/INV_candidate.txt2.2

#echo "python ./src/add_rep.py $SEGDUP $OUTPUT/INV_candidate.txt2.2 > $OUTPUT/INV_candidate.txt2.3"
python ./src/add_rep.py $SEGDUP $OUTPUT/INV_candidate.txt2.2 > $OUTPUT/INV_candidate.txt2.3

#echo "python ./src/add_rep2.py $SELF_CHAIN $OUTPUT/INV_candidate.txt2.3 > $OUTPUT/INV_candidate.txt2.4"
python ./src/add_rep2.py $SELF_CHAIN $OUTPUT/INV_candidate.txt2.3 > $OUTPUT/INV_candidate.txt2.4

#echo "python ./src/rep_filter.py $OUTPUT/INV_candidate.txt2.4 -4 -3|python ./src/rep_filter.py /dev/stdin -2 -1 > $OUTPUT/INV_candidate.txt2.5"
python ./src/rep_filter.py $OUTPUT/INV_candidate.txt2.4 -4 -3|python ./src/rep_filter.py /dev/stdin -2 -1 > $OUTPUT/INV_candidate.txt2.5

#echo "python ./src/VAF.py $OUTPUT/INV_candidate.txt2.5 $SORTED_BAM $MIN_VAF 30 0.5 4 8 > $OUTPUT/INV_candidate.txt2.6"
python ./src/VAF.py $OUTPUT/INV_candidate.txt2.5 $SORTED_BAM $MIN_VAF 30 0.5 4 8 > $OUTPUT/INV_candidate.txt2.6

#echo "python  ./src/SB_CH2.py $OUTPUT/INV_candidate.txt2.6 $FASTQ 2 11 11 > $OUTPUT/INV_candidate.txt2.7"
python  ./src/SB_CH2.py $OUTPUT/INV_candidate.txt2.6 $FASTQ 2 11 11 > $OUTPUT/INV_candidate.txt2.7

#echo "python ./src/add_rep3.py $SR $OUTPUT/INV_candidate.txt2.7 2000|python ./src/add_rep3.py $RMSK /dev/stdin 2000 > $OUTPUT/INV_candidate.txt2.8"
python ./src/add_rep3.py $SR $OUTPUT/INV_candidate.txt2.7 2000|python ./src/add_rep3.py $RMSK /dev/stdin 2000 > $OUTPUT/INV_candidate.txt2.8

#echo "python ./src/TRS_filt3.py $OUTPUT/INV_candidate.txt2.8 0.8 50|python ./src/INV_filt.py /dev/stdin 0.8 12|python ./src/TRS_filt4.py /dev/stdin 10 0.3 >  $OUTPUT/INV_candidate.filtered.txt"
python ./src/TRS_filt3.py $OUTPUT/INV_candidate.txt2.8 0.8 50|python ./src/INV_filt.py /dev/stdin 0.8 12|python ./src/TRS_filt4.py /dev/stdin 10 0.3 >  $OUTPUT/INV_candidate.filtered.txt

rm $OUTPUT/INV_candidate.txt2.2 $OUTPUT/INV_candidate.txt2.3 $OUTPUT/INV_candidate.txt2.4 $OUTPUT/INV_candidate.txt2.5 $OUTPUT/INV_candidate.txt2.6 $OUTPUT/INV_candidate.txt2.7 $OUTPUT/INV_candidate.txt2.8

python ./src/vcf.py $OUTPUT/DEL_candidate.filtered.txt $OUTPUT/INS_candidate.filtered.txt $OUTPUT/INV_candidate.filtered.txt $OUTPUT/TRS_candidate.filtered.txt $OUTPUT/CHR_candidate.filtered.txt > $OUTPUT/SV.vcf

echo "Output file" $OUTPUT/SV.vcf

