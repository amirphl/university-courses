;====================================================================
; Main.asm file generated by New Project wizard
;
; Created:   Fri May 17 2019
; Processor: ATmega16
; Compiler:  AVRASM (Proteus)
;====================================================================

;====================================================================
; DEFINITIONS
;====================================================================

;====================================================================
; VARIABLES
;====================================================================

;====================================================================
; RESET and INTERRUPT VECTORS
;====================================================================
; written by amirphl. amirphl@gmail.com github:amirphl instagram:amirphl
.equ	LCD_RS	= 1
.equ	LCD_RW	= 2
.equ	LCD_E	= 3

.def	temp	= r16
.def	argument= r17		;argument for calling subroutines
.def	return	= r18		;return value from subroutines


      ; Reset Vector
      rjmp  Start

;====================================================================
; CODE SEGMENT
;====================================================================

;ADC conversion interrupt
.org 0x01C
      in r20,ADCL
      in r21,ADCH
      andi r21,0b00000011
      
      call	LCD_wait
      sbrc r21,1
      ldi	argument, '1'
      sbrs r21,1
      ldi	argument, '0'
      call	LCD_putchar
      sbrc r21,0
      ldi	argument, '1'
      sbrs r21,0
      ldi	argument, '0'
      call	LCD_putchar
      sbrc r20,7
      ldi	argument, '1'
      sbrs r20,7
      ldi	argument, '0'
      call	LCD_putchar
      sbrc r20,6
      ldi	argument, '1'
      sbrs r20,6
      ldi	argument, '0'
      call	LCD_putchar
      sbrc r20,5
      ldi	argument, '1'
      sbrs r20,5
      ldi	argument, '0'
      call	LCD_putchar
      sbrc r20,4
      ldi	argument, '1'
      sbrs r20,4
      ldi	argument, '0'
      call	LCD_putchar
      sbrc r20,3
      ldi	argument, '1'
      sbrs r20,3
      ldi	argument, '0'
      call	LCD_putchar
      sbrc r20,2
      ldi	argument, '1'
      sbrs r20,2
      ldi	argument, '0'
      call	LCD_putchar
      sbrc r20,1
      ldi	argument, '1'
      sbrs r20,1
      ldi	argument, '0'
      call	LCD_putchar
      sbrc r20,0
      ldi	argument, '1'
      sbrs r20,0
      ldi	argument, '0'
      call	LCD_putchar
      
      call turn_on
      
      subi r21,0b00
      breq turn_off
      mov r21,r26
      
      subi r21,0b01
      breq special_case_1
      mov r21,r26
      
   a: subi r21,0b11
      breq turn_off
      mov r21,r26
      
      subi r21,0b10
      breq special_case_2
      mov r21,r26
   b:
reti

Start:
      sei 
      
      ;stack pointer setup
      ldi r16,high(RAMEND)
      out SPH,r16
      ldi r16,low(RAMEND)
      out SPL,r16
      
      ;init LCD
      rcall	LCD_init     
     
      ;LED2 setup
      ldi r16,0b00110000
      out DDRD,r16 
      
      ;MUX = ADC1 , use AREF 
      in r16,ADMUX
      ori r16,0b01000001
      andi r16,0b01100001
      out ADMUX,r16
      
      ;ADIE = 1
      in r16,ADCSRA
      ori r16,0b00001000
      out ADCSRA,r16
      
      ;ADEN = 1
      in r16,ADCSRA
      ori r16,0b10000000
      out ADCSRA,r16
      
      ;100 clock idle
      ldi r16,50
      make_delay:
	 dec r16
	 brne make_delay
	 
      ;ADSC = 1
      in r16,ADCSRA
      ori r16,0b01000000
      out ADCSRA,r16
      
      ;100 clock idle
      ldi r16,50
      make_delay_2:
	 dec r16
	 brne make_delay_2
      
      
Loop:
      jmp  Loop

      
turn_on:
   ldi r24,0b00010000
   out PORTD,r24
ret


turn_off:
   ldi r24,0b00000000
   out PORTD,r24
jmp Loop


special_case_1:
   ldi r27,129
   add r20,r27
   brvc turn_off
   mov r20,r25
jmp a   


special_case_2:
   ldi r27,129
   add r20,r27
   brvs turn_off
   mov r20,r25
jmp b


