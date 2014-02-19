.includepath "/usr/share/avra"
.include "m48def.inc"

.def zero = r0
.def work = r16
.def temp = r17

.cseg
.org 0
	rjmp main
.org OC1Aaddr
	rjmp timer_isr

main:	

sp_init:
	ldi	work, low(RAMEND)
	out	SPL, work
	ldi	work, high(RAMEND)
	out	SPH, work

port_init:
	sbi	DDRB, PB3
	cbi	PORTB, PB3

timer_init:
	ldi work, (1 << WGM12) | (1 << CS10)
	sts TCCR1B, work

	ldi work, high((16000000/12000)-1)
	sts OCR1AH, work

	ldi work, low((16000000/12000)-1)
	sts OCR1AL, work
	
	ldi work, (1 << OCIE1A)
	sts TIMSK1, work

	sei
loop:	
	rjmp loop

timer_isr:
	ldi	temp, 255
	in	work, PORTB
	eor	work, temp
	out	PORTB, work
	reti
