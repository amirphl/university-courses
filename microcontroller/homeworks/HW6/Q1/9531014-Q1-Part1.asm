.def temp = r20 ;stores timer counter 0 overflows
.def temp_2 = r22 ;stores timer counter 0 overflows
.def LED_stat = r21; ; LED status, 0xFF equals on, 0x00 equals off
.org 0x00
	jmp RESET

.org 0x12
	jmp TIMER_OVERFLOW_INTERRUPT_HANDLING ;TVO0

RESET:
	;disable interrupt
	;cli
	
	;set inputs and outputs
	ldi r16,0x3F
	out DDRD,r16
	ldi r16,0x08
	out DDRB,r16
	;pulling up inputs
	ldi r16,0xC0
	out PORTD,r16
	
	
	;stack pointer setup
	ldi r16,high(RAMEND)
	out SPH,r16
	ldi r16,low(RAMEND)
	out SPL,r16
	
	;timer counetr 0 setup (set prescaler to scale 64 times)
	;ldi r16,(1<<CS00)
	;out TCCR0,r16
	;ldi r16,(1<<CS01)
	;out TCCR0,r16
	;ldi r16,(0<<CS02)
	;out TCCR0,r16
	
	;timer counetr 0 setup (set WGM00 and WGM01)
	ldi r16,(0<<WGM00)
	out TCCR0,r16
	ldi r16,(0<<WGM00)
	out TCCR0,r16
	
	;timer counetr 0 setup (set COM00 and COM01)
	ldi r16,(1<<COM00)
	out TCCR0,r16
	ldi r16,(0<<COM01)
	out TCCR0,r16
	
	;timer counetr 0 setup (set TCNT0 and TOV0)
	ldi r16,0x00
	out TCNT0,r16
	ldi r16,(1<<TOV0)
	out TIFR,r16
	
	
	;reset temp and temp_2
	ldi temp,100
	ldi temp_2,3
	
	;reset LED_stat
	ldi LED_stat,0x00
	
	;enable timer counter interrupt
	;ldi r16,(1<<TOIE0)|(1<<OCIE0)
	;out TIMSK,r16
	
	in r16, TCCR0
	ori r16, 0x3 
	out TCCR0, r16

	in r16, TIMSK
	ori r16, 0x1 
	out TIMSK, r16
	
	;enable interrupt 
	sei
	
	jmp MAIN

MAIN:
	jmp FOREVER

FOREVER:
	jmp FOREVER

TIMER_OVERFLOW_INTERRUPT_HANDLING:
      dec temp
      brne a
      ldi temp,100
      dec temp_2
      breq CHANGE_LED_STATE 
reti

a:
   reti

CHANGE_LED_STATE:
   ldi r16,0xC0
   out PORTD,r16
   
   ldi temp,100
   ldi temp_2,3
   
   cpi LED_stat,0x00
   breq TURN_ON
   ldi LED_stat,0x00
reti

TURN_ON:
   ldi LED_stat,0xFF
   ldi r16,0xF0
   out PORTD,r16
reti