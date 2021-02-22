	// RPi3 Mini UART Library

	// 

	.global mu_init, mu_tx, mu_rx, mu_flush

	// Device address - gotten from BCM arm peripherals doc.	
	.equ MINI_UART.BASE,   0x3f215040

	// Register offsets
	// All regs are 8 bits except the BAUD_REG which is 16
	.equ THR_REG,     0x00
	.equ RHR_REG,     0x00
	.equ LSR_REG,     0x14   
	.equ BAUD_REG,    0x28
	

	// Bit offsets (in LSR)
	.equ TX_IDLE,     6  // Bit 6
	.equ TX_FIFO_E,   5  // Bit 5
	.equ RX_FIFO_E,   0  // Bit 0

	
	.text
mu_init:
	
	// The mini-uart seems set up except the
	// rate needs adjustment.

	// baudrate = system_clock_freq / (8 * (BAUD_REG + 1))
	// So, setting BAUD_REG to 270 (0x10e) gets us close to
	// 115200
	
	// adjust the baud rate
	ldr x1, =MINI_UART.BASE
	mov w0, 0x10e
	str w0, [x1, BAUD_REG]
	ret

	// Transmit byte
	// w0 is the byte to write
mu_tx:	ldr x1, =MINI_UART.BASE

	// wait for Tx fifo to be not full 
1:	ldr w2, [x1, LSR_REG]
	tbz  w2, TX_FIFO_E, 1b

	// output the byte
	str w0, [x1, THR_REG]
	ret
	
	// Receive byte
	// Return byte in w0	
mu_rx:	ldr x1, =MINI_UART.BASE

	// Wait for Rx fifo to be not empty
1:	ldr w2, [x1, LSR_REG]
	tbz w2, RX_FIFO_E, 1b

	// Read the byte into w0
	ldr w0, [x1, RHR_REG]
	ret

mu_flush:
	ldr x1, =MINI_UART.BASE
	// wait for Tx to finish up
1:	ldr w2, [x1, LSR_REG]
	tbz w2, TX_IDLE, 1b
	ret

	
	.ltorg
