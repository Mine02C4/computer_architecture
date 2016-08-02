#!/usr/bin/env python
print('\tlw $4,0($0)')
print('\tadd $3,$0,$0')
for i in range(100):
	print('\tmult $2,$4,$4')
	if i < 99:
		print('\tlw $4,%d($0)' % ((i + 1) * 4))
	print('\tadd $3,$3,$2')
print('\tsw $3, 0x7fff($0)')
print('end: beq $0,$0, end')
print('\tadd $0,$0,$0')
