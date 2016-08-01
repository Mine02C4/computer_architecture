.PHONY: contest test syn
POWERLOG:=log/mipse.power.log
PROGDIRS:=prog_norm prog_swap prog_grade
PROGBASESCORES:=$(addsuffix /base.score,$(PROGDIRS))
PROGCONTESTSCORES:=$(addsuffix /contest.score,$(PROGDIRS))
PROGSCORES:= $(PROGBASESCORES) $(PROGCONTESTSCORES)
BASEMUL=$(shell echo '$(foreach score, $(PROGBASESCORES), $(shell cat $(score)) *) 1' | bc)
CONTESTMUL=$(shell echo '$(foreach score, $(PROGCONTESTSCORES), $(shell cat $(score)) *) 1' | bc)

contest: score.score
	cat score.score

score.score: $(PROGSCORES) contest.power base.power
	echo "e(1/3*l($(BASEMUL) / $(CONTESTMUL)))*`cat base.power`/`cat contest.power`" | bc -l | tee score.score

contest.power: $(POWERLOG)
	grep 'Total Dynamic Power' log/mipse.power.log | sed -e 's/^.*\=[ ]*\([0-9\.]\+\) mW.*/\1/g' | tee contest.power

prog_%/contest.score: prog_%
	$(MAKE) -C $<

test:	test_mipse.v mipse.v alu.v rfile.v dmem.v imem.v
	iverilog test_mipse.v mipse.v alu.v rfile.v dmem.v imem.v
syn:	mipse.log

$(POWERLOG): mipse.v alu.v rfile.v dmem.v imem.v mipse.tcl
	dc_shell-t -f mipse.tcl | tee mipse.log


