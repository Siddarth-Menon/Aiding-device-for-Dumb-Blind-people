
;CodeVisionAVR C Compiler V1.24.8d Professional
;(C) Copyright 1998-2006 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : No
;Word align FLASH struct: No
;Enhanced core instructions    : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	.EQU GICR=0x3B
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

	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_adc_noise_red=0x10
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70

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
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
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

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
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

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
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

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
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
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
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
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
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
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
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
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
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

	.CSEG
	.ORG 0

	.INCLUDE "asm.vec"
	.INCLUDE "asm.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x800)
	LDI  R25,HIGH(0x800)
	LDI  R26,0x60
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

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x85F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x85F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x260)
	LDI  R29,HIGH(0x260)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260
;       1 #include <mega32.h> 
;       2 #include <delay.h>
;       3 #include <stdio.h> 
;       4 // Declare your global variables here
;       5 #define ADC_VREF_TYPE 0x00
;       6 
;       7  unsigned char count=0;
;       8  unsigned char data, i;
;       9  
;      10  #define RXB8 1
;      11 #define TXB8 0
;      12 #define UPE 2
;      13 #define OVR 3
;      14 #define FE 4
;      15 #define UDRE 5
;      16 #define RXC 7
;      17 
;      18 #define FRAMING_ERROR (1<<FE)
;      19 #define PARITY_ERROR (1<<UPE)
;      20 #define DATA_OVERRUN (1<<OVR)
;      21 #define DATA_REGISTER_EMPTY (1<<UDRE)
;      22 #define RX_COMPLETE (1<<RXC)
;      23 
;      24 // USART Receiver buffer
;      25 #define RX_BUFFER_SIZE 8
;      26 char rx_buffer[RX_BUFFER_SIZE];
_rx_buffer:
	.BYTE 0x8
;      27 
;      28 #if RX_BUFFER_SIZE<256
;      29 unsigned char rx_wr_index,rx_rd_index,rx_counter;
;      30 #else
;      31 unsigned int rx_wr_index,rx_rd_index,rx_counter;
;      32 #endif
;      33 
;      34 // This flag is set on USART Receiver buffer overflow
;      35 bit rx_buffer_overflow;
;      36 
;      37 // USART Receiver interrupt service routine
;      38 interrupt [USART_RXC] void usart_rx_isr(void)
;      39 {

	.CSEG
_usart_rx_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;      40 char status,data;
;      41 status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R16
;	data -> R17
	IN   R16,11
;      42 data=UDR;
	IN   R17,12
;      43 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R16
	ANDI R30,LOW(0x1C)
	BREQ PC+3
	JMP _0x3
;      44    {
;      45    rx_buffer[rx_wr_index]=data;
	MOV  R26,R7
	LDI  R27,0
	SUBI R26,LOW(-_rx_buffer)
	SBCI R27,HIGH(-_rx_buffer)
	ST   X,R17
;      46    if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BREQ PC+3
	JMP _0x4
	CLR  R7
;      47    if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R9
	LDI  R30,LOW(8)
	CP   R30,R9
	BREQ PC+3
	JMP _0x5
;      48       {
;      49       rx_counter=0;
	CLR  R9
;      50       rx_buffer_overflow=1;
	SET
	BLD  R2,0
;      51       };
_0x5:
;      52    };
_0x3:
;      53 }
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;      54 
;      55 #ifndef _DEBUG_TERMINAL_IO_
;      56 // Get a character from the USART Receiver buffer
;      57 #define _ALTERNATE_GETCHAR_
;      58 #pragma used+
;      59 char getchar(void)
;      60 {
_getchar:
;      61 char data;
;      62 while (rx_counter==0);
	ST   -Y,R16
;	data -> R16
_0x6:
	TST  R9
	BREQ PC+3
	JMP _0x8
	RJMP _0x6
_0x8:
;      63 data=rx_buffer[rx_rd_index];
	MOV  R30,R8
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R16,Z
;      64 if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	INC  R8
	LDI  R30,LOW(8)
	CP   R30,R8
	BREQ PC+3
	JMP _0x9
	CLR  R8
;      65 #asm("cli")
_0x9:
	cli
;      66 --rx_counter;
	DEC  R9
;      67 #asm("sei")
	sei
;      68 return data;
	MOV  R30,R16
	LD   R16,Y+
	RET
;      69 }
;      70 #pragma used-
;      71 #endif
;      72 
;      73 // USART Transmitter buffer
;      74 #define TX_BUFFER_SIZE 8
;      75 char tx_buffer[TX_BUFFER_SIZE];

	.DSEG
_tx_buffer:
	.BYTE 0x8
