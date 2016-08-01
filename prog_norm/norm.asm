	addi $1,$0,396
	add $3,$0,$0
loop:
	lw $4,0($1)
	addi $1,$1,-4
	mult $4,$4,$4
	bne $1,$0,loop
	add $3,$3,$4
	lw $4,0($1)
	mult $4,$4,$4
	add $3,$3,$4
	sw  $3, 0x7fff($0)
end: beq $0,$0,end
	add $0,$0,$0
