	.globl midr, elev, mpidr, vbar2, vbar2_set
	
	lr .req x30
	
midr:	mrs x0, MIDR_EL1
	ret

elev:	mrs x0, CurrentEL
	ret

mpidr:  mrs x0, MPIDR_EL1
	ret
	
vbar2:	mrs x0, VBAR_EL2
	ret

vbar2_set:
	msr VBAR_EL2, x0
	ret

	.balign 0x10
	
default_handler:
	//adr x1, str_Except
	//bl uart_puts
	adr x0, start
	msr ELR_EL1, x0
	eret


	.macro vector name handler
\name:	b \handler
	.balign 0x80
	.endm

	// vector table is 2k bytes long and must start on a 2k boundary. 
	.section .vector_tab 
	.global vector_table_el3
	.balign 0x800
vector_table_el3:
	vector   curr_el_sp0_sync        default_handler
	vector   curr_el_sp0_irq         default_handler
	vector   curr_el_sp0_fiq         default_handler
	vector   curr_el_sp0_serror      default_handler
	
	vector   curr_el_spx_sync        default_handler
	vector   curr_el_spx_irq         default_handler
	vector   curr_el_spx_fiq         default_handler
	vector   curr_el_spx_serror      default_handler

	vector   lower_el_aarch64_sync   default_handler
	vector   lower_el_aarch64_irq    default_handler
	vector   lower_el_aarch64_fiq    default_handler
	vector   lower_el_aarch64_serror default_handler

	vector   lower_el_aarch32_sync   default_handler
	vector   lower_el_aarch32_irq    default_handler
