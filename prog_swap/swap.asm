	addi $1,$0,400
loop: addi $1,$1,-4
	lw $4,400($1)
	lw $3,0($1)
	sw $4,0($1)
	bne $1,$0,loop
	sw $3,400($1)
	sw  $3, 0x7fff($0)
end: beq $0,$0, end
	add $0,$0,$0
