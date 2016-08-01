	add $1,$0,$0
	addi $2,$0,100
	add $3,$0,$0
loop: lw $4,0($1)
	addi $2,$2,-1
	mult $4,$4,$4
	addi $1,$1,4
	bne $2,$0,loop
	add $3,$3,$4
	sw  $3, 0x7fff($0)
end: beq $0,$0,end
	add $0,$0,$0
