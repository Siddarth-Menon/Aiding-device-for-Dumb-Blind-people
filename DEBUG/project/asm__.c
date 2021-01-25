#include <mega32.h> 
#include <delay.h>
#include <stdio.h> 
// Declare your global variables here
#define ADC_VREF_TYPE 0x00

 unsigned char count=0;
 unsigned char data, i;
 
 #define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE<256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index]=data;
   if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      };
   };
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index];
if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE<256
unsigned char tx_wr_index,tx_rd_index,tx_counter;
#else
unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index];
   if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
   };
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index]=c;
   if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
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
ADMUX=adc_input|ADC_VREF_TYPE;
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
ADMUX=ADC_VREF_TYPE;
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



