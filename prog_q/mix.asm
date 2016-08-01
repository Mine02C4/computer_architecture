	addi $1,$0,400
loop: addi $1,$1,-4
    lw $3,0($1)
	lw $4,400($1)
	or $4,$4,$3
	sw $4,800($1)
	bne $1,$0,loop
	add $0,$0,$0
	sw  $3, 0x7fff($0)
end: beq $0,$0, end
	add $0,$0,$0
