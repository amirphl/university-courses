.org 0x00
	jmp RESET

RESET:
	ldi r20,110
	ldi r21,220
	
	ldi r16,0x00
	out DDRD,r16
	ldi r16,0xC0
	out PORTD,r16
	ldi r16,0x08
	out DDRB,r16
	
	in r16, TCCR0
	ori r16,(1<<WGM00)|(1<<COM01)|(1<<CS00)
	out TCCR0, r16
	
	out OCR0,r20
	jmp MAIN
	
MAIN:
	sbis pind,7
	out OCR0,r20
	sbis pind,6
	out OCR0,r21
	jmp MAIN