#!/usr/bin/env python
for i in range(100):
	print('\tlw $3,%d($0)' % (i * 4))
	print('\tgrade $5,$3')
	print('\tsw $5,%d($0)' % (i * 4 + 400))
print('\tsw $3, 0x7fff($0)')
print('end: beq $0,$0, end')
print('\tadd $0,$0,$0')
