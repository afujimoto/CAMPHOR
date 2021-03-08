import sys
import re
###contig=<ID=chrY_KI270740_random,length=0>
##SAMPLE=<ID=NA19240>
##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  NA19240
#chr1    59605   .       C       <INS>   30      PASS    END=59605;SVTYPE=INS;SVLEN=244;CONTIG=stitch.085.3.94209.chr1.36179.176179;CONTIG_START=3534;CONTIG_END=3778;SEQ
#chr1    90136   .       C       <INS>   30      PASS    END=90136;SVTYPE=INS;SVLEN=59;CONTIG=stitch.085.3.94209.chr1.36179.176179;CONTIG_START=34215;CONTIG_END=34274;SE
#chr1    90407   .       G       <INS>   30      PASS    END=90407;SVTYPE=INS;SVLEN=59;CONTIG=stitch.080.4.113099.chr1.16179.176179;CONTIG_START=53453;CONTIG_END=53512;S
#chr1    135720  .       G       <INS>   30      PASS    END=135720;SVTYPE=INS;SVLEN=6047;CONTIG=0;CONTIG_START=0;CONTIG_END=0;SEQ=0;IS_TRF=0;SVCLASS=0;CALLSET=bionano;U
#chr1    136212  .       T       <DEL>   30      PASS    END=136213;SVTYPE=DEL;SVLEN=-97;CONTIG=stitch.085.3.94209.chr1.36179.176179;CONTIG_START=80359;CONTIG_END=80359;

f = open(sys.argv[1])
for line in f:
	line = line.replace("\n", "")
	line_l = line.split("\t")
	
	if line[0] == "#":
		continue

	end_pos, length = "", ""
	info_l = line_l[7].split(";")

	if "DUP" in line_l[4]:
		line_l[4] = "INS"

	if not "INS" in line_l[4] and not "DEL" in line_l[4]:
		continue
	
	for tmp in info_l:
		if tmp.startswith("END="):
			end_pos = int(tmp.replace("END=", ""))
		if tmp.startswith("SVLEN="):
			length = abs(int(tmp.replace("SVLEN=", "")))

	line_l[4] = line_l[4].replace("<", "").replace(">", "")
	if line_l[4] == "DEL":
		print(line_l[0], line_l[1], line_l[0], int(line_l[1]) + length, line_l[4], length,  line_l[5], sep="\t")
	else:
		print(line_l[0], line_l[1], line_l[0], int(line_l[1]), line_l[4], length,  line_l[5], sep="\t")
