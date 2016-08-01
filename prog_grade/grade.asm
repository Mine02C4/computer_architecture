	addi $1,$0,400
loop:
	addi $1,$1,-4
	lw $3,0($1)
	slti $4,$3,85
	bne $4,$0,btest
	addi $5,$0,5
	bne $1,$0, loop
	sw $5,400($1)
	beq $0,$0,exit
	add $0,$0,$0
btest:
	slti $4,$3,60
	bne $4,$0,ctest
	addi $5,$0,4
	bne $1,$0, loop
	sw $5,400($1)
	beq $0,$0,exit
	add $0,$0,$0
ctest:
	slti $4,$3,40
	bne $4,$0,dtest
	addi $5,$0,3
	bne $1,$0, loop
	sw $5,400($1)
	beq $0,$0,exit
	add $0,$0,$0
dtest:
	slti $4,$3,10
	bne $4,$0,etest
	addi $5,$0,2
	bne $1,$0, loop
	sw $5,400($1)
	beq $0,$0,exit
	add $0,$0,$0
etest:
	addi $5,$0,1
	sw $5,400($1)
	bne $1,$0, loop
	add $0,$0,$0
exit:
	sw  $3, 0x7fff($0)
end: beq $0,$0,end
	add $0,$0,$0
