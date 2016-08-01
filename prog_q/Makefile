test:	test_mipse.v mipse.v alu.v rfile.v dmem.v imem.v
	iverilog test_mipse.v mipse.v alu.v rfile.v dmem.v imem.v
imem:	mix.asm
	./asm.pl mix.asm -o imem.dat
