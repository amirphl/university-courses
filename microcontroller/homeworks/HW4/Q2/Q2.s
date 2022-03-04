.org 0x00
jmp rst

.org 0xFF
rst:
   ;in r16,wdtcr
   ;ori r16,(1<<wdtoe)|,(1<<wde)|(1 << WDP2) | (1 << WDP1) | (1 << WDP0)
   ;out wdtcr,r16

   sbr r16,0x1F
   sbr r17,0x0F
   out wdtcr,r16
   out wdtcr,r17
   ;ldi r16, (WDTOE<<1)
   ;out wdtcr, r16
   ;ldi r17, (wde<<1)|(WDP2<<1)|(WDP1<<1)|(WDP0<<1)
   ;out wdtcr, r17
   
	; initialize stack pointer
	LDI	R16, low(RAMEND)
	OUT	SPL, R16
	LDI	R16, high(RAMEND)
	OUT	SPH, R16
	 
	; set PD5 to output , PD3 abd PD6 to input and pull up PD3 and PD6
	ldi r16,0x20
	out DDRD,r16
	sbi PORTD,3
	sbi PORTD,6
	cbi PORTD,5
jmp main

main:
   in r17,PIND
   sbrs r17,3 ; skip if PD3 is 1
   sbi PORTD,5 ; set PD5 1
   sbrs r17,6 ; skip if PD6 is 1
   jmp reset_watcher
jmp main

reset_watcher:
      wdr
jmp main
