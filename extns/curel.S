
get_current_el:	
	mrs x0, CurrentEL
	adr x1, 1f
	str x0, [x1]
	ret
	
1:	.dword 0
	
