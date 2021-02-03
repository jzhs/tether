
	.text
	lr .req x30

start:	
	adr x0, start
	mov sp, x0
	bl mu_init

	
loop:
	bl mu_rx

	// Check for Load command
	cmp w0, #1
	bne 1f
	bl load
	b loop

	// Check for Store command
1:	cmp w0, #2
	bne 2f
	bl store
	b loop

	// Check for Call command
2:	cmp w0, #3
	bne 3f
	bl call
	b loop

3:      // Otherwise just echo it back for now.
	bl mu_tx
	b loop


load:	str lr, [sp, #-16]!
	bl rxword      // read load address
	ldrb w0, [x0]  // read byte at that addr
	bl mu_tx       // transmit
	ldr lr, [sp], #16
	ret
	
store:	str lr, [sp, #-16]!
	bl rxword      // read store address
	mov x19, x0
	bl mu_rx       // read byte to store
	strb w0, [x19] // Store it
	ldr lr, [sp], #16
	ret

call:	str lr, [sp, #-16]!
	bl rxword      // read address to call
	blr x0         // do the call
	ldr lr, [sp], #16
	ret

rxword: str lr, [sp, #-16]!
	mov x19, #0
	bl mu_rx
	add x19, x0, x19
	bl mu_rx
	add x19, x0, x19, lsl 8
	bl mu_rx
	add x19, x0, x19, lsl 8
	bl mu_rx
	add x19, x0, x19, lsl 8
	mov x0, x19
	ldr lr, [sp], #16
	ret
