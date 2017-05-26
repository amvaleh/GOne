#include <MCP79410.h>

unsigned char make_hex(unsigned char num)
{
    unsigned char units = num % 10;
    unsigned char tens = num / 10;
    return (tens << 4) | units;
}

unsigned char make_dec(unsigned char num)
{
    unsigned char units = num & 0x0F;
    unsigned char tens = num >> 4;
    return tens*10 + units;
}
void WriteRTCByte(unsigned char adr, unsigned char data)
{
    i2c_start();
    i2c_write(0b11011110);
    i2c_write(adr);
    i2c_write(data);     
    i2c_stop();
}

unsigned char ReadRTCByte(unsigned char adr)
{
  unsigned char data;
  i2c_start();
  i2c_write(0b11011110);
  i2c_write(adr);
  i2c_start();
  i2c_write(0b11011111);
  data=i2c_read(0);
  return data;
}

unsigned char getRTCData(const unsigned char adr, const unsigned char validbits)
{
  unsigned char data;
  data = ReadRTCByte(adr);
  data = data & (0xff >> (8-validbits));
  return data;
}

void setDateTime (unsigned char year, unsigned char month, unsigned char day, unsigned char hour, unsigned char minute, unsigned char second ) 
{
    unsigned char hh = make_hex(hour);
    unsigned char mm = make_hex(minute);
    unsigned char ss = make_hex(second);

    WriteRTCByte(0,0);       //STOP RTC
    
    WriteRTCByte(7,0b01000000);
    WriteRTCByte(1,mm);    //MINUTE=18
    WriteRTCByte(2,hh);    //HOUR=8
    WriteRTCByte(3,0x09);    //DAY=1(MONDAY) AND VBAT=1
    WriteRTCByte(4,day-1);    //DATE=28
    WriteRTCByte(5,month);    //MONTH=2
    WriteRTCByte(6,year);    //YEAR=11
    WriteRTCByte(0,0x80);    //START RTC, SECOND=00
}

unsigned char second(void) { return make_dec(getRTCData(0,7)) ;}
unsigned char minute(void) { return make_dec(getRTCData(1,7)) ;}
unsigned char hour24(void) { return make_dec(getRTCData(2,6)) ;}
unsigned char day(void) { return make_dec(getRTCData(4,6)) ;}
unsigned char month(void) { return make_dec(getRTCData(5,5)) ;}
unsigned char year(void) { return make_dec(getRTCData(6,8)) ;}