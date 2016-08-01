.PHONY: evalans

evalans: contest.score

result.dat: a.out imem.dat dmem.dat
	./a.out | tee out.log

contest.score: out.log answer result.dat
	./evalans.sh

a.out:	test_mipse.v mipse.v alu.v rfile.v dmem.v imem.v
	iverilog test_mipse.v mipse.v alu.v rfile.v dmem.v imem.v
imem.dat:	grade.asm
	./asm.pl grade.asm -o imem.dat
