
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32A
;Program type           : Application
;Clock frequency        : 11.059200 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _LED_Disp_show=R4
	.DEF _LED_Disp_show_msb=R5
	.DEF _wait=R6
	.DEF _wait_msb=R7
	.DEF _success=R8
	.DEF _success_msb=R9
	.DEF _success1=R10
	.DEF _success1_msb=R11
	.DEF _counter_5ms=R12
	.DEF _counter_5ms_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x1
_0x4:
	.DB  0xB,0xE
_0x5:
	.DB  0x19
_0x0:
	.DB  0x0
_0x40000:
	.DB  0x25,0x73,0x25,0x63,0x0,0x41,0x54,0x5A
	.DB  0x0,0x41,0x54,0x26,0x46,0x0,0x41,0x54
	.DB  0x2B,0x43,0x4D,0x45,0x45,0x3D,0x31,0x0
	.DB  0x41,0x54,0x2B,0x43,0x50,0x49,0x4E,0x3F
	.DB  0x0,0x52,0x45,0x41,0x44,0x59,0x0,0x41
	.DB  0x54,0x2B,0x43,0x50,0x49,0x4E,0x3D,0x22
	.DB  0x25,0x73,0x22,0x0,0x41,0x54,0x2B,0x43
	.DB  0x4D,0x47,0x46,0x3D,0x31,0x0,0x41,0x54
	.DB  0x2B,0x43,0x53,0x4D,0x50,0x3D,0x31,0x37
	.DB  0x2C,0x31,0x39,0x36,0x2C,0x30,0x2C,0x30
	.DB  0x0,0x41,0x54,0x2B,0x43,0x53,0x43,0x53
	.DB  0x3D,0x22,0x47,0x53,0x4D,0x22,0x0,0x41
	.DB  0x54,0x0,0x4F,0x4B,0x0,0x41,0x54,0x2B
	.DB  0x43,0x52,0x45,0x47,0x3F,0x0,0x30,0x2C
	.DB  0x31,0x0,0x41,0x54,0x2B,0x43,0x4D,0x47
	.DB  0x53,0x3D,0x22,0x2B,0x25,0x73,0x22,0x0
	.DB  0x3E,0x0,0x25,0x73,0x0,0x41,0x54,0x2B
	.DB  0x43,0x47,0x41,0x54,0x54,0x3D,0x31,0x0
	.DB  0x41,0x54,0x2B,0x43,0x47,0x44,0x43,0x4F
	.DB  0x4E,0x54,0x3D,0x31,0x2C,0x22,0x49,0x50
	.DB  0x22,0x2C,0x22,0x25,0x73,0x22,0x0,0x45
	.DB  0x52,0x52,0x4F,0x52,0x0,0x41,0x54,0x2B
	.DB  0x43,0x53,0x54,0x54,0x3D,0x22,0x25,0x73
	.DB  0x22,0x2C,0x22,0x22,0x2C,0x22,0x22,0x0
	.DB  0x41,0x54,0x2B,0x43,0x49,0x49,0x43,0x52
	.DB  0x0,0x41,0x54,0x2B,0x43,0x49,0x46,0x53
	.DB  0x52,0x0,0x41,0x54,0x2B,0x43,0x49,0x50
	.DB  0x48,0x45,0x41,0x44,0x3D,0x31,0x0,0x41
	.DB  0x54,0x2B,0x43,0x49,0x50,0x53,0x54,0x41
	.DB  0x52,0x54,0x3D,0x22,0x54,0x43,0x50,0x22
	.DB  0x2C,0x22,0x25,0x73,0x22,0x2C,0x22,0x38
	.DB  0x30,0x22,0x0,0x43,0x4F,0x4E,0x4E,0x45
	.DB  0x43,0x54,0x0,0x41,0x4C,0x52,0x45,0x41
	.DB  0x44,0x59,0x0,0x43,0x4F,0x4E,0x4E,0x45
	.DB  0x43,0x54,0x20,0x4F,0x4B,0x0,0x46,0x41
	.DB  0x49,0x4C,0x0,0x41,0x54,0x2B,0x43,0x49
	.DB  0x50,0x53,0x45,0x4E,0x44,0x0,0x53,0x45
	.DB  0x4E,0x44,0x20,0x4F,0x4B,0x0,0x6C,0x0
	.DB  0x74,0x0,0x6D,0x0,0x62,0x0,0x61,0x0
	.DB  0x6E,0x0,0x31,0x30,0x34,0x2E,0x32,0x38
	.DB  0x2E,0x32,0x35,0x2E,0x35,0x0,0x49,0x72
	.DB  0x61,0x6E,0x63,0x65,0x6C,0x6C,0x2D,0x47
	.DB  0x50,0x52,0x53,0x0,0x67,0x6F,0x6C,0x6F
	.DB  0x67,0x72,0x61,0x6D,0x2E,0x63,0x6F,0x6D
	.DB  0x0,0x2F,0x61,0x70,0x69,0x2F,0x76,0x31
	.DB  0x2F,0x70,0x72,0x6F,0x62,0x65,0x73,0x2F
	.DB  0x70,0x72,0x6F,0x63,0x65,0x73,0x73,0x0
	.DB  0x73,0x75,0x63,0x63,0x65,0x73,0x73,0x22
	.DB  0x3A,0x74,0x72,0x75,0x65,0x0,0x41,0x54
	.DB  0x2B,0x43,0x49,0x50,0x43,0x6C,0x4F,0x53
	.DB  0x45,0x0,0x41,0x54,0x2B,0x43,0x49,0x50
	.DB  0x53,0x48,0x55,0x54,0x0,0x25,0x73,0x3D
	.DB  0x25,0x64,0x26,0x25,0x73,0x3D,0x25,0x64
	.DB  0x26,0x25,0x73,0x3D,0x25,0x64,0x26,0x25
	.DB  0x73,0x3D,0x25,0x64,0x26,0x25,0x73,0x3D
	.DB  0x25,0x64,0x26,0x25,0x73,0x3D,0x25,0x64
	.DB  0x26,0x25,0x73,0x3D,0x25,0x64,0x26,0x25
	.DB  0x73,0x3D,0x25,0x64,0x0,0x50,0x4F,0x53
	.DB  0x54,0x20,0x25,0x73,0x20,0x48,0x54,0x54
	.DB  0x50,0x2F,0x31,0x2E,0x30,0xD,0xA,0x48
	.DB  0x6F,0x73,0x74,0x3A,0x20,0x25,0x73,0xD
	.DB  0xA,0x55,0x73,0x65,0x72,0x2D,0x41,0x67
	.DB  0x65,0x6E,0x74,0x3A,0x20,0x48,0x54,0x54
	.DB  0x50,0x54,0x6F,0x6F,0x6C,0x2F,0x31,0x2E
	.DB  0x30,0xD,0xA,0x43,0x6F,0x6E,0x74,0x65
	.DB  0x6E,0x74,0x2D,0x54,0x79,0x70,0x65,0x3A
	.DB  0x20,0x61,0x70,0x70,0x6C,0x69,0x63,0x61
	.DB  0x74,0x69,0x6F,0x6E,0x2F,0x78,0x2D,0x77
	.DB  0x77,0x77,0x2D,0x66,0x6F,0x72,0x6D,0x2D
	.DB  0x75,0x72,0x6C,0x65,0x6E,0x63,0x6F,0x64
	.DB  0x65,0x64,0xD,0xA,0x43,0x6F,0x6E,0x74
	.DB  0x65,0x6E,0x74,0x2D,0x4C,0x65,0x6E,0x67
	.DB  0x74,0x68,0x3A,0x20,0x25,0x64,0xD,0xA
	.DB  0xD,0xA,0x25,0x73,0xD,0xA,0xD,0xA
	.DB  0x0,0x41,0x54,0x2B,0x43,0x53,0x51,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _head_onoff
	.DW  _0x3*2

	.DW  0x01
	.DW  _0x25
	.DW  _0x0*2

	.DW  0x04
	.DW  _0x4000F
	.DW  _0x40000*2+5

	.DW  0x05
	.DW  _0x4000F+4
	.DW  _0x40000*2+9

	.DW  0x0A
	.DW  _0x4000F+9
	.DW  _0x40000*2+14

	.DW  0x09
	.DW  _0x4000F+19
	.DW  _0x40000*2+24

	.DW  0x06
	.DW  _0x4000F+28
	.DW  _0x40000*2+33

	.DW  0x0A
	.DW  _0x40011
	.DW  _0x40000*2+52

	.DW  0x13
	.DW  _0x40011+10
	.DW  _0x40000*2+62

	.DW  0x0E
	.DW  _0x40011+29
	.DW  _0x40000*2+81

	.DW  0x03
	.DW  _0x40012
	.DW  _0x40000*2+95

	.DW  0x03
	.DW  _0x40012+3
	.DW  _0x40000*2+98

	.DW  0x09
	.DW  _0x40015
	.DW  _0x40000*2+101

	.DW  0x04
	.DW  _0x40015+9
	.DW  _0x40000*2+110

	.DW  0x02
	.DW  _0x4001B
	.DW  _0x40000*2+128

	.DW  0x03
	.DW  _0x4001B+2
	.DW  _0x40000*2+98

	.DW  0x03
	.DW  _0x40026
	.DW  _0x40000*2+95

	.DW  0x03
	.DW  _0x40026+3
	.DW  _0x40000*2+98

	.DW  0x0B
	.DW  _0x40026+6
	.DW  _0x40000*2+133

	.DW  0x03
	.DW  _0x40026+17
	.DW  _0x40000*2+98

	.DW  0x06
	.DW  _0x40026+20
	.DW  _0x40000*2+167

	.DW  0x03
	.DW  _0x40026+26
	.DW  _0x40000*2+98

	.DW  0x09
	.DW  _0x40026+29
	.DW  _0x40000*2+192

	.DW  0x03
	.DW  _0x40026+38
	.DW  _0x40000*2+98

	.DW  0x09
	.DW  _0x40026+41
	.DW  _0x40000*2+201

	.DW  0x0D
	.DW  _0x40031
	.DW  _0x40000*2+210

	.DW  0x03
	.DW  _0x40031+13
	.DW  _0x40000*2+98

	.DW  0x03
	.DW  _0x40031+16
	.DW  _0x40000*2+98

	.DW  0x08
	.DW  _0x40031+19
	.DW  _0x40000*2+251

	.DW  0x08
	.DW  _0x40031+27
	.DW  _0x40000*2+259

	.DW  0x0B
	.DW  _0x40031+35
	.DW  _0x40000*2+267

	.DW  0x05
	.DW  _0x40031+46
	.DW  _0x40000*2+278

	.DW  0x0B
	.DW  _0x40038
	.DW  _0x40000*2+283

	.DW  0x02
	.DW  _0x40038+11
	.DW  _0x40000*2+128

	.DW  0x08
	.DW  _0x40038+13
	.DW  _0x40000*2+294

	.DW  0x0C
	.DW  _0x4003C
	.DW  _0x40000*2+390

	.DW  0x03
	.DW  _0x4003C+12
	.DW  _0x40000*2+98

	.DW  0x0B
	.DW  _0x4003D
	.DW  _0x40000*2+402

	.DW  0x03
	.DW  _0x4003D+11
	.DW  _0x40000*2+98

	.DW  0x03
	.DW  _0x40048
	.DW  _0x40000*2+95

	.DW  0x03
	.DW  _0x40048+3
	.DW  _0x40000*2+98

	.DW  0x03
	.DW  _0x40048+6
	.DW  _0x40000*2+95

	.DW  0x03
	.DW  _0x40048+9
	.DW  _0x40000*2+98

	.DW  0x03
	.DW  _0x40058
	.DW  _0x40000*2+95

	.DW  0x03
	.DW  _0x40058+3
	.DW  _0x40000*2+98

	.DW  0x07
	.DW  _0x4005F
	.DW  _0x40000*2+593

	.DW  0x04
	.DW  _0x4005F+7
	.DW  _0x40000*2+596

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 5/7/2017
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32A
;Program type            : Application
;AVR Core Clock frequency: 11.059200 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega32a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;
;// I2C Bus functions
;#include <i2c.h>
;
;// LM75 Temperature Sensor functions
;#include <lm75.h>
;#include "MCP79410.h"
;
;#include "SIM800.h"
;
;#define sendinterval 3600;
;#include <sleep.h>
;// Declare your global variables here
;//Globarl variables:
;volatile int Temp,Hum,Lux;
;volatile long int k=0; //count the refresh rate int timer 2
;int LED_Disp_show = 0; //flag for showing data in led
;
;int wait,success,success1,counter_5ms=0,now_5ms,head_onoff=1;

	.DSEG
;
;int Temp_LED=0,Hum_LED=0,Lux_LED=0,Red=0,Blue=0,Green=0,turn=0,blue_delay,red_delay;
;#define LC1 PORTB.4
;#define LC2 PORTB.3
;#define LC3 PORTA.1
;#define LC4 PORTB.5
;#define LR1 PORTA.0
;#define LR2 PORTB.0
;#define LR3 PORTB.1
;#define LR4 PORTA.3
;
;long int buff_counter; //count the chars recieved
;char rec_buff[rec_buff_size]; //store the last chars recieved from module. it used in RX interrupt function.
;long int second_=3595;
;int val[8];
;char VAR_1[7];
;char VAR_2[7];
;char VAR_3[7];
;char VAR_4[7];
;char VAR_5[7];
;char VAR_6[7];
;char VAR_7[7];
;char VAR_8[7];
;char _SERVER_[20];
;char _APN_[20];
;char _HOST_[20];
;char _PAGEADDRESS_[50];
;char _SUCCESSSIGN_[20];
;int next_send_time=25;
;
;int G_Lum, G_Temp, G_Mois; //the global variable for lux and temp and mois.
;char first_time=0;
;
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (1<<ADLAR))
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 0054 {

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 0055 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 0056 // Delay needed for the stabilization of the ADC input voltage
; 0000 0057 delay_us(10);
	__DELAY_USB 37
; 0000 0058 // Start the AD conversion
; 0000 0059 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 005A // Wait for the AD conversion to complete
; 0000 005B while ((ADCSRA & (1<<ADIF))==0);
_0x6:
	SBIS 0x6,4
	RJMP _0x6
; 0000 005C ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 005D return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
; 0000 005E }
; .FEND
;
;void LED_Disp(void)
; 0000 0061 {
_LED_Disp:
; .FSTART _LED_Disp
; 0000 0062     Lux_LED = 0;
	LDI  R30,LOW(0)
	STS  _Lux_LED,R30
	STS  _Lux_LED+1,R30
; 0000 0063     if(G_Lum > 160) Lux_LED = 1;
	CALL SUBOPT_0x0
	CPI  R26,LOW(0xA1)
	LDI  R30,HIGH(0xA1)
	CPC  R27,R30
	BRLT _0x9
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x1
; 0000 0064     if(G_Lum > 180) Lux_LED = 2;
_0x9:
	CALL SUBOPT_0x0
	CPI  R26,LOW(0xB5)
	LDI  R30,HIGH(0xB5)
	CPC  R27,R30
	BRLT _0xA
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x1
; 0000 0065     if(G_Lum > 200) Lux_LED = 3;
_0xA:
	CALL SUBOPT_0x0
	CPI  R26,LOW(0xC9)
	LDI  R30,HIGH(0xC9)
	CPC  R27,R30
	BRLT _0xB
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x1
; 0000 0066     if(G_Lum > 220) Lux_LED = 4;
_0xB:
	CALL SUBOPT_0x0
	CPI  R26,LOW(0xDD)
	LDI  R30,HIGH(0xDD)
	CPC  R27,R30
	BRLT _0xC
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x1
; 0000 0067 
; 0000 0068     Temp_LED =0;
_0xC:
	LDI  R30,LOW(0)
	STS  _Temp_LED,R30
	STS  _Temp_LED+1,R30
; 0000 0069     if(G_Temp > 200) Temp_LED = 1;
	CALL SUBOPT_0x2
	CPI  R26,LOW(0xC9)
	LDI  R30,HIGH(0xC9)
	CPC  R27,R30
	BRLT _0xD
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x3
; 0000 006A     if(G_Temp > 270) Temp_LED = 2;
_0xD:
	CALL SUBOPT_0x2
	CPI  R26,LOW(0x10F)
	LDI  R30,HIGH(0x10F)
	CPC  R27,R30
	BRLT _0xE
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x3
; 0000 006B     if(G_Temp > 350) Temp_LED = 3;
_0xE:
	CALL SUBOPT_0x2
	CPI  R26,LOW(0x15F)
	LDI  R30,HIGH(0x15F)
	CPC  R27,R30
	BRLT _0xF
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x3
; 0000 006C     if(G_Temp > 400) Temp_LED = 4;
_0xF:
	CALL SUBOPT_0x2
	CPI  R26,LOW(0x191)
	LDI  R30,HIGH(0x191)
	CPC  R27,R30
	BRLT _0x10
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x3
; 0000 006D 
; 0000 006E 
; 0000 006F     Hum_LED=0;
_0x10:
	LDI  R30,LOW(0)
	STS  _Hum_LED,R30
	STS  _Hum_LED+1,R30
; 0000 0070     if(G_Mois > 25) Hum_LED = 1;
	CALL SUBOPT_0x4
	SBIW R26,26
	BRLT _0x11
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x5
; 0000 0071     if(G_Mois > 50) Hum_LED = 2;
_0x11:
	CALL SUBOPT_0x4
	SBIW R26,51
	BRLT _0x12
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x5
; 0000 0072     if(G_Mois > 90) Hum_LED = 3;
_0x12:
	CALL SUBOPT_0x4
	CPI  R26,LOW(0x5B)
	LDI  R30,HIGH(0x5B)
	CPC  R27,R30
	BRLT _0x13
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x5
; 0000 0073     if(G_Mois > 120) Hum_LED = 4;
_0x13:
	CALL SUBOPT_0x4
	CPI  R26,LOW(0x79)
	LDI  R30,HIGH(0x79)
	CPC  R27,R30
	BRLT _0x14
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x5
; 0000 0074 }
_0x14:
	RET
