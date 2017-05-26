/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 5/7/2017
Author  :
Company :
Comments:


Chip type               : ATmega32A
Program type            : Application
AVR Core Clock frequency: 11.059200 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32a.h>

#include <delay.h>

// I2C Bus functions
#include <i2c.h>

// LM75 Temperature Sensor functions
#include <lm75.h>
#include "MCP79410.h"

#include "SIM800.h"

#define sendinterval 3600;
#include <sleep.h>
// Declare your global variables here
//Globarl variables:
volatile int Temp,Hum,Lux;
volatile long int k=0; //count the refresh rate int timer 2
int LED_Disp_show = 0; //flag for showing data in led

int wait,success,success1,counter_5ms=0,now_5ms,head_onoff=1;

int Temp_LED=0,Hum_LED=0,Lux_LED=0,Red=0,Blue=0,Green=0,turn=0,blue_delay,red_delay;
#define LC1 PORTB.4
#define LC2 PORTB.3
#define LC3 PORTA.1
#define LC4 PORTB.5
#define LR1 PORTA.0
#define LR2 PORTB.0
#define LR3 PORTB.1
#define LR4 PORTA.3

long int buff_counter; //count the chars recieved
char rec_buff[rec_buff_size]; //store the last chars recieved from module. it used in RX interrupt function.
long int second_=3595;
int val[8];
char VAR_1[7];
char VAR_2[7];
char VAR_3[7];
char VAR_4[7];
char VAR_5[7];
char VAR_6[7];
char VAR_7[7];
char VAR_8[7];
char _SERVER_[20];
char _APN_[20];
char _HOST_[20];
char _PAGEADDRESS_[50];
char _SUCCESSSIGN_[20];
int next_send_time=25;

int G_Lum, G_Temp, G_Mois; //the global variable for lux and temp and mois.    
char first_time=0;

// Voltage Reference: AREF pin
#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (1<<ADLAR))
// Read the 8 most significant bits
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCH;
}

void LED_Disp(void)
{
    Lux_LED = 0;
    if(G_Lum > 160) Lux_LED = 1;
    if(G_Lum > 180) Lux_LED = 2;
    if(G_Lum > 200) Lux_LED = 3;
    if(G_Lum > 220) Lux_LED = 4;

    Temp_LED =0;
    if(G_Temp > 200) Temp_LED = 1;
    if(G_Temp > 270) Temp_LED = 2;
    if(G_Temp > 350) Temp_LED = 3;
    if(G_Temp > 400) Temp_LED = 4;


    Hum_LED=0;
    if(G_Mois > 25) Hum_LED = 1;
    if(G_Mois > 50) Hum_LED = 2;
    if(G_Mois > 90) Hum_LED = 3;
    if(G_Mois > 120) Hum_LED = 4;
}
void LED_Disp_clear(void)
{
    Lux_LED = 0;
    Temp_LED =0;
    Hum_LED=0;
}
int moisture(int times)
{
    float sum=0;
    int i;
    for(i=0;i<times;i++)
    {
        sum = sum + (float)read_adc(6); 
    }       
    return (int)(sum/times);
}
int temperature(void)
{
    return lm75_temperature_10(0)-2;
}
int battery_voltage(void)
{
    return (int)(100*((2.49*255)/((float)read_adc(5))));
}

