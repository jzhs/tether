
	;;  these equ's from m328pdef.inc
	.equ UBRR0L, 0xc4
	.equ UBRR0H, 0xc5
	.equ UCSR0A, 0xc0
	.equ UCSR0B, 0xc1
	.equ UCSR0C, 0xc2
	.equ UDR0,   0xc6

start:
	rcall uart_init

loop:
	rcall uart_rx
	rcall uart_tx
	rjmp loop

uart_init:
	ldi 	r17, 0x33      ; 19200 baud
	sts     UBRR0L, r17
	clr 	r17
	sts	UBRR0H, r17
	ldi	r17, 0x18	      ;enable TX and RX
	sts 	UCSR0B, r17
	ldi	r17, 6	      ;8 data bits
	sts	UCSR0C, r17
	ret

	; transmit r16 on uart
uart_tx: 
	lds	xl, UCSR0A
	sbrs	xl,5
	rJMP	uart_tx
	sts     UDR0, r16
	ret

	; receive r16 from uart
uart_rx:
	lds	xl,UCSR0A
	sbrs	xl,7
	rjmp    uart_rx
	lds	r16,UDR0
	ret

