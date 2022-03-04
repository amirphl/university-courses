; written by amirphl. amirphl@gmail.com github:amirphl instagram:amirphl
.equ	LCD_RS	= 1
.equ	LCD_RW	= 2
.equ	LCD_E	= 3

.def	temp	= r16
.def	argument= r17		;argument for calling subroutines
.def	return	= r18		;return value from subroutines

.org 0x00
	jmp RESET

.org 0x02
	jmp KeyFind ;EXT_INT0

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
	
	;USART setup
	call USART_SETUP
	
	;enable interrupt 
	sei
	
	;LCD after power-up: ("*" means black bar)
	rcall	LCD_init
	
	jmp MAIN

USART_SETUP:
	;setup baud rate
	ldi r16,207
	out UBRRL,r16
	clr r16
	out UBRRH,r16
	;Enable receiver and transmitter
	;ldi r16,0b00100000
	;out UCSRA,r16
	;in r16,UCSRC
	;ori r16,0b10100110
	;out UCSRC,r16
	;in r16,UCSRB
	;ori r16,0b00001110
	;out UCSRB,r16
	 ldi r16, (0 << TXCIE)|(1 << TXEN)|(1 << UCSZ2)|(1 << RXCIE)|(0 << TXB8)
	 out UCSRB, r16
	 ldi r16, (1 << URSEL)|(1 << UPM1)|(0 << UPM0)|(0 << USBS)| (1 << UCSZ1)|(1 << UCSZ0)
	 out UCSRC, r16

	ret

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
	
	;put char on LCD
	mov r17,r0
	cpi r17,0x00
	in r16,SREG
	sbrc r16,1
	ldi argument,'0'
	cpi r17,0x01
	in r16,SREG
	sbrc r16,1
	ldi argument,'1'
	cpi r17,0x02
	in r16,SREG
	sbrc r16,1
	ldi argument,'2'
	cpi r17,0x03
	in r16,SREG
	sbrc r16,1
	ldi argument,'3'
	cpi r17,0x04
	in r16,SREG
	sbrc r16,1
	ldi argument,'4'
	cpi r17,0x05
	in r16,SREG
	sbrc r16,1
	ldi argument,'5'
	cpi r17,0x06
	in r16,SREG
	sbrc r16,1
	ldi argument,'6'
	cpi r17,0x07
	in r16,SREG
	sbrc r16,1
	ldi argument,'7'
	cpi r17,0x08
	in r16,SREG
	sbrc r16,1
	ldi argument,'8'
	cpi r17,0x09
	in r16,SREG
	sbrc r16,1
	ldi argument,'9'
	cpi r17,0x0A
	in r16,SREG
	sbrc r16,1
	ldi argument,'A'
	cpi r17,0x0B
	in r16,SREG
	sbrc r16,1
	ldi argument,'B'
	cpi r17,0x0C
	in r16,SREG
	sbrc r16,1
	ldi argument,'C'
	cpi r17,0x0D
	in r16,SREG
	sbrc r16,1
	ldi argument,'D'
	cpi r17,0x0E
	in r16,SREG
	sbrc r16,1
	ldi argument,'E'
	cpi r17,0x0F
	in r16,SREG
	sbrc r16,1
	ldi argument,'F'
	
	rcall	LCD_putchar
	
	;keyboard setup
	ldi r16,0xF0
	out DDRC,r16
	ldi r16,0x0F
	out PORTC,r16
	
	call USART_TRANSMIT
	
	reti

USART_TRANSMIT:

	 in r16,UCSRA
      a: sbrs r16,5 ;check UDRE
	 jmp a
	 in r16,UCSRB
	 andi r16,0b11111110 ;clear TXB8
	 out UCSRB,r16
	 out UDR,r0
  
	 ret

MAIN:
	;call LCD
	jmp MAIN
	
lcd_command8:	;used for init (we need some 8-bit commands to switch to 4-bit mode!)
	in	temp, DDRA		;we need to set the high nibble of DDRD while leaving
					;the other bits untouched. Using temp for that.
	sbr	temp, 0b11110000	;set high nibble in temp
	out	DDRA, temp		;write value to DDRD again
	in	temp, PortA		;then get the port value
	cbr	temp, 0b11110000	;and clear the data bits
	cbr	argument, 0b00001111	;then clear the low nibble of the argument
					;so that no control line bits are overwritten
	or	temp, argument		;then set the data bits (from the argument) in the
					;Port value
	out	PortA, temp		;and write the port value.
	sbi	PortA, LCD_E		;now strobe E
	nop
	nop
	nop
	cbi	PortA, LCD_E
	in	temp, DDRA		;get DDRD to make the data lines input again
	cbr	temp, 0b11110000	;clear data line direction bits
	out	DDRA, temp		;and write to DDRD
ret

