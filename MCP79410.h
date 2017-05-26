#ifndef MCP79410_H
#define MCP79410_H

#include <i2c.h>
#include <mega32a.h>
#include <delay.h>

unsigned char getRTCData(const unsigned char adr, const unsigned char validbits);
void setDateTime (unsigned char year, unsigned char month, unsigned char day, unsigned char hour, unsigned char minute, unsigned char second );
unsigned char second(void);
unsigned char minute(void);
unsigned char hour24(void);
unsigned char day(void);
unsigned char month(void);
unsigned char year(void);

#endif
