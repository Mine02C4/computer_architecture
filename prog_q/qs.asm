	addi $30,$0,0x1000
	addi $1,$0,0
	addi $2,$0,0
	addi $3,$0,10
	jal qs
end: beq $0,$0, end

	addi $4,$0,$2
	addi $5,$0,$3
	lw $6,0($2)
	lw $7,0($3)
	add $8,$6,$7

    lw $3,0($1)
	lw $4,400($1)
	or $4,$4,$3
	sw $4,800($1)
	bne $1,$0,loop
	add $0,$0,$0
	sw  $3, 0x7fff($0)
end: beq $0,$0, end
	add $0,$0,$0
