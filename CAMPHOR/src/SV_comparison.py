import sys

correct_ans_f = open(sys.argv[1])
call_res_f = open(sys.argv[2])
range_len = int(sys.argv[3])
FN_min_len = int(sys.argv[4])
#rep_type = sys.argv[5]

correct_ans_l = []
for line in correct_ans_f:
	line = line.replace("\n", "")
	line_l = line.split("\t")

#	if line_l[-1] != rep_type:
#		continue

	correct_ans_l.append(line_l)

#chr1    789481  chr1    789481  INS     2320    SC,TR
#chr1    820879  chr1    820879  INS     245     SC,TR
#chr1    876005  chr1    876005  INS     1227    SC,TR
#chr10   321596  chr10   322672  DEL     1076    -,TR
#chr10   321718  chr10   322277  DEL     559     SC,TR

call_res_l = []
for line in call_res_f:
	line = line.replace("\n", "")
	line_l = line.split("\t")

#	if line_l[-1] != rep_type:
#		continue

	call_res_l.append(line_l)

detected_call_res_d = {}
both_num, ans_num, nano_num = 0, 0, 0
for tmp_l1 in correct_ans_l:

	found_l = []
	for tmp_l2 in call_res_l:
		if tmp_l1[0] == tmp_l2[0] and abs(int(tmp_l1[1]) - int(tmp_l2[1])) < range_len and abs(int(tmp_l1[3]) - int(tmp_l2[3])) < range_len and tmp_l1[4] == tmp_l2[4]:
			found_l.append(",".join(tmp_l2[0:7]))
			detected_call_res_d[",".join(tmp_l2[0:7])] = 1

	if len(found_l):
		both_num += 1
	else:
		if float(tmp_l1[5]) >= FN_min_len:
			ans_num += 1
	
for tmp_l2 in call_res_l:
	if not ",".join(tmp_l2[0:7]) in detected_call_res_d:
		if ">" in tmp_l2[5] or float(tmp_l2[5]) >= FN_min_len:
			nano_num += 1

print("Common, GS_only, Nanopore_only", both_num, ans_num, nano_num, sep="\t")
