start:
	;initialize registers
	mov r10, 0				;screen
	mov sp, 0
	
	;initialize displays
	send r10, 0x12e0		;set cursor to bottom
	send r10, 0x200a		;screen color
	mov r10, 1				;set r10 to decimal display
	send r10, 0x0000		;set display to zero
	mov r10, 0				;set back to screen
	
	call clearScr			;clear the screen
	
	mov r0, .startmessage	;get message
	call printText			;print it
.waitLoop1:
	recv r1, r10			;wait for data
	jnc .waitLoop1			;if none, keep checking
	
	call clearScr			;clear the screen
	
	mov r0, .startmessage2	;get another message
	call printText			;print it
	
	call clearScr			;clear screen
	
	mov r0, .startmessage3	;next message
	call printText			;print it
	
.fib:
	mov r10, 1				;set r10 to display
	mov r1, 0				;initialize r1 to 0
	mov r2, 1				;initialize r2 to 1
.loop:
	send r10, r1			;display number
	
	mov r4, r2				;move r2 into r4 to perform r3 = r2 + r1
	
	add r4, r1				;add them
	mov r3, r4				;move r4 into r3
	
	mov r1, r2				;move r2 into r1
	mov r2, r3				;move r3 into r2
	
	nop						;wait for display
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	
	cmp r1, 46368			;check if r1 is = to 46368
	jne .loop				;if number did not equal, keep going, otherwise, stop
	send r10, r1			;display last number
	
	hlt						;stop
	
.startmessage:
	dw "This is the RTERM P2 working",1
	dw "with the R2",1,1
	dw "But how?",1
	dw "Well, the R2 has the same I/O",1
	dw "port as the R1",1,1
	dw "Pros:",1
	dw " - Has a bigger display (32*24)",1
	dw " - Downwords scrolling",1,1
	dw "Cons:",1
	dw " - Takes more space",1
	dw " - Limited character set",1
	dw "   (Unextended)",1,1
	dw "Equal:",1
	dw " - Same color",1
	dw " - Same basic characters",1
	dw " - Same port",1
	dw " - Has a keyboard",1
	dw " - Same speed",1,1
	dw "Press any key to continue...",1
	dw "You may have to hold a key down",1,1,1,1,1
	
	dw 0
	
.startmessage2:
	dw "You see that you may have had to",1
	dw "hold a key down or press it",1
	dw "multiple times?",1,1
	dw "That is because the keyboard",1
	dw "sends the data right away",1
	dw "and for only one frame, it",1
	dw "requires at least two frames",1
	dw "                "
	
	dw 0
	
.startmessage3:
	dw "Now testing decimal display",1
	dw "with fibonacci sequence...",1
	dw 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	
	dw 0
	
	hlt
	
printText:
	send r10, 0x12e0		;set cursor to bottom left
.printLoop:
	mov r1, [r0]			;get character
	jz .end					;if null, end
	send r10, r1			;send character to display
	add r0, 1				;increment to next character
	
	cmp r1, 1				;is the data a 1?
	jne .skipNl				;if not, don't do a line feed
	
	send r10, 0x3000		;line feed
	jmp printText			;reset cursor position
.skipNl:
	jmp .printLoop			;get new character
	
.end:
	ret						;return
	
clearScr:
	;send 24 line feeds
	send r10, 0x3000
	send r10, 0x3000
	send r10, 0x3000
	send r10, 0x3000
	send r10, 0x3000
	send r10, 0x3000
	send r10, 0x3000
	send r10, 0x3000
	send r10, 0x3000
	send r10, 0x3000
	send r10, 0x3000
	send r10, 0x3000
	send r10, 0x3000
	send r10, 0x3000
	send r10, 0x3000
	send r10, 0x3000
	send r10, 0x3000
	send r10, 0x3000
	send r10, 0x3000
	send r10, 0x3000
	send r10, 0x3000
	send r10, 0x3000
	send r10, 0x3000
	send r10, 0x3000
	ret				 		;return