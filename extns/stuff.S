	.globl midr, elev
	
midr:	mrs x0, MIDR_EL1
	ret

elev:	mrs x0, CurrentEL
	ret

