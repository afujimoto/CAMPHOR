import sys
import re
##CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  /archive/data/amed_snt/WORK/james/NA19240_SV_calling_results/20201203_minimap2_v2.17_alignments/NA19240_all.fastq.0.minimap2.sort.bam
#chr1    66239   0       ATTATATTATATAATATATAATATAAATATAATATAA   N       .       PASS    PRECISE;SVMETHOD=Snifflesv1.0.12;CHR2=chr1;END=66276;STD_quant_start=6.164414;STD_quant_stop=5.412947;Kurtosis_quant_start=0.221510;Kurtosis_quant_stop=1.767848;SVTYPE=DEL;SUPTYPE=AL;SVLEN=-37;STRANDS=+-;STRANDS2=9,7,9,7;RE=16;REF_strand=11,13;Strandbias_pval=0.54037;AF=0.666667 GT:DR:DV        0/1:8:16


f = open(sys.argv[1])
for line in f:
	line = line.replace("\n", "")
	line_l = line.split("\t")
	
	if line[0] == "#":
		continue

	end_pos, length, SV_type = "", "", ""
	info_l = line_l[7].split(";")

#SVTYPE=DEL	
	for tmp in info_l:
#		print(tmp)
		if tmp.startswith("END="):
			end_pos = int(tmp.replace("END=", ""))
		if tmp.startswith("SVLEN="):
			length = abs(int(tmp.replace("SVLEN=", "")))
		if tmp.startswith("SVTYPE="):
			SV_type = tmp.replace("SVTYPE=", "")

	if SV_type != "INS" and SV_type != "DEL":
		continue

	if SV_type == "DEL":
		print(line_l[0], line_l[1], line_l[0], end_pos, SV_type, length, sep="\t")
	else:
		print(line_l[0], line_l[1], line_l[0], int(line_l[1]), SV_type, length, sep="\t")
