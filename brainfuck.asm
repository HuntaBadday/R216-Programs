	
	; brainfuck interpreter by HuntaBadday
	; brainfuck code is at the bottom
	
	%include "common"
	
	mov r10, 0 ; port number for screen
	mov r11, 0x1000 ; cursor position
	mov sp, 0 ; reset stack pointer
	
	send r10, 0x200a ; set screen colour
	send r10, 0x1000 ; set screen position
	
	mov r4, 0 ; code pointer
	mov r5, 0 ; memory pointer
	
	call clear ; clear screen
	
main:
	; get instruction
	mov r1, [code+r4]
	jz halt
	add r4, 1
	
	; execute
	cmp r1, '+'
	je increment
	cmp r1, '-'
	je decrement
	cmp r1, '>'
	je right
	cmp r1, '<'
	je left
	cmp r1, '.'
	je output
	cmp r1, ','
	je input
	cmp r1, '['
	je openloop
	cmp r1, ']'
	je closeloop
	
	jmp main
	
increment:
	; add 1 to memory with index r5 (memory pointer)
	add [memory+r5], 1
	jmp main
	
decrement:
	; sub 1 from memory with index r5 (memory pointer)
	sub [memory+r5], 1
	jmp main
	
right:
	; add 1 to r5 (memory pointer)
	add r5, 1
	and r5, 0xff ; limit to 256 cells
	jmp main
	
left:
	; sub 1 from r5 (memory pointer)
	sub r5, 1
	and r5, 0xff ; limit to 256 cells
	jmp main
	
output:
	add r11, 1 ; add 1 to cursor position
	cmp r11, 0x10bf ; check if off screen (compares with last character address of screen)
	jg .nextScreen ; clear screen if true
.back:
	mov r1, [memory+r5] ; get character
	send r10, r1 ; send to screen
	jmp main
.nextScreen:
	mov r11, 0x1000 ; reset cursor position
	call clear ; clear screen
	jmp .back ; go back
	
input:
	; put cursor character on screen
	send r10, 127
	send r10, r11
.waitloop:
	wait r0 ; wait for data
	js .waitloop
	bump r10
.recvloop:
	recv r1, r0 ; recieve data
	jnc .recvloop
	mov [memory+r5], r1
	send r10, 32 ; clear cursor character
	send r10, r11
	jmp main
	
openloop:
	mov r1, [memory+r5] ; get number from memory
	push r4 ; push pointer to stack
	cmp r1, 0 ; compare memory with 0
	jnz main ; if not zero continue
	add sp, 1 ; otherwise remove value from stack
	mov r1, 1 ; set counter
.search:
	mov r2, [code+r4] ; get instruction
	add r4, 1 ; increment pointer
	cmp r2, '[' ; if '[' increment counter
	jne .skip
	add r1, 1
	jmp .search
.skip:
	cmp r2, ']' ; if ']' decrement counter
	jne .search
	sub r1, 1
	jz main ; if counter is zero then the corresponding ']' has been found
	jmp .search ; otherwise keep looping
	
closeloop:
	mov r1, [memory+r5] ; get number from memory
	cmp r1, 0 ; check if 0
	jnz .notDone ; if not zero go to corresponding '['
	add sp, 1 ; otherwise remove pointer from stack
	jmp main
.notDone:
	mov r4, [sp] ; get pointer to correspoinding '[' and store it to r4 (code pointer)
	jmp main
	
halt:
	hlt
	jmp halt
	
;SUBROUTINES
clear:
	send r10, 0x1000 ; set cursor to upper left
	mov r1, 12 ; lines to clear
	mov r2, 32 ; character to fill (for debugging)
.loop:
	send r10, r2 ; send 16 blanks for a line
	send r10, r2
	send r10, r2
	send r10, r2
	send r10, r2
	send r10, r2
	send r10, r2
	send r10, r2
	send r10, r2
	send r10, r2
	send r10, r2
	send r10, r2
	send r10, r2
	send r10, r2
	send r10, r2
	send r10, r2
	sub r1, 1
	jnz .loop ; repeat until done
	send r10, 0x1000 ; return cursor
	ret ; return
	
code:
	dw "+++++[>+++++<-]>+++++++" ; set cell to 32 (' ' character)
	dw "[.+]" ; loop through character set
	dw 0
	
memory:
	; 256 cells for brainfuck
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0