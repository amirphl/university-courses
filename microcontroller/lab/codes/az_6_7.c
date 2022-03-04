/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 4/15/2019
Author  : 
Company : 
Comments: 


Chip type               : ATmega32A
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32a.h>
#include <delay.h>
// Declare your global variables here
int ff;
int f;

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
// Place your code here
    ff = 1;    
}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
// Place your code here
    f = 0;
    ff = 0;
}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Low level
// INT1: On
// INT1 Mode: Low level
// INT2: Off
GICR|=(1<<INT1) | (1<<INT0) | (0<<INT2);
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);
GIFR=(1<<INTF1) | (1<<INTF0) | (0<<INTF2);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Global enable interrupts
#asm("sei")

DDRB = 0xFF;
DDRD.2 = 0;
DDRD.3 = 0;
PORTB = 0x00;
PORTD.2 = 1;
PORTD.3 = 1;
ff = 0;

while (1)
      {
      // Place your code here
      if (ff == 1) {
        PORTB.7 = 0;
        f = 1;
        while (f == 1) {
            PORTB.0 = 1;
            PORTB.1 = 1;
            PORTB.2 = 1;
            PORTB.3 = 1;
            PORTB.4 = 1;
            PORTB.5 = 1;
            PORTB.6 = 0;
            if (f == 0) {
                break;
            }
            delay_ms(50);
            if (f == 0) {
                break;
            }
            PORTB.0 = 0;
            PORTB.1 = 0;
            PORTB.2 = 0;
            PORTB.3 = 0;
            PORTB.4 = 1;
            PORTB.5 = 1;
            PORTB.6 = 0;
            if (f == 0) {
                break;
            }
            delay_ms(50);
            if (f == 0) {
                break;
            }
            PORTB.0 = 1;
            PORTB.1 = 1;
            PORTB.2 = 0;
            PORTB.3 = 1;
            PORTB.4 = 1;
            PORTB.5 = 0;
            PORTB.6 = 1;    
            if (f == 0) {
                break;
            }
            delay_ms(50);
            if (f == 0) {
                break;
            }
            PORTB.0 = 1;
            PORTB.1 = 1;
            PORTB.2 = 1;
            PORTB.3 = 1;
            PORTB.4 = 0;
            PORTB.5 = 0;
            PORTB.6 = 1;    
            if (f == 0) {
                break;
            }
            delay_ms(50);
            if (f == 0) {
                break;
            }
            PORTB.0 = 0;
            PORTB.1 = 1;
            PORTB.2 = 1;
            PORTB.3 = 0;
            PORTB.4 = 0;
            PORTB.5 = 1;
            PORTB.6 = 1;    
            if (f == 0) {
                break;
            }
            delay_ms(50);
            if (f == 0) {
                break;
            }
            PORTB.0 = 1;
            PORTB.1 = 0;
            PORTB.2 = 1;
            PORTB.3 = 1;
            PORTB.4 = 0;
            PORTB.5 = 1;
            PORTB.6 = 1;    
            if (f == 0) {
                break;
            }
            delay_ms(50);
            if (f == 0) {
                break;
            }
            PORTB.0 = 1;
            PORTB.1 = 0;
            PORTB.2 = 1;
            PORTB.3 = 1;
            PORTB.4 = 1;
            PORTB.5 = 1;
            PORTB.6 = 1;    
            if (f == 0) {
                break;
            }
            delay_ms(50);
            if (f == 0) {
                break;
            }
            PORTB.0 = 1;
            PORTB.1 = 1;
            PORTB.2 = 1;
            PORTB.3 = 0;
            PORTB.4 = 0;
            PORTB.5 = 0;
            PORTB.6 = 0;    
            if (f == 0) {
                break;
            }
            delay_ms(50);
            if (f == 0) {
                break;
            }
            PORTB.0 = 1;
            PORTB.1 = 1;
            PORTB.2 = 1;
            PORTB.3 = 1;
            PORTB.4 = 1;
            PORTB.5 = 1;
            PORTB.6 = 1;    
            if (f == 0) {
                break;
            }
            delay_ms(50);
            if (f == 0) {
                break;
            }
            PORTB.0 = 1;
            PORTB.1 = 1;
            PORTB.2 = 1;
            PORTB.3 = 1;
            PORTB.4 = 0;
            PORTB.5 = 1;
            PORTB.6 = 1;    
            if (f == 0) {
                break;
            }
            delay_ms(50);
        }
      }
      }
}
