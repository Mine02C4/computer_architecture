.PHONY: contest syn clean
VFILES:=mipse.v alu.v rfile.v dmem.v imem.v
POWERLOG:=log/mipse.power.log
TIMINGLOG:=log/mipse.max.timing.log
PROGDIRS:=prog_norm prog_swap prog_grade
PROGBASESCORES:=$(addsuffix /base.score,$(PROGDIRS))
PROGCONTESTSCORES:=$(addsuffix /contest.score,$(PROGDIRS))
PROGSCORES:= $(PROGBASESCORES) $(PROGCONTESTSCORES)
BASEMUL=$(shell echo '$(foreach score, $(PROGBASESCORES), $(shell cat $(score)) *) 1' | bc)
CONTESTMUL=$(shell echo '$(foreach score, $(PROGCONTESTSCORES), $(shell cat $(score)) *) 1' | bc)
SLACK=$(shell grep 'slack' -m1 $(TIMINGLOG) | sed -e 's/[^0-9.]*\([0-9.]\+\)$$/\1/g')
TARGETPERIOD=$(shell grep 'create_clock' mipse.tcl | sed -e 's/^[^0-9.]*\([0-9.]\+\)[^0-9.]*/\1/g')

contest: score.score
	cat score.score

score.score: $(PROGSCORES) contest.power base.power contest.period base.period
	echo "e(1/3*l($(BASEMUL) / $(CONTESTMUL)))*(`cat base.power`*`cat base.period`)/(`cat contest.power`*`cat contest.period`)" | bc -l > score.score

contest.period: $(TIMINGLOG) mipse.tcl
	echo "$(TARGETPERIOD) - ($(SLACK))" | bc > contest.period

contest.power: $(POWERLOG)
	grep 'Total Dynamic Power' log/mipse.power.log | sed -e 's/^.*\=[ ]*\([0-9\.]\+\) mW.*/\1/g' | tee contest.power

$(POWERLOG) $(TIMINGLOG): mipse.log

prog_%/contest.score: $(VFILES)
	$(MAKE) -C $(@D)

a.out:	test_mipse.v mipse.v alu.v rfile.v dmem.v imem.v
	iverilog test_mipse.v mipse.v alu.v rfile.v dmem.v imem.v
syn:	mipse.log

mipse.log: mipse.v alu.v rfile.v dmem.v imem.v mipse.tcl
	dc_shell-t -f mipse.tcl | tee mipse.log

clean:
	rm contest.period contest.power $(PROGCONTESTSCORES)

