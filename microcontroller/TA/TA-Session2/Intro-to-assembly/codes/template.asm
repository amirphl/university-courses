.org 0x00
jmp reset_isr

.org 0x04
jmp interruptX_isr

.org 0x28
jmp interruptX_isr

reset_isr : 
cli
; initialize everything that needed to be initialized just once
sei
jmp main

interruptX_isr : 
cli
; initialize everything that needed to be initialized just once
sei
reti

interruptY_isr : 
cli
; initialize everything that needed to be initialized just once
sei
reti


main : 
; main loop
jmp main

routine1 : 
; code for routine 1
ret

routine2 : 
; code for routine 1
ret