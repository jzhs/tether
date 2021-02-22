/*
 * 
*/
	
_start:	
	mrs x6, MPIDR_EL1
	and x6, x6, #0x3
	cbz x6, primary_cpu

	adr x5, spin_cpu0
secondary_cpu:
	wfe
	ldr x4, [x5, x6, lsl #3]  // spin_cpu0 + 8*id
	cbz x4, secondary_cpu
	br  x4                    // jump to given addr

	// x0 = core number
	// x1 = address
start_core:
	adr x5, spin_cpu0
	str x1, [x5, x0, lsl #3]  // spin_cpu0 + 8*id
	sev
	ret

	
primary_cpu:
	// jump to the kernel entry
	ldr w0, kernel_entry
	br x0
	
	.ltorg

	.align 3
spin_cpu0:
	.quad 0
spin_cpu1:
	.quad 0
spin_cpu2:
	.quad 0
spin_cpu3:
        .quad 0




	// This final block filled in by firmware
	.org 0xf0
	.word 0x5afe570b  // stub_magic
	.word 0x0         // 0xf4 stub_version
	.word 0x0         // 0xf8 dtb_ptr32
kernel_entry:
	.word 0x0         // 0xfc kernel_entry32

	.org 0x100	
dtb_space:
	// filled in by FW. Should start with 0xd00dfeed
	// or 0xedfe0dd0 in other endianness.
	

	