;      76 
;      77 #if TX_BUFFER_SIZE<256
;      78 unsigned char tx_wr_index,tx_rd_index,tx_counter;
;      79 #else
;      80 unsigned int tx_wr_index,tx_rd_index,tx_counter;
;      81 #endif
;      82 
;      83 // USART Transmitter interrupt service routine
;      84 interrupt [USART_TXC] void usart_tx_isr(void)
;      85 {

	.CSEG
_usart_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;      86 if (tx_counter)
	TST  R12
	BRNE PC+3
	JMP _0xA
;      87    {
;      88    --tx_counter;
	DEC  R12
;      89    UDR=tx_buffer[tx_rd_index];
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
;      90    if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	INC  R11
	LDI  R30,LOW(8)
	CP   R30,R11
	BREQ PC+3
	JMP _0xB
	CLR  R11
;      91    };
_0xB:
_0xA:
;      92 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;      93 
;      94 #ifndef _DEBUG_TERMINAL_IO_
;      95 // Write a character to the USART Transmitter buffer
;      96 #define _ALTERNATE_PUTCHAR_
;      97 #pragma used+
;      98 void putchar(char c)
;      99 {
_putchar:
;     100 while (tx_counter == TX_BUFFER_SIZE);
;	c -> Y+0
_0xC:
	LDI  R30,LOW(8)
	CP   R30,R12
	BREQ PC+3
	JMP _0xE
	RJMP _0xC
_0xE:
;     101 #asm("cli")
	cli
;     102 if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	TST  R12
	BREQ PC+3
	JMP _0x10
	SBIS 0xB,5
	RJMP _0x10
	RJMP _0xF
_0x10:
;     103    {
;     104    tx_buffer[tx_wr_index]=c;
	MOV  R30,R10
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
;     105    if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	INC  R10
	LDI  R30,LOW(8)
	CP   R30,R10
	BREQ PC+3
	JMP _0x12
	CLR  R10
;     106    ++tx_counter;
_0x12:
	INC  R12
;     107    }
;     108 else
	RJMP _0x13
_0xF:
;     109    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
;     110 #asm("sei")
_0x13:
	sei
;     111 }
	ADIW R28,1
	RET
;     112 #pragma used-
;     113 #endif
;     114 
;     115 // Standard Input/Output functions
;     116 #include <stdio.h>
;     117 
;     118 // External Interrupt 0 service routine
;     119 interrupt [EXT_INT0] void ext_int0_isr(void)
;     120 {
_ext_int0_isr:
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
;     121 // Place your code here 
;     122 if(PIND.2==0)
	SBIC 0x10,2
	RJMP _0x14
;     123 {
;     124 //printf("interrrupt");
;     125 delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x0
;     126 if(PIND.2==0)
	SBIC 0x10,2
	RJMP _0x15
;     127 {
;     128 count++;
	INC  R4
;     129 if(count==3)
	LDI  R30,LOW(3)
	CP   R30,R4
	BREQ PC+3
	JMP _0x16
;     130 {
;     131  count=0;
	CLR  R4
;     132 }
;     133 
;     134 }
_0x16:
;     135 }
_0x15:
;     136 
;     137 }
_0x14:
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
;     138 void slave(unsigned char);
;     139 
;     140 // Read the AD conversion result
;     141 unsigned int read_adc(unsigned char adc_input)
;     142 {
_read_adc:
;     143 ADMUX=adc_input|ADC_VREF_TYPE;
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
;     144 // Start the AD conversion
;     145 ADCSRA|=0x40;
	SBI  0x6,6
;     146 // Wait for the AD conversion to complete
;     147 while ((ADCSRA & 0x10)==0);
_0x17:
	SBIC 0x6,4
	RJMP _0x19
	RJMP _0x17
_0x19:
;     148 ADCSRA|=0x10;
	SBI  0x6,4
;     149 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
;     150 }
;     151 
;     152 unsigned int pot;
;     153 unsigned int x;

	.DSEG
_x:
	.BYTE 0x2
;     154 unsigned int y;
_y:
	.BYTE 0x2
;     155 unsigned int z;  
_z:
	.BYTE 0x2
;     156 
;     157 //unsigned char a;
;     158 
;     159 unsigned int x1;
_x1:
	.BYTE 0x2
;     160 unsigned int y1;
_y1:
	.BYTE 0x2
;     161 unsigned int z1;
_z1:
	.BYTE 0x2
;     162 
;     163 void main(void)
;     164 {

	.CSEG
_main:
;     165 // Declare your local variables here
;     166 
;     167 // Input/Output Ports initialization
;     168 // Port A initialization
;     169 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=Out 
;     170 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=0 
;     171 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
;     172 DDRA=0x00;
	OUT  0x1A,R30
;     173 
;     174 // Port B initialization
;     175 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;     176 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;     177 PORTB=0x00;
	OUT  0x18,R30
;     178 DDRB=0x00;
	OUT  0x17,R30
;     179 
;     180 // Port C initialization
;     181 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;     182 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;     183 PORTC=0x00;
	OUT  0x15,R30
;     184 DDRC=0x00;
	OUT  0x14,R30
;     185 
;     186 // Port D initialization
;     187 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;     188 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;     189 PORTD=0x04;
	LDI  R30,LOW(4)
	OUT  0x12,R30
;     190 DDRD=0x30;
	LDI  R30,LOW(48)
	OUT  0x11,R30
;     191 
;     192 // Timer/Counter 0 initialization
;     193 // Clock source: System Clock
;     194 // Clock value: Timer 0 Stopped
;     195 // Mode: Normal top=FFh
;     196 // OC0 output: Disconnected
;     197 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
;     198 TCNT0=0x00;
	OUT  0x32,R30
;     199 OCR0=0x00;
	OUT  0x3C,R30
;     200 
;     201 // Timer/Counter 1 initialization
;     202 // Clock source: System Clock
;     203 // Clock value: Timer 1 Stopped
;     204 // Mode: Normal top=FFFFh
;     205 // OC1A output: Discon.
;     206 // OC1B output: Discon.
;     207 // Noise Canceler: Off
;     208 // Input Capture on Falling Edge
;     209 // Timer 1 Overflow Interrupt: Off
;     210 // Input Capture Interrupt: Off
;     211 // Compare A Match Interrupt: Off
;     212 // Compare B Match Interrupt: Off
;     213 TCCR1A=0x00;
	OUT  0x2F,R30
;     214 TCCR1B=0x00;
	OUT  0x2E,R30
;     215 TCNT1H=0x00;
	OUT  0x2D,R30
;     216 TCNT1L=0x00;
	OUT  0x2C,R30
;     217 ICR1H=0x00;
	OUT  0x27,R30
;     218 ICR1L=0x00;
	OUT  0x26,R30
;     219 OCR1AH=0x00;
	OUT  0x2B,R30
;     220 OCR1AL=0x00;
	OUT  0x2A,R30
;     221 OCR1BH=0x00;
	OUT  0x29,R30
;     222 OCR1BL=0x00;
	OUT  0x28,R30
;     223 
;     224 // Timer/Counter 2 initialization
;     225 // Clock source: System Clock
;     226 // Clock value: Timer 2 Stopped
;     227 // Mode: Normal top=FFh
;     228 // OC2 output: Disconnected
;     229 ASSR=0x00;
	OUT  0x22,R30
;     230 TCCR2=0x00;
	OUT  0x25,R30
;     231 TCNT2=0x00;
	OUT  0x24,R30
;     232 OCR2=0x00;
	OUT  0x23,R30
;     233 
;     234 // // External Interrupt(s) initialization
;     235 // // INT0: Off
;     236 // // INT1: Off
;     237 // // INT2: Off
;     238 // MCUCR=0x00;
;     239 // MCUCSR=0x00;
;     240 
;     241 // Timer(s)/Counter(s) Interrupt(s) initialization
;     242 TIMSK=0x00;
	OUT  0x39,R30
;     243 
;     244 // Analog Comparator initialization
;     245 // Analog Comparator: Off
;     246 // Analog Comparator Input Capture by Timer/Counter 1: Off
;     247 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     248 SFIOR=0x00; 
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     249 
;     250 // ADC initialization
;     251 // ADC Clock frequency: 1000.000 kHz
;     252 // ADC Voltage Reference: AREF pin
;     253 ADMUX=ADC_VREF_TYPE;
	OUT  0x7,R30
;     254 ADCSRA=0x84;       
	LDI  R30,LOW(132)
	OUT  0x6,R30
;     255  // External Interrupt(s) initialization
;     256 // INT0: On
;     257 // INT0 Mode: Low level
;     258 // INT1: Off
;     259 // INT2: Off
;     260 GICR|=0x40;
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
;     261 MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
;     262 MCUCSR=0x00;
	OUT  0x34,R30
;     263 GIFR=0x40;
	LDI  R30,LOW(64)
	OUT  0x3A,R30
;     264 
;     265 // USART initialization
;     266 // Communication Parameters: 8 Data, 1 Stop, No Parity
;     267 // USART Receiver: On
;     268 // USART Transmitter: On
;     269 // USART Mode: Asynchronous
;     270 // USART Baud rate: 9600
;     271 UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
;     272 UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
;     273 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
;     274 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;     275 UBRRL=0x67;
	LDI  R30,LOW(103)
	OUT  0x9,R30
;     276 #asm("sei")
	sei
;     277 
;     278 while (1)
_0x1A:
;     279       {     
;     280          if(count==1)
	LDI  R30,LOW(1)
	CP   R30,R4
	BREQ PC+3
	JMP _0x1D
;     281          { 
;     282          //printf("working");
;     283       x=read_adc(1);    
	ST   -Y,R30
	CALL _read_adc
	STS  _x,R30
	STS  _x+1,R31
;     284       
;     285       y=read_adc(2);    
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _read_adc
	STS  _y,R30
	STS  _y+1,R31
;     286           
;     287       z=read_adc(3);  
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _read_adc
	STS  _z,R30
	STS  _z+1,R31
;     288       
;     289       x1=read_adc(4);    
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _read_adc
	STS  _x1,R30
	STS  _x1+1,R31
;     290       
;     291       y1=read_adc(5);    
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _read_adc
	STS  _y1,R30
	STS  _y1+1,R31
;     292           
;     293       z1=read_adc(6);  
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _read_adc
	STS  _z1,R30
	STS  _z1+1,R31
;     294        
;     295       if((x>310&&x<340)&&(y>385&&y<415))
	CALL SUBOPT_0x1
	CPI  R26,LOW(0x137)
	LDI  R30,HIGH(0x137)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x1F
	CALL SUBOPT_0x1
	CPI  R26,LOW(0x154)
	LDI  R30,HIGH(0x154)
	CPC  R27,R30
	BRLO PC+3
	JMP _0x1F
	RJMP _0x20
_0x1F:
	RJMP _0x21
_0x20:
	CALL SUBOPT_0x2
	CPI  R26,LOW(0x182)
	LDI  R30,HIGH(0x182)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x22
	CALL SUBOPT_0x2
	CPI  R26,LOW(0x19F)
	LDI  R30,HIGH(0x19F)
	CPC  R27,R30
	BRLO PC+3
	JMP _0x22
	RJMP _0x23
_0x22:
	RJMP _0x21
_0x23:
	RJMP _0x24
_0x21:
	RJMP _0x1E
_0x24:
;     296       {
;     297       //printf("A\n\r");  
;     298       //delay_ms(1000);
;     299       slave(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _slave
;     300       //delay_ms(1000);
;     301       }
;     302       else       
	RJMP _0x25
_0x1E:
;     303       if((x>385&&x<415)&&(y>330&&y<360))
	CALL SUBOPT_0x1
	CPI  R26,LOW(0x182)
	LDI  R30,HIGH(0x182)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x27
	CALL SUBOPT_0x1
	CPI  R26,LOW(0x19F)
	LDI  R30,HIGH(0x19F)
	CPC  R27,R30
	BRLO PC+3
	JMP _0x27
	RJMP _0x28
_0x27:
	RJMP _0x29
_0x28:
	CALL SUBOPT_0x2
	CPI  R26,LOW(0x14B)
	LDI  R30,HIGH(0x14B)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x2A
	CALL SUBOPT_0x2
	CPI  R26,LOW(0x168)
	LDI  R30,HIGH(0x168)
	CPC  R27,R30
	BRLO PC+3
	JMP _0x2A
	RJMP _0x2B
_0x2A:
	RJMP _0x29
_0x2B:
	RJMP _0x2C
_0x29:
	RJMP _0x26
_0x2C:
;     304       {
;     305       //printf("B\n\r"); 
;     306       //delay_ms(1000);  
;     307       slave(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _slave
;     308       //delay_ms(1000);
;     309       }      
;     310       else       
	RJMP _0x2D
_0x26:
;     311       if((x>255&&x<285)&&(y>310&&y<340))
	CALL SUBOPT_0x1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x2F
	CALL SUBOPT_0x1
	CPI  R26,LOW(0x11D)
	LDI  R30,HIGH(0x11D)
	CPC  R27,R30
	BRLO PC+3
	JMP _0x2F
	RJMP _0x30
_0x2F:
	RJMP _0x31
_0x30:
	CALL SUBOPT_0x2
	CPI  R26,LOW(0x137)
	LDI  R30,HIGH(0x137)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x32
	CALL SUBOPT_0x2
	CPI  R26,LOW(0x154)
	LDI  R30,HIGH(0x154)
	CPC  R27,R30
	BRLO PC+3
	JMP _0x32
	RJMP _0x33
_0x32:
	RJMP _0x31
_0x33:
	RJMP _0x34
_0x31:
	RJMP _0x2E
_0x34:
;     312       {
;     313       //printf("C\n\r");
;     314       //delay_ms(1000); 
;     315       slave(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _slave
;     316       //delay_ms(1000);
;     317       }  
;     318       else       
	RJMP _0x35
_0x2E:
;     319       if((x>330&&x<360)&&(y>310&&y<340))
	CALL SUBOPT_0x1
	CPI  R26,LOW(0x14B)
	LDI  R30,HIGH(0x14B)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x37
	CALL SUBOPT_0x1
	CPI  R26,LOW(0x168)
	LDI  R30,HIGH(0x168)
	CPC  R27,R30
	BRLO PC+3
	JMP _0x37
	RJMP _0x38
_0x37:
	RJMP _0x39
_0x38:
	CALL SUBOPT_0x2
	CPI  R26,LOW(0x137)
	LDI  R30,HIGH(0x137)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x3A
	CALL SUBOPT_0x2
	CPI  R26,LOW(0x154)
	LDI  R30,HIGH(0x154)
	CPC  R27,R30
	BRLO PC+3
	JMP _0x3A
	RJMP _0x3B
_0x3A:
	RJMP _0x39
_0x3B:
	RJMP _0x3C
_0x39:
	RJMP _0x36
_0x3C:
;     320       {
;     321       //printf("D\n\r");   
;     322       //delay_ms(1000); 
;     323       slave(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _slave
;     324       //delay_ms(1000);
;     325       }  
;     326       else       
	RJMP _0x3D
_0x36:
;     327       if((x>320&&x<350)&&(y>315&&y<345))
	CALL SUBOPT_0x1
	CPI  R26,LOW(0x141)
	LDI  R30,HIGH(0x141)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x3F
	CALL SUBOPT_0x1
	CPI  R26,LOW(0x15E)
	LDI  R30,HIGH(0x15E)
	CPC  R27,R30
	BRLO PC+3
	JMP _0x3F
	RJMP _0x40
_0x3F:
	RJMP _0x41
_0x40:
	CALL SUBOPT_0x2
	CPI  R26,LOW(0x13C)
	LDI  R30,HIGH(0x13C)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x42
	CALL SUBOPT_0x2
	CPI  R26,LOW(0x159)
	LDI  R30,HIGH(0x159)
	CPC  R27,R30
	BRLO PC+3
	JMP _0x42
	RJMP _0x43
_0x42:
	RJMP _0x41
_0x43:
	RJMP _0x44
_0x41:
	RJMP _0x3E
_0x44:
;     328       {
;     329       //printf("E\n\r");
;     330       //delay_ms(1000); 
;     331       slave(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _slave
;     332       //delay_ms(1000);
;     333       }  
;     334       else
	RJMP _0x45
_0x3E:
;     335       {
;     336       //printf("Invalid position 1\n\r");  
;     337       delay_ms(1000);
	CALL SUBOPT_0x3
;     338       } 
_0x45:
_0x3D:
_0x35:
_0x2D:
_0x25:
;     339       }     
;     340       
;     341       
;     342      if(count==2)
_0x1D:
	LDI  R30,LOW(2)
	CP   R30,R4
	BREQ PC+3
	JMP _0x46
;     343       
;     344       {
;     345          //printf("working2");
;     346 //          printf("working1");
;     347        
;     348       if(rx_counter>0) 
	LDI  R30,LOW(0)
	CP   R30,R9
	BRLO PC+3
	JMP _0x47
;     349       { 
;     350      
;     351       while(getchar()!='$'); 
_0x48:
	CALL _getchar
	CPI  R30,LOW(0x24)
	BRNE PC+3
	JMP _0x4A
	RJMP _0x48
_0x4A:
;     352      
;     353       
;     354       data=getchar();
	CALL _getchar
	MOV  R5,R30
;     355       if(data=='A')
	LDI  R30,LOW(65)
	CP   R30,R5
	BREQ PC+3
	JMP _0x4B
;     356       {  
;     357 //         printf("working2");
;     358       
;     359       for(i=0;i<2;i++)
	CLR  R6
_0x4D:
	LDI  R30,LOW(2)
	CP   R6,R30
	BRLO PC+3
	JMP _0x4E
;     360       {
;     361       PORTD.4=1;  
	CALL SUBOPT_0x4
;     362       PORTD.5=1;
;     363       delay_ms(1000);
;     364       PORTD.4=0;  
	CALL SUBOPT_0x5
;     365       PORTD.5=0;
;     366       delay_ms(1000); 
;     367       
;     368      
;     369       
;     370       } 
_0x4C:
	INC  R6
	RJMP _0x4D
_0x4E:
;     371        delay_ms(5000);
	CALL SUBOPT_0x6
;     372       }
;     373         
;     374       
;     375       if(data=='B')
_0x4B:
	LDI  R30,LOW(66)
	CP   R30,R5
	BREQ PC+3
	JMP _0x4F
;     376       { 
;     377       for(i=0;i<3;i++)
	CLR  R6
_0x51:
	LDI  R30,LOW(3)
	CP   R6,R30
	BRLO PC+3
	JMP _0x52
;     378       {
;     379       PORTD.4=1; 
	CALL SUBOPT_0x4
;     380       PORTD.5=1;
;     381       delay_ms(1000);
;     382       PORTD.4=0; 
	CALL SUBOPT_0x5
;     383       PORTD.5=0;
;     384       delay_ms(1000);
;     385       
;     386       
;     387       }
_0x50:
	INC  R6
	RJMP _0x51
_0x52:
;     388       delay_ms(5000); 
	CALL SUBOPT_0x6
;     389       }
;     390             
;     391       if(data=='C')
_0x4F:
	LDI  R30,LOW(67)
	CP   R30,R5
	BREQ PC+3
	JMP _0x53
;     392       { 
;     393       for(i=0;i<4;i++)
	CLR  R6
_0x55:
	LDI  R30,LOW(4)
	CP   R6,R30
	BRLO PC+3
	JMP _0x56
;     394       {
;     395       PORTD.4=1;  
	CALL SUBOPT_0x4
;     396        PORTD.5=1;
;     397       delay_ms(1000);
;     398       PORTD.4=0; 
	CALL SUBOPT_0x5
;     399       PORTD.5=0;
;     400       delay_ms(1000);
;     401       
;     402      
;     403       }  
_0x54:
	INC  R6
	RJMP _0x55
_0x56:
;     404       delay_ms(5000);
	CALL SUBOPT_0x6
;     405       }   
;     406       
;     407       if(data=='D')
_0x53:
	LDI  R30,LOW(68)
	CP   R30,R5
	BREQ PC+3
	JMP _0x57
;     408       { 
;     409        for(i=0;i<5;i++)
	CLR  R6
_0x59:
	LDI  R30,LOW(5)
	CP   R6,R30
	BRLO PC+3
	JMP _0x5A
;     410       {
;     411       PORTD.4=1;
	CALL SUBOPT_0x4
;     412        PORTD.5=1;
;     413       delay_ms(1000);
;     414       PORTD.4=0; 
	CALL SUBOPT_0x5
;     415       PORTD.5=0;
;     416       delay_ms(1000); 
;     417        
;     418       
;     419       } 
_0x58:
	INC  R6
	RJMP _0x59
_0x5A:
;     420        delay_ms(5000);
	CALL SUBOPT_0x6
;     421       }
;     422       
;     423       
;     424       }
_0x57:
;     425       }
_0x47:
;     426       
;     427         
;     428       
;     429       };
_0x46:
	RJMP _0x1A
_0x1C:
;     430 }  
_0x5B:
	RJMP _0x5B
;     431 
;     432 void slave(unsigned char a)  
;     433 {
_slave:
;     434 
;     435       
;     436       
;     437       if(a==0)
;	a -> Y+0
	LD   R30,Y
	CPI  R30,0
	BREQ PC+3
	JMP _0x5C
;     438       { 
;     439       if((x1>310&&x1<340)&&(y1>385&&y1<415))
	CALL SUBOPT_0x7
	CPI  R26,LOW(0x137)
	LDI  R30,HIGH(0x137)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x5E
	CALL SUBOPT_0x8
	BRLO PC+3
	JMP _0x5E
	RJMP _0x5F
_0x5E:
	RJMP _0x60
_0x5F:
	CALL SUBOPT_0x9
	CPI  R26,LOW(0x182)
	LDI  R30,HIGH(0x182)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x61
	CALL SUBOPT_0xA
	BRLO PC+3
	JMP _0x61
	RJMP _0x62
_0x61:
	RJMP _0x60
_0x62:
	RJMP _0x63
_0x60:
	RJMP _0x5D
_0x63:
;     440       {
;     441       printf("$hi#");
	__POINTW1FN _0,0
	CALL SUBOPT_0xB
;     442       delay_ms(1000);
;     443       }
;     444       else       
	RJMP _0x64
_0x5D:
;     445       if((x1>385&&x1<415)&&(y1>330&&y1<360))
	CALL SUBOPT_0xC
	BRSH PC+3
	JMP _0x66
	CALL SUBOPT_0xD
	BRLO PC+3
	JMP _0x66
	RJMP _0x67
_0x66:
	RJMP _0x68
_0x67:
	CALL SUBOPT_0xE
	BRSH PC+3
	JMP _0x69
	CALL SUBOPT_0xF
	BRLO PC+3
	JMP _0x69
	RJMP _0x6A
_0x69:
	RJMP _0x68
_0x6A:
	RJMP _0x6B
_0x68:
	RJMP _0x65
_0x6B:
;     446       {
;     447       printf("$hello#\n\r"); 
	__POINTW1FN _0,5
	CALL SUBOPT_0xB
;     448       delay_ms(1000);
;     449       }      
;     450       else       
	RJMP _0x6C
_0x65:
;     451       if((x1>255&&x1<285)&&(y1>310&&y1<340))
	CALL SUBOPT_0x10
	BRSH PC+3
	JMP _0x6E
	CALL SUBOPT_0x11
	BRLO PC+3
	JMP _0x6E
	RJMP _0x6F
_0x6E:
	RJMP _0x70
_0x6F:
	CALL SUBOPT_0x12
	BRSH PC+3
	JMP _0x71
	CALL SUBOPT_0x13
	BRLO PC+3
	JMP _0x71
	RJMP _0x72
_0x71:
	RJMP _0x70
_0x72:
	RJMP _0x73
_0x70:
	RJMP _0x6D
_0x73:
;     452       {
;     453       printf("$slept?#\n\r");
	__POINTW1FN _0,15
	CALL SUBOPT_0xB
;     454       delay_ms(1000);
;     455       }  
;     456       else       
	RJMP _0x74
_0x6D:
;     457       if((x1>330&&x1<360)&&(y1>310&&y1<340))
	CALL SUBOPT_0x14
	BRSH PC+3
	JMP _0x76
	CALL SUBOPT_0x15
	BRLO PC+3
	JMP _0x76
	RJMP _0x77
_0x76:
	RJMP _0x78
_0x77:
	CALL SUBOPT_0x12
	BRSH PC+3
	JMP _0x79
	CALL SUBOPT_0x13
	BRLO PC+3
	JMP _0x79
	RJMP _0x7A
_0x79:
	RJMP _0x78
_0x7A:
	RJMP _0x7B
_0x78:
	RJMP _0x75
_0x7B:
;     458       {
;     459       printf("$bye#\n\r");   
	__POINTW1FN _0,26
	CALL SUBOPT_0xB
;     460       delay_ms(1000);
;     461       }  
;     462       else       
	RJMP _0x7C
_0x75:
;     463       if((x1>320&&x1<350)&&(y1>315&&y1<345))
	CALL SUBOPT_0x16
	BRSH PC+3
	JMP _0x7E
	CALL SUBOPT_0x17
	BRLO PC+3
	JMP _0x7E
	RJMP _0x7F
_0x7E:
	RJMP _0x80
_0x7F:
	CALL SUBOPT_0x18
	BRSH PC+3
	JMP _0x81
	CALL SUBOPT_0x19
	BRLO PC+3
	JMP _0x81
	RJMP _0x82
_0x81:
	RJMP _0x80
_0x82:
	RJMP _0x83
_0x80:
	RJMP _0x7D
_0x83:
;     464       {
;     465       printf("$miss u#\n\r");
	__POINTW1FN _0,34
	CALL SUBOPT_0xB
;     466       delay_ms(1000);
;     467       }  
;     468       else
	RJMP _0x84
_0x7D:
;     469       {
;     470       //printf("Invalid position 2\n\r"); 
;     471       delay_ms(1000);
	CALL SUBOPT_0x3
;     472       }   
_0x84:
_0x7C:
_0x74:
_0x6C:
_0x64:
;     473       }                  
;     474       
;     475       //-----------------
;     476       
;     477         if(a==1)
_0x5C:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x85
;     478       { 
;     479       if((x1>310&&x1<340)&&(y1>385&&y1<415))
	CALL SUBOPT_0x1A
	BRSH PC+3
	JMP _0x87
	CALL SUBOPT_0x8
	BRLO PC+3
	JMP _0x87
	RJMP _0x88
_0x87:
	RJMP _0x89
_0x88:
	CALL SUBOPT_0x1B
	BRSH PC+3
	JMP _0x8A
	CALL SUBOPT_0xA
	BRLO PC+3
	JMP _0x8A
	RJMP _0x8B
_0x8A:
	RJMP _0x89
_0x8B:
	RJMP _0x8C
_0x89:
	RJMP _0x86
_0x8C:
;     480       {
;     481       printf("$apple#\n\r");
	__POINTW1FN _0,45
	CALL SUBOPT_0xB
;     482       delay_ms(1000);
;     483       }
;     484       else       
	RJMP _0x8D
_0x86:
;     485       if((x1>385&&x1<415)&&(y1>330&&y1<360))
	CALL SUBOPT_0xC
	BRSH PC+3
	JMP _0x8F
	CALL SUBOPT_0xD
	BRLO PC+3
	JMP _0x8F
	RJMP _0x90
_0x8F:
	RJMP _0x91
_0x90:
	CALL SUBOPT_0xE
	BRSH PC+3
	JMP _0x92
	CALL SUBOPT_0xF
	BRLO PC+3
	JMP _0x92
	RJMP _0x93
_0x92:
	RJMP _0x91
_0x93:
	RJMP _0x94
_0x91:
	RJMP _0x8E
_0x94:
;     486       {
;     487       printf("$orange#\n\r"); 
	__POINTW1FN _0,55
	CALL SUBOPT_0xB
;     488       delay_ms(1000);
;     489       }      
;     490       else       
	RJMP _0x95
_0x8E:
;     491       if((x1>255&&x1<285)&&(y1>310&&y1<340))
	CALL SUBOPT_0x10
	BRSH PC+3
	JMP _0x97
	CALL SUBOPT_0x11
	BRLO PC+3
	JMP _0x97
	RJMP _0x98
_0x97:
	RJMP _0x99
_0x98:
	CALL SUBOPT_0x12
	BRSH PC+3
	JMP _0x9A
	CALL SUBOPT_0x13
	BRLO PC+3
	JMP _0x9A
	RJMP _0x9B
_0x9A:
	RJMP _0x99
_0x9B:
	RJMP _0x9C
_0x99:
	RJMP _0x96
_0x9C:
;     492       {
;     493       printf("$mango#\n\r");
	__POINTW1FN _0,66
	CALL SUBOPT_0xB
;     494       delay_ms(1000);
;     495       }  
;     496       else       
	RJMP _0x9D
_0x96:
;     497       if((x1>330&&x1<360)&&(y1>310&&y1<340))
	CALL SUBOPT_0x14
	BRSH PC+3
	JMP _0x9F
	CALL SUBOPT_0x15
	BRLO PC+3
	JMP _0x9F
	RJMP _0xA0
_0x9F:
	RJMP _0xA1
_0xA0:
	CALL SUBOPT_0x12
	BRSH PC+3
	JMP _0xA2
	CALL SUBOPT_0x13
	BRLO PC+3
	JMP _0xA2
	RJMP _0xA3
_0xA2:
	RJMP _0xA1
_0xA3:
	RJMP _0xA4
_0xA1:
	RJMP _0x9E
_0xA4:
;     498       {
;     499       printf("$pears#\n\r");   
	__POINTW1FN _0,76
	CALL SUBOPT_0xB
;     500       delay_ms(1000);
;     501       }  
;     502       else       
	RJMP _0xA5
_0x9E:
;     503       if((x1>320&&x1<350)&&(y1>315&&y1<345))
	CALL SUBOPT_0x16
	BRSH PC+3
	JMP _0xA7
	CALL SUBOPT_0x17
	BRLO PC+3
	JMP _0xA7
	RJMP _0xA8
_0xA7:
	RJMP _0xA9
_0xA8:
	CALL SUBOPT_0x18
	BRSH PC+3
	JMP _0xAA
	CALL SUBOPT_0x19
	BRLO PC+3
	JMP _0xAA
	RJMP _0xAB
_0xAA:
	RJMP _0xA9
_0xAB:
	RJMP _0xAC
_0xA9:
	RJMP _0xA6
_0xAC:
;     504       {
;     505       printf("$grapes#\n\r");
	__POINTW1FN _0,86
	CALL SUBOPT_0xB
;     506       delay_ms(1000);
;     507       }  
;     508       else
	RJMP _0xAD
_0xA6:
;     509       {
;     510       //printf("Invalid position 2\n\r"); 
;     511       delay_ms(1000);
	CALL SUBOPT_0x3
;     512       }   
_0xAD:
_0xA5:
_0x9D:
_0x95:
_0x8D:
;     513       }
;     514       
;     515       //--------------------------
;     516       
;     517         if(a==2)
_0x85:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BREQ PC+3
	JMP _0xAE
;     518       { 
;     519       if((x1>310&&x1<340)&&(y1>385&&y1<415))
	CALL SUBOPT_0x1A
	BRSH PC+3
	JMP _0xB0
	CALL SUBOPT_0x8
	BRLO PC+3
	JMP _0xB0
	RJMP _0xB1
_0xB0:
	RJMP _0xB2
_0xB1:
	CALL SUBOPT_0x1B
	BRSH PC+3
	JMP _0xB3
	CALL SUBOPT_0xA
	BRLO PC+3
	JMP _0xB3
	RJMP _0xB4
_0xB3:
	RJMP _0xB2
_0xB4:
	RJMP _0xB5
_0xB2:
	RJMP _0xAF
_0xB5:
;     520       {
;     521       printf("$car#\n\r");
	__POINTW1FN _0,97
	CALL SUBOPT_0xB
;     522       delay_ms(1000);
;     523       }
;     524       else       
	RJMP _0xB6
_0xAF:
;     525       if((x1>385&&x1<415)&&(y1>330&&y1<360))
	CALL SUBOPT_0xC
	BRSH PC+3
	JMP _0xB8
	CALL SUBOPT_0xD
	BRLO PC+3
	JMP _0xB8
	RJMP _0xB9
_0xB8:
	RJMP _0xBA
_0xB9:
	CALL SUBOPT_0xE
	BRSH PC+3
	JMP _0xBB
	CALL SUBOPT_0xF
	BRLO PC+3
	JMP _0xBB
	RJMP _0xBC
_0xBB:
	RJMP _0xBA
_0xBC:
	RJMP _0xBD
_0xBA:
	RJMP _0xB7
_0xBD:
;     526       {
;     527       printf("$bus#\n\r"); 
	__POINTW1FN _0,105
	CALL SUBOPT_0xB
;     528       delay_ms(1000);
;     529       }      
;     530       else       
	RJMP _0xBE
_0xB7:
;     531       if((x1>255&&x1<285)&&(y1>310&&y1<340))
	CALL SUBOPT_0x10
	BRSH PC+3
	JMP _0xC0
	CALL SUBOPT_0x11
	BRLO PC+3
	JMP _0xC0
	RJMP _0xC1
_0xC0:
	RJMP _0xC2
_0xC1:
	CALL SUBOPT_0x12
	BRSH PC+3
	JMP _0xC3
	CALL SUBOPT_0x13
	BRLO PC+3
	JMP _0xC3
	RJMP _0xC4
_0xC3:
	RJMP _0xC2
_0xC4:
	RJMP _0xC5
_0xC2:
	RJMP _0xBF
_0xC5:
;     532       {
;     533       printf("$bike#\n\r");
	__POINTW1FN _0,113
	CALL SUBOPT_0xB
;     534       delay_ms(1000);
;     535       }  
;     536       else       
	RJMP _0xC6
_0xBF:
;     537       if((x1>330&&x1<360)&&(y1>310&&y1<340))
	CALL SUBOPT_0x14
	BRSH PC+3
	JMP _0xC8
	CALL SUBOPT_0x15
	BRLO PC+3
	JMP _0xC8
	RJMP _0xC9
_0xC8:
	RJMP _0xCA
_0xC9:
	CALL SUBOPT_0x12
	BRSH PC+3
	JMP _0xCB
	CALL SUBOPT_0x13
	BRLO PC+3
	JMP _0xCB
	RJMP _0xCC
_0xCB:
	RJMP _0xCA
_0xCC:
	RJMP _0xCD
_0xCA:
	RJMP _0xC7
_0xCD:
;     538       {
;     539       printf("$truck#\n\r");   
	__POINTW1FN _0,122
	CALL SUBOPT_0xB
;     540       delay_ms(1000);
;     541       }  
;     542       else       
	RJMP _0xCE
_0xC7:
;     543       if((x1>320&&x1<350)&&(y1>315&&y1<345))
	CALL SUBOPT_0x16
	BRSH PC+3
	JMP _0xD0
	CALL SUBOPT_0x17
	BRLO PC+3
	JMP _0xD0
	RJMP _0xD1
_0xD0:
	RJMP _0xD2
_0xD1:
	CALL SUBOPT_0x18
	BRSH PC+3
	JMP _0xD3
	CALL SUBOPT_0x19
	BRLO PC+3
	JMP _0xD3
	RJMP _0xD4
_0xD3:
	RJMP _0xD2
_0xD4:
	RJMP _0xD5
_0xD2:
	RJMP _0xCF
_0xD5:
;     544       {
;     545       printf("$rickshaw#\n\r");
	__POINTW1FN _0,132
	CALL SUBOPT_0xB
;     546       delay_ms(1000);
;     547       }  
;     548       else
	RJMP _0xD6
_0xCF:
;     549       {
;     550       //printf("Invalid position 2\n\r"); 
;     551       delay_ms(1000);
	CALL SUBOPT_0x3
;     552       }   
_0xD6:
_0xCE:
_0xC6:
_0xBE:
_0xB6:
;     553       }
;     554       
;     555       //--------------------------
;     556       
;     557         if(a==3)
_0xAE:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BREQ PC+3
	JMP _0xD7
;     558       { 
;     559       if((x1>310&&x1<340)&&(y1>385&&y1<415))
	CALL SUBOPT_0x1A
	BRSH PC+3
	JMP _0xD9
	CALL SUBOPT_0x8
	BRLO PC+3
	JMP _0xD9
	RJMP _0xDA
_0xD9:
	RJMP _0xDB
_0xDA:
	CALL SUBOPT_0x1B
	BRSH PC+3
	JMP _0xDC
	CALL SUBOPT_0xA
	BRLO PC+3
	JMP _0xDC
	RJMP _0xDD
_0xDC:
	RJMP _0xDB
_0xDD:
	RJMP _0xDE
_0xDB:
	RJMP _0xD8
_0xDE:
;     560       {
;     561       printf("$india#\n\r");
	__POINTW1FN _0,145
	CALL SUBOPT_0xB
;     562       delay_ms(1000);
;     563       }
;     564       else       
	RJMP _0xDF
_0xD8:
;     565       if((x1>385&&x1<415)&&(y1>330&&y1<360))
	CALL SUBOPT_0xC
	BRSH PC+3
	JMP _0xE1
	CALL SUBOPT_0xD
	BRLO PC+3
	JMP _0xE1
	RJMP _0xE2
_0xE1:
	RJMP _0xE3
_0xE2:
	CALL SUBOPT_0xE
	BRSH PC+3
	JMP _0xE4
	CALL SUBOPT_0xF
	BRLO PC+3
	JMP _0xE4
	RJMP _0xE5
_0xE4:
	RJMP _0xE3
_0xE5:
	RJMP _0xE6
_0xE3:
	RJMP _0xE0
_0xE6:
;     566       {
;     567       printf("$US#\n\r"); 
	__POINTW1FN _0,155
	CALL SUBOPT_0xB
;     568       delay_ms(1000);
;     569       }      
;     570       else       
	RJMP _0xE7
_0xE0:
;     571       if((x1>255&&x1<285)&&(y1>310&&y1<340))
	CALL SUBOPT_0x10
	BRSH PC+3
	JMP _0xE9
	CALL SUBOPT_0x11
	BRLO PC+3
	JMP _0xE9
	RJMP _0xEA
_0xE9:
	RJMP _0xEB
_0xEA:
	CALL SUBOPT_0x12
	BRSH PC+3
	JMP _0xEC
	CALL SUBOPT_0x13
	BRLO PC+3
	JMP _0xEC
	RJMP _0xED
_0xEC:
	RJMP _0xEB
_0xED:
	RJMP _0xEE
_0xEB:
	RJMP _0xE8
_0xEE:
;     572       {
;     573       printf("$UK#\n\r");
	__POINTW1FN _0,162
	CALL SUBOPT_0xB
;     574       delay_ms(1000);
;     575       }  
;     576       else       
	RJMP _0xEF
_0xE8:
;     577       if((x1>330&&x1<360)&&(y1>310&&y1<340))
	CALL SUBOPT_0x14
	BRSH PC+3
	JMP _0xF1
	CALL SUBOPT_0x15
	BRLO PC+3
	JMP _0xF1
	RJMP _0xF2
_0xF1:
	RJMP _0xF3
_0xF2:
	CALL SUBOPT_0x12
	BRSH PC+3
	JMP _0xF4
	CALL SUBOPT_0x13
	BRLO PC+3
	JMP _0xF4
	RJMP _0xF5
_0xF4:
	RJMP _0xF3
_0xF5:
	RJMP _0xF6
_0xF3:
	RJMP _0xF0
_0xF6:
;     578       {
;     579       printf("$Canada#\n\r");   
	__POINTW1FN _0,169
	CALL SUBOPT_0xB
;     580       delay_ms(1000);
;     581       }  
;     582       else       
	RJMP _0xF7
_0xF0:
;     583       if((x1>320&&x1<350)&&(y1>315&&y1<345))
	CALL SUBOPT_0x16
	BRSH PC+3
	JMP _0xF9
	CALL SUBOPT_0x17
	BRLO PC+3
	JMP _0xF9
	RJMP _0xFA
_0xF9:
	RJMP _0xFB
_0xFA:
	CALL SUBOPT_0x18
	BRSH PC+3
	JMP _0xFC
	CALL SUBOPT_0x19
	BRLO PC+3
	JMP _0xFC
	RJMP _0xFD
_0xFC:
	RJMP _0xFB
_0xFD:
	RJMP _0xFE
_0xFB:
	RJMP _0xF8
_0xFE:
;     584       {
;     585       printf("$Germany#\n\r");
	__POINTW1FN _0,180
	CALL SUBOPT_0xB
;     586       delay_ms(1000);
;     587       }  
;     588       else
	RJMP _0xFF
_0xF8:
;     589       {
;     590       //printf("Invalid position 2\n\r"); 
;     591       delay_ms(1000);
	CALL SUBOPT_0x3
;     592       }   
_0xFF:
_0xF7:
_0xEF:
_0xE7:
_0xDF:
;     593       }
;     594       
;     595       //-----------------------------
;     596       
;     597         if(a==4)
_0xD7:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BREQ PC+3
	JMP _0x100
;     598       { 
;     599       if((x1>310&&x1<340)&&(y1>385&&y1<415))
	CALL SUBOPT_0x1A
	BRSH PC+3
	JMP _0x102
	CALL SUBOPT_0x8
	BRLO PC+3
	JMP _0x102
	RJMP _0x103
_0x102:
	RJMP _0x104
_0x103:
	CALL SUBOPT_0x1B
	BRSH PC+3
	JMP _0x105
	CALL SUBOPT_0xA
	BRLO PC+3
	JMP _0x105
	RJMP _0x106
_0x105:
	RJMP _0x104
_0x106:
	RJMP _0x107
_0x104:
	RJMP _0x101
_0x107:
;     600       {
;     601       printf("$Phone#\n\r");
	__POINTW1FN _0,192
	CALL SUBOPT_0xB
;     602       delay_ms(1000);
;     603       }
;     604       else       
	RJMP _0x108
_0x101:
;     605       if((x1>385&&x1<415)&&(y1>330&&y1<360))
	CALL SUBOPT_0xC
	BRSH PC+3
	JMP _0x10A
	CALL SUBOPT_0xD
	BRLO PC+3
	JMP _0x10A
	RJMP _0x10B
_0x10A:
	RJMP _0x10C
_0x10B:
	CALL SUBOPT_0xE
	BRSH PC+3
	JMP _0x10D
	CALL SUBOPT_0xF
	BRLO PC+3
	JMP _0x10D
	RJMP _0x10E
_0x10D:
	RJMP _0x10C
_0x10E:
	RJMP _0x10F
_0x10C:
	RJMP _0x109
_0x10F:
;     606       {
;     607       printf("$Watch#\n\r"); 
	__POINTW1FN _0,202
	CALL SUBOPT_0xB
;     608       delay_ms(1000);
;     609       }      
;     610       else       
	RJMP _0x110
_0x109:
;     611       if((x1>255&&x1<285)&&(y1>310&&y1<340))
	CALL SUBOPT_0x10
	BRSH PC+3
	JMP _0x112
	CALL SUBOPT_0x11
	BRLO PC+3
	JMP _0x112
	RJMP _0x113
_0x112:
	RJMP _0x114
_0x113:
	CALL SUBOPT_0x12
	BRSH PC+3
	JMP _0x115
	CALL SUBOPT_0x13
	BRLO PC+3
	JMP _0x115
	RJMP _0x116
_0x115:
	RJMP _0x114
_0x116:
	RJMP _0x117
_0x114:
	RJMP _0x111
_0x117:
;     612       {
;     613       printf("$PC#\n\r");
	__POINTW1FN _0,212
	CALL SUBOPT_0xB
;     614       delay_ms(1000);
;     615       }  
;     616       else       
	RJMP _0x118
_0x111:
;     617       if((x1>330&&x1<360)&&(y1>310&&y1<340))
	CALL SUBOPT_0x14
	BRSH PC+3
	JMP _0x11A
	CALL SUBOPT_0x15
	BRLO PC+3
	JMP _0x11A
	RJMP _0x11B
_0x11A:
	RJMP _0x11C
_0x11B:
	CALL SUBOPT_0x12
	BRSH PC+3
	JMP _0x11D
	CALL SUBOPT_0x13
	BRLO PC+3
	JMP _0x11D
	RJMP _0x11E
_0x11D:
	RJMP _0x11C
_0x11E:
	RJMP _0x11F
_0x11C:
	RJMP _0x119
_0x11F:
;     618       {
;     619       printf("$Internet#\n\r");   
	__POINTW1FN _0,219
	CALL SUBOPT_0xB
;     620       delay_ms(1000);
;     621       }  
;     622       else       
	RJMP _0x120
_0x119:
;     623       if((x1>320&&x1<350)&&(y1>315&&y1<345))
	CALL SUBOPT_0x16
	BRSH PC+3
	JMP _0x122
	CALL SUBOPT_0x17
	BRLO PC+3
	JMP _0x122
	RJMP _0x123
_0x122:
	RJMP _0x124
_0x123:
	CALL SUBOPT_0x18
	BRSH PC+3
	JMP _0x125
	CALL SUBOPT_0x19
	BRLO PC+3
	JMP _0x125
	RJMP _0x126
_0x125:
	RJMP _0x124
_0x126:
	RJMP _0x127
_0x124:
	RJMP _0x121
_0x127:
;     624       {
;     625       printf("$Laptop#\n\r");
	__POINTW1FN _0,232
	CALL SUBOPT_0xB
;     626       delay_ms(1000);
;     627       }  
;     628       else
	RJMP _0x128
_0x121:
;     629       {
;     630       //printf("Invalid position 2\n\r"); 
;     631       delay_ms(1000);
	CALL SUBOPT_0x3
;     632       }   
_0x128:
_0x120:
_0x118:
_0x110:
_0x108:
;     633       }
;     634       
;     635       }
_0x100:
	ADIW R28,1
	RET
;     636 
;     637 
;     638 //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;     639 
;     640 //   if(count==2)
;     641 //       
;     642 //       {
;     643 //          //printf("working2");
;     644 //       
;     645 //        
;     646 //       if(rx_counter>0) 
;     647 //       { 
;     648 //      
;     649 //       while(getchar()!='$'); 
;     650 //        //printf("working2");
;     651 //       
;     652 //       data=getchar();
;     653 //       if(data=='A')
;     654 //       { 
;     655 //       for(i=0;i<2;i++)
;     656 //       {
;     657 //       PORTD.5=1;
;     658 //       delay_ms(100);
;     659 //       PORTD.5=0;
;     660 //       delay_ms(100); 
;     661 //       
;     662 //       } 
;     663 //        delay_ms(1000);
;     664 //       }
;     665 //         
;     666 //       
;     667 //       if(data=='B')
;     668 //       { 
;     669 //       for(i=0;i++;i<3)
;     670 //       {
;     671 //       PORTD.5=1;
;     672 //       delay_ms(100);
;     673 //       PORTD.5=0;
;     674 //       delay_ms(100);
;     675 //       }
;     676 //       delay_ms(1000); 
;     677 //       }
;     678 //             
;     679 //       if(data=='C')
;     680 //       { 
;     681 //       for(i=0;i++;i<4)
;     682 //       {
;     683 //       PORTD.5=1;
;     684 //       delay_ms(100);
;     685 //       PORTD.5=0;
;     686 //       delay_ms(100);
;     687 //       }  
;     688 //       delay_ms(1000);
;     689 //       }   
;     690 //       
;     691 //       if(data=='D')
;     692 //       { 
;     693 //        for(i=0;i++;i<5)
;     694 //       {
;     695 //       PORTD.5=1;
;     696 //       delay_ms(100);
;     697 //       PORTD.5=0;
;     698 //       delay_ms(100); 
;     699 //       
;     700 //       } 
;     701 //        delay_ms(1000);
;     702 //       }
;     703 //       
;     704 //       
;     705 //       }
;     706 //       }
;     707 
;     708 
;     709 

__put_G2:
	LD   R26,Y
	LDD  R27,Y+1
	CALL __GETW1P
	SBIW R30,0
	BRNE PC+3
	JMP _0x129
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+2
	STD  Z+0,R26
	RJMP _0x12A
_0x129:
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _putchar
_0x12A:
	ADIW R28,3
	RET
__print_G2:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R16,0
_0x12B:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x12D
	MOV  R30,R16
	CPI  R30,0
	BREQ PC+3
	JMP _0x131
	CPI  R19,37
	BREQ PC+3
	JMP _0x132
	LDI  R16,LOW(1)
	RJMP _0x133
_0x132:
	CALL SUBOPT_0x1C
_0x133:
	RJMP _0x130
_0x131:
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x134
	CPI  R19,37
	BREQ PC+3
	JMP _0x135
	CALL SUBOPT_0x1C
	LDI  R16,LOW(0)
	RJMP _0x130
_0x135:
	LDI  R16,LOW(2)
	LDI  R21,LOW(0)
	LDI  R17,LOW(0)
	CPI  R19,45
	BREQ PC+3
	JMP _0x136
	LDI  R17,LOW(1)
	RJMP _0x130
_0x136:
	CPI  R19,43
	BREQ PC+3
	JMP _0x137
	LDI  R21,LOW(43)
	RJMP _0x130
_0x137:
	CPI  R19,32
	BREQ PC+3
	JMP _0x138
	LDI  R21,LOW(32)
	RJMP _0x130
_0x138:
	RJMP _0x139
_0x134:
	CPI  R30,LOW(0x2)
	BREQ PC+3
	JMP _0x13A
_0x139:
	LDI  R20,LOW(0)
	LDI  R16,LOW(3)
	CPI  R19,48
	BREQ PC+3
	JMP _0x13B
	ORI  R17,LOW(128)
	RJMP _0x130
_0x13B:
	RJMP _0x13C
_0x13A:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x130
_0x13C:
	CPI  R19,48
	BRSH PC+3
	JMP _0x13F
	CPI  R19,58
	BRLO PC+3
	JMP _0x13F
	RJMP _0x140
_0x13F:
	RJMP _0x13E
_0x140:
	MOV  R26,R20
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R20,R30
	MOV  R30,R19
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x130
_0x13E:
	MOV  R30,R19
	CPI  R30,LOW(0x63)
	BREQ PC+3
	JMP _0x144
	CALL SUBOPT_0x1D
	LD   R30,X
	CALL SUBOPT_0x1E
	RJMP _0x145
	RJMP _0x146
_0x144:
	CPI  R30,LOW(0x73)
	BREQ PC+3
	JMP _0x147
_0x146:
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1F
	CALL _strlen
	MOV  R16,R30
	RJMP _0x148
	RJMP _0x149
_0x147:
	CPI  R30,LOW(0x70)
	BREQ PC+3
	JMP _0x14A
_0x149:
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1F
	CALL _strlenf
	MOV  R16,R30
	ORI  R17,LOW(8)
_0x148:
	ORI  R17,LOW(2)
	ANDI R17,LOW(127)
	LDI  R18,LOW(0)
	RJMP _0x14B
	RJMP _0x14C
_0x14A:
	CPI  R30,LOW(0x64)
	BREQ PC+3
	JMP _0x14D
_0x14C:
	RJMP _0x14E
_0x14D:
	CPI  R30,LOW(0x69)
	BREQ PC+3
	JMP _0x14F
_0x14E:
	ORI  R17,LOW(4)
	RJMP _0x150
_0x14F:
	CPI  R30,LOW(0x75)
	BREQ PC+3
	JMP _0x151
_0x150:
	LDI  R30,LOW(_tbl10_G2*2)
	LDI  R31,HIGH(_tbl10_G2*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R16,LOW(5)
	RJMP _0x152
	RJMP _0x153
_0x151:
	CPI  R30,LOW(0x58)
	BREQ PC+3
	JMP _0x154
_0x153:
	ORI  R17,LOW(8)
	RJMP _0x155
_0x154:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x186
_0x155:
	LDI  R30,LOW(_tbl16_G2*2)
	LDI  R31,HIGH(_tbl16_G2*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R16,LOW(4)
_0x152:
	SBRS R17,2
	RJMP _0x157
	CALL SUBOPT_0x1D
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,0
	BRLT PC+3
	JMP _0x158
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R21,LOW(45)
_0x158:
	CPI  R21,0
	BRNE PC+3
	JMP _0x159
	SUBI R16,-LOW(1)
	RJMP _0x15A
_0x159:
	ANDI R17,LOW(251)
_0x15A:
	RJMP _0x15B
_0x157:
	CALL SUBOPT_0x1D
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x15B:
_0x14B:
	SBRC R17,0
	RJMP _0x15C
_0x15D:
	CP   R16,R20
	BRLO PC+3
	JMP _0x15F
	SBRS R17,7
	RJMP _0x160
	SBRS R17,2
	RJMP _0x161
	ANDI R17,LOW(251)
	MOV  R19,R21
	SUBI R16,LOW(1)
	RJMP _0x162
_0x161:
	LDI  R19,LOW(48)
_0x162:
	RJMP _0x163
_0x160:
	LDI  R19,LOW(32)
_0x163:
	CALL SUBOPT_0x1C
	SUBI R20,LOW(1)
	RJMP _0x15D
_0x15F:
_0x15C:
	MOV  R18,R16
	SBRS R17,1
	RJMP _0x164
_0x165:
	CPI  R18,0
	BRNE PC+3
	JMP _0x167
	SBRS R17,3
	RJMP _0x168
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,1
	LPM  R30,Z
	CALL SUBOPT_0x1E
	RJMP _0x169
_0x168:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
	CALL SUBOPT_0x1E
_0x169:
	CPI  R20,0
	BRNE PC+3
	JMP _0x16A
	SUBI R20,LOW(1)
_0x16A:
	SUBI R18,LOW(1)
	RJMP _0x165
_0x167:
	RJMP _0x16B
_0x164:
_0x16D:
	LDI  R19,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,2
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
_0x16F:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRSH PC+3
	JMP _0x171
	SUBI R19,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x16F
_0x171:
	CPI  R19,58
	BRSH PC+3
	JMP _0x172
	SBRS R17,3
	RJMP _0x173
	SUBI R19,-LOW(7)
	RJMP _0x174
_0x173:
	SUBI R19,-LOW(39)
_0x174:
_0x172:
	SBRS R17,4
	RJMP _0x175
	RJMP _0x176
_0x175:
	CPI  R19,49
	BRLO PC+3
	JMP _0x178
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE PC+3
	JMP _0x178
	RJMP _0x177
_0x178:
	ORI  R17,LOW(16)
	RJMP _0x17A
_0x177:
	CP   R20,R18
	BRSH PC+3
	JMP _0x17C
	SBRC R17,0
	RJMP _0x17C
	RJMP _0x17D
_0x17C:
	RJMP _0x17B
_0x17D:
	LDI  R19,LOW(32)
	SBRS R17,7
	RJMP _0x17E
	LDI  R19,LOW(48)
	ORI  R17,LOW(16)
_0x17A:
	SBRS R17,2
	RJMP _0x17F
	ANDI R17,LOW(251)
	ST   -Y,R21
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	CALL __put_G2
	CPI  R20,0
	BRNE PC+3
	JMP _0x180
	SUBI R20,LOW(1)
_0x180:
_0x17F:
_0x17E:
_0x176:
	CALL SUBOPT_0x1C
	CPI  R20,0
	BRNE PC+3
	JMP _0x181
	SUBI R20,LOW(1)
_0x181:
_0x17B:
	SUBI R18,LOW(1)
_0x16C:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRSH PC+3
	JMP _0x16E
	RJMP _0x16D
_0x16E:
_0x16B:
	SBRS R17,0
	RJMP _0x182
_0x183:
	CPI  R20,0
	BRNE PC+3
	JMP _0x185
	SUBI R20,LOW(1)
	LDI  R30,LOW(32)
	CALL SUBOPT_0x1E
	RJMP _0x183
_0x185:
_0x182:
_0x186:
_0x145:
	LDI  R16,LOW(0)
_0x143:
_0x130:
	RJMP _0x12B
_0x12D:
	CALL __LOADLOCR6
	ADIW R28,18
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,2
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,0
	STD  Y+2,R30
	STD  Y+2+1,R30
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	CALL __print_G2
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	POP  R15
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 44 TIMES, CODE SIZE REDUCTION:83 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1:
	LDS  R26,_x
	LDS  R27,_x+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2:
	LDS  R26,_y
	LDS  R27,_y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 39 TIMES, CODE SIZE REDUCTION:73 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	SBI  0x12,4
	SBI  0x12,5
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	CBI  0x12,4
	CBI  0x12,5
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 50 TIMES, CODE SIZE REDUCTION:95 WORDS
SUBOPT_0x7:
	LDS  R26,_x1
	LDS  R27,_x1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	CALL SUBOPT_0x7
	CPI  R26,LOW(0x154)
	LDI  R30,HIGH(0x154)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 50 TIMES, CODE SIZE REDUCTION:95 WORDS
SUBOPT_0x9:
	LDS  R26,_y1
	LDS  R27,_y1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	CALL SUBOPT_0x9
	CPI  R26,LOW(0x19F)
	LDI  R30,HIGH(0x19F)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:141 WORDS
SUBOPT_0xB:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	CALL SUBOPT_0x7
	CPI  R26,LOW(0x182)
	LDI  R30,HIGH(0x182)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	CALL SUBOPT_0x7
	CPI  R26,LOW(0x19F)
	LDI  R30,HIGH(0x19F)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE:
	CALL SUBOPT_0x9
	CPI  R26,LOW(0x14B)
	LDI  R30,HIGH(0x14B)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF:
	CALL SUBOPT_0x9
	CPI  R26,LOW(0x168)
	LDI  R30,HIGH(0x168)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10:
	CALL SUBOPT_0x7
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	CALL SUBOPT_0x7
	CPI  R26,LOW(0x11D)
	LDI  R30,HIGH(0x11D)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x12:
	CALL SUBOPT_0x9
	CPI  R26,LOW(0x137)
	LDI  R30,HIGH(0x137)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x13:
	CALL SUBOPT_0x9
	CPI  R26,LOW(0x154)
	LDI  R30,HIGH(0x154)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x14:
	CALL SUBOPT_0x7
	CPI  R26,LOW(0x14B)
	LDI  R30,HIGH(0x14B)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x15:
	CALL SUBOPT_0x7
	CPI  R26,LOW(0x168)
	LDI  R30,HIGH(0x168)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x16:
	CALL SUBOPT_0x7
	CPI  R26,LOW(0x141)
	LDI  R30,HIGH(0x141)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x17:
	CALL SUBOPT_0x7
	CPI  R26,LOW(0x15E)
	LDI  R30,HIGH(0x15E)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x18:
	CALL SUBOPT_0x9
	CPI  R26,LOW(0x13C)
	LDI  R30,HIGH(0x13C)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	CALL SUBOPT_0x9
	CPI  R26,LOW(0x159)
	LDI  R30,HIGH(0x159)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	CALL SUBOPT_0x7
	CPI  R26,LOW(0x137)
	LDI  R30,HIGH(0x137)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1B:
	CALL SUBOPT_0x9
	CPI  R26,LOW(0x182)
	LDI  R30,HIGH(0x182)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1C:
	ST   -Y,R19
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1D:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,4
	STD  Y+14,R26
	STD  Y+14+1,R27
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1E:
	ST   -Y,R30
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

_strlen:
	ld   r26,y+
	ld   r27,y+
	clr  r30
	clr  r31
__strlen0:
	ld   r22,x+
	tst  r22
	breq __strlen1
	adiw r30,1
	rjmp __strlen0
__strlen1:
	ret

_strlenf:
	clr  r26
	clr  r27
	ld   r30,y+
	ld   r31,y+
__strlenf0:
	lpm  r0,z+
	tst  r0
	breq __strlenf1
	adiw r26,1
	rjmp __strlenf0
__strlenf1:
	movw r30,r26
	ret

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	COM  R30
	COM  R31
	ADIW R30,1
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
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