; .FEND
;void LED_Disp_clear(void)
; 0000 0076 {
_LED_Disp_clear:
; .FSTART _LED_Disp_clear
; 0000 0077     Lux_LED = 0;
	LDI  R30,LOW(0)
	STS  _Lux_LED,R30
	STS  _Lux_LED+1,R30
; 0000 0078     Temp_LED =0;
	STS  _Temp_LED,R30
	STS  _Temp_LED+1,R30
; 0000 0079     Hum_LED=0;
	STS  _Hum_LED,R30
	STS  _Hum_LED+1,R30
; 0000 007A }
	RET
; .FEND
;int moisture(int times)
; 0000 007C {
_moisture:
; .FSTART _moisture
; 0000 007D     float sum=0;
; 0000 007E     int i;
; 0000 007F     for(i=0;i<times;i++)
	CALL SUBOPT_0x6
;	times -> Y+6
;	sum -> Y+2
;	i -> R16,R17
_0x16:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x17
; 0000 0080     {
; 0000 0081         sum = sum + (float)read_adc(6);
	LDI  R26,LOW(6)
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
; 0000 0082     }
	__ADDWRN 16,17,1
	RJMP _0x16
_0x17:
; 0000 0083     return (int)(sum/times);
	RJMP _0x20E000E
; 0000 0084 }
; .FEND
;int temperature(void)
; 0000 0086 {
_temperature:
; .FSTART _temperature
; 0000 0087     return lm75_temperature_10(0)-2;
	LDI  R26,LOW(0)
	CALL _lm75_temperature_10
	SBIW R30,2
	RET
; 0000 0088 }
; .FEND
;int battery_voltage(void)
; 0000 008A {
_battery_voltage:
; .FSTART _battery_voltage
; 0000 008B     return (int)(100*((2.49*255)/((float)read_adc(5))));
	LDI  R26,LOW(5)
	CALL SUBOPT_0x7
	__GETD2N 0x441EBCCD
	CALL __DIVF21
	__GETD2N 0x42C80000
	CALL __MULF12
	CALL __CFD1
	RET
; 0000 008C }
; .FEND
;
;int luminosity(int times)
; 0000 008F {
_luminosity:
; .FSTART _luminosity
; 0000 0090     float sum=0;
; 0000 0091     int i;
; 0000 0092     for(i=0;i<times;i++)
	CALL SUBOPT_0x6
;	times -> Y+6
;	sum -> Y+2
;	i -> R16,R17
_0x19:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x1A
; 0000 0093     {
; 0000 0094         sum = sum + (float)read_adc(2);
	LDI  R26,LOW(2)
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
; 0000 0095     }
	__ADDWRN 16,17,1
	RJMP _0x19
_0x1A:
; 0000 0096     return (int)(sum/times);
_0x20E000E:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__GETD2S 2
	CALL __CWD1
	CALL __CDF1
	CALL __DIVF21
	CALL __CFD1
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
; 0000 0097 }
; .FEND
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 009B {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	CALL SUBOPT_0x9
; 0000 009C // Place your code here
; 0000 009D     char sms_buff[30];
; 0000 009E     int t_out=0;
; 0000 009F     int step=0;
; 0000 00A0     int min, last_min;
; 0000 00A1     int YEAR_,MONTH_,DATE_,HOUR_,MIN_,SEC_;
; 0000 00A2 
; 0000 00A3     //sleep disable:
; 0000 00A4     sleep_disable();
	SBIW R28,44
	CALL __SAVELOCR6
;	sms_buff -> Y+20
;	t_out -> R16,R17
;	step -> R18,R19
;	min -> R20,R21
;	last_min -> Y+18
;	YEAR_ -> Y+16
;	MONTH_ -> Y+14
;	DATE_ -> Y+12
;	HOUR_ -> Y+10
;	MIN_ -> Y+8
;	SEC_ -> Y+6
	CALL SUBOPT_0xA
	CALL _sleep_disable
; 0000 00A5 
; 0000 00A6     min = minute();
	CALL _minute
	MOV  R20,R30
	CLR  R21
; 0000 00A7 
; 0000 00A8     /*
; 0000 00A9     LC1=1;
; 0000 00AA     LR1=1;
; 0000 00AB     delay_ms(10);
; 0000 00AC     LC1=0;
; 0000 00AD     LR1=0;
; 0000 00AE     */
; 0000 00AF 
; 0000 00B0     //if(first_time==1 || min==0)
; 0000 00B1     if(min % 15 == 0 || first_time==1)
	MOVW R26,R20
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL __MODW21
	SBIW R30,0
	BREQ _0x1C
	LDS  R26,_first_time
	CPI  R26,LOW(0x1)
	BREQ _0x1C
	RJMP _0x1B
_0x1C:
; 0000 00B2     {
; 0000 00B3         PORTC.4 = 0; // Turning (OnOff) MOSFET on!
	CBI  0x15,4
; 0000 00B4         first_time=0;
	LDI  R30,LOW(0)
	STS  _first_time,R30
; 0000 00B5 
; 0000 00B6         LED_Disp_show=1; // turning led display on
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 00B7         delay_ms(5000);
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	CALL _delay_ms
; 0000 00B8 
; 0000 00B9         //set values:
; 0000 00BA         val[0]=luminosity(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _luminosity
	STS  _val,R30
	STS  _val+1,R31
; 0000 00BB         val[1]=temperature();
	RCALL _temperature
	__PUTW1MN _val,2
; 0000 00BC         val[2]=moisture(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _moisture
	__PUTW1MN _val,4
; 0000 00BD         val[3]=battery_voltage();
	RCALL _battery_voltage
	__PUTW1MN _val,6
; 0000 00BE         val[4]=0;
	__POINTW1MN _val,8
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 00BF         val[5]=123;
	__POINTW1MN _val,10
	LDI  R26,LOW(123)
	LDI  R27,HIGH(123)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 00C0         val[7]=0;
	__POINTW1MN _val,14
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 00C1 
; 0000 00C2         GICR = (0<<INT1); // disable ext int 1 from RTC
	LDI  R30,LOW(0)
	OUT  0x3B,R30
; 0000 00C3         #asm("sei");
	sei
; 0000 00C4 
; 0000 00C5         //turning on module
; 0000 00C6         if(step==0)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x20
; 0000 00C7         {
; 0000 00C8             if(sim800_on())
	CALL _sim800_on
	SBIW R30,0
	BREQ _0x21
; 0000 00C9             {
; 0000 00CA                 step++;
	__ADDWRN 18,19,1
; 0000 00CB             }
; 0000 00CC             else
_0x21:
; 0000 00CD             {
; 0000 00CE                 //Error on step 0
; 0000 00CF             }
; 0000 00D0         }
; 0000 00D1 
; 0000 00D2         //Step 1: initialize Program basic paramiter  programmer should modify the prog_init() function.
; 0000 00D3         if(step==1)
_0x20:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x23
; 0000 00D4         {
; 0000 00D5             prog_init();
	CALL _prog_init
; 0000 00D6             step++;
	__ADDWRN 18,19,1
; 0000 00D7         }
; 0000 00D8 
; 0000 00D9         //Step 2: initialize Module:
; 0000 00DA         if(step==2)
_0x23:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x24
; 0000 00DB         {
; 0000 00DC             sim800_init("");
	__POINTW2MN _0x25,0
	CALL _sim800_init
; 0000 00DD             step++;
	__ADDWRN 18,19,1
; 0000 00DE         }
; 0000 00DF 
; 0000 00E0         //Step 3: Wait until registeration in network:
; 0000 00E1         if(step==3)
_0x24:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x26
; 0000 00E2         {
; 0000 00E3             t_out=0;
	__GETWRN 16,17,0
; 0000 00E4             while(!check_reg() && t_out<=25)
_0x27:
	CALL _check_reg
	SBIW R30,0
	BRNE _0x2A
	__CPWRN 16,17,26
	BRLT _0x2B
_0x2A:
	RJMP _0x29
_0x2B:
; 0000 00E5             {
; 0000 00E6                  //wait until reg on network
; 0000 00E7                  delay_ms(1000);
	CALL SUBOPT_0xB
; 0000 00E8             }
	RJMP _0x27
_0x29:
; 0000 00E9 
; 0000 00EA             if(t_out<=25)
	__CPWRN 16,17,26
	BRGE _0x2C
; 0000 00EB             {
; 0000 00EC                 val[6]=signal_q();
	CALL _signal_q
	__PUTW1MN _val,12
; 0000 00ED                 step++;
	__ADDWRN 18,19,1
; 0000 00EE             }
; 0000 00EF             else
_0x2C:
; 0000 00F0             {
; 0000 00F1                 //Error on step 3
; 0000 00F2             }
; 0000 00F3         }
; 0000 00F4 
; 0000 00F5         //Step 4: Post data.
; 0000 00F6         if(step==4)
_0x26:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x2E
; 0000 00F7         {
; 0000 00F8             if(post_data(val))
	LDI  R26,LOW(_val)
	LDI  R27,HIGH(_val)
	CALL _post_data
	SBIW R30,0
	BREQ _0x2F
; 0000 00F9             {
; 0000 00FA                 step++;
	__ADDWRN 18,19,1
; 0000 00FB             }
; 0000 00FC             delay_ms(1000);
_0x2F:
	CALL SUBOPT_0xB
; 0000 00FD         }
; 0000 00FE 
; 0000 00FF         //Time IC Settings
; 0000 0100         if(step==5)
_0x2E:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x30
; 0000 0101         {
; 0000 0102             get_server_time(&YEAR_,&MONTH_,&DATE_,&HOUR_,&MIN_,&SEC_);
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
	MOVW R26,R28
	ADIW R26,16
	CALL _get_server_time
; 0000 0103             setDateTime(YEAR_-2000,MONTH_,DATE_,HOUR_,MIN_,SEC_);
	LDD  R30,Y+16
	SUBI R30,LOW(208)
	ST   -Y,R30
	LDD  R30,Y+15
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R30,Y+13
	ST   -Y,R30
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+11
	CALL _setDateTime
; 0000 0104         }
; 0000 0105         sim800_off();
_0x30:
	CALL _sim800_off
; 0000 0106 
; 0000 0107         delay_ms(15000);
	LDI  R26,LOW(15000)
	LDI  R27,HIGH(15000)
	CALL _delay_ms
; 0000 0108         LED_Disp_show=0; // turning led display off
	CLR  R4
	CLR  R5
; 0000 0109         delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 010A     }
; 0000 010B     GICR = (1<<INT1); // re-enable ext int 1 from RTC
_0x1B:
	LDI  R30,LOW(128)
	OUT  0x3B,R30
; 0000 010C     //sleep and interrupt enable
; 0000 010D     #asm("sei");
	sei
; 0000 010E     sleep_enable();
	CALL _sleep_enable
; 0000 010F }
	CALL __LOADLOCR6
	ADIW R28,50
	RJMP _0xD9
; .FEND

	.DSEG
_0x25:
	.BYTE 0x1
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 011A {

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 011B     char data;
; 0000 011C     data=UDR;
	ST   -Y,R17
;	data -> R17
	IN   R17,12
; 0000 011D     //lcd_putchar(data);
; 0000 011E     rec_buff[buff_counter]=data;
	CALL SUBOPT_0xD
	ST   Z,R17
; 0000 011F 
; 0000 0120     buff_counter++;
	LDI  R26,LOW(_buff_counter)
	LDI  R27,HIGH(_buff_counter)
	CALL SUBOPT_0xE
; 0000 0121     if(buff_counter>=rec_buff_size || (rec_buff[buff_counter]=='P' && rec_buff[buff_counter-1]=='I' && rec_buff[buff_cou ...
	LDS  R26,_buff_counter
	LDS  R27,_buff_counter+1
	LDS  R24,_buff_counter+2
	LDS  R25,_buff_counter+3
	__CPD2N 0x366
	BRGE _0x32
	CALL SUBOPT_0xD
	LD   R26,Z
	CPI  R26,LOW(0x50)
	BRNE _0x33
	LDS  R30,_buff_counter
	LDS  R31,_buff_counter+1
	SBIW R30,1
	SUBI R30,LOW(-_rec_buff)
	SBCI R31,HIGH(-_rec_buff)
	LD   R26,Z
	CPI  R26,LOW(0x49)
	BRNE _0x33
	LDS  R30,_buff_counter
	LDS  R31,_buff_counter+1
	SBIW R30,2
	SUBI R30,LOW(-_rec_buff)
	SBCI R31,HIGH(-_rec_buff)
	LD   R26,Z
	CPI  R26,LOW(0x2B)
	BREQ _0x32
_0x33:
	RJMP _0x31
_0x32:
; 0000 0122     {
; 0000 0123        buff_counter=0;
	CALL SUBOPT_0xF
; 0000 0124     }
; 0000 0125 }
_0x31:
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 012C {
; 0000 012D     return 0;
; 0000 012E }
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0138 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	CALL SUBOPT_0x9
; 0000 0139     // Reinitialize Timer 0 value
; 0000 013A     TCNT0=0x28;
	LDI  R30,LOW(40)
	OUT  0x32,R30
; 0000 013B     // Place your code here
; 0000 013C     //refreshing the led datas, each 1 sec
; 0000 013D     if(LED_Disp_show)
	MOV  R0,R4
	OR   R0,R5
	BREQ _0x36
; 0000 013E     {
; 0000 013F         if(k>=500)
	LDS  R26,_k
	LDS  R27,_k+1
	LDS  R24,_k+2
	LDS  R25,_k+3
	__CPD2N 0x1F4
	BRLT _0x37
; 0000 0140         {
; 0000 0141             k=0;
	LDI  R30,LOW(0)
	STS  _k,R30
	STS  _k+1,R30
	STS  _k+2,R30
	STS  _k+3,R30
; 0000 0142             G_Lum=luminosity(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _luminosity
	STS  _G_Lum,R30
	STS  _G_Lum+1,R31
; 0000 0143             G_Temp=temperature();
	RCALL _temperature
	STS  _G_Temp,R30
	STS  _G_Temp+1,R31
; 0000 0144             G_Mois=moisture(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	RCALL _moisture
	STS  _G_Mois,R30
	STS  _G_Mois+1,R31
; 0000 0145             LED_Disp();
	RCALL _LED_Disp
; 0000 0146         }
; 0000 0147         k++;
_0x37:
	LDI  R26,LOW(_k)
	LDI  R27,HIGH(_k)
	CALL SUBOPT_0xE
; 0000 0148     }
; 0000 0149     else
	RJMP _0x38
_0x36:
; 0000 014A     {
; 0000 014B         LED_Disp_clear();
	RCALL _LED_Disp_clear
; 0000 014C     }
_0x38:
; 0000 014D }
_0xD9:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;// Timer2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 0152 {
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R0
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0153     //Reinitialize Timer2 value
; 0000 0154 
; 0000 0155     TCNT2=0x94;
	LDI  R30,LOW(148)
	OUT  0x24,R30
; 0000 0156     //Place your code here
; 0000 0157 
; 0000 0158     turn++;
	LDI  R26,LOW(_turn)
	LDI  R27,HIGH(_turn)
	CALL SUBOPT_0x10
; 0000 0159 
; 0000 015A     if(turn==1 && red_delay>=4)       // Red turn
	CALL SUBOPT_0x11
	SBIW R26,1
	BRNE _0x3A
	LDS  R26,_red_delay
	LDS  R27,_red_delay+1
	SBIW R26,4
	BRGE _0x3B
_0x3A:
	RJMP _0x39
_0x3B:
; 0000 015B     {
; 0000 015C         red_delay = 0;
	LDI  R30,LOW(0)
	STS  _red_delay,R30
	STS  _red_delay+1,R30
; 0000 015D 
; 0000 015E         LC1 = 0;
	CALL SUBOPT_0x12
; 0000 015F         LC2 = 0;
; 0000 0160         LC3 = 0;
; 0000 0161         LC4 = 0;
; 0000 0162         //delay_us(10);
; 0000 0163 
; 0000 0164         LR1 = (Temp_LED > 0) ? 1 : 0;
	CALL SUBOPT_0x13
	CALL __CPW02
	BRGE _0x44
	LDI  R30,LOW(1)
	RJMP _0x45
_0x44:
	LDI  R30,LOW(0)
_0x45:
	CPI  R30,0
	BRNE _0x47
	CBI  0x1B,0
	RJMP _0x48
_0x47:
	SBI  0x1B,0
_0x48:
; 0000 0165         LR2 = (Temp_LED > 1) ? 1 : 0;
	CALL SUBOPT_0x13
	SBIW R26,2
	BRLT _0x49
	LDI  R30,LOW(1)
	RJMP _0x4A
_0x49:
	LDI  R30,LOW(0)
_0x4A:
	CPI  R30,0
	BRNE _0x4C
	CBI  0x18,0
	RJMP _0x4D
_0x4C:
	SBI  0x18,0
_0x4D:
; 0000 0166         LR3 = (Temp_LED > 2) ? 1 : 0;
	CALL SUBOPT_0x13
	SBIW R26,3
	BRLT _0x4E
	LDI  R30,LOW(1)
	RJMP _0x4F
_0x4E:
	LDI  R30,LOW(0)
_0x4F:
	CPI  R30,0
	BRNE _0x51
	CBI  0x18,1
	RJMP _0x52
_0x51:
	SBI  0x18,1
_0x52:
; 0000 0167         LR4 = (Temp_LED > 3) ? 1 : 0;
	CALL SUBOPT_0x13
	SBIW R26,4
	BRLT _0x53
	LDI  R30,LOW(1)
	RJMP _0x54
_0x53:
	LDI  R30,LOW(0)
_0x54:
	CPI  R30,0
	BRNE _0x56
	CBI  0x1B,3
	RJMP _0x57
_0x56:
	SBI  0x1B,3
_0x57:
; 0000 0168         //delay_us(10);
; 0000 0169 
; 0000 016A         LC1 = 1;
	SBI  0x18,4
; 0000 016B         LC2 = 0;
	CBI  0x18,3
; 0000 016C         LC3 = 0;
	CBI  0x1B,1
; 0000 016D         LC4 = 0;
	CBI  0x18,5
; 0000 016E     }
; 0000 016F     else if(turn==2 && blue_delay>=2)  // Blue turn
	RJMP _0x60
_0x39:
	CALL SUBOPT_0x11
	SBIW R26,2
	BRNE _0x62
	LDS  R26,_blue_delay
	LDS  R27,_blue_delay+1
	SBIW R26,2
	BRGE _0x63
_0x62:
	RJMP _0x61
_0x63:
; 0000 0170     {
; 0000 0171         blue_delay = 0;
	LDI  R30,LOW(0)
	STS  _blue_delay,R30
	STS  _blue_delay+1,R30
; 0000 0172 
; 0000 0173         LC1 = 0;
	CALL SUBOPT_0x12
; 0000 0174         LC2 = 0;
; 0000 0175         LC3 = 0;
; 0000 0176         LC4 = 0;
; 0000 0177         //delay_us(10);
; 0000 0178 
; 0000 0179         LR1 = (Hum_LED > 0) ? 1 : 0;
	CALL SUBOPT_0x14
	CALL __CPW02
	BRGE _0x6C
	LDI  R30,LOW(1)
	RJMP _0x6D
_0x6C:
	LDI  R30,LOW(0)
_0x6D:
	CPI  R30,0
	BRNE _0x6F
	CBI  0x1B,0
	RJMP _0x70
_0x6F:
	SBI  0x1B,0
_0x70:
; 0000 017A         LR2 = (Hum_LED > 1) ? 1 : 0;
	CALL SUBOPT_0x14
	SBIW R26,2
	BRLT _0x71
	LDI  R30,LOW(1)
	RJMP _0x72
_0x71:
	LDI  R30,LOW(0)
_0x72:
	CPI  R30,0
	BRNE _0x74
	CBI  0x18,0
	RJMP _0x75
_0x74:
	SBI  0x18,0
_0x75:
; 0000 017B         LR3 = (Hum_LED > 2) ? 1 : 0;
	CALL SUBOPT_0x14
	SBIW R26,3
	BRLT _0x76
	LDI  R30,LOW(1)
	RJMP _0x77
_0x76:
	LDI  R30,LOW(0)
_0x77:
	CPI  R30,0
	BRNE _0x79
	CBI  0x18,1
	RJMP _0x7A
_0x79:
	SBI  0x18,1
_0x7A:
; 0000 017C         LR4 = (Hum_LED > 3) ? 1 : 0;
	CALL SUBOPT_0x14
	SBIW R26,4
	BRLT _0x7B
	LDI  R30,LOW(1)
	RJMP _0x7C
_0x7B:
	LDI  R30,LOW(0)
_0x7C:
	CPI  R30,0
	BRNE _0x7E
	CBI  0x1B,3
	RJMP _0x7F
_0x7E:
	SBI  0x1B,3
_0x7F:
; 0000 017D         //delay_us(10);
; 0000 017E 
; 0000 017F         LC1 = 0;
	CBI  0x18,4
; 0000 0180         LC2 = 1;
	SBI  0x18,3
; 0000 0181         LC3 = 0;
	CBI  0x1B,1
; 0000 0182         LC4 = 0;
	CBI  0x18,5
; 0000 0183     }
; 0000 0184     else if(turn==3)  // Green turn
	RJMP _0x88
_0x61:
	CALL SUBOPT_0x11
	SBIW R26,3
	BRNE _0x89
; 0000 0185     {
; 0000 0186         LC1 = 0;
	CALL SUBOPT_0x12
; 0000 0187         LC2 = 0;
; 0000 0188         LC3 = 0;
; 0000 0189         LC4 = 0;
; 0000 018A         //delay_us(10);
; 0000 018B 
; 0000 018C         LR1 = (Lux_LED > 2) ? 1 : 0;
	CALL SUBOPT_0x15
	SBIW R26,3
	BRLT _0x92
	LDI  R30,LOW(1)
	RJMP _0x93
_0x92:
	LDI  R30,LOW(0)
_0x93:
	CPI  R30,0
	BRNE _0x95
	CBI  0x1B,0
	RJMP _0x96
_0x95:
	SBI  0x1B,0
_0x96:
; 0000 018D         LR2 = (Lux_LED > 1) ? 1 : 0;
	CALL SUBOPT_0x15
	SBIW R26,2
	BRLT _0x97
	LDI  R30,LOW(1)
	RJMP _0x98
_0x97:
	LDI  R30,LOW(0)
_0x98:
	CPI  R30,0
	BRNE _0x9A
	CBI  0x18,0
	RJMP _0x9B
_0x9A:
	SBI  0x18,0
_0x9B:
; 0000 018E         LR3 = (Lux_LED > 0) ? 1 : 0;
	CALL SUBOPT_0x15
	CALL __CPW02
	BRGE _0x9C
	LDI  R30,LOW(1)
	RJMP _0x9D
_0x9C:
	LDI  R30,LOW(0)
_0x9D:
	CPI  R30,0
	BRNE _0x9F
	CBI  0x18,1
	RJMP _0xA0
_0x9F:
	SBI  0x18,1
_0xA0:
; 0000 018F         LR4 = (Lux_LED > 3) ? 1 : 0;
	CALL SUBOPT_0x15
	SBIW R26,4
	BRLT _0xA1
	LDI  R30,LOW(1)
	RJMP _0xA2
_0xA1:
	LDI  R30,LOW(0)
_0xA2:
	CPI  R30,0
	BRNE _0xA4
	CBI  0x1B,3
	RJMP _0xA5
_0xA4:
	SBI  0x1B,3
_0xA5:
; 0000 0190         //delay_us(10);
; 0000 0191 
; 0000 0192         LC1 = 0;
	CBI  0x18,4
; 0000 0193         LC2 = 0;
	CBI  0x18,3
; 0000 0194         LC3 = 1;
	SBI  0x1B,1
; 0000 0195         LC4 = 0;
	CBI  0x18,5
; 0000 0196     }
; 0000 0197     else if(turn==4)  // Head turn
	RJMP _0xAE
_0x89:
	CALL SUBOPT_0x11
	SBIW R26,4
	BREQ PC+2
	RJMP _0xAF
; 0000 0198     {
; 0000 0199         LC1 = 0;
	CALL SUBOPT_0x12
; 0000 019A         LC2 = 0;
; 0000 019B         LC3 = 0;
; 0000 019C         LC4 = 0;
; 0000 019D         //delay_us(10);
; 0000 019E 
; 0000 019F         LR1 = (Green == 1) ? 1 : 0;
	LDS  R26,_Green
	LDS  R27,_Green+1
	SBIW R26,1
	BRNE _0xB8
	LDI  R30,LOW(1)
	RJMP _0xB9
_0xB8:
	LDI  R30,LOW(0)
_0xB9:
	CPI  R30,0
	BRNE _0xBB
	CBI  0x1B,0
	RJMP _0xBC
_0xBB:
	SBI  0x1B,0
_0xBC:
; 0000 01A0         LR2 = (0 == 0) ? 0 : 0;;
	CBI  0x18,0
; 0000 01A1         LR3 = (Blue == 1) ? 1 : 0;
	LDS  R26,_Blue
	LDS  R27,_Blue+1
	SBIW R26,1
	BRNE _0xBF
	LDI  R30,LOW(1)
	RJMP _0xC0
_0xBF:
	LDI  R30,LOW(0)
_0xC0:
	CPI  R30,0
	BRNE _0xC2
	CBI  0x18,1
	RJMP _0xC3
_0xC2:
	SBI  0x18,1
_0xC3:
; 0000 01A2         LR4 = (Red == 1) ? 1 : 0;
	LDS  R26,_Red
	LDS  R27,_Red+1
	SBIW R26,1
	BRNE _0xC4
	LDI  R30,LOW(1)
	RJMP _0xC5
_0xC4:
	LDI  R30,LOW(0)
_0xC5:
	CPI  R30,0
	BRNE _0xC7
	CBI  0x1B,3
	RJMP _0xC8
_0xC7:
	SBI  0x1B,3
_0xC8:
; 0000 01A3         //delay_us(10);
; 0000 01A4 
; 0000 01A5         LC1 = 0;
	CBI  0x18,4
; 0000 01A6         LC2 = 0;
	CBI  0x18,3
; 0000 01A7         LC3 = 0;
	CBI  0x1B,1
; 0000 01A8         LC4 = (head_onoff == 1);
	LDS  R26,_head_onoff
	LDS  R27,_head_onoff+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	CPI  R30,0
	BRNE _0xCF
	CBI  0x18,5
	RJMP _0xD0
_0xCF:
	SBI  0x18,5
_0xD0:
; 0000 01A9 
; 0000 01AA         turn = 0;
	LDI  R30,LOW(0)
	STS  _turn,R30
	STS  _turn+1,R30
; 0000 01AB         blue_delay++;
	LDI  R26,LOW(_blue_delay)
	LDI  R27,HIGH(_blue_delay)
	CALL SUBOPT_0x10
; 0000 01AC         red_delay++;
	LDI  R26,LOW(_red_delay)
	LDI  R27,HIGH(_red_delay)
	CALL SUBOPT_0x10
; 0000 01AD     }
; 0000 01AE 
; 0000 01AF }
_0xAF:
_0xAE:
_0x88:
_0x60:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void main(void)
; 0000 01B2 {
_main:
; .FSTART _main
; 0000 01B3 // Declare your local variables here
; 0000 01B4 
; 0000 01B5 // Input/Output Ports initialization
; 0000 01B6 // Port A initialization
; 0000 01B7 // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=In Bit1=Out Bit0=Out
; 0000 01B8 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (1<<DDA4) | (1<<DDA3) | (0<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(27)
	OUT  0x1A,R30
; 0000 01B9 // State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=0 Bit2=T Bit1=0 Bit0=0
; 0000 01BA PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 01BB 
; 0000 01BC // Port B initialization
; 0000 01BD // Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=In Bit1=Out Bit0=Out
; 0000 01BE DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (0<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(59)
	OUT  0x17,R30
; 0000 01BF // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 01C0 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 01C1 
; 0000 01C2 // Port C initialization
; 0000 01C3 // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 01C4 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (1<<DDC4) | (1<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(24)
	OUT  0x14,R30
; 0000 01C5 // State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 01C6 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 01C7 
; 0000 01C8 // Port D initialization
; 0000 01C9 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 01CA DDRD=(0<<DDD7) | (0<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(32)
	OUT  0x11,R30
; 0000 01CB // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 01CC PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 01CD 
; 0000 01CE // Timer/Counter 0 initialization
; 0000 01CF // Clock source: System Clock
; 0000 01D0 // Clock value: 43.200 kHz
; 0000 01D1 // Mode: Normal top=0xFF
; 0000 01D2 // OC0 output: Disconnected
; 0000 01D3 // Timer Period: 5 ms
; 0000 01D4 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0000 01D5 TCNT0=0x28;
	LDI  R30,LOW(40)
	OUT  0x32,R30
; 0000 01D6 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 01D7 
; 0000 01D8 // Timer/Counter 1 initialization
; 0000 01D9 // Clock source: System Clock
; 0000 01DA // Clock value: 1382.400 kHz
; 0000 01DB // Mode: Fast PWM top=0x00FF
; 0000 01DC // OC1A output: Non-Inverted PWM
; 0000 01DD // OC1B output: Disconnected
; 0000 01DE // Noise Canceler: Off
; 0000 01DF // Input Capture on Falling Edge
; 0000 01E0 // Timer Period: 0.18519 ms
; 0000 01E1 // Output Pulse(s):
; 0000 01E2 // OC1A Period: 0.18519 ms Width: 0 us
; 0000 01E3 // Timer1 Overflow Interrupt: On
; 0000 01E4 // Input Capture Interrupt: Off
; 0000 01E5 // Compare A Match Interrupt: Off
; 0000 01E6 // Compare B Match Interrupt: Off
; 0000 01E7 TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(129)
	OUT  0x2F,R30
; 0000 01E8 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
	LDI  R30,LOW(10)
	OUT  0x2E,R30
; 0000 01E9 TCNT1H=0xF7;
	LDI  R30,LOW(247)
	OUT  0x2D,R30
; 0000 01EA TCNT1L=0x5C;
	LDI  R30,LOW(92)
	OUT  0x2C,R30
; 0000 01EB ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 01EC ICR1L=0x00;
	OUT  0x26,R30
; 0000 01ED OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 01EE OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01EF OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01F0 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01F1 
; 0000 01F2 // Timer/Counter 2 initialization
; 0000 01F3 // Clock source: System Clock
; 0000 01F4 // Clock value: 172.800 kHz
; 0000 01F5 // Mode: Normal top=0xFF
; 0000 01F6 // OC2 output: Disconnected
; 0000 01F7 // Timer Period: 1.0012 ms
; 0000 01F8 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 01F9 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (1<<CS22) | (0<<CS21) | (0<<CS20);
	LDI  R30,LOW(4)
	OUT  0x25,R30
; 0000 01FA TCNT2=0x53;
	LDI  R30,LOW(83)
	OUT  0x24,R30
; 0000 01FB OCR2=0x00;
	LDI  R30,LOW(0)
	OUT  0x23,R30
; 0000 01FC 
; 0000 01FD // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01FE TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(65)
	OUT  0x39,R30
; 0000 01FF 
; 0000 0200 // External Interrupt(s) initialization
; 0000 0201 // INT0: Off
; 0000 0202 // INT1: On
; 0000 0203 // INT1 Mode: Falling Edge
; 0000 0204 // INT2: Off
; 0000 0205 GICR|=(1<<INT1) | (0<<INT0) | (0<<INT2);
	IN   R30,0x3B
	ORI  R30,0x80
	OUT  0x3B,R30
; 0000 0206 MCUCR=(1<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(8)
	OUT  0x35,R30
; 0000 0207 MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 0208 GIFR=(1<<INTF1) | (0<<INTF0) | (0<<INTF2);
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0000 0209 
; 0000 020A // USART initialization
; 0000 020B // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 020C // USART Receiver: On
; 0000 020D // USART Transmitter: On
; 0000 020E // USART Mode: Asynchronous
; 0000 020F // USART Baud Rate: 9600
; 0000 0210 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0211 UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 0212 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0213 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0214 UBRRL=0x47;
	LDI  R30,LOW(71)
	OUT  0x9,R30
; 0000 0215 
; 0000 0216 // Analog Comparator initialization
; 0000 0217 // Analog Comparator: Off
; 0000 0218 // The Analog Comparator's positive input is
; 0000 0219 // connected to the AIN0 pin
; 0000 021A // The Analog Comparator's negative input is
; 0000 021B // connected to the AIN1 pin
; 0000 021C ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 021D 
; 0000 021E // ADC initialization
; 0000 021F // ADC Clock frequency: 691.200 kHz
; 0000 0220 // ADC Voltage Reference: AREF pin
; 0000 0221 // ADC Auto Trigger Source: ADC Stopped
; 0000 0222 // Only the 8 most significant bits of
; 0000 0223 // the AD conversion result are used
; 0000 0224 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 0225 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 0226 SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0227 
; 0000 0228 // SPI initialization
; 0000 0229 // SPI disabled
; 0000 022A SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 022B 
; 0000 022C // TWI initialization
; 0000 022D // TWI disabled
; 0000 022E TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 022F 
; 0000 0230 // Bit-Banged I2C Bus initialization
; 0000 0231 // I2C Port: PORTC
; 0000 0232 // I2C SDA bit: 0
; 0000 0233 // I2C SCL bit: 1
; 0000 0234 // Bit Rate: 100 kHz
; 0000 0235 // Note: I2C settings are specified in the
; 0000 0236 // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 0237 i2c_init();
	CALL _i2c_init
; 0000 0238 
; 0000 0239 // LM75 Temperature Sensor initialization
; 0000 023A // thyst: 75°C
; 0000 023B // tos: 80°C
; 0000 023C // O.S. polarity: 0
; 0000 023D lm75_init(0,75,80,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(75)
	ST   -Y,R30
	LDI  R30,LOW(80)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lm75_init
; 0000 023E 
; 0000 023F //first time:
; 0000 0240 first_time=1;
	LDI  R30,LOW(1)
	STS  _first_time,R30
; 0000 0241 
; 0000 0242 setDateTime(17,1,1,12,5,5);
	LDI  R30,LOW(17)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(5)
	RCALL _setDateTime
; 0000 0243 
; 0000 0244 LED_Disp_clear();
	RCALL _LED_Disp_clear
; 0000 0245 
; 0000 0246 PORTA.4 = 0; // MOSVCC on!
	CBI  0x1B,4
; 0000 0247 OCR1A = 500;
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0248 
; 0000 0249 delay_ms(500);
	CALL SUBOPT_0x16
; 0000 024A // Global enable interrupts
; 0000 024B 
; 0000 024C #asm("sei")
	sei
; 0000 024D sleep_enable();
	CALL _sleep_enable
; 0000 024E idle();
	CALL _idle
; 0000 024F delay_ms(3000);
	CALL SUBOPT_0x17
; 0000 0250 
; 0000 0251 while (1)
_0xD3:
; 0000 0252       {
; 0000 0253          /*
; 0000 0254          Red = (i<11);
; 0000 0255          Blue = (i > 11 && i < 22);
; 0000 0256          Green = (i > 22);
; 0000 0257          Temp_LED = timing[(i)%33];
; 0000 0258          Hum_LED = timing[(i+22)%33];
; 0000 0259          Lux_LED = timing[(i+11)%33];
; 0000 025A          i++;
; 0000 025B          i=i%33;
; 0000 025C          delay_ms(60);
; 0000 025D          */
; 0000 025E          //Temp = lm75_temperature_10(0);  //requires 300ms delay afterwards
; 0000 025F          //Hum = read_adc(6);
; 0000 0260          //printf("%02d:%02d:%02d\n",hour24(),minute(),second());
; 0000 0261          //printf("%d\n",Hum);
; 0000 0262          //delay_ms(1000);
; 0000 0263 
; 0000 0264          PORTA.4 = 0; // MOSVCC on!
	CBI  0x1B,4
; 0000 0265          GICR|=(1<<INT1) | (0<<INT0) | (0<<INT2);
	IN   R30,0x3B
	ORI  R30,0x80
	OUT  0x3B,R30
; 0000 0266 
; 0000 0267 
; 0000 0268          #asm("sei");
	sei
; 0000 0269          sleep_enable();
	CALL _sleep_enable
; 0000 026A          idle();
	CALL _idle
; 0000 026B 
; 0000 026C          //delay_ms(1000);
; 0000 026D          //goto sleep
; 0000 026E 
; 0000 026F       }
	RJMP _0xD3
; 0000 0270 }
_0xD8:
	RJMP _0xD8
; .FEND
;#include <MCP79410.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;unsigned char make_hex(unsigned char num)
; 0001 0004 {

	.CSEG
_make_hex:
; .FSTART _make_hex
; 0001 0005     unsigned char units = num % 10;
; 0001 0006     unsigned char tens = num / 10;
; 0001 0007     return (tens << 4) | units;
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	num -> Y+2
;	units -> R17
;	tens -> R16
	LDD  R26,Y+2
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	MOV  R17,R30
	LDD  R26,Y+2
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOV  R16,R30
	SWAP R30
	ANDI R30,0xF0
	OR   R30,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20E0003
; 0001 0008 }
; .FEND
;
;unsigned char make_dec(unsigned char num)
; 0001 000B {
_make_dec:
; .FSTART _make_dec
; 0001 000C     unsigned char units = num & 0x0F;
; 0001 000D     unsigned char tens = num >> 4;
; 0001 000E     return tens*10 + units;
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	num -> Y+2
;	units -> R17
;	tens -> R16
	LDD  R30,Y+2
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	LDD  R30,Y+2
	SWAP R30
	ANDI R30,0xF
	MOV  R16,R30
	LDI  R26,LOW(10)
	MULS R16,R26
	MOVW R30,R0
	ADD  R30,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20E0003
; 0001 000F }
; .FEND
;void WriteRTCByte(unsigned char adr, unsigned char data)
; 0001 0011 {
_WriteRTCByte:
; .FSTART _WriteRTCByte
; 0001 0012     i2c_start();
	ST   -Y,R26
;	adr -> Y+1
;	data -> Y+0
	CALL SUBOPT_0x18
; 0001 0013     i2c_write(0b11011110);
; 0001 0014     i2c_write(adr);
; 0001 0015     i2c_write(data);
	LD   R26,Y
	CALL SUBOPT_0x19
; 0001 0016     i2c_stop();
; 0001 0017 }
	RJMP _0x20E000D
; .FEND
;
;unsigned char ReadRTCByte(unsigned char adr)
; 0001 001A {
_ReadRTCByte:
; .FSTART _ReadRTCByte
; 0001 001B   unsigned char data;
; 0001 001C   i2c_start();
	ST   -Y,R26
	ST   -Y,R17
;	adr -> Y+1
;	data -> R17
	CALL SUBOPT_0x18
; 0001 001D   i2c_write(0b11011110);
; 0001 001E   i2c_write(adr);
; 0001 001F   i2c_start();
	CALL _i2c_start
; 0001 0020   i2c_write(0b11011111);
	LDI  R26,LOW(223)
	CALL _i2c_write
; 0001 0021   data=i2c_read(0);
	LDI  R26,LOW(0)
	CALL _i2c_read
	MOV  R17,R30
; 0001 0022   return data;
	LDD  R17,Y+0
	RJMP _0x20E000D
; 0001 0023 }
; .FEND
;
;unsigned char getRTCData(const unsigned char adr, const unsigned char validbits)
; 0001 0026 {
_getRTCData:
; .FSTART _getRTCData
; 0001 0027   unsigned char data;
; 0001 0028   data = ReadRTCByte(adr);
	ST   -Y,R26
	ST   -Y,R17
;	adr -> Y+2
;	validbits -> Y+1
;	data -> R17
	LDD  R26,Y+2
	RCALL _ReadRTCByte
	MOV  R17,R30
; 0001 0029   data = data & (0xff >> (8-validbits));
	LDD  R26,Y+1
	LDI  R30,LOW(8)
	SUB  R30,R26
	LDI  R26,LOW(255)
	LDI  R27,HIGH(255)
	CALL __LSRW12
	AND  R17,R30
; 0001 002A   return data;
	MOV  R30,R17
	LDD  R17,Y+0
	JMP  _0x20E0003
; 0001 002B }
; .FEND
;
;void setDateTime (unsigned char year, unsigned char month, unsigned char day, unsigned char hour, unsigned char minute,  ...
; 0001 002E {
_setDateTime:
; .FSTART _setDateTime
; 0001 002F     unsigned char hh = make_hex(hour);
; 0001 0030     unsigned char mm = make_hex(minute);
; 0001 0031     unsigned char ss = make_hex(second);
; 0001 0032 
; 0001 0033     WriteRTCByte(0,0);       //STOP RTC
	ST   -Y,R26
	CALL __SAVELOCR4
;	year -> Y+9
;	month -> Y+8
;	day -> Y+7
;	hour -> Y+6
;	minute -> Y+5
;	second -> Y+4
;	hh -> R17
;	mm -> R16
;	ss -> R19
	LDD  R26,Y+6
	RCALL _make_hex
	MOV  R17,R30
	LDD  R26,Y+5
	RCALL _make_hex
	MOV  R16,R30
	LDD  R26,Y+4
	RCALL _make_hex
	MOV  R19,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _WriteRTCByte
; 0001 0034 
; 0001 0035     WriteRTCByte(7,0b01000000);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(64)
	RCALL _WriteRTCByte
; 0001 0036     WriteRTCByte(1,mm);    //MINUTE=18
	LDI  R30,LOW(1)
	ST   -Y,R30
	MOV  R26,R16
	RCALL _WriteRTCByte
; 0001 0037     WriteRTCByte(2,hh);    //HOUR=8
	LDI  R30,LOW(2)
	ST   -Y,R30
	MOV  R26,R17
	RCALL _WriteRTCByte
; 0001 0038     WriteRTCByte(3,0x09);    //DAY=1(MONDAY) AND VBAT=1
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(9)
	RCALL _WriteRTCByte
; 0001 0039     WriteRTCByte(4,day-1);    //DATE=28
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDD  R26,Y+8
	SUBI R26,LOW(1)
	RCALL _WriteRTCByte
; 0001 003A     WriteRTCByte(5,month);    //MONTH=2
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDD  R26,Y+9
	RCALL _WriteRTCByte
; 0001 003B     WriteRTCByte(6,year);    //YEAR=11
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDD  R26,Y+10
	RCALL _WriteRTCByte
; 0001 003C     WriteRTCByte(0,0x80);    //START RTC, SECOND=00
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(128)
	RCALL _WriteRTCByte
; 0001 003D }
	CALL __LOADLOCR4
	ADIW R28,10
	RET
; .FEND
;
;unsigned char second(void) { return make_dec(getRTCData(0,7)) ;}
; 0001 003F unsigned char second(void) { return make_dec(getRTCData(0,7)) ;}
;unsigned char minute(void) { return make_dec(getRTCData(1,7)) ;}
; 0001 0040 unsigned char minute(void) { return make_dec(getRTCData(1,7)) ;}
_minute:
; .FSTART _minute
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(7)
	RCALL _getRTCData
	MOV  R26,R30
	RCALL _make_dec
	RET
; .FEND
;unsigned char hour24(void) { return make_dec(getRTCData(2,6)) ;}
; 0001 0041 unsigned char hour24(void) { return make_dec(getRTCData(2,6)) ;}
;unsigned char day(void) { return make_dec(getRTCData(4,6)) ;}
; 0001 0042 unsigned char day(void) { return make_dec(getRTCData(4,6)) ;}
;unsigned char month(void) { return make_dec(getRTCData(5,5)) ;}
; 0001 0043 unsigned char month(void) { return make_dec(getRTCData(5,5)) ;}
;unsigned char year(void) { return make_dec(getRTCData(6,8)) ;}
; 0001 0044 unsigned char year(void) { return make_dec(getRTCData(6,8)) ;}
;#include "SIM800.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;extern char rec_buff[rec_buff_size];
;extern long int buff_counter;
;
;extern int val[8];
;extern char VAR_1[7];
;extern char VAR_2[7];
;extern char VAR_3[7];
;extern char VAR_4[7];
;extern char VAR_5[7];
;extern char VAR_6[7];
;extern char VAR_7[7];
;extern char VAR_8[7];
;extern char _SERVER_[20];
;extern char _APN_[20];
;extern char _HOST_[20];
;extern char _PAGEADDRESS_[50];
;extern char _SUCCESSSIGN_[20];
;
;//Functions:
;//This Function is for emptying any array || buff_2_empty: The Array || cells_2_empty: the number of cells should be cle ...
;void emp_str(char *buff_2_empty,int cells_2_empty)
; 0002 0018 {

	.CSEG
_emp_str:
; .FSTART _emp_str
; 0002 0019     int ii;
; 0002 001A     for (ii=0;ii<cells_2_empty;ii++)
	CALL SUBOPT_0x1A
;	*buff_2_empty -> Y+4
;	cells_2_empty -> Y+2
;	ii -> R16,R17
	__GETWRN 16,17,0
_0x40004:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x40005
; 0002 001B     {
; 0002 001C         buff_2_empty[ii]='\0';
	MOVW R30,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
; 0002 001D     }
	__ADDWRN 16,17,1
	RJMP _0x40004
_0x40005:
; 0002 001E }
	RJMP _0x20E000A
; .FEND
;
;//This Function is for searching the recieved buffer from GSM Module for a specific string. if the string found, it will ...
;//Headers Needed: string.h
;//Global vars needed: rec_buff
;int search(char *str_to_search)
; 0002 0024 {
_search:
; .FSTART _search
; 0002 0025     if(strstr(rec_buff,str_to_search))
	ST   -Y,R27
	ST   -Y,R26
;	*str_to_search -> Y+0
	LDI  R30,LOW(_rec_buff)
	LDI  R31,HIGH(_rec_buff)
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL _strstr
	SBIW R30,0
	BREQ _0x40006
; 0002 0026     {
; 0002 0027         return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x20E000D
; 0002 0028     }
; 0002 0029     else
_0x40006:
; 0002 002A     {
; 0002 002B         return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20E000D
; 0002 002C     }
; 0002 002D }
; .FEND
;
;//This function waites until it saw a specefic string in recieved buffer.
;//Input paramiters: str_2_s: string to see, time_out: time out in sec
;//output: if saw before time out:1 else 0
;//headers needed: delay.h
;int wait_until(char* str_2_s,int time_out)
; 0002 0034 {
_wait_until:
; .FSTART _wait_until
; 0002 0035     int t_out=1;
; 0002 0036     while(!search(str_2_s) && t_out<=10*time_out)
	CALL SUBOPT_0x1A
;	*str_2_s -> Y+4
;	time_out -> Y+2
;	t_out -> R16,R17
	__GETWRN 16,17,1
_0x40008:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL _search
	SBIW R30,0
	BRNE _0x4000B
	CALL SUBOPT_0x1B
	CP   R30,R16
	CPC  R31,R17
	BRGE _0x4000C
_0x4000B:
	RJMP _0x4000A
_0x4000C:
; 0002 0037     {
; 0002 0038         t_out++;
	__ADDWRN 16,17,1
; 0002 0039         delay_ms(100);
	CALL SUBOPT_0x1C
; 0002 003A     }
	RJMP _0x40008
_0x4000A:
; 0002 003B     if(t_out<10*time_out)
	CALL SUBOPT_0x1B
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x4000D
; 0002 003C     {
; 0002 003D         return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x20E000A
; 0002 003E     }
; 0002 003F     else
_0x4000D:
; 0002 0040     {
; 0002 0041         return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20E000A
; 0002 0042     }
; 0002 0043 }
; .FEND
;
;//This function clears All cell in rec_buff (data from module)
;//Global Vars Needed: buff_counter, rec_buff
;void clear_rec_buff(void)
; 0002 0048 {
_clear_rec_buff:
; .FSTART _clear_rec_buff
; 0002 0049     emp_str(rec_buff,rec_buff_size-1);
	LDI  R30,LOW(_rec_buff)
	LDI  R31,HIGH(_rec_buff)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(869)
	LDI  R27,HIGH(869)
	RCALL _emp_str
; 0002 004A     buff_counter=0;
	CALL SUBOPT_0xF
; 0002 004B }
	RET
; .FEND
;
;//AT Command send Function.
;void at_command(char* at_cmnd)
; 0002 004F {
_at_command:
; .FSTART _at_command
; 0002 0050    printf("%s%c",at_cmnd,0x0d);
	ST   -Y,R27
	ST   -Y,R26
;	*at_cmnd -> Y+0
	__POINTW1FN _0x40000,0
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x1D
	__GETD1N 0xD
	CALL __PUTPARD1
	LDI  R24,8
	CALL _printf
	ADIW R28,10
; 0002 0051 }
_0x20E000D:
	ADIW R28,2
	RET
; .FEND
;
;//õSend Ctrl+Z to Modem:
;//Headers Needed: delay.h
;ctrl_z(void)
; 0002 0056 {
_ctrl_z:
; .FSTART _ctrl_z
; 0002 0057     delay_ms(100);
	CALL SUBOPT_0x1C
; 0002 0058     printf("%c",0x1a);
	__POINTW1FN _0x40000,2
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x1A
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
; 0002 0059     delay_ms(50);
	CALL SUBOPT_0x1E
; 0002 005A }
	RET
; .FEND
;
;//This Function initialize the sim800 Module || pin_code: the simcard pin
;//if pin code is deactivated, let it be free like this: sim800_init("")
;//Headers Needed: delay.h
;void sim800_init(char* pin_code)
; 0002 0060 {
_sim800_init:
; .FSTART _sim800_init
; 0002 0061     char at_buff[12];
; 0002 0062 
; 0002 0063     at_command("ATZ");  //Reset Module
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,12
;	*pin_code -> Y+12
;	at_buff -> Y+0
	__POINTW2MN _0x4000F,0
	CALL SUBOPT_0x1F
; 0002 0064     delay_ms(100);
; 0002 0065     at_command("AT&F"); //Factory reset Module
	__POINTW2MN _0x4000F,4
	RCALL _at_command
; 0002 0066     delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0002 0067 
; 0002 0068     at_command("AT+CMEE=1"); //Deactive echo
	__POINTW2MN _0x4000F,9
	RCALL _at_command
; 0002 0069     delay_ms(50);
	CALL SUBOPT_0x1E
; 0002 006A 
; 0002 006B     //at_command("ATE0"); //Deactive echo
; 0002 006C     delay_ms(50);
	CALL SUBOPT_0x1E
; 0002 006D 
; 0002 006E     clear_rec_buff();
	RCALL _clear_rec_buff
; 0002 006F     //check pin code:
; 0002 0070     at_command("AT+CPIN?");
	__POINTW2MN _0x4000F,19
	RCALL _at_command
; 0002 0071     delay_ms(50);
	CALL SUBOPT_0x1E
; 0002 0072 
; 0002 0073     if(!search("READY"))
	__POINTW2MN _0x4000F,28
	RCALL _search
	SBIW R30,0
	BRNE _0x40010
; 0002 0074     {
; 0002 0075         sprintf(at_buff,"AT+CPIN=\"%s\"",pin_code);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x40000,39
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x20
; 0002 0076         at_command(at_buff);
	MOVW R26,R28
	CALL SUBOPT_0x1F
; 0002 0077         delay_ms(100);
; 0002 0078     }
; 0002 0079 }
_0x40010:
	ADIW R28,14
	RET
; .FEND

	.DSEG
_0x4000F:
	.BYTE 0x22
;
;//This Function initialize sending sms in module.
;//headers needed: delay.h
;void sms_init(void)
; 0002 007E {

	.CSEG
; 0002 007F     at_command("AT+CMGF=1");
; 0002 0080     delay_ms(50);
; 0002 0081 
; 0002 0082     at_command("AT+CSMP=17,196,0,0");
; 0002 0083     delay_ms(50);
; 0002 0084 
; 0002 0085     at_command("AT+CSCS=\"GSM\"");
; 0002 0086     delay_ms(50);
; 0002 0087 }

	.DSEG
_0x40011:
	.BYTE 0x2B
;
;//This Function will check if the module is respond.
;int sim_800_ping(void)
; 0002 008B {

	.CSEG
; 0002 008C     clear_rec_buff();
; 0002 008D     at_command("AT");
; 0002 008E     if(wait_until("OK",1))
; 0002 008F     {
; 0002 0090        delay_ms(50);
; 0002 0091        return 1;
; 0002 0092     }
; 0002 0093     else
; 0002 0094     {
; 0002 0095         delay_ms(50);
; 0002 0096         return 0;
; 0002 0097     }
; 0002 0098 }

	.DSEG
_0x40012:
	.BYTE 0x6
;//This Function checks the Module registration in network
;//Headers needed: delay.h
;int check_reg(void)
; 0002 009C {

	.CSEG
_check_reg:
; .FSTART _check_reg
; 0002 009D     clear_rec_buff();
	RCALL _clear_rec_buff
; 0002 009E     at_command("AT+CREG?");
	__POINTW2MN _0x40015,0
	CALL SUBOPT_0x1F
; 0002 009F     delay_ms(100);
; 0002 00A0     if(search("0,1"))
	__POINTW2MN _0x40015,9
	RCALL _search
	SBIW R30,0
	BREQ _0x40016
; 0002 00A1     {
; 0002 00A2         return 1;
	RJMP _0x20E0005
; 0002 00A3     }
; 0002 00A4     else
_0x40016:
; 0002 00A5     {
; 0002 00A6         return 0;
	RJMP _0x20E0007
; 0002 00A7     }
; 0002 00A8 }
; .FEND

	.DSEG
_0x40015:
	.BYTE 0xD
;
;//This Function sends sms
;//headers needed: delay.h
;int send_sms(char* sms_text, char* phone_number)
; 0002 00AD {

	.CSEG
; 0002 00AE     char at_buff[25];
; 0002 00AF     int time_out=0;
; 0002 00B0     int stat=0;
; 0002 00B1 
; 0002 00B2     sms_init();
;	*sms_text -> Y+31
;	*phone_number -> Y+29
;	at_buff -> Y+4
;	time_out -> R16,R17
;	stat -> R18,R19
; 0002 00B3     clear_rec_buff();
; 0002 00B4     sprintf(at_buff,"AT+CMGS=\"+%s\"",phone_number);
; 0002 00B5     at_command(at_buff);
; 0002 00B6     delay_ms(100);
; 0002 00B7     while(!search(">") && time_out<50)
; 0002 00B8     {
; 0002 00B9         time_out++;
; 0002 00BA         delay_ms(100);
; 0002 00BB     }
; 0002 00BC     if(time_out<50)  //means that it saw >
; 0002 00BD     {
; 0002 00BE         printf("%s",sms_text);
; 0002 00BF         delay_ms(1000);
; 0002 00C0         ctrl_z();
; 0002 00C1 
; 0002 00C2         time_out=0;
; 0002 00C3         clear_rec_buff();
; 0002 00C4         while(!search("OK") && time_out<10)
; 0002 00C5         {
; 0002 00C6             time_out++;
; 0002 00C7             delay_ms(1000);
; 0002 00C8         }
; 0002 00C9         if(time_out<10)
; 0002 00CA         {
; 0002 00CB             stat=1;
; 0002 00CC         }
; 0002 00CD     }
; 0002 00CE     return stat;
; 0002 00CF }

	.DSEG
_0x4001B:
	.BYTE 0x5
;
;//This function initializes socket connection in module
;//Example: socket_init("Irancell-GPRS")
;//headers needed: delay.h
;int socket_init(char* APN_name)
; 0002 00D5 {

	.CSEG
_socket_init:
; .FSTART _socket_init
; 0002 00D6     char at_buff_[35];
; 0002 00D7     int step=1;
; 0002 00D8     clear_rec_buff();
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,35
	ST   -Y,R17
	ST   -Y,R16
;	*APN_name -> Y+37
;	at_buff_ -> Y+2
;	step -> R16,R17
	__GETWRN 16,17,1
	RCALL _clear_rec_buff
; 0002 00D9 
; 0002 00DA //lcd_clear();
; 0002 00DB 
; 0002 00DC     if(step==1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x40025
; 0002 00DD     {
; 0002 00DE //lcd_puts("1 ");
; 0002 00DF         at_command("AT");
	__POINTW2MN _0x40026,0
	RCALL _at_command
; 0002 00E0         if(wait_until("OK",1))
	__POINTW1MN _0x40026,3
	CALL SUBOPT_0x21
	BREQ _0x40027
; 0002 00E1         {
; 0002 00E2             step++;
	__ADDWRN 16,17,1
; 0002 00E3             delay_ms(500);
	CALL SUBOPT_0x16
; 0002 00E4         }
; 0002 00E5     }
_0x40027:
; 0002 00E6     clear_rec_buff();
_0x40025:
	RCALL _clear_rec_buff
; 0002 00E7 
; 0002 00E8     if(step==2)
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x40028
; 0002 00E9     {
; 0002 00EA //lcd_puts("2 ");
; 0002 00EB         at_command("AT+CGATT=1");
	__POINTW2MN _0x40026,6
	RCALL _at_command
; 0002 00EC         wait_until("OK",10);
	__POINTW1MN _0x40026,17
	CALL SUBOPT_0x22
; 0002 00ED 
; 0002 00EE         sprintf(at_buff_,"AT+CGDCONT=1,\"IP\",\"%s\"",APN_name);
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x40000,144
	CALL SUBOPT_0x23
	CALL SUBOPT_0x20
; 0002 00EF         at_command(at_buff_);
	MOVW R26,R28
	ADIW R26,2
	CALL SUBOPT_0x1F
; 0002 00F0         delay_ms(100);
; 0002 00F1 
; 0002 00F2         if(!search("ERROR"))
	__POINTW2MN _0x40026,20
	RCALL _search
	SBIW R30,0
	BRNE _0x40029
; 0002 00F3         {
; 0002 00F4             step++;
	__ADDWRN 16,17,1
; 0002 00F5         }
; 0002 00F6     }
_0x40029:
; 0002 00F7     clear_rec_buff();
_0x40028:
	RCALL _clear_rec_buff
; 0002 00F8 
; 0002 00F9     if(step==3)
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x4002A
; 0002 00FA     {
; 0002 00FB //lcd_puts("3 ");
; 0002 00FC         sprintf(at_buff_,"AT+CSTT=\"%s\",\"\",\"\"",APN_name);
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x40000,173
	CALL SUBOPT_0x23
	CALL SUBOPT_0x20
; 0002 00FD         at_command(at_buff_);
	MOVW R26,R28
	ADIW R26,2
	RCALL _at_command
; 0002 00FE         if(wait_until("OK",10))
	__POINTW1MN _0x40026,26
	CALL SUBOPT_0x22
	SBIW R30,0
	BREQ _0x4002B
; 0002 00FF         {
; 0002 0100             step++;
	__ADDWRN 16,17,1
; 0002 0101         }
; 0002 0102     }
_0x4002B:
; 0002 0103     clear_rec_buff();
_0x4002A:
	RCALL _clear_rec_buff
; 0002 0104 
; 0002 0105     if(step==4)
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x4002C
; 0002 0106     {
; 0002 0107 //lcd_puts("4 ");
; 0002 0108         at_command("AT+CIICR");
	__POINTW2MN _0x40026,29
	RCALL _at_command
; 0002 0109         if(wait_until("OK",15))
	__POINTW1MN _0x40026,38
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(15)
	CALL SUBOPT_0x24
	BREQ _0x4002D
; 0002 010A         {
; 0002 010B             step++;
	__ADDWRN 16,17,1
; 0002 010C         }
; 0002 010D     }
_0x4002D:
; 0002 010E     clear_rec_buff();
_0x4002C:
	RCALL _clear_rec_buff
; 0002 010F 
; 0002 0110     if(step==5)
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x4002E
; 0002 0111     {
; 0002 0112 //lcd_puts("5 ");
; 0002 0113         at_command("AT+CIFSR");
	__POINTW2MN _0x40026,41
	RCALL _at_command
; 0002 0114         delay_ms(500);
	CALL SUBOPT_0x16
; 0002 0115         step++;
	__ADDWRN 16,17,1
; 0002 0116     }
; 0002 0117     if(step<6)
_0x4002E:
	__CPWRN 16,17,6
	BRGE _0x4002F
; 0002 0118     {
; 0002 0119 //lcd_puts("NOT");
; 0002 011A         return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20E000C
; 0002 011B     }
; 0002 011C     else
_0x4002F:
; 0002 011D     {
; 0002 011E //lcd_puts("6 ");
; 0002 011F         return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
; 0002 0120     }
; 0002 0121 }
_0x20E000C:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,39
	RET
; .FEND

	.DSEG
_0x40026:
	.BYTE 0x32
;
;//This Function will open socket to inputed ip (or domain) and port 80
;int open_socket(char *server)
; 0002 0125 {

	.CSEG
_open_socket:
; .FSTART _open_socket
; 0002 0126     char at_buff[50];
; 0002 0127     clear_rec_buff();
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,50
;	*server -> Y+50
;	at_buff -> Y+0
	RCALL _clear_rec_buff
; 0002 0128 
; 0002 0129     at_command("AT+CIPHEAD=1");
	__POINTW2MN _0x40031,0
	RCALL _at_command
; 0002 012A     wait_until("OK",3);
	__POINTW1MN _0x40031,13
	CALL SUBOPT_0x25
; 0002 012B     clear_rec_buff();
	RCALL _clear_rec_buff
; 0002 012C 
; 0002 012D     sprintf(at_buff,"AT+CIPSTART=\"TCP\",\"%s\",\"80\"",server);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x40000,223
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+54
	LDD  R31,Y+54+1
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x20
; 0002 012E     at_command(at_buff);
	MOVW R26,R28
	RCALL _at_command
; 0002 012F     wait_until("OK",3);
	__POINTW1MN _0x40031,16
	CALL SUBOPT_0x25
; 0002 0130 
; 0002 0131     wait_until("CONNECT",20);
	__POINTW1MN _0x40031,19
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _wait_until
; 0002 0132 
; 0002 0133     if(search("ALREADY"))
	__POINTW2MN _0x40031,27
	RCALL _search
	SBIW R30,0
	BREQ _0x40032
; 0002 0134     {
; 0002 0135 //lcd_clear();
; 0002 0136 //lcd_puts("ALREADY");
; 0002 0137         return 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x20E000B
; 0002 0138     }
; 0002 0139     else if(search("CONNECT OK"))
_0x40032:
	__POINTW2MN _0x40031,35
	RCALL _search
	SBIW R30,0
	BREQ _0x40034
; 0002 013A     {
; 0002 013B //lcd_clear();
; 0002 013C //lcd_puts("c OK");
; 0002 013D         return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x20E000B
; 0002 013E     }
; 0002 013F     else if(search("FAIL"))
_0x40034:
	__POINTW2MN _0x40031,46
	RCALL _search
	SBIW R30,0
	BREQ _0x40036
; 0002 0140     {
; 0002 0141 //lcd_clear();
; 0002 0142 //lcd_puts("fail");
; 0002 0143         return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20E000B
; 0002 0144     }
; 0002 0145     else
_0x40036:
; 0002 0146     {
; 0002 0147         return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
; 0002 0148     }
; 0002 0149 }
_0x20E000B:
	ADIW R28,52
	RET
; .FEND

	.DSEG
_0x40031:
	.BYTE 0x33
;
;//Function fot ready to send DATA in socket
;//headers: delay.h, string.h
;//success_sign: means the string that is sign for beggining of the return value of the server, ex: success
;int socket_send_data(char* socket_data, char* success_sign)
; 0002 014F {

	.CSEG
_socket_send_data:
; .FSTART _socket_send_data
; 0002 0150     int stat=0;
; 0002 0151     clear_rec_buff();
	CALL SUBOPT_0x1A
;	*socket_data -> Y+4
;	*success_sign -> Y+2
;	stat -> R16,R17
	__GETWRN 16,17,0
	RCALL _clear_rec_buff
; 0002 0152     delay_ms(100);
	CALL SUBOPT_0x1C
; 0002 0153     at_command("AT+CIPSEND");
	__POINTW2MN _0x40038,0
	RCALL _at_command
; 0002 0154 
; 0002 0155     if(wait_until(">",20))
	__POINTW1MN _0x40038,11
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(20)
	CALL SUBOPT_0x24
	BREQ _0x40039
; 0002 0156     {
; 0002 0157 //lcd_clear();
; 0002 0158 //lcd_puts(">");
; 0002 0159         clear_rec_buff();
	RCALL _clear_rec_buff
; 0002 015A         printf("%s",socket_data);
	__POINTW1FN _0x40000,130
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0x1D
	LDI  R24,4
	CALL _printf
	ADIW R28,6
; 0002 015B         delay_ms(500);
	CALL SUBOPT_0x16
; 0002 015C         ctrl_z();
	RCALL _ctrl_z
; 0002 015D         delay_ms(50);
	CALL SUBOPT_0x1E
; 0002 015E         ctrl_z();
	RCALL _ctrl_z
; 0002 015F         if(wait_until("SEND OK",20))
	__POINTW1MN _0x40038,13
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(20)
	CALL SUBOPT_0x24
	BREQ _0x4003A
; 0002 0160         {
; 0002 0161 //lcd_puts("Send OK");
; 0002 0162            stat=1;
	__GETWRN 16,17,1
; 0002 0163            if(wait_until(success_sign,30))
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(30)
	CALL SUBOPT_0x24
	BREQ _0x4003B
; 0002 0164            {
; 0002 0165 //lcd_puts("succs");
; 0002 0166             delay_ms(1000);
	CALL SUBOPT_0xB
; 0002 0167 //lcd_clear();
; 0002 0168 //lcd_puts(ret);
; 0002 0169            }
; 0002 016A         }
_0x4003B:
; 0002 016B 
; 0002 016C     }
_0x4003A:
; 0002 016D 
; 0002 016E     return stat;
_0x40039:
	MOVW R30,R16
_0x20E000A:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
; 0002 016F }
; .FEND

	.DSEG
_0x40038:
	.BYTE 0x15
;
;
;//this function will init the program data variables
;void prog_init(void)
; 0002 0174 {

	.CSEG
_prog_init:
; .FSTART _prog_init
; 0002 0175     //Data Var naming:
; 0002 0176    sprintf(VAR_1,        "l");
	LDI  R30,LOW(_VAR_1)
	LDI  R31,HIGH(_VAR_1)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x40000,302
	CALL SUBOPT_0x26
; 0002 0177    sprintf(VAR_2,        "t");
	LDI  R30,LOW(_VAR_2)
	LDI  R31,HIGH(_VAR_2)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x40000,304
	CALL SUBOPT_0x26
; 0002 0178    sprintf(VAR_3,        "m");
	LDI  R30,LOW(_VAR_3)
	LDI  R31,HIGH(_VAR_3)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x40000,306
	CALL SUBOPT_0x26
; 0002 0179    sprintf(VAR_4,        "b");
	LDI  R30,LOW(_VAR_4)
	LDI  R31,HIGH(_VAR_4)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x40000,308
	CALL SUBOPT_0x26
; 0002 017A    sprintf(VAR_5,        "c");
	LDI  R30,LOW(_VAR_5)
	LDI  R31,HIGH(_VAR_5)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x40000,3
	CALL SUBOPT_0x26
; 0002 017B    sprintf(VAR_6,        "s");
	LDI  R30,LOW(_VAR_6)
	LDI  R31,HIGH(_VAR_6)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x40000,131
	CALL SUBOPT_0x26
; 0002 017C    sprintf(VAR_7,        "a");
	LDI  R30,LOW(_VAR_7)
	LDI  R31,HIGH(_VAR_7)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x40000,310
	CALL SUBOPT_0x26
; 0002 017D    sprintf(VAR_8,        "n");
	LDI  R30,LOW(_VAR_8)
	LDI  R31,HIGH(_VAR_8)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x40000,312
	CALL SUBOPT_0x26
; 0002 017E 
; 0002 017F     //Server Paramiters:
; 0002 0180    sprintf(_SERVER_,     "104.28.25.5");
	LDI  R30,LOW(__SERVER_)
	LDI  R31,HIGH(__SERVER_)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x40000,314
	CALL SUBOPT_0x26
; 0002 0181    sprintf(_APN_,        "Irancell-GPRS");
	LDI  R30,LOW(__APN_)
	LDI  R31,HIGH(__APN_)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x40000,326
	CALL SUBOPT_0x26
; 0002 0182    sprintf(_HOST_,       "gologram.com");
	LDI  R30,LOW(__HOST_)
	LDI  R31,HIGH(__HOST_)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x40000,340
	CALL SUBOPT_0x26
; 0002 0183    sprintf(_PAGEADDRESS_,"/api/v1/probes/process");
	LDI  R30,LOW(__PAGEADDRESS_)
	LDI  R31,HIGH(__PAGEADDRESS_)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x40000,353
	CALL SUBOPT_0x26
; 0002 0184    sprintf(_SUCCESSSIGN_,"success\":true");
	LDI  R30,LOW(__SUCCESSSIGN_)
	LDI  R31,HIGH(__SUCCESSSIGN_)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x40000,376
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	JMP  _0x20E0004
; 0002 0185 
; 0002 0186 }
; .FEND
;
;//this function will close socket
;void close_socket(void)
; 0002 018A {
_close_socket:
; .FSTART _close_socket
; 0002 018B     at_command("AT+CIPClOSE");
	__POINTW2MN _0x4003C,0
	RCALL _at_command
; 0002 018C     wait_until("OK",3);
	__POINTW1MN _0x4003C,12
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(3)
	RJMP _0x20E0009
; 0002 018D }
; .FEND

	.DSEG
_0x4003C:
	.BYTE 0xF
;
;//this function disconnects GPRS connection
;void gprs_dis(void)
; 0002 0191 {

	.CSEG
_gprs_dis:
; .FSTART _gprs_dis
; 0002 0192     at_command("AT+CIPSHUT");
	__POINTW2MN _0x4003D,0
	RCALL _at_command
; 0002 0193     wait_until("OK",5);
	__POINTW1MN _0x4003D,11
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(5)
_0x20E0009:
	LDI  R27,0
	RCALL _wait_until
; 0002 0194 }
	RET
; .FEND

	.DSEG
_0x4003D:
	.BYTE 0xE
;//this function will upload variables to server by http post method.
;int post_data(int vars_value[8])
; 0002 0197 {

	.CSEG
_post_data:
; .FSTART _post_data
; 0002 0198     int _time_out=0;
; 0002 0199     int _time_out1=0;
; 0002 019A     char post_buff[200];
; 0002 019B     char data_value[100];
; 0002 019C     //strlen
; 0002 019D     sprintf(data_value,"%s=%d&%s=%d&%s=%d&%s=%d&%s=%d&%s=%d&%s=%d&%s=%d",VAR_1,vars_value[0],VAR_2,vars_value[1],VAR_3,v ...
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,44
	SUBI R29,1
	CALL __SAVELOCR4
;	vars_value -> Y+304
;	_time_out -> R16,R17
;	_time_out1 -> R18,R19
;	post_buff -> Y+104
;	data_value -> Y+4
	CALL SUBOPT_0xA
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x40000,413
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_VAR_1)
	LDI  R31,HIGH(_VAR_1)
	CALL SUBOPT_0x1D
	__GETW2SX 312
	CALL SUBOPT_0x27
	LDI  R30,LOW(_VAR_2)
	LDI  R31,HIGH(_VAR_2)
	CALL SUBOPT_0x1D
	__GETW2SX 320
	ADIW R26,2
	CALL SUBOPT_0x27
	LDI  R30,LOW(_VAR_3)
	LDI  R31,HIGH(_VAR_3)
	CALL SUBOPT_0x1D
	__GETW2SX 328
	ADIW R26,4
	CALL SUBOPT_0x27
	LDI  R30,LOW(_VAR_4)
	LDI  R31,HIGH(_VAR_4)
	CALL SUBOPT_0x1D
	__GETW2SX 336
	ADIW R26,6
	CALL SUBOPT_0x27
	LDI  R30,LOW(_VAR_5)
	LDI  R31,HIGH(_VAR_5)
	CALL SUBOPT_0x1D
	__GETW2SX 344
	ADIW R26,8
	CALL SUBOPT_0x27
	LDI  R30,LOW(_VAR_6)
	LDI  R31,HIGH(_VAR_6)
	CALL SUBOPT_0x1D
	__GETW2SX 352
	ADIW R26,10
	CALL SUBOPT_0x27
	LDI  R30,LOW(_VAR_7)
	LDI  R31,HIGH(_VAR_7)
	CALL SUBOPT_0x1D
	__GETW2SX 360
	ADIW R26,12
	CALL SUBOPT_0x27
	LDI  R30,LOW(_VAR_8)
	LDI  R31,HIGH(_VAR_8)
	CALL SUBOPT_0x1D
	__GETW2SX 368
	ADIW R26,14
	CALL SUBOPT_0x27
	LDI  R24,64
	CALL _sprintf
	ADIW R28,63
	ADIW R28,5
; 0002 019E     sprintf(post_buff,"POST %s HTTP/1.0\r\nHost: %s\r\nUser-Agent: HTTPTool/1.0\r\nContent-Type: application/x-www-form- ...
	MOVW R30,R28
	SUBI R30,LOW(-(104))
	SBCI R31,HIGH(-(104))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x40000,461
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(__PAGEADDRESS_)
	LDI  R31,HIGH(__PAGEADDRESS_)
	CALL SUBOPT_0x1D
	LDI  R30,LOW(__HOST_)
	LDI  R31,HIGH(__HOST_)
	CALL SUBOPT_0x1D
	MOVW R26,R28
	ADIW R26,16
	CALL _strlen
	CALL SUBOPT_0x1D
	MOVW R30,R28
	ADIW R30,20
	CALL SUBOPT_0x1D
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0002 019F 
; 0002 01A0     _time_out1=0;
	__GETWRN 18,19,0
; 0002 01A1 
; 0002 01A2     socketstart:
_0x4003E:
; 0002 01A3     while(socket_init(_APN_)!=1 && _time_out<=5)
_0x4003F:
	LDI  R26,LOW(__APN_)
	LDI  R27,HIGH(__APN_)
	RCALL _socket_init
	SBIW R30,1
	BREQ _0x40042
	__CPWRN 16,17,6
	BRLT _0x40043
_0x40042:
	RJMP _0x40041
_0x40043:
; 0002 01A4     {
; 0002 01A5         //wait until connect to socket
; 0002 01A6         _time_out++;
	__ADDWRN 16,17,1
; 0002 01A7     }
	RJMP _0x4003F
_0x40041:
; 0002 01A8 
; 0002 01A9     open_socket(_SERVER_);
	LDI  R26,LOW(__SERVER_)
	LDI  R27,HIGH(__SERVER_)
	RCALL _open_socket
; 0002 01AA     if(socket_send_data(post_buff,_SUCCESSSIGN_))
	MOVW R30,R28
	SUBI R30,LOW(-(104))
	SBCI R31,HIGH(-(104))
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(__SUCCESSSIGN_)
	LDI  R27,HIGH(__SUCCESSSIGN_)
	RCALL _socket_send_data
	SBIW R30,0
	BREQ _0x40044
; 0002 01AB     {
; 0002 01AC         close_socket();
	RCALL _close_socket
; 0002 01AD         delay_ms(500);
	CALL SUBOPT_0x16
; 0002 01AE         gprs_dis();
	RCALL _gprs_dis
; 0002 01AF         return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x20E0008
; 0002 01B0     }
; 0002 01B1     else if(_time_out1<=5)
_0x40044:
	__CPWRN 18,19,6
	BRGE _0x40046
; 0002 01B2     {
; 0002 01B3 //lcd_puts("retry");
; 0002 01B4         _time_out1++;
	__ADDWRN 18,19,1
; 0002 01B5         close_socket();
	RCALL _close_socket
; 0002 01B6         gprs_dis();
	RCALL _gprs_dis
; 0002 01B7         delay_ms(1000);
	CALL SUBOPT_0xB
; 0002 01B8         goto socketstart;
	RJMP _0x4003E
; 0002 01B9     }
; 0002 01BA     else
_0x40046:
; 0002 01BB     {
; 0002 01BC         close_socket();
	RCALL _close_socket
; 0002 01BD         delay_ms(500);
	CALL SUBOPT_0x16
; 0002 01BE         gprs_dis();
	RCALL _gprs_dis
; 0002 01BF         return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
; 0002 01C0     }
; 0002 01C1 }
_0x20E0008:
	CALL __LOADLOCR4
	ADIW R28,50
	SUBI R29,-1
	RET
; .FEND
;
;
;//This function turns on module
;int sim800_on(void)
; 0002 01C6 {
_sim800_on:
; .FSTART _sim800_on
; 0002 01C7     clear_rec_buff();
	RCALL _clear_rec_buff
; 0002 01C8     at_command("AT");
	__POINTW2MN _0x40048,0
	CALL SUBOPT_0x1F
; 0002 01C9     delay_ms(100);
; 0002 01CA     if(!search("OK"))
	__POINTW2MN _0x40048,3
	RCALL _search
	SBIW R30,0
	BRNE _0x40049
; 0002 01CB     {
; 0002 01CC         PORTC.3=1;
	SBI  0x15,3
; 0002 01CD         delay_ms(3000);
	CALL SUBOPT_0x17
; 0002 01CE         PORTC.3=0;
	CBI  0x15,3
; 0002 01CF     }
; 0002 01D0     clear_rec_buff();
_0x40049:
	RCALL _clear_rec_buff
; 0002 01D1     at_command("AT");
	__POINTW2MN _0x40048,6
	RCALL _at_command
; 0002 01D2     if(wait_until("OK",1))
	__POINTW1MN _0x40048,9
	CALL SUBOPT_0x21
	BRNE _0x20E0005
; 0002 01D3     {
; 0002 01D4         return 1;
; 0002 01D5     }
; 0002 01D6     else
; 0002 01D7     {
; 0002 01D8         PORTC.3=1;
	RJMP _0x20E0006
; 0002 01D9         delay_ms(3000);
; 0002 01DA         PORTC.3=0;
; 0002 01DB         return 0;
; 0002 01DC     }
; 0002 01DD }
; .FEND

	.DSEG
_0x40048:
	.BYTE 0xC
;
;//This function turns OFF module
;int sim800_off(void)
; 0002 01E1 {

	.CSEG
_sim800_off:
; .FSTART _sim800_off
; 0002 01E2     PORTC.3=1;
	SBI  0x15,3
; 0002 01E3     delay_ms(3000);
	CALL SUBOPT_0x17
; 0002 01E4     PORTC.3=0;
	CBI  0x15,3
; 0002 01E5 
; 0002 01E6     clear_rec_buff();
	RCALL _clear_rec_buff
; 0002 01E7     at_command("AT");
	__POINTW2MN _0x40058,0
	RCALL _at_command
; 0002 01E8     if(wait_until("OK",1))
	__POINTW1MN _0x40058,3
	CALL SUBOPT_0x21
	BREQ _0x40059
; 0002 01E9     {
; 0002 01EA         PORTC.3=1;
_0x20E0006:
	SBI  0x15,3
; 0002 01EB         delay_ms(3000);
	CALL SUBOPT_0x17
; 0002 01EC         PORTC.3=0;
	CBI  0x15,3
; 0002 01ED 
; 0002 01EE         return 0;
_0x20E0007:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET
; 0002 01EF     }
; 0002 01F0     else
_0x40059:
; 0002 01F1     {
; 0002 01F2         return 1;
_0x20E0005:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET
; 0002 01F3     }
; 0002 01F4 }
	RET
; .FEND

	.DSEG
_0x40058:
	.BYTE 0x6
;
;//This Function will reset sim800
;void sim800_reset(void)
; 0002 01F8 {

	.CSEG
; 0002 01F9     sim800_off();
; 0002 01FA     sim800_on();
; 0002 01FB }
;//signal quality:
;int signal_q(void)
; 0002 01FE {
_signal_q:
; .FSTART _signal_q
; 0002 01FF     char sig_buff[3];
; 0002 0200     int i_=0;
; 0002 0201     int j_=0;
; 0002 0202 
; 0002 0203     emp_str(sig_buff,3);
	SBIW R28,3
	CALL __SAVELOCR4
;	sig_buff -> Y+4
;	i_ -> R16,R17
;	j_ -> R18,R19
	CALL SUBOPT_0xA
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(3)
	LDI  R27,0
	RCALL _emp_str
; 0002 0204     clear_rec_buff();
	RCALL _clear_rec_buff
; 0002 0205     at_command("AT+CSQ");
	__POINTW2MN _0x4005F,0
	RCALL _at_command
; 0002 0206     wait_until("CSQ",1);
	__POINTW1MN _0x4005F,7
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _wait_until
; 0002 0207     while(rec_buff[i_]!=':' && i_<=20)
_0x40060:
	LDI  R26,LOW(_rec_buff)
	LDI  R27,HIGH(_rec_buff)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	CPI  R26,LOW(0x3A)
	BREQ _0x40063
	__CPWRN 16,17,21
	BRLT _0x40064
_0x40063:
	RJMP _0x40062
_0x40064:
; 0002 0208     {
; 0002 0209         i_++;
	__ADDWRN 16,17,1
; 0002 020A     }
	RJMP _0x40060
_0x40062:
; 0002 020B     i_++;
	__ADDWRN 16,17,1
; 0002 020C     while(rec_buff[i_]!=',' && j_<=2)
_0x40065:
	LDI  R26,LOW(_rec_buff)
	LDI  R27,HIGH(_rec_buff)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	CPI  R26,LOW(0x2C)
	BREQ _0x40068
	__CPWRN 18,19,3
	BRLT _0x40069
_0x40068:
	RJMP _0x40067
_0x40069:
; 0002 020D     {
; 0002 020E         sig_buff[j_]=rec_buff[i_];
	MOVW R30,R18
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDI  R26,LOW(_rec_buff)
	LDI  R27,HIGH(_rec_buff)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0002 020F         i_++;
	__ADDWRN 16,17,1
; 0002 0210         j_++;
	__ADDWRN 18,19,1
; 0002 0211     }
	RJMP _0x40065
_0x40067:
; 0002 0212     while(j_<=2)
_0x4006A:
	__CPWRN 18,19,3
	BRGE _0x4006C
; 0002 0213     {
; 0002 0214         sig_buff[j_]='\0';
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R18
	ADC  R27,R19
	LDI  R30,LOW(0)
	ST   X,R30
; 0002 0215         j_++;
	__ADDWRN 18,19,1
; 0002 0216     }
	RJMP _0x4006A
_0x4006C:
; 0002 0217     return atoi(sig_buff);
	MOVW R26,R28
	ADIW R26,4
	CALL _atoi
	CALL __LOADLOCR4
	ADIW R28,7
	RET
; 0002 0218 }
; .FEND

	.DSEG
_0x4005F:
	.BYTE 0xB
;
;// get server time
;void get_server_time(int *s_year, int* s_mon, int* s_dat, int* s_hour, int* s_min, int* s_sec)
; 0002 021C {

	.CSEG
_get_server_time:
; .FSTART _get_server_time
; 0002 021D     volatile int ii=0;
; 0002 021E     volatile int jj=0;
; 0002 021F 
; 0002 0220     char YEAR[5];
; 0002 0221     char MONTH[3];
; 0002 0222     char DATE[3];
; 0002 0223     char HOUR[3];
; 0002 0224     char MIN[3];
; 0002 0225     char SEC[3];
; 0002 0226 
; 0002 0227     while(ii<=rec_buff_size)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,24
	LDI  R30,LOW(0)
	STD  Y+20,R30
	STD  Y+21,R30
	STD  Y+22,R30
	STD  Y+23,R30
;	*s_year -> Y+34
;	*s_mon -> Y+32
;	*s_dat -> Y+30
;	*s_hour -> Y+28
;	*s_min -> Y+26
;	*s_sec -> Y+24
;	ii -> Y+22
;	jj -> Y+20
;	YEAR -> Y+15
;	MONTH -> Y+12
;	DATE -> Y+9
;	HOUR -> Y+6
;	MIN -> Y+3
;	SEC -> Y+0
_0x4006D:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CPI  R26,LOW(0x367)
	LDI  R30,HIGH(0x367)
	CPC  R27,R30
	BRLT PC+2
	RJMP _0x4006F
; 0002 0228     {
; 0002 0229         if(rec_buff[ii]=='t' &&  rec_buff[ii+1]=='i' && rec_buff[ii+2]=='m' && rec_buff[ii+3]=='e' && rec_buff[ii+4]=='" ...
	CALL SUBOPT_0x28
	LD   R26,Z
	CPI  R26,LOW(0x74)
	BRNE _0x40071
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	__ADDW1MN _rec_buff,1
	LD   R26,Z
	CPI  R26,LOW(0x69)
	BRNE _0x40071
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	__ADDW1MN _rec_buff,2
	LD   R26,Z
	CPI  R26,LOW(0x6D)
	BRNE _0x40071
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	__ADDW1MN _rec_buff,3
	LD   R26,Z
	CPI  R26,LOW(0x65)
	BRNE _0x40071
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	__ADDW1MN _rec_buff,4
	LD   R26,Z
	CPI  R26,LOW(0x22)
	BREQ _0x40072
_0x40071:
	RJMP _0x40070
_0x40072:
; 0002 022A         {
; 0002 022B             ii=ii+7;
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	ADIW R30,7
	STD  Y+22,R30
	STD  Y+22+1,R31
; 0002 022C             while(jj<4)
_0x40073:
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	SBIW R26,4
	BRGE _0x40075
; 0002 022D             {
; 0002 022E                YEAR[jj]=rec_buff[ii];
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	MOVW R26,R28
	ADIW R26,15
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
; 0002 022F                jj++;
; 0002 0230                ii++;
; 0002 0231             }
	RJMP _0x40073
_0x40075:
; 0002 0232             YEAR[4]='\0';
	LDI  R30,LOW(0)
	STD  Y+19,R30
; 0002 0233             ii++;
	CALL SUBOPT_0x2B
; 0002 0234             jj=0;
; 0002 0235             while(jj<2)
_0x40076:
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	SBIW R26,2
	BRGE _0x40078
; 0002 0236             {
; 0002 0237                MONTH[jj]=rec_buff[ii];
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	MOVW R26,R28
	ADIW R26,12
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
; 0002 0238                jj++;
; 0002 0239                ii++;
; 0002 023A             }
	RJMP _0x40076
_0x40078:
; 0002 023B             MONTH[2]='\0';
	LDI  R30,LOW(0)
	STD  Y+14,R30
; 0002 023C             ii++;
	CALL SUBOPT_0x2B
; 0002 023D             jj=0;
; 0002 023E             while(jj<2)
_0x40079:
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	SBIW R26,2
	BRGE _0x4007B
; 0002 023F             {
; 0002 0240                 DATE[jj]=rec_buff[ii];
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	MOVW R26,R28
	ADIW R26,9
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
; 0002 0241                 jj++;
; 0002 0242                 ii++;
; 0002 0243             }
	RJMP _0x40079
_0x4007B:
; 0002 0244             DATE[2]='\0';
	LDI  R30,LOW(0)
	STD  Y+11,R30
; 0002 0245             ii++;
	CALL SUBOPT_0x2B
; 0002 0246             jj=0;
; 0002 0247             while(jj<2)
_0x4007C:
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	SBIW R26,2
	BRGE _0x4007E
; 0002 0248             {
; 0002 0249                 HOUR[jj]=rec_buff[ii];
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	MOVW R26,R28
	ADIW R26,6
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
; 0002 024A                 jj++;
; 0002 024B                 ii++;
; 0002 024C             }
	RJMP _0x4007C
_0x4007E:
; 0002 024D             HOUR[2]='\0';
	LDI  R30,LOW(0)
	STD  Y+8,R30
; 0002 024E             ii++;
	CALL SUBOPT_0x2B
; 0002 024F             jj=0;
; 0002 0250             while(jj<2)
_0x4007F:
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	SBIW R26,2
	BRGE _0x40081
; 0002 0251             {
; 0002 0252                 MIN[jj]=rec_buff[ii];
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	MOVW R26,R28
	ADIW R26,3
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
; 0002 0253                 jj++;
; 0002 0254                 ii++;
; 0002 0255             }
	RJMP _0x4007F
_0x40081:
; 0002 0256             MIN[2]='\0';
	LDI  R30,LOW(0)
	STD  Y+5,R30
; 0002 0257             ii++;
	CALL SUBOPT_0x2B
; 0002 0258             jj=0;
; 0002 0259             while(jj<2)
_0x40082:
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	SBIW R26,2
	BRGE _0x40084
; 0002 025A             {
; 0002 025B                 SEC[jj]=rec_buff[ii];
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	MOVW R26,R28
	CALL SUBOPT_0x29
	LD   R30,Z
	ST   X,R30
; 0002 025C                 ii++;
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	ADIW R30,1
	STD  Y+22,R30
	STD  Y+22+1,R31
; 0002 025D                 jj++;
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ADIW R30,1
	STD  Y+20,R30
	STD  Y+20+1,R31
; 0002 025E             }
	RJMP _0x40082
_0x40084:
; 0002 025F             SEC[2]='\0';
	LDI  R30,LOW(0)
	STD  Y+2,R30
; 0002 0260 
; 0002 0261 
; 0002 0262             *s_year=atoi(YEAR);
	MOVW R26,R28
	ADIW R26,15
	CALL _atoi
	LDD  R26,Y+34
	LDD  R27,Y+34+1
	ST   X+,R30
	ST   X,R31
; 0002 0263             *s_mon= atoi(MONTH);
	MOVW R26,R28
	ADIW R26,12
	CALL _atoi
	LDD  R26,Y+32
	LDD  R27,Y+32+1
	ST   X+,R30
	ST   X,R31
; 0002 0264             *s_dat= atoi(DATE);
	MOVW R26,R28
	ADIW R26,9
	CALL _atoi
	LDD  R26,Y+30
	LDD  R27,Y+30+1
	ST   X+,R30
	ST   X,R31
; 0002 0265             *s_hour=atoi(HOUR);
	MOVW R26,R28
	ADIW R26,6
	CALL _atoi
	LDD  R26,Y+28
	LDD  R27,Y+28+1
	ST   X+,R30
	ST   X,R31
; 0002 0266             *s_min= atoi(MIN);
	MOVW R26,R28
	ADIW R26,3
	CALL _atoi
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	ST   X+,R30
	ST   X,R31
; 0002 0267             *s_sec= atoi(SEC);
	MOVW R26,R28
	CALL _atoi
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	ST   X+,R30
	ST   X,R31
; 0002 0268 
; 0002 0269             break;
	RJMP _0x4006F
; 0002 026A         }
; 0002 026B         ii++;
_0x40070:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	ADIW R30,1
	STD  Y+22,R30
	STD  Y+22+1,R31
; 0002 026C     }
	RJMP _0x4006D
_0x4006F:
; 0002 026D }
	ADIW R28,36
	RET
; .FEND

	.CSEG
_lm75_set_temp_G100:
; .FSTART _lm75_set_temp_G100
	ST   -Y,R26
	CALL _i2c_start
	LDD  R26,Y+2
	CALL _i2c_write
	LDD  R26,Y+1
	CALL _i2c_write
	LD   R26,Y
	CALL _i2c_write
	LDI  R26,LOW(0)
	CALL SUBOPT_0x19
	JMP  _0x20E0003
; .FEND
_lm75_init:
; .FSTART _lm75_init
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+4
	CALL SUBOPT_0x2C
	LDI  R26,LOW(1)
	CALL _i2c_write
	LDD  R30,Y+1
	LSL  R30
	LSL  R30
	MOV  R26,R30
	CALL SUBOPT_0x19
	ST   -Y,R17
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _lm75_set_temp_G100
	ST   -Y,R17
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _lm75_set_temp_G100
	LDD  R17,Y+0
	JMP  _0x20E0002
; .FEND
_lm75_temperature_10:
; .FSTART _lm75_temperature_10
	ST   -Y,R26
	SBIW R28,2
	ST   -Y,R17
	LDD  R30,Y+3
	CALL SUBOPT_0x2C
	LDI  R26,LOW(0)
	CALL _i2c_write
	CALL _i2c_start
	SUBI R17,-LOW(1)
	MOV  R26,R17
	CALL _i2c_write
	LDI  R26,LOW(1)
	CALL _i2c_read
	STD  Y+2,R30
	LDI  R26,LOW(0)
	CALL _i2c_read
	STD  Y+1,R30
	CALL _i2c_stop
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(7)
	CALL __ASRW12
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	CALL __MULW12
	LDD  R17,Y+0
	JMP  _0x20E0004
; .FEND

	.CSEG
_atoi:
; .FSTART _atoi
	ST   -Y,R27
	ST   -Y,R26
   	ldd  r27,y+1
   	ld   r26,y
__atoi0:
   	ld   r30,x
        mov  r24,r26
	MOV  R26,R30
	CALL _isspace
        mov  r26,r24
   	tst  r30
   	breq __atoi1
   	adiw r26,1
   	rjmp __atoi0
__atoi1:
   	clt
   	ld   r30,x
   	cpi  r30,'-'
   	brne __atoi2
   	set
   	rjmp __atoi3
__atoi2:
   	cpi  r30,'+'
   	brne __atoi4
__atoi3:
   	adiw r26,1
__atoi4:
   	clr  r22
   	clr  r23
__atoi5:
   	ld   r30,x
        mov  r24,r26
	MOV  R26,R30
	CALL _isdigit
        mov  r26,r24
   	tst  r30
   	breq __atoi6
   	movw r30,r22
   	lsl  r22
   	rol  r23
   	lsl  r22
   	rol  r23
   	add  r22,r30
   	adc  r23,r31
   	lsl  r22
   	rol  r23
   	ld   r30,x+
   	clr  r31
   	subi r30,'0'
   	add  r22,r30
   	adc  r23,r31
   	rjmp __atoi5
__atoi6:
   	movw r30,r22
   	brtc __atoi7
   	com  r30
   	com  r31
   	adiw r30,1
__atoi7:
   	adiw r28,2
   	ret
; .FEND

	.DSEG

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
_strstr:
; .FSTART _strstr
	ST   -Y,R27
	ST   -Y,R26
    ldd  r26,y+2
    ldd  r27,y+3
    movw r24,r26
strstr0:
    ld   r30,y
    ldd  r31,y+1
strstr1:
    ld   r23,z+
    tst  r23
    brne strstr2
    movw r30,r24
    rjmp strstr3
strstr2:
    ld   r22,x+
    cp   r22,r23
    breq strstr1
    adiw r24,1
    movw r26,r24
    tst  r22
    brne strstr0
    clr  r30
    clr  r31
strstr3:
_0x20E0004:
	ADIW R28,4
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET
; .FEND
_put_usart_G103:
; .FSTART _put_usart_G103
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x10
_0x20E0003:
	ADIW R28,3
	RET
; .FEND
_put_buff_G103:
; .FSTART _put_buff_G103
	CALL SUBOPT_0x1A
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2060010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2060012
	__CPWRN 16,17,2
	BRLO _0x2060013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2060012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x10
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2060013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2060014
	CALL SUBOPT_0x10
_0x2060014:
	RJMP _0x2060015
_0x2060010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2060015:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20E0002:
	ADIW R28,5
	RET
; .FEND
__print_G103:
; .FSTART __print_G103
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2060016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2060018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x206001C
	CPI  R18,37
	BRNE _0x206001D
	LDI  R17,LOW(1)
	RJMP _0x206001E
_0x206001D:
	CALL SUBOPT_0x2D
_0x206001E:
	RJMP _0x206001B
_0x206001C:
	CPI  R30,LOW(0x1)
	BRNE _0x206001F
	CPI  R18,37
	BRNE _0x2060020
	CALL SUBOPT_0x2D
	RJMP _0x20600CC
_0x2060020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2060021
	LDI  R16,LOW(1)
	RJMP _0x206001B
_0x2060021:
	CPI  R18,43
	BRNE _0x2060022
	LDI  R20,LOW(43)
	RJMP _0x206001B
_0x2060022:
	CPI  R18,32
	BRNE _0x2060023
	LDI  R20,LOW(32)
	RJMP _0x206001B
_0x2060023:
	RJMP _0x2060024
_0x206001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2060025
_0x2060024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2060026
	ORI  R16,LOW(128)
	RJMP _0x206001B
_0x2060026:
	RJMP _0x2060027
_0x2060025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x206001B
_0x2060027:
	CPI  R18,48
	BRLO _0x206002A
	CPI  R18,58
	BRLO _0x206002B
_0x206002A:
	RJMP _0x2060029
_0x206002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x206001B
_0x2060029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x206002F
	CALL SUBOPT_0x2E
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x2F
	RJMP _0x2060030
_0x206002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2060032
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x30
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2060033
_0x2060032:
	CPI  R30,LOW(0x70)
	BRNE _0x2060035
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x30
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2060033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2060036
_0x2060035:
	CPI  R30,LOW(0x64)
	BREQ _0x2060039
	CPI  R30,LOW(0x69)
	BRNE _0x206003A
_0x2060039:
	ORI  R16,LOW(4)
	RJMP _0x206003B
_0x206003A:
	CPI  R30,LOW(0x75)
	BRNE _0x206003C
_0x206003B:
	LDI  R30,LOW(_tbl10_G103*2)
	LDI  R31,HIGH(_tbl10_G103*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x206003D
_0x206003C:
	CPI  R30,LOW(0x58)
	BRNE _0x206003F
	ORI  R16,LOW(8)
	RJMP _0x2060040
_0x206003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2060071
_0x2060040:
	LDI  R30,LOW(_tbl16_G103*2)
	LDI  R31,HIGH(_tbl16_G103*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x206003D:
	SBRS R16,2
	RJMP _0x2060042
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2060043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2060043:
	CPI  R20,0
	BREQ _0x2060044
	SUBI R17,-LOW(1)
	RJMP _0x2060045
_0x2060044:
	ANDI R16,LOW(251)
_0x2060045:
	RJMP _0x2060046
_0x2060042:
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x31
_0x2060046:
_0x2060036:
	SBRC R16,0
	RJMP _0x2060047
_0x2060048:
	CP   R17,R21
	BRSH _0x206004A
	SBRS R16,7
	RJMP _0x206004B
	SBRS R16,2
	RJMP _0x206004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x206004D
_0x206004C:
	LDI  R18,LOW(48)
_0x206004D:
	RJMP _0x206004E
_0x206004B:
	LDI  R18,LOW(32)
_0x206004E:
	CALL SUBOPT_0x2D
	SUBI R21,LOW(1)
	RJMP _0x2060048
_0x206004A:
_0x2060047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x206004F
_0x2060050:
	CPI  R19,0
	BREQ _0x2060052
	SBRS R16,3
	RJMP _0x2060053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2060054
_0x2060053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2060054:
	CALL SUBOPT_0x2D
	CPI  R21,0
	BREQ _0x2060055
	SUBI R21,LOW(1)
_0x2060055:
	SUBI R19,LOW(1)
	RJMP _0x2060050
_0x2060052:
	RJMP _0x2060056
_0x206004F:
_0x2060058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x206005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x206005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x206005A
_0x206005C:
	CPI  R18,58
	BRLO _0x206005D
	SBRS R16,3
	RJMP _0x206005E
	SUBI R18,-LOW(7)
	RJMP _0x206005F
_0x206005E:
	SUBI R18,-LOW(39)
_0x206005F:
_0x206005D:
	SBRC R16,4
	RJMP _0x2060061
	CPI  R18,49
	BRSH _0x2060063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2060062
_0x2060063:
	RJMP _0x20600CD
_0x2060062:
	CP   R21,R19
	BRLO _0x2060067
	SBRS R16,0
	RJMP _0x2060068
_0x2060067:
	RJMP _0x2060066
_0x2060068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2060069
	LDI  R18,LOW(48)
_0x20600CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x206006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x2F
	CPI  R21,0
	BREQ _0x206006B
	SUBI R21,LOW(1)
_0x206006B:
_0x206006A:
_0x2060069:
_0x2060061:
	CALL SUBOPT_0x2D
	CPI  R21,0
	BREQ _0x206006C
	SUBI R21,LOW(1)
_0x206006C:
_0x2060066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2060059
	RJMP _0x2060058
_0x2060059:
_0x2060056:
	SBRS R16,0
	RJMP _0x206006D
_0x206006E:
	CPI  R21,0
	BREQ _0x2060070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x2F
	RJMP _0x206006E
_0x2060070:
_0x206006D:
_0x2060071:
_0x2060030:
_0x20600CC:
	LDI  R17,LOW(0)
_0x206001B:
	RJMP _0x2060016
_0x2060018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x32
	SBIW R30,0
	BRNE _0x2060072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20E0001
_0x2060072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x32
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL SUBOPT_0x33
	LDI  R30,LOW(_put_buff_G103)
	LDI  R31,HIGH(_put_buff_G103)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G103
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20E0001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL SUBOPT_0x33
	LDI  R30,LOW(_put_usart_G103)
	LDI  R31,HIGH(_put_usart_G103)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G103
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_sleep_enable:
; .FSTART _sleep_enable
   in   r30,power_ctrl_reg
   sbr  r30,__se_bit
   out  power_ctrl_reg,r30
	RET
; .FEND
_sleep_disable:
; .FSTART _sleep_disable
   in   r30,power_ctrl_reg
   cbr  r30,__se_bit
   out  power_ctrl_reg,r30
	RET
; .FEND
_idle:
; .FSTART _idle
   in   r30,power_ctrl_reg
   cbr  r30,__sm_mask
   out  power_ctrl_reg,r30
   in   r30,sreg
   sei
   sleep
   out  sreg,r30
	RET
; .FEND

	.CSEG
_isdigit:
; .FSTART _isdigit
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
; .FEND
_isspace:
; .FSTART _isspace
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret
; .FEND

	.CSEG

	.DSEG
_k:
	.BYTE 0x4
_head_onoff:
	.BYTE 0x2
_Temp_LED:
	.BYTE 0x2
_Hum_LED:
	.BYTE 0x2
_Lux_LED:
	.BYTE 0x2
_Red:
	.BYTE 0x2
_Blue:
	.BYTE 0x2
_Green:
	.BYTE 0x2
_turn:
	.BYTE 0x2
_blue_delay:
	.BYTE 0x2
_red_delay:
	.BYTE 0x2
_buff_counter:
	.BYTE 0x4
_rec_buff:
	.BYTE 0x366
_val:
	.BYTE 0x10
_VAR_1:
	.BYTE 0x7
_VAR_2:
	.BYTE 0x7
_VAR_3:
	.BYTE 0x7
_VAR_4:
	.BYTE 0x7
_VAR_5:
	.BYTE 0x7
_VAR_6:
	.BYTE 0x7
_VAR_7:
	.BYTE 0x7
_VAR_8:
	.BYTE 0x7
__SERVER_:
	.BYTE 0x14
__APN_:
	.BYTE 0x14
__HOST_:
	.BYTE 0x14
__PAGEADDRESS_:
	.BYTE 0x32
__SUCCESSSIGN_:
	.BYTE 0x14
_G_Lum:
	.BYTE 0x2
_G_Temp:
	.BYTE 0x2
_G_Mois:
	.BYTE 0x2
_first_time:
	.BYTE 0x1
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDS  R26,_G_Lum
	LDS  R27,_G_Lum+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	STS  _Lux_LED,R30
	STS  _Lux_LED+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDS  R26,_G_Temp
	LDS  R27,_G_Temp+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	STS  _Temp_LED,R30
	STS  _Temp_LED+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDS  R26,_G_Mois
	LDS  R27,_G_Mois+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	STS  _Hum_LED,R30
	STS  _Hum_LED+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x6:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	CALL _read_adc
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	__GETD2S 2
	CALL __ADDF12
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x9:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	MOVW R30,R28
	ADIW R30,16
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDS  R30,_buff_counter
	LDS  R31,_buff_counter+1
	SUBI R30,LOW(-_rec_buff)
	SBCI R31,HIGH(-_rec_buff)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	STS  _buff_counter,R30
	STS  _buff_counter+1,R30
	STS  _buff_counter+2,R30
	STS  _buff_counter+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x10:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDS  R26,_turn
	LDS  R27,_turn+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	CBI  0x18,4
	CBI  0x18,3
	CBI  0x1B,1
	CBI  0x18,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDS  R26,_Temp_LED
	LDS  R27,_Temp_LED+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LDS  R26,_Hum_LED
	LDS  R27,_Hum_LED+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	LDS  R26,_Lux_LED
	LDS  R27,_Lux_LED+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x16:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	CALL _i2c_start
	LDI  R26,LOW(222)
	CALL _i2c_write
	LDD  R26,Y+1
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	CALL _i2c_write
	JMP  _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x1D:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	LDI  R26,LOW(50)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	CALL _at_command
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x21:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _wait_until
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(10)
	LDI  R27,0
	JMP  _wait_until

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+41
	LDD  R31,Y+41+1
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	LDI  R27,0
	CALL _wait_until
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _wait_until

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x26:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x27:
	CALL __GETW1P
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x28:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	SUBI R30,LOW(-_rec_buff)
	SBCI R31,HIGH(-_rec_buff)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x29:
	ADD  R26,R30
	ADC  R27,R31
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x2A:
	LD   R30,Z
	ST   X,R30
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ADIW R30,1
	STD  Y+20,R30
	STD  Y+20+1,R31
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	ADIW R30,1
	STD  Y+22,R30
	STD  Y+22+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2B:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	ADIW R30,1
	STD  Y+22,R30
	STD  Y+22+1,R31
	LDI  R30,LOW(0)
	STD  Y+20,R30
	STD  Y+20+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	LSL  R30
	ORI  R30,LOW(0x90)
	MOV  R17,R30
	CALL _i2c_start
	MOV  R26,R17
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2D:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2E:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2F:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x30:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x31:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET


	.CSEG
	.equ __sda_bit=0
	.equ __scl_bit=1
	.equ __i2c_port=0x15 ;PORTC
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,18
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,37
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__ASRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __ASRW12R
__ASRW12L:
	ASR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRW12L
__ASRW12R:
	RET

__LSRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSRW12R
__LSRW12L:
	LSR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRW12L
__LSRW12R:
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__EQW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BREQ __EQW12T
	CLR  R30
__EQW12T:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
