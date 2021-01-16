	jmp 0x0200



	;Image format:
	;first number can be 1 or 0 (Pixel on or off)
	;Second number is to repeat for as many pixels needed
	;Example: If the first number is a 1 and the second is 13, it will turn 13 pixels on (One pixel at current position and the next 12)
	;If it were a zero in the first number then those pixels will be off
	
	;End an image using 0xFFFF or -1
	
	;The default image is the Commodore logo
	
image:
	dw 0,16
	dw 0,4,1,5,0,7
	dw 0,3,1,6,0,7
	dw 0,3,1,2,0,4,1,4,0,3
	dw 0,3,1,2,0,4,1,3,0,4
	dw 0,3,1,2,0,11
	dw 0,3,1,2,0,11
	dw 0,3,1,2,0,4,1,3,0,4
	dw 0,3,1,2,0,4,1,4,0,3
	dw 0,3,1,6,0,7
	dw 0,4,1,5,0,7
	dw 0,16
	dw 0xffff
	
	org 0x0200
	
	;initialize registers
	mov r10, 0
	mov sp, 0
	
	;initialize display
	send r10, 0x1000
	send r10, 0x200a
	
	;clear the screen
	call clearScr
	send r10, 0x1000
	
	mov r0, .startmessage	;get start message
	call printStr			;print start message
	call display
.endloop:
	hlt
	jmp .endloop
	
.startmessage:
	dw "By:  HuntaBadday"
	dw "================"
	dw 0
	
display:
	send r10, 0x1000
	mov r3, image	;get pointer for image data
	
initloop:
	;check for end byte
	mov r1, [r3]
	cmp r1, 0xffff
	je .end
	
	;see if pixels have to be on or off
	mov r2, 144	;Here you can choose what character the pixel on state will be
	cmp r1, 1
	je .on
	mov r2, 32	;Here you can choose what character the pixel off state will be
.on:
	;for loop times counter
	mov r1, [r3+1]
	add r3, 2
	
.displayloop:
	;simple for loop
	send r10, r2
	sub r1, 1
	jnz .displayloop
	jmp initloop
	
.end:
	ret
	
printStr:
	;initialize display
.loop:
	mov r1, [r0]	;get charater
	jz .end			;if null, end
	send r10, r1	;print
	add r0, 1		;increment text pointer
	jmp .loop		;loop
	
.end:
	ret
	
clearScr:
	;initialize display and line counter
	send r10, 0x1000
	mov r1, 12
	
.loop:
	;send full line of whitespace
	send r10, 32
	send r10, 32
	send r10, 32
	send r10, 32
	send r10, 32
	send r10, 32
	send r10, 32
	send r10, 32
	send r10, 32
	send r10, 32
	send r10, 32
	send r10, 32
	send r10, 32
	send r10, 32
	send r10, 32
	send r10, 32
	;subtract and see if we should keep looping
	sub r1, 1
	jnz .loop
	ret