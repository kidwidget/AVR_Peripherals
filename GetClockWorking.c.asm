;
; GetClockWorking.asm
;
; Created: 8/30/2022 5:18:55 PM
; Author : kidwidget
;

; includes
.include "ATxmega32E5def.inc"

; def
.def temp = r16

; equ
.equ PROTECT = 0xD8

; interrupt vectors
.org 0x0000
	rjmp reset

; past interrupt vectors
.org 0x0056 

reset:
	; enable external 32KHz crytal and internal 32MHz 
	; external 32KHz will be used for calibration
	; protect io registers from interrupts
	ldi temp, PROTECT 
	out CPU_CCP, temp
	ldi temp, (1<<OSC_XOSCEN_bp) | (1<<OSC_RC32MEN_bp)
	sts OSC_CTRL, temp

	; wait for the internal 32MHz to stabilize
	waitFor32MHzInternal:
		lds temp, OSC_STATUS
		sbrs temp, OSC_RC32MRDY_bp
		rjmp waitFor32MHzInternal

	; use 32MHz internal clock, must protect from interrupts
	ldi temp, PROTECT
	sts CPU_CCP, temp
	ldi temp, CLK_SCLKSEL_RC32M_gc
	sts CLK_CTRL, temp

	; disable default 2MHz clock
	ldi temp, PROTECT
	out CPU_CCP, temp
	ldi temp, (0<<OSC_RC2MEN_bp)
	sts OSC_CTRL, temp
	
	; enable calibration, start by selecting external crystal
	ldi temp, OSC_RC32MCREF_RC32K_gc
	sts OSC_DFLLCTRL, temp
	;enable calibration
	ldi temp, (1<<DFLL_ENABLE_bp)

	; configure portD pin7 as output, have it ouput the system clock
	ldi temp, 0xFF
	sts PORTD_DIR, temp
	
	ldi temp, PORTCFG_CLKOUT_PD7_gc
	sts PORTCFG_CLKOUT, temp


loop:
	rjmp loop

	
