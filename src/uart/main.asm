.includepath "/usr/share/avra"
.include "m48def.inc"

.def zero = r0
.def temp = r1
.def work = r16
.def uart_tx = r17

.equ F_CPU	= 16000000
.equ BAUDRATE	= 9600

.cseg
.org 0
	rjmp main
.org URXCaddr
	rjmp uart_rx

main:	
; todo: port init
; todo: test

uart_init:
.equ UBRR_VAL   = ((F_CPU+BAUDRATE*8)/(BAUDRATE*16)-1)
	ldi     work, HIGH(UBRR_VAL)
	sts     UBRR0H, work

	ldi     work, LOW(UBRR_VAL)
	sts     UBRR0L, work 

	ldi     work, (1<<UMSEL00)|(1<<UCSZ01)|(1<<UCSZ00)
	sts     UCSR0C, work

	lds	work, UCSR0B
	sbr     work, TXEN0
	sbr	work, RXEN0
	sts	UCSR0B, work

loop:	
	ldi uart_tx, 0xaa
	call uart_transmit
	rjmp loop


uart_transmit:
	lds	work, UCSR0A
	sbr 	work, UDRE0
	sts 	UCSR0A, work
	rjmp 	uart_transmit
	sts 	UDR0, uart_tx
	lds	work, UCSR0A
	sbr 	work, TXC0
	sts	UCSR0A, work
uart_transmit_wait:
	lds	work, UCSR0A
	sbrs 	work, TXC0
	rjmp	uart_transmit_wait
	ret

uart_receive:
	lds	work, UCSR0A
	sbrs 	work, RXC0
	rjmp 	uart_receive
	lds 	work, UDR0
	ret

uart_rx:
	
	
