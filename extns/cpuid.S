
get_midr:	
	mrs x0, MIDR_EL1
	adr x1, 1f
	str x0, [x1]
	ret
	
1:	.dword 0
	
