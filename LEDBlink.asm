;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Created by: Simeon Ramjit and Darnell Gracen ;
;Date: 18.01.2018							  ;
;Version: 1.4								  ;
;Program description: This program flashes    ;
;an LED on PORTD<7> with a frequency of 1Hz.  ;
;The flashing is controlled by an active low  ;
;switch on PORTD<6>.The clock freq is 4MHz    ;
;Notes: If the code doesn't work, check your  ;
;configuration bits and the PIC you're using  ;
;This was written for the PIC16F877 but you   ;
;may have the PIC16F877A.You'll have to change;
;the first two lines as well as 'Device' under;
;the tab 'Configure'						  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


				LIST  	p = 16f877		;Define microcontroller
				INCLUDE <P16F877.INC>		

REGA			EQU 	0x20				;Label three registers, later to be used to hold the delay counter values
REGB			EQU 	0x21
REGC			EQU 	0x22	

				ORG 	0x00				;Direct PIC where to load program from on reset
				goto	main
				
main
				ORG		0x20				;Start main program from this address to avoid conflicts with interrupt vectors etc.
				BANKSEL	TRISD				;Select bank 1, i.e. where the TRISD register is


				movlw	B'01000000'			;Define every in on PORTD as outputs except RD6, make an input for the switch
				movwf	TRISD				;Move value into TRISD register to configure it
				
;--------------------Starting Main Program---------------------------
checkSwitch	
			    BANKSEL	PORTD				;Select bank 0, i.e. where PORTD is	
				btfsc	PORTD,6				;Check switch status, is it high or low ? 
				goto 	startBlink			;If high execute startBlinking
				goto 	stopBlink			;If low execute stopBlinking
startBlink		
				BANKSEL	PORTD               ;Select bank again, just to be sure
				movlw	B'10000000'		    ;Make RD7 high
				movwf	PORTD				;Move value into register and turn on LED
				call	oneSecondDelay		;Keep lit for 1s
				movlw	B'00000000'		    ;Make RD7 low
				movwf 	PORTD				;Move value into register and turn off LED
				call	oneSecondDelay		;Keep off for 1s
				goto 	checkSwitch			;Goto to routine to determine status of switch

stopBlink	
				goto	checkSwitch		    ;Goto to routine to determine status of switch

;--------------------------Routines-------------------------------------
;It should be noted that the values in these registers are not what the original calculation gave,
;but the result after fine tuning.
oneSecondDelay
				movlw 0x07
				movwf REGA
loopOne
				movlw 0xC8
				movwf REGB
loopTwo
				movlw 0xED
				movwf REGC
loopThree
				decfsz REGC,F
				goto loopThree
				decfsz REGB,F
				goto loopTwo
				decfsz REGA,F
				goto loopOne
				return
;--------------------------Program Termination-------------------------------------
				END							