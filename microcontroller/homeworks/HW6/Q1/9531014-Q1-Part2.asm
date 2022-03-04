.org 0x00
	jmp MAIN

MAIN:
	ldi r16,0xFF
	out DDRB,r16
	ldi r16, 0xF3
	out OCR0,r16
	in r16, TCCR0
	ori r16,(1<<4)
	ori r16,0x05
	out TCCR0, r16
	jmp loop
	
loop:
   jmp loop