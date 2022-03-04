;====================================================================
; Main.asm file generated by New Project wizard
;
; Created:   Thu Apr 11 2019
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

      ; Reset Vector

;====================================================================
; CODE SEGMENT
;====================================================================

.org 0xFF

BCDTo7_Seg:
	.db 0xBF
	.db 0x06
	.db 0xDB
	.db 0xCF
	.db 0xE6
	.db 0xED
	.db 0xFD
	.db 0x07
	.db 0xFF
	.db 0xEF

.org 0x00
jmp init
init:
	; initialize stack pointer
	LDI	R16, low(RAMEND)
	OUT	SPL, R16
	LDI	R16, high(RAMEND)
	OUT	SPH, R16
	 
	; set PD5 and PD4 to output and PD3 to input and pull up PD3 and PD6
	ldi r16,0x30
	out DDRD,r16
	ser r16
	out DDRB,r16
	sbi PORTD,3
	sbi PORTD,6
jmp main_part_c

main_part_a:
	in r17,PIND
	sbrs r17,3 ; skip if PD3 is 1
	sbi PORTD,5 ; set PD5 1
	sbrc r17,3 ; skip if PD3 is 0
	cbi PORTD,5 ; clear PD5 0
jmp main_part_a

main_part_b:
	in r17,PIND
	sbrs r17,6 ; skip if PD6 is 1
	call part_b
jmp main_part_b

part_b:
	call on_two_min
	call off_two_min
	call on_two_min
	call off_two_min
	call on_two_min
	call off_two_min
	call on_two_min
	call off_two_min
	call on_two_min
	call off_two_min	
ret

on_two_min:
    sbi PORTD,4 ; set PD4 1
    ldi  r18, 3
    ldi  r19, 97
    ldi  r20, 195
    ldi  r21, 143
L1: dec  r21
    brne L1
    dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
ret

off_two_min:
    cbi PORTD,4 ; clear PD4 0
    ldi  r18, 3
    ldi  r19, 97
    ldi  r20, 195
    ldi  r21, 143
L2: dec  r21
    brne L2
    dec  r20
    brne L2
    dec  r19
    brne L2
    dec  r18
    brne L2
ret

main_part_c:
   ldi r16,0xEF
   out PORTB,r16
jmp main_part_c


;====================================================================