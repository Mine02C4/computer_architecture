#!/usr/bin/env python
print('\tlw $3,0($0)')
for i in range(100):
	if i % 2 == 0:
		print('\tlw $2,%d($0)' % ((i + 1) * 4))
		print('\tgrade $3,%d($0)' % (i * 4 + 400))
	else:
		if i < 99:
			print('\tlw $3,%d($0)' % ((i + 1) * 4))
		print('\tgrade $2,%d($0)' % (i * 4 + 400))
print('\tsw $3, 0x7fff($0)')
print('end: beq $0,$0, end')
print('\tadd $0,$0,$0')