lcd_command8:	;used for init (we need some 8-bit commands to switch to 4-bit mode!)
	in	temp, DDRC		;we need to set the high nibble of DDRD while leaving
					;the other bits untouched. Using temp for that.
	sbr	temp, 0b11110000	;set high nibble in temp
	out	DDRC, temp		;write value to DDRD again
	in	temp, PortC		;then get the port value
	cbr	temp, 0b11110000	;and clear the data bits
	cbr	argument, 0b00001111	;then clear the low nibble of the argument
					;so that no control line bits are overwritten
	or	temp, argument		;then set the data bits (from the argument) in the
					;Port value
	out	PortC, temp		;and write the port value.
	sbi	PortC, LCD_E		;now strobe E
	nop
	nop
	nop
	cbi	PortC, LCD_E
	in	temp, DDRC		;get DDRD to make the data lines input again
	cbr	temp, 0b11110000	;clear data line direction bits
	out	DDRC, temp		;and write to DDRD
ret

lcd_putchar:
	push	argument		;save the argmuent (it's destroyed in between)
	in	temp, DDRC		;get data direction bits
	sbr	temp, 0b11110000	;set the data lines to output
	out	DDRC, temp		;write value to DDRD
	in	temp, PortC		;then get the data from PortD
	cbr	temp, 0b11111110	;clear ALL LCD lines (data and control!)
	cbr	argument, 0b00001111	;we have to write the high nibble of our argument first
					;so mask off the low nibble
	or	temp, argument		;now set the argument bits in the Port value
	out	PortC, temp		;and write the port value
	sbi	PortC, LCD_RS		;now take RS high for LCD char data register access
	sbi	PortC, LCD_E		;strobe Enable
	nop
	nop
	nop
	cbi	PortC, LCD_E
	pop	argument		;restore the argument, we need the low nibble now...
	cbr	temp, 0b11110000	;clear the data bits of our port value
	swap	argument		;we want to write the LOW nibble of the argument to
					;the LCD data lines, which are the HIGH port nibble!
	cbr	argument, 0b00001111	;clear unused bits in argument
	or	temp, argument		;and set the required argument bits in the port value
	out	PortC, temp		;write data to port
	sbi	PortC, LCD_RS		;again, set RS
	sbi	PortC, LCD_E		;strobe Enable
	nop
	nop
	nop
	cbi	PortC, LCD_E
	cbi	PortC, LCD_RS
	in	temp, DDRC
	cbr	temp, 0b11110000	;data lines are input again
	out	DDRC, temp
ret

lcd_command:	;same as LCD_putchar, but with RS low!
	push	argument
	in	temp, DDRC
	sbr	temp, 0b11110000
	out	DDRC, temp
	in	temp, PortC
	cbr	temp, 0b11111110
	cbr	argument, 0b00001111
	or	temp, argument

	out	PortC, temp
	sbi	PortC, LCD_E
	nop
	nop
	nop
	cbi	PortC, LCD_E
	pop	argument
	cbr	temp, 0b11110000
	swap	argument
	cbr	argument, 0b00001111
	or	temp, argument
	out	PortC, temp
	sbi	PortC, LCD_E
	nop
	nop
	nop
	cbi	PortC, LCD_E
	in	temp, DDRC
	cbr	temp, 0b11110000
	out	DDRC, temp
ret

LCD_getchar:
	in	temp, DDRC		;make sure the data lines are inputs
	andi	temp, 0b00001111	;so clear their DDR bits
	out	DDRC, temp
	sbi	PortC, LCD_RS		;we want to access the char data register, so RS high
	sbi	PortC, LCD_RW		;we also want to read from the LCD -> RW high
	sbi	PortC, LCD_E		;while E is high
	nop
	in	temp, PinC		;we need to fetch the HIGH nibble
	andi	temp, 0b11110000	;mask off the control line data
	mov	return, temp		;and copy the HIGH nibble to return
	cbi	PortC, LCD_E		;now take E low again
	nop				;wait a bit before strobing E again
	nop	
	sbi	PortC, LCD_E		;same as above, now we're reading the low nibble
	nop
	in	temp, PinC		;get the data
	andi	temp, 0b11110000	;and again mask off the control line bits
	swap	temp			;temp HIGH nibble contains data LOW nibble! so swap
	or	return, temp		;and combine with previously read high nibble
	cbi	PortC, LCD_E		;take all control lines low again
	cbi	PortC, LCD_RS
	cbi	PortC, LCD_RW
ret					;the character read from the LCD is now in return

LCD_getaddr:	;works just like LCD_getchar, but with RS low, return.7 is the busy flag
	in	temp, DDRC
	andi	temp, 0b00001111
	out	DDRC, temp
	cbi	PortC, LCD_RS
	sbi	PortC, LCD_RW
	sbi	PortC, LCD_E
	nop
	in	temp, PinC
	andi	temp, 0b11110000
	mov	return, temp
	cbi	PortC, LCD_E
	nop
	nop
	sbi	PortC, LCD_E
	nop
	in	temp, PinC
	andi	temp, 0b11110000
	swap	temp
	or	return, temp
	cbi	PortC, LCD_E
	cbi	PortC, LCD_RW
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
	out	DDRC, temp
	
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