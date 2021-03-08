import sys

f = open(sys.argv[1])
output_file_name = sys.argv[2]
num_files = int(sys.argv[3])

file_handle_l = []
for i in range(num_files):
	file_name = output_file_name + "."  + str(i)
	file_handle_l.append(open(file_name, "w"))

num_row = 0
num_seq = 0
name, seq, q_score, plus = "", "", "", ""
for line in f:
	num_row += 1

	line = line.replace("\n", "")
	
	if num_row%4 == 1:
		name = line
	elif num_row%4 == 2:
		seq = line
	elif num_row%4 == 3:
		q_score = line
	else:
		num_seq += 1
		out_f = file_handle_l[num_seq%num_files]
		print(name, file = out_f)
		print(seq, file = out_f)
		print(q_score, file = out_f)
		print(line, file = out_f)
	
