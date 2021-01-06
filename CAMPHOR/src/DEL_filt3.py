import sys

#chr10   264914  chr10   265033  19      DEL     116     8,8,8   21,22   0.884   0,21/0,22       19      0       10/9    |||     c157f6b6-2439-4ec5-ae52-c2c029ad07df;within;chr10;264772;chr10;264948;10994;26;10981;256725;268314;16.1;60;+;-;-;2|db62a5e4-fdec-438b-864e-d12f4bad07a4;within;chr10;264816;chr10;264990;7548;30;7540;257154;265241;17.4;60;+;-;-;1|c95459fc-fcf2-4c11-9604-701b19376cbf;within;chr10;264826;chr10;265002;10639;33;10612;262864;274087;15.3;60;-;-;-;0|acf959

f = open(sys.argv[1])
len_cutoff_l = sys.argv[2].split(",")
min_dis_cutoff_l = sys.argv[3].split(",")
support_read_col = int(sys.argv[4])
strand_bias_col = int(sys.argv[5])
distance_btw_BP = int(sys.argv[6])
distance_btw_BP_prop = float(sys.argv[7])
VAF_cutoff = float(sys.argv[8])
VAF_col = int(sys.argv[9])
segment_col = int(sys.argv[10])

#print("len_cutoff_l", len_cutoff_l)

len_cutoff_l = [int(i) for i in len_cutoff_l]
min_dis_cutoff_l = [int(i) for i in min_dis_cutoff_l]

for line in f:
	line = line.replace("\n", "")
	line_l = line.split("\t")

#	print("########################")
#	print(line)
#	print(line_l[VAF_col], VAF_cutoff)
	if float(line_l[VAF_col]) < VAF_cutoff:
		continue

	support_read_filt = 0
	for i in range(len(len_cutoff_l) - 1, -1, -1):
		if int(line_l[6]) >= len_cutoff_l[i] and int(line_l[support_read_col]) >= min_dis_cutoff_l[i]:
			support_read_filt += 1
			break

#	print("support_read_filt", support_read_filt, line_l[strand_bias_col])

	if support_read_filt == 0:
		continue
	
	if int(line_l[strand_bias_col]) == 1:
		continue

#54460fbf-e16d-432e-9709-819efedf7d06;within;chr10;930602;chr10;934162;8298;46;8278;926799;938174;15;60;-;-;-;560
	overlap_read_pair = 0
	segment_l = line_l[segment_col].split('|')
	for i in range(len(segment_l)):
		segment_tmp_l1 = segment_l[i].split(";")
		for j in range(i + 1, len(segment_l)):
			segment_tmp_l2 = segment_l[j].split(";")
#			print("1", segment_tmp_l1)
#			print("2", segment_tmp_l2)
			smaller_del_length = min(int(segment_tmp_l1[5]) - int(segment_tmp_l1[3]), int(segment_tmp_l2[5]) - int(segment_tmp_l2[3]))
			distance_btw_BP_cutoff = min(distance_btw_BP, smaller_del_length*distance_btw_BP_prop)
#			print("distance_btw_BP_cutoff", distance_btw_BP_cutoff)
			if abs(int(segment_tmp_l1[3]) - int(segment_tmp_l2[3])) <= distance_btw_BP_cutoff and abs(int(segment_tmp_l1[5]) - int(segment_tmp_l2[5])) <= distance_btw_BP_cutoff:
				overlap_read_pair += 1

#	print("overlap_read_pair", overlap_read_pair)

	if overlap_read_pair >= 1:
		print(line)
