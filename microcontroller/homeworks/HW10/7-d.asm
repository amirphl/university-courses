call RESET
.org 0x002
EXTERNAL_INT0:
	; R0 HOLDS BUFFER DATA( KEY SELECTED )
	; R17 HOLDS PORTB STATE(DECODER)
	IN R16, PORTC
	IN R25, SREG
	; CHECK SOURCE IS BUFFER OR NOT
	CPI R16, 0x00
	SBRC R25, 1
		IN R17, 0x08 ; SELECT BUFFER #1
	CPI R16, 0x01
	SBRC R25, 1
		IN R17, 0x0A ; SELECT BUFFER #2
	CPI R16, 0x02
	SBRC R25, 1
		IN R17, 0x0C ; SELECT BUFFER #3
	CPI R16, 0x03
	SBRC R25, 1
		IN R17, 0x0E ; SELECT BUFFER #4
	
	
	; IF SOURCE IS BUFFER, START READING
	CPI R16, 0x00
	SBRC R25, 1
		CALL BufferRead
	CPI R16, 0x01
	SBRC R25, 1
		CALL BufferRead
	CPI R16, 0x02
	SBRC R25, 1
		CALL BufferRead
	CPI R16, 0x03
	SBRC R25, 1
		CALL BufferRead
	
	
	; CHECK SOURCE IS LATCH OR NOT
	CPI R16, 0x04
	SBRC R25, 1
		IN R17, 0x01 ; SELECT LATCH #1
	CPI R16, 0x05
	SBRC R25, 1
		IN R17, 0x03 ; SELECT LATCH #2
	CPI R16, 0x06
	SBRC R25, 1
		IN R17, 0x05 ; SELECT LATCH #3
	CPI R16, 0x07
	SBRC R25, 1
		IN R17, 0x07 ; SELECT LATCH #4


	; IF SOURCE IS LATCH, START WRITING
	CPI R16, 0x04
	SBRC R25, 1
		CALL OutputWrite
	CPI R16, 0x05
	SBRC R25, 1
		CALL OutputWrite
	CPI R16, 0x06
	SBRC R25, 1
		CALL OutputWrite
	CPI R16, 0x07
	SBRC R25, 1
		CALL OutputWrite


	reti


MAIN:
	jmp MAIN


RESET:
	LDI R24, 0x00
	OUT DDRC, R24 ; PORTC is Input
	LDI R24, 0x00
	OUT DDRD, R24 ; PORTD is Input
	; IMPLEMENT INTTERUPT SETUP FOR INT0 HERE 
	; TODO
	sei
	JMP MAIN


; Port Address Valid to data valid in PIN register > tPHL (74ls138) + tPZL (74244) + 1.5 Clocks (port Pd)= 41ns+30ns+1.5 Clocks
; Port Address Valid to data valid in PIN register > 41ns+30ns+1.5*62.5=164.75ns which is less than 3 clock pulses (each clock=62.5ns)
BufferRead: 
	LDI R24, 0x00
	OUT DDRA, R24 ; PORTA is Input
	LDI R24, 0xFF
	OUT DDRB, R24 ; PORTB is Output
	MOV R24, R17 ; Buffer SELECTION 
	OUT PORTB, R24 ;
	NOP
	NOP
	NOP
	LDI R20, 0x8 ; R20 will finally contain the No. of the pressed Key
	LOOP1:
		IN R16, PINA ; Read Value from Input Buffer #1
		CPI R16, 0xFF
		BREQ LOOP1 ; If R16=0xFF means that no Key was Pressed
		;RCALL Delay20ms ; Call a 20ms Delay if any key was pressed
	LOOP2: 
		DEC R20;
		LSL R16 ; Shift left the Value read from Keyboard
		BRCC LOOP3 ; Branch if Carry Flag is Cleared, so the pressed Key is detected
		RJMP LOOP2
	LOOP3:
		MOV R0, R20; ; Now R0 Contains the No. of pressed key
	RET


OutputWrite:
	LDI R20, 0xFF
	OUT DDRA, R20 ; PORTA is Output
	OUT DDRB, R20 ; PORTB is Output
	OUT PORTA, R0 ; Value on Port A
	MOV R20, R17  ; LATCH SELECTION
	OUT PORTB , R20 ; Latch Strobe High
	DEC R20
	OUT PORTB , R20 ; Latch Strobe Low 2*62.5 ns > TSHSL=35ns TSHSL=STB High Time
	; 4*62.5 ns > TIVSL=0 ns TIVSL=Input To STB Set Time
	NOP ; (NOP and next instruction time)=2*62.5ns > TSLIX=25ns TSLIX=Input To STB Hold Time
	RET