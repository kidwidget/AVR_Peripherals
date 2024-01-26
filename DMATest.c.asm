;
; DMATest.asm
;
; Created: 1/25/2024 4:23:10 PM
; Author : kidwidget
;
.include "iox32e5.h"

; Replace with your application code
start:
    ldi r16, 0xAA
	sts 0x2000, r16
; set up dma
	ldi r16, (EDMA_ENABLE_bm) | (EDMA_CHMODE_STD02_gc)
	sts EDMA_CTRL, r16

	ldi r16, (EDMA_ENABLE_bm)
	sts EDMA_CH0_CTRLA, r16

	ldi r16, (EDMA_CH_RELOAD_BLOCK_gc) | (EDMA_CH_DESTDIR_INC_gc)
	sts EDMA_CH0_DESTADDRCTRL, r16

	ldi r16, 0xE8;
	sts EDMA_CH0_TRFCNTL, r16
	ldi r16, 0x03
	sts EDMA_CH0_TRFCNTH, r16
	
	ldi r16, 0x00
	sts EDMA_CH0_ADDRL, r16
	ldi r16, 0x20
	sts EDMA_CH0_ADDRH, r16

	ldi r16, 0x01
	sts EDMA_CH0_DESTADDRL, r16
	ldi r16, 0x20
	sts EDMA_CH0_DESTADDRH, r16


; dma is set up start it and loop
	; put ctrla in r16, sbi on the transfer request bit, then put r16 back into ctrla
	; this keeps you from accidentally screwing up the settings
	lds r16, EDMA_CH0_CTRLA
	ori r16, (1 << EDMA_CH_TRFREQ_bp)
	sts EDMA_CH0_CTRLA, r16

loop: 
	rjmp loop

	