int luminosity(int times)
{
    float sum=0;
    int i;
    for(i=0;i<times;i++)
    {
        sum = sum + (float)read_adc(2); 
    }       
    return (int)(sum/times);
}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
// Place your code here
    char sms_buff[30];
    int t_out=0;  
    int step=0;
    int min, last_min;
    int YEAR_,MONTH_,DATE_,HOUR_,MIN_,SEC_;    
    
    //sleep disable:
    sleep_disable();   
             
    min = minute(); 
    
    /*
    LC1=1;
    LR1=1;
    delay_ms(10);
    LC1=0;
    LR1=0;  
    */            
    
    //if(first_time==1 || min==0)
    if(min % 15 == 0 || first_time==1)
    {                            
        PORTC.4 = 0; // Turning (OnOff) MOSFET on!   
        first_time=0;
         
        LED_Disp_show=1; // turning led display on
        delay_ms(5000);

        //set values:
        val[0]=luminosity(10);
        val[1]=temperature();
        val[2]=moisture(500);
        val[3]=battery_voltage();
        val[4]=0;
        val[5]=123;
        val[7]=0;

        GICR = (0<<INT1); // disable ext int 1 from RTC
        #asm("sei");  
              
        //turning on module          
        if(step==0)
        {   
            if(sim800_on())  
            {          
                step++;  
            }
            else
            {
                //Error on step 0
            }        
        }        
        
        //Step 1: initialize Program basic paramiter  programmer should modify the prog_init() function.
        if(step==1)
        {
            prog_init();
            step++;
        }         
        
        //Step 2: initialize Module:    
        if(step==2)
        {
            sim800_init("");   
            step++; 
        }                       
        
        //Step 3: Wait until registeration in network:  
        if(step==3)
        {
            t_out=0;
            while(!check_reg() && t_out<=25)
            {
                 //wait until reg on network
                 delay_ms(1000);
            }   
            
            if(t_out<=25)
            {
                val[6]=signal_q();
                step++;
            }
            else
            {  
                //Error on step 3
            }
        }
        
        //Step 4: Post data.      
        if(step==4)
        {             
            if(post_data(val))
            {
                step++;
            }
            delay_ms(1000);
        }         
        
        //Time IC Settings  
        if(step==5)
        {
            get_server_time(&YEAR_,&MONTH_,&DATE_,&HOUR_,&MIN_,&SEC_);
            setDateTime(YEAR_-2000,MONTH_,DATE_,HOUR_,MIN_,SEC_);   
        } 
        sim800_off(); 
           
        delay_ms(15000);
        LED_Disp_show=0; // turning led display off 
        delay_ms(10);
    }                
    GICR = (1<<INT1); // re-enable ext int 1 from RTC        
    //sleep and interrupt enable       
    #asm("sei"); 
    sleep_enable();
}

#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)


// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
    char data;
    data=UDR;
    //lcd_putchar(data);
    rec_buff[buff_counter]=data;

    buff_counter++;
    if(buff_counter>=rec_buff_size || (rec_buff[buff_counter]=='P' && rec_buff[buff_counter-1]=='I' && rec_buff[buff_counter-2]=='+'))
    {
       buff_counter=0;
    }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
    return 0;
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>


// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    // Reinitialize Timer 0 value
    TCNT0=0x28;
    // Place your code here 
    //refreshing the led datas, each 1 sec
    if(LED_Disp_show)
    {
        if(k>=500)
        {
            k=0;
            G_Lum=luminosity(2);
            G_Temp=temperature();
            G_Mois=moisture(5);    
            LED_Disp();
        }    
        k++; 
    }
    else
    {
        LED_Disp_clear();
    }
}


// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
    //Reinitialize Timer2 value

    TCNT2=0x94;
    //Place your code here  
    
    turn++;

    if(turn==1 && red_delay>=4)       // Red turn
    {
        red_delay = 0;

        LC1 = 0;
        LC2 = 0;
        LC3 = 0;
        LC4 = 0;
        //delay_us(10);

        LR1 = (Temp_LED > 0) ? 1 : 0;
        LR2 = (Temp_LED > 1) ? 1 : 0;
        LR3 = (Temp_LED > 2) ? 1 : 0;
        LR4 = (Temp_LED > 3) ? 1 : 0;
        //delay_us(10);

        LC1 = 1;
        LC2 = 0;
        LC3 = 0;
        LC4 = 0;
    }
    else if(turn==2 && blue_delay>=2)  // Blue turn
    {
        blue_delay = 0;

        LC1 = 0;
        LC2 = 0;
        LC3 = 0;
        LC4 = 0;
        //delay_us(10);

        LR1 = (Hum_LED > 0) ? 1 : 0;
        LR2 = (Hum_LED > 1) ? 1 : 0;
        LR3 = (Hum_LED > 2) ? 1 : 0;
        LR4 = (Hum_LED > 3) ? 1 : 0;
        //delay_us(10);

        LC1 = 0;
        LC2 = 1;
        LC3 = 0;
        LC4 = 0;
    }
    else if(turn==3)  // Green turn
    {
        LC1 = 0;
        LC2 = 0;
        LC3 = 0;
        LC4 = 0;
        //delay_us(10);

        LR1 = (Lux_LED > 2) ? 1 : 0;
        LR2 = (Lux_LED > 1) ? 1 : 0;
        LR3 = (Lux_LED > 0) ? 1 : 0;
        LR4 = (Lux_LED > 3) ? 1 : 0;
        //delay_us(10);

        LC1 = 0;
        LC2 = 0;
        LC3 = 1;
        LC4 = 0;
    }
    else if(turn==4)  // Head turn
    {
        LC1 = 0;
        LC2 = 0;
        LC3 = 0;
        LC4 = 0;
        //delay_us(10);

        LR1 = (Green == 1) ? 1 : 0;
        LR2 = (0 == 0) ? 0 : 0;;
        LR3 = (Blue == 1) ? 1 : 0;
        LR4 = (Red == 1) ? 1 : 0;
        //delay_us(10);

        LC1 = 0;
        LC2 = 0;
        LC3 = 0;
        LC4 = (head_onoff == 1);

        turn = 0;
        blue_delay++;
        red_delay++;
    }    
   
}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=In Bit1=Out Bit0=Out
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (1<<DDA4) | (1<<DDA3) | (0<<DDA2) | (1<<DDA1) | (1<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=0 Bit2=T Bit1=0 Bit0=0
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=In Bit1=Out Bit0=Out
DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (0<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=0
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (1<<DDC4) | (1<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=0 Bit2=T Bit1=T Bit0=T
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
DDRD=(0<<DDD7) | (0<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 43.200 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
// Timer Period: 5 ms
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x28;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 1382.400 kHz
// Mode: Fast PWM top=0x00FF
// OC1A output: Non-Inverted PWM
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 0.18519 ms
// Output Pulse(s):
// OC1A Period: 0.18519 ms Width: 0 us
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (1<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
TCNT1H=0xF7;
TCNT1L=0x5C;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 172.800 kHz
// Mode: Normal top=0xFF
// OC2 output: Disconnected
// Timer Period: 1.0012 ms
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (1<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x53;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: On
// INT1 Mode: Falling Edge
// INT2: Off
GICR|=(1<<INT1) | (0<<INT0) | (0<<INT2);
MCUCR=(1<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);
GIFR=(1<<INTF1) | (0<<INTF0) | (0<<INTF2);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x47;

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);

// ADC initialization
// ADC Clock frequency: 691.200 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: ADC Stopped
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Bit-Banged I2C Bus initialization
// I2C Port: PORTC
// I2C SDA bit: 0
// I2C SCL bit: 1
// Bit Rate: 100 kHz
// Note: I2C settings are specified in the
// Project|Configure|C Compiler|Libraries|I2C menu.
i2c_init();

// LM75 Temperature Sensor initialization
// thyst: 75�C
// tos: 80�C
// O.S. polarity: 0
lm75_init(0,75,80,0);

//first time:
first_time=1;

setDateTime(17,1,1,12,5,5);

LED_Disp_clear();

PORTA.4 = 0; // MOSVCC on!
OCR1A = 500;

delay_ms(500);
// Global enable interrupts

#asm("sei")
sleep_enable();
idle(); 
delay_ms(3000);

while (1)
      {
         /*
         Red = (i<11);
         Blue = (i > 11 && i < 22);
         Green = (i > 22);
         Temp_LED = timing[(i)%33];
         Hum_LED = timing[(i+22)%33];
         Lux_LED = timing[(i+11)%33];
         i++;
         i=i%33;
         delay_ms(60);
         */
         //Temp = lm75_temperature_10(0);  //requires 300ms delay afterwards
         //Hum = read_adc(6);
         //printf("%02d:%02d:%02d\n",hour24(),minute(),second());
         //printf("%d\n",Hum);
         //delay_ms(1000);   
                       
         PORTA.4 = 0; // MOSVCC on!  
         GICR|=(1<<INT1) | (0<<INT0) | (0<<INT2); 
         

         #asm("sei");
         sleep_enable();
         idle();   
          
         //delay_ms(1000);
         //goto sleep
         
      }
}