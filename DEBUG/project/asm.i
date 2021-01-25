// CodeVisionAVR C Compiler
// (C) 1998-2004 Pavel Haiduc, HP InfoTech S.R.L.
// I/O registers definitions for the ATmega32
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      // 16 bit access
sfrb ADCSRA=6;
sfrb ADCSR=6;     // for compatibility with older code
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   // 16 bit access
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  // 16 bit access
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  // 16 bit access
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  // 16 bit access
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb OCR0=0X3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-
// Interrupt vectors definitions
// CodeVisionAVR C Compiler
// (C) 1998-2000 Pavel Haiduc, HP InfoTech S.R.L.
#pragma used+
void delay_us(unsigned int n);
void delay_ms(unsigned int n);
#pragma used-
// CodeVisionAVR C Compiler
// (C) 1998-2003 Pavel Haiduc, HP InfoTech S.R.L.
// Prototypes for standard I/O functions
// CodeVisionAVR C Compiler
// (C) 1998-2002 Pavel Haiduc, HP InfoTech S.R.L.
// Variable length argument list macros
typedef char *va_list;
#pragma used+
char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);
char *gets(char *str,unsigned int len);
void printf(char flash *fmtstr,...);
void sprintf(char *str, char flash *fmtstr,...);
void vprintf (char flash * fmtstr, va_list argptr);
void vsprintf (char *str, char flash * fmtstr, va_list argptr);
signed char scanf(char flash *fmtstr,...);
signed char sscanf(char *str, char flash *fmtstr,...);
                                               #pragma used-
#pragma library stdio.lib
// Declare your global variables here
 unsigned char count=0;
 unsigned char data, i;
  // USART Receiver buffer
