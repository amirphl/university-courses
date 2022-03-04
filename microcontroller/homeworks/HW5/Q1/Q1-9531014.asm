; written by amirphl. amirphl@gmail.com github:amirphl instagram:amirphl
.org 0x00
	jmp RESET

.org 0x02
	jmp KeyFind ;EXT_INT0

.org 0x04
	jmp EXT_INT1

.org 0x12C
RESET:
	;disable interrupt
	cli
	
	;SW1 , LED1 setup
	ldi r16,0x20
	out DDRD,r16
	;disabling first interrupt
	ldi r16,0x08
	out PORTD,r16
	
	;keyboard setup
	ldi r16,0xF0
	out DDRC,r16
	ldi r16,0x0F
	out PORTC,r16
	
	;7 segement setup
	ldi r16,0xFF
	out DDRB,r16
	ldi r16,0x00
	out PORTB,r16
	
	
	ldi r20,0x00
	
	;interrupt setup
	ldi r16,(1<<IVCE)
	out GICR,r16
	ldi r16,(0<<IVSEL)
	out GICR,r16
	ldi r16,(1<<INT0)|(1<<INT1)
	out GICR,r16
	
	ldi r16,(1<<ISC00)
	out MCUCR,r16
	ldi r16,(0<<ISC01)
	out MCUCR,r16
	ldi r16,(1<<ISC10)
	out MCUCR,r16
	ldi r16,(1<<ISC11)
	out MCUCR,r16
	
	;stack pointer setup
	ldi r16,high(RAMEND)
	out SPH,r16
	ldi r16,low(RAMEND)
	out SPL,r16
	
	;enable interrupt 
	sei
	
	jmp MAIN


.org 0x15E
EXT_INT1:
	in r16,PORTD
	ldi r17,0x20
	ldi r18,0x00
	
	sbrc r16,5
		out PORTD,r18
	sbrs r16,5
		out PORTD,r17
	
	reti


.org 0x1C2
KeyFind: ;EXT_INT0
        
	;finding key, r16 is temporary register, r0 contains key
	
	;row 1
	ldi r17,0xEF
	out PORTC,r17
	sbis PINC,0
	ldi r16,0x00
	sbis PINC,1
	ldi r16,0x01
	sbis PINC,2
	ldi r16,0x02
	sbis PINC,3
	ldi r16,0x03
	
	;row 2
	ldi r17,0xDF
	out PORTC,r17
	sbis PINC,0
	ldi r16,0x04
	sbis PINC,1
	ldi r16,0x05
	sbis PINC,2
	ldi r16,0x06
	sbis PINC,3
	ldi r16,0x07
	
	;row 3
	ldi r17,0xBF
	out PORTC,r17
	sbis PINC,0
	ldi r16,0x08
	sbis PINC,1
	ldi r16,0x09
	sbis PINC,2
	ldi r16,0x0A
	sbis PINC,3
	ldi r16,0x0B
	
	;row 4
	ldi r17,0x7F
	out PORTC,r17
	sbis PINC,0
	ldi r16,0x0C
	sbis PINC,1
	ldi r16,0x0D
	sbis PINC,2
	ldi r16,0x0E
	sbis PINC,3
	ldi r16,0x0F
	
	;finaly move r16 to r0
	mov r0,r16
	
	;turning 7segment on
	mov r17,r0
	cpi r17,0x00
	in r16,SREG
	sbrc r16,1
	call zero
	cpi r17,0x01
	in r16,SREG
	sbrc r16,1
	call one
	cpi r17,0x02
	in r16,SREG
	sbrc r16,1
	call two
	cpi r17,0x03
	in r16,SREG
	sbrc r16,1
	call three
	cpi r17,0x04
	in r16,SREG
	sbrc r16,1
	call four
	cpi r17,0x05
	in r16,SREG
	sbrc r16,1
	call five
	cpi r17,0x06
	in r16,SREG
	sbrc r16,1
	call six
	cpi r17,0x07
	in r16,SREG
	sbrc r16,1
	call ven
	cpi r17,0x08
	in r16,SREG
	sbrc r16,1
	call eight
	cpi r17,0x09
	in r16,SREG
	sbrc r16,1
	call nine
	cpi r17,0x0A
	in r16,SREG
	sbrc r16,1
	call ten
	cpi r17,0x0B
	in r16,SREG
	sbrc r16,1
	call eleven
	cpi r17,0x0C
	in r16,SREG
	sbrc r16,1
	call twelve
	cpi r17,0x0D
	in r16,SREG
	sbrc r16,1
	call thirteen
	cpi r17,0x0E
	in r16,SREG
	sbrc r16,1
	call fourteen
	cpi r17,0x0F
	in r16,SREG
	sbrc r16,1
	call fifteen
	
	;keyboard setup
	ldi r16,0xF0
	out DDRC,r16
	ldi r16,0x0F
	out PORTC,r16
	
	reti


.org 0x190
MAIN:
	jmp MAIN

	
.org 0x285
; showing 0 on 7 segment
zero:
   ldi r16,0x3F
   out PORTB,r16
   ret
; showing 1 on 7 segment
one:
   ldi r16,0x06
   out PORTB,r16
   ret
two:
   ldi r16,0x5B
   out PORTB,r16
   ret
three:
   ldi r16,0x4F
   out PORTB,r16
   ret
four:
   ldi r16,0x66
   out PORTB,r16
   ret
five:
   ldi r16,0x6D 	 	
   out PORTB,r16
   ret
six:
   ldi r16,0x7D
   out PORTB,r16
   ret
ven:
   ldi r16,0x07
   out PORTB,r16
   ret
eight:
   ldi r16,0x7F
   out PORTB,r16
   ret
nine:
   ldi r16,0x6F
   out PORTB,r16
   ret
ten:
   ldi r16,0x77
   out PORTB,r16
   ret
eleven:
   ldi r16,0x7C
   out PORTB,r16
   ret
twelve:
   ldi r16,0x61
   out PORTB,r16
   ret
thirteen:
   ldi r16,0x5E
   out PORTB,r16
   ret
fourteen:
   ldi r16,0x79	
   out PORTB,r16
   ret
; showing F on 7 segment
fifteen:
   ldi r16,0x71
   out PORTB,r16
   ret

	