lcd_putchar:
	push	argument		;save the argmuent (it's destroyed in between)
	in	temp, DDRA		;get data direction bits
	sbr	temp, 0b11110000	;set the data lines to output
	out	DDRA, temp		;write value to DDRD
	in	temp, PortA		;then get the data from PortD
	cbr	temp, 0b11111110	;clear ALL LCD lines (data and control!)
	cbr	argument, 0b00001111	;we have to write the high nibble of our argument first
					;so mask off the low nibble
	or	temp, argument		;now set the argument bits in the Port value
	out	PortA, temp		;and write the port value
	sbi	PortA, LCD_RS		;now take RS high for LCD char data register access
	sbi	PortA, LCD_E		;strobe Enable
	nop
	nop
	nop
	cbi	PortA, LCD_E
	pop	argument		;restore the argument, we need the low nibble now...
	cbr	temp, 0b11110000	;clear the data bits of our port value
	swap	argument		;we want to write the LOW nibble of the argument to
					;the LCD data lines, which are the HIGH port nibble!
	cbr	argument, 0b00001111	;clear unused bits in argument
	or	temp, argument		;and set the required argument bits in the port value
	out	PortA, temp		;write data to port
	sbi	PortA, LCD_RS		;again, set RS
	sbi	PortA, LCD_E		;strobe Enable
	nop
	nop
	nop
	cbi	PortA, LCD_E
	cbi	PortA, LCD_RS
	in	temp, DDRA
	cbr	temp, 0b11110000	;data lines are input again
	out	DDRA, temp
ret

lcd_command:	;same as LCD_putchar, but with RS low!
	push	argument
	in	temp, DDRA
	sbr	temp, 0b11110000
	out	DDRA, temp
	in	temp, PortA
	cbr	temp, 0b11111110
	cbr	argument, 0b00001111
	or	temp, argument

	out	PortA, temp
	sbi	PortA, LCD_E
	nop
	nop
	nop
	cbi	PortA, LCD_E
	pop	argument
	cbr	temp, 0b11110000
	swap	argument
	cbr	argument, 0b00001111
	or	temp, argument
	out	PortA, temp
	sbi	PortA, LCD_E
	nop
	nop
	nop
	cbi	PortA, LCD_E
	in	temp, DDRA
	cbr	temp, 0b11110000
	out	DDRA, temp
ret

LCD_getchar:
	in	temp, DDRA		;make sure the data lines are inputs
	andi	temp, 0b00001111	;so clear their DDR bits
	out	DDRA, temp
	sbi	PortA, LCD_RS		;we want to access the char data register, so RS high
	sbi	PortA, LCD_RW		;we also want to read from the LCD -> RW high
	sbi	PortA, LCD_E		;while E is high
	nop
	in	temp, PinA		;we need to fetch the HIGH nibble
	andi	temp, 0b11110000	;mask off the control line data
	mov	return, temp		;and copy the HIGH nibble to return
	cbi	PortA, LCD_E		;now take E low again
	nop				;wait a bit before strobing E again
	nop	
	sbi	PortA, LCD_E		;same as above, now we're reading the low nibble
	nop
	in	temp, PinA		;get the data
	andi	temp, 0b11110000	;and again mask off the control line bits
	swap	temp			;temp HIGH nibble contains data LOW nibble! so swap
	or	return, temp		;and combine with previously read high nibble
	cbi	PortA, LCD_E		;take all control lines low again
	cbi	PortA, LCD_RS
	cbi	PortA, LCD_RW
ret					;the character read from the LCD is now in return

LCD_getaddr:	;works just like LCD_getchar, but with RS low, return.7 is the busy flag
	in	temp, DDRA
	andi	temp, 0b00001111
	out	DDRA, temp
	cbi	PortA, LCD_RS
	sbi	PortA, LCD_RW
	sbi	PortA, LCD_E
	nop
	in	temp, PinA
	andi	temp, 0b11110000
	mov	return, temp
	cbi	PortA, LCD_E
	nop
	nop
	sbi	PortA, LCD_E
	nop
	in	temp, PinA
	andi	temp, 0b11110000
	swap	temp
	or	return, temp
	cbi	PortA, LCD_E
	cbi	PortA, LCD_RW
ret

LCD_wait:				;read address and busy flag until busy flag cleared
	rcall	LCD_getaddr
	andi	return, 0x80
	brne	LCD_wait
	ret


LCD_delay:
	clr	r2
	LCD_delay_outer:
	clr	r3
		LCD_delay_inner:
		dec	r3
		brne	LCD_delay_inner
	dec	r2
	brne	LCD_delay_outer
ret

LCD_init:
	
	ldi	temp, 0b00001110	;control lines are output, rest is input
	out	DDRA, temp
	
	rcall	LCD_delay		;first, we'll tell the LCD that we want to use it
	ldi	argument, 0x20		;in 4-bit mode.
	rcall	LCD_command8		;LCD is still in 8-BIT MODE while writing this command!!!

	rcall	LCD_wait
	ldi	argument, 0x28		;NOW: 2 lines, 5*7 font, 4-BIT MODE!
	rcall	LCD_command		;
	
	rcall	LCD_wait
	ldi	argument, 0x0F		;now proceed as usual: Display on, cursor on, blinking
	rcall	LCD_command
	
	rcall	LCD_wait
	ldi	argument, 0x01		;clear display, cursor -> home
	rcall	LCD_command
	
	rcall	LCD_wait
	ldi	argument, 0x06		;auto-inc cursor
	rcall	LCD_command
ret