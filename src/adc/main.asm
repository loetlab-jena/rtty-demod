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
	ldi 	work, 255
	out	DDRD, work

adc_init: 
	ldi work, (0 << REFS1) | (1 << REFS0) | (1 << ADLAR) | (0 << MUX3) | (0 << MUX2) | (0 << MUX1) | (1 << MUX0)
	sts ADMUX, work

	ldi work, (1 << ADEN) | (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0)
	sts ADCSRA, work
	
	ldi work, (1 << ADC1D)
	sts DIDR0, work

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
	; blink LED
	ldi	temp, 255
	in	work, PORTB
	eor	work, temp
	out	PORTB, work
	
	lds temp, ADCH
	;start conversion of ADC
	lds	work, ADCSRA
	sbr 	work, (1 << ADSC) | (1 << ADIF)
	sts	ADCSRA, work
	; output ADC result
	out 	PORTD, temp
	reti

