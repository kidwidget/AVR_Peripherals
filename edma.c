/*
 * napkin.c
 *
 * Created: 3/26/2024 8:29:09 PM
 * Author : kidwidget
 */ 

#include <avr/io.h>
#include <avr/cpufunc.h>
#include <avr/interrupt.h>


int main(void)
{
	// enable edma with 2 standard channels
	EDMA.CTRL |= EDMA_ENABLE_bm | EDMA_CHMODE_STD02_gc;
	// enable edma ch, burst length 1 byte
	EDMA.CH0.CTRLA |= EDMA_ENABLE_bm;
	// enable transaction finished interrupt
	EDMA.CH0.CTRLB |= EDMA_CH_TRNINTLVL_LO_gc;
	// reload source address after burst, do not increment
	EDMA.CH0.ADDRCTRL |= EDMA_CH_RELOAD_BURST_gc;
	// destination address reload at the end of block, increment
	EDMA.CH0.DESTADDRCTRL |= EDMA_CH_DESTRELOAD_BLOCK_gc | EDMA_CH_DESTDIR_INC_gc;
	// using software trigger, adc will trigger in real world
	// EDMA.CH0.TRIGSRC |= EDMA_CH_TRIGSRC_ADCA_CH0_gc;
	// block size = 10, real world use 3328
	EDMA.CH0.TRFCNT = 5;
	// source address = adc result
	EDMA.CH0.ADDR = 0x0224;
	// destination address = start of sram
	EDMA.CH0.DESTADDR = 0x2000;
	// enable global interrupts, and enable priority low
	sei();
	PMIC.CTRL|= PMIC_LOLVLEN_bm;
	// request edma
	EDMA.CH0.CTRLA |= EDMA_CH_TRFREQ_bm;
    while (1) 
    {
		// trigger edma
		_NOP();
		_NOP();
		_NOP();
		_NOP();
		_NOP();		
		_NOP();
		_NOP();
		_NOP();
		_NOP();

    }
}
ISR(EDMA_CH0_vect){
	EDMA.CH0.CTRLA |= EDMA_ENABLE_bm | EDMA_CH_TRFREQ_bm;
	EDMA.CH0.CTRLB |= EDMA_CH_TRNIF_bm;
}