char rx_buffer[8];
unsigned char rx_wr_index,rx_rd_index,rx_counter;
// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;
// USART Receiver interrupt service routine
interrupt [14] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & ((1<<4) | (1<<2) | (1<<3)))==0)
   {
   rx_buffer[rx_wr_index]=data;
   if (++rx_wr_index == 8) rx_wr_index=0;
   if (++rx_counter == 8)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      };
   };
}
// Get a character from the USART Receiver buffer
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index];
if (++rx_rd_index == 8) rx_rd_index=0;
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
// USART Transmitter buffer
char tx_buffer[8];
unsigned char tx_wr_index,tx_rd_index,tx_counter;
// USART Transmitter interrupt service routine
interrupt [16] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index];
   if (++tx_rd_index == 8) tx_rd_index=0;
   };
}
// Write a character to the USART Transmitter buffer
#pragma used+
void putchar(char c)
{
while (tx_counter == 8);
#asm("cli")
if (tx_counter || ((UCSRA & (1<<5))==0))
   {
   tx_buffer[tx_wr_index]=c;
   if (++tx_wr_index == 8) tx_wr_index=0;
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
// Standard Input/Output functions
// CodeVisionAVR C Compiler
// (C) 1998-2003 Pavel Haiduc, HP InfoTech S.R.L.
// Prototypes for standard I/O functions
                                               // External Interrupt 0 service routine
interrupt [2] void ext_int0_isr(void)
interrupt [2] void ext_int0_isr(void)
{
// Place your code here 
if(PIND.2==0)
{
//printf("interrrupt");
delay_ms(200);
if(PIND.2==0)
{
count++;
if(count==3)
{
 count=0;
}
}
}
}
void slave(unsigned char);
// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input|0x00;
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}
unsigned int pot;
unsigned int x;
unsigned int y;
unsigned int z;  
//unsigned char a;
unsigned int x1;
unsigned int y1;
unsigned int z1;
void main(void)
{
// Declare your local variables here
// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=Out 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=0 
PORTA=0x00;
DDRA=0x00;
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;
// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;
// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x04;
DDRD=0x30;
// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;
// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer 1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
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
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;
// // External Interrupt(s) initialization
// // INT0: Off
// // INT1: Off
// // INT2: Off
// MCUCR=0x00;
// MCUCSR=0x00;
// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;
// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00; 
// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AREF pin
ADMUX=0x00;
ADCSRA=0x84;       
 // External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Low level
// INT1: Off
// INT2: Off
GICR|=0x40;
MCUCR=0x00;
MCUCSR=0x00;
GIFR=0x40;
// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud rate: 9600
UCSRA=0x00;
UCSRB=0xD8;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x67;
#asm("sei")
while (1)
      {     
         if(count==1)
         { 
         //printf("working");
      x=read_adc(1);    
            y=read_adc(2);    
                z=read_adc(3);  
            x1=read_adc(4);    
            y1=read_adc(5);    
                z1=read_adc(6);  
             if((x>310&&x<340)&&(y>385&&y<415))
      {
      //printf("A\n\r");  
      //delay_ms(1000);
      slave(0);
      //delay_ms(1000);
      }
      else       
      if((x>385&&x<415)&&(y>330&&y<360))
      {
      //printf("B\n\r"); 
      //delay_ms(1000);  
      slave(1);
      //delay_ms(1000);
      }      
      else       
      if((x>255&&x<285)&&(y>310&&y<340))
      {
      //printf("C\n\r");
      //delay_ms(1000); 
      slave(2);
      //delay_ms(1000);
      }  
      else       
      if((x>330&&x<360)&&(y>310&&y<340))
      {
      //printf("D\n\r");   
      //delay_ms(1000); 
      slave(3);
      //delay_ms(1000);
      }  
      else       
      if((x>320&&x<350)&&(y>315&&y<345))
      {
      //printf("E\n\r");
      //delay_ms(1000); 
      slave(4);
      //delay_ms(1000);
      }  
      else
      {
      //printf("Invalid position 1\n\r");  
      delay_ms(1000);
      } 
      }     
                 if(count==2)
            {
         //printf("working2");
//          printf("working1");
             if(rx_counter>0) 
      { 
           while(getchar()!='$'); 
                 data=getchar();
      if(data=='A')
      {  
//         printf("working2");
            for(i=0;i<2;i++)
      {
      PORTD.4=1;  
      PORTD.5=1;
      delay_ms(1000);
      PORTD.4=0;  
      PORTD.5=0;
      delay_ms(1000); 
                       } 
       delay_ms(5000);
      }
                    if(data=='B')
      { 
      for(i=0;i<3;i++)
      {
      PORTD.4=1; 
      PORTD.5=1;
      delay_ms(1000);
      PORTD.4=0; 
      PORTD.5=0;
      delay_ms(1000);
                  }
      delay_ms(5000); 
      }
                  if(data=='C')
      { 
      for(i=0;i<4;i++)
      {
      PORTD.4=1;  
       PORTD.5=1;
      delay_ms(1000);
      PORTD.4=0; 
      PORTD.5=0;
      delay_ms(1000);
                 }  
      delay_ms(5000);
      }   
            if(data=='D')
      { 
       for(i=0;i<5;i++)
      {
      PORTD.4=1;
       PORTD.5=1;
      delay_ms(1000);
      PORTD.4=0; 
      PORTD.5=0;
      delay_ms(1000); 
                   } 
       delay_ms(5000);
      }
                  }
      }
                          };
}  
void slave(unsigned char a)  
{
                  if(a==0)
      { 
      if((x1>310&&x1<340)&&(y1>385&&y1<415))
      {
      printf("$hi#");
      delay_ms(1000);
      }
      else       
      if((x1>385&&x1<415)&&(y1>330&&y1<360))
      {
      printf("$hello#\n\r"); 
      delay_ms(1000);
      }      
      else       
      if((x1>255&&x1<285)&&(y1>310&&y1<340))
      {
      printf("$slept?#\n\r");
      delay_ms(1000);
      }  
      else       
      if((x1>330&&x1<360)&&(y1>310&&y1<340))
      {
      printf("$bye#\n\r");   
      delay_ms(1000);
      }  
      else       
      if((x1>320&&x1<350)&&(y1>315&&y1<345))
      {
      printf("$miss u#\n\r");
      delay_ms(1000);
      }  
      else
      {
      //printf("Invalid position 2\n\r"); 
      delay_ms(1000);
      }   
      }                  
            //-----------------
              if(a==1)
      { 
      if((x1>310&&x1<340)&&(y1>385&&y1<415))
      {
      printf("$apple#\n\r");
      delay_ms(1000);
      }
      else       
      if((x1>385&&x1<415)&&(y1>330&&y1<360))
      {
      printf("$orange#\n\r"); 
      delay_ms(1000);
      }      
      else       
      if((x1>255&&x1<285)&&(y1>310&&y1<340))
      {
      printf("$mango#\n\r");
      delay_ms(1000);
      }  
      else       
      if((x1>330&&x1<360)&&(y1>310&&y1<340))
      {
      printf("$pears#\n\r");   
      delay_ms(1000);
      }  
      else       
      if((x1>320&&x1<350)&&(y1>315&&y1<345))
      {
      printf("$grapes#\n\r");
      delay_ms(1000);
      }  
      else
      {
      //printf("Invalid position 2\n\r"); 
      delay_ms(1000);
      }   
      }
            //--------------------------
              if(a==2)
      { 
      if((x1>310&&x1<340)&&(y1>385&&y1<415))
      {
      printf("$car#\n\r");
      delay_ms(1000);
      }
      else       
      if((x1>385&&x1<415)&&(y1>330&&y1<360))
      {
      printf("$bus#\n\r"); 
      delay_ms(1000);
      }      
      else       
      if((x1>255&&x1<285)&&(y1>310&&y1<340))
      {
      printf("$bike#\n\r");
      delay_ms(1000);
      }  
      else       
      if((x1>330&&x1<360)&&(y1>310&&y1<340))
      {
      printf("$truck#\n\r");   
      delay_ms(1000);
      }  
      else       
      if((x1>320&&x1<350)&&(y1>315&&y1<345))
      {
      printf("$rickshaw#\n\r");
      delay_ms(1000);
      }  
      else
      {
      //printf("Invalid position 2\n\r"); 
      delay_ms(1000);
      }   
      }
            //--------------------------
              if(a==3)
      { 
      if((x1>310&&x1<340)&&(y1>385&&y1<415))
      {
      printf("$india#\n\r");
      delay_ms(1000);
      }
      else       
      if((x1>385&&x1<415)&&(y1>330&&y1<360))
      {
      printf("$US#\n\r"); 
      delay_ms(1000);
      }      
      else       
      if((x1>255&&x1<285)&&(y1>310&&y1<340))
      {
      printf("$UK#\n\r");
      delay_ms(1000);
      }  
      else       
      if((x1>330&&x1<360)&&(y1>310&&y1<340))
      {
      printf("$Canada#\n\r");   
      delay_ms(1000);
      }  
      else       
      if((x1>320&&x1<350)&&(y1>315&&y1<345))
      {
      printf("$Germany#\n\r");
      delay_ms(1000);
      }  
      else
      {
      //printf("Invalid position 2\n\r"); 
      delay_ms(1000);
      }   
      }
            //-----------------------------
              if(a==4)
      { 
      if((x1>310&&x1<340)&&(y1>385&&y1<415))
      {
      printf("$Phone#\n\r");
      delay_ms(1000);
      }
      else       
      if((x1>385&&x1<415)&&(y1>330&&y1<360))
      {
      printf("$Watch#\n\r"); 
      delay_ms(1000);
      }      
      else       
      if((x1>255&&x1<285)&&(y1>310&&y1<340))
      {
      printf("$PC#\n\r");
      delay_ms(1000);
      }  
      else       
      if((x1>330&&x1<360)&&(y1>310&&y1<340))
      {
      printf("$Internet#\n\r");   
      delay_ms(1000);
      }  
      else       
      if((x1>320&&x1<350)&&(y1>315&&y1<345))
      {
      printf("$Laptop#\n\r");
      delay_ms(1000);
      }  
      else
      {
      //printf("Invalid position 2\n\r"); 
      delay_ms(1000);
      }   
      }
            }
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   if(count==2)
//       
//       {
//          //printf("working2");
//       
//        
//       if(rx_counter>0) 
//       { 
//      
//       while(getchar()!='$'); 
//        //printf("working2");
//       
//       data=getchar();
//       if(data=='A')
//       { 
//       for(i=0;i<2;i++)
//       {
//       PORTD.5=1;
//       delay_ms(100);
//       PORTD.5=0;
//       delay_ms(100); 
//       
//       } 
//        delay_ms(1000);
//       }
//         
//       
//       if(data=='B')
//       { 
//       for(i=0;i++;i<3)
//       {
//       PORTD.5=1;
//       delay_ms(100);
//       PORTD.5=0;
//       delay_ms(100);
//       }
//       delay_ms(1000); 
//       }
//             
//       if(data=='C')
//       { 
//       for(i=0;i++;i<4)
//       {
//       PORTD.5=1;
//       delay_ms(100);
//       PORTD.5=0;
//       delay_ms(100);
//       }  
//       delay_ms(1000);
//       }   
//       
//       if(data=='D')
//       { 
//        for(i=0;i++;i<5)
//       {
//       PORTD.5=1;
//       delay_ms(100);
//       PORTD.5=0;
//       delay_ms(100); 
//       
//       } 
//        delay_ms(1000);
//       }
//       
//       
//       }
//       }
