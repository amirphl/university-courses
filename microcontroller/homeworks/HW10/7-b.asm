; Port Address Valid to data valid in PIN register > tPHL (74ls138) + tPZL (74244) + 1.5 Clocks (port Pd)= 41ns+30ns+1.5 Clocks
; Port Address Valid to data valid in PIN register > 41ns+30ns+1.5*62.5=164.75ns which is less than 3 clock pulses (each clock=62.5ns)
BufferRead: 
	LDI R24, 0x00
	OUT DDRA, R24 ; PORTA is Input
	LDI R24, 0xFF
	OUT DDRB, R24 ; PORTB is Output
	LDI R24, 0x04 ; Buffer #1 
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
		CALL OutputWrite

OutputWrite:
	LDI R20, 0xFF
	OUT DDRA, R20 ; PORTA is Output
	OUT DDRB, R20 ; PORTB is Output
	OUT PORTA, R0 ; Value on Port A
	LDI R20, 0x01
	OUT PORTB , R20 ; Latch1 Strobe High
	LDI R20, 0x00 ;
	OUT PORTB , R20 ; Latch1 Strobe Low 2*62.5 ns > TSHSL=35ns TSHSL=STB High Time
	; 4*62.5 ns > TIVSL=0 ns TIVSL=Input To STB Set Time
	NOP ; (NOP and next instruction time)=2*62.5ns > TSLIX=25ns TSLIX=Input To STB Hold Time
	jmp BufferRead