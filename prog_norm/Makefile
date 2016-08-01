.PHONY: evalans

evalans: contest.score

out.log: a.out imem.dat dmem.dat
	./a.out | tee out.log

contest.score: out.log
	./evalans.sh

a.out:	test_mipse.v mipse.v alu.v rfile.v dmem.v imem.v
	iverilog test_mipse.v mipse.v alu.v rfile.v dmem.v imem.v
imem.dat:	norm.asm
	./asm.pl norm.asm -o imem.dat
