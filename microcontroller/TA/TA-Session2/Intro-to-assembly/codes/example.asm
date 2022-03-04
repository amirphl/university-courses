.def temp1 = r16
.def temp2 = r17
.def temp3 = r18
.org 0x00
jmp reset_isr

reset_isr:
    clr temp1
    out ddrA, temp1

    ldi temp1, 0xFF
    out ddrB, temp1
    out portA, temp1
    clr temp3
jmp main

main:
    in temp1, pinA
    com temp1  
    cp temp1, temp2
    breq main
    mov temp2, temp1
    out portB, temp3
    cpi temp1, 0x00
    breq output0
    cpi temp1, 0x01
    breq output1
    cpi temp1, 0x02
    breq output2
    cpi temp1, 0x03
    breq output3
    cpi temp1, 0x04
    breq output4
    cpi temp1, 0x05
    breq output5
    cpi temp1, 0x06
    breq output6
    cpi temp1, 0x07
    breq output7
jmp main    

output0:
    sbi portB, 0x00
jmp main 
output1:
    sbi portB, 0x01
jmp main    
output2:
    sbi portB, 0x02
jmp main    
output3:
    sbi portB, 0x03
jmp main    
output4:
    sbi portB, 0x04
jmp main    
output5:
    sbi portB, 0x05
jmp main    
output6:
    sbi portB, 0x06
jmp main    
output7:
    sbi portB, 0x07
jmp main    
 