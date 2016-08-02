#!/usr/bin/env python
print('\tlw $3,0($0)')
for i in range(99):
	if i > 0:
		print('\tsw $5,%d($0)' % ((i - 1) * 4 + 400))
	print('\tgrade $5,$3')
	if i < 99:
		print('\tlw $3,%d($0)' % ((i + 1) * 4))
print('\tsw $5, 792($0)')
print('\tgrade $5,$3')
print('\tsw $5, 796($0)')
print('\tsw $3, 0x7fff($0)')
print('end: beq $0,$0, end')
print('\tadd $0,$0,$0')
