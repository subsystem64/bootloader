bits 16							;16 bit Real Mode
[org 0x7c00]						; We are loaded by BIOS at 0x7C00

start: jmp loader			


msg	db	'Welcome to My Operating System!', 0x0a, 0		; the string to print


Print:
			lodsb					; load next byte from string from SI to AL
			or			al, al		; Does AL=0?
			jz			PrintDone	; Yep, null terminator found-bail out
			mov			ah,	0x0e	; Nope-Print the character
			int			0x10
			jmp			Print		; Repeat until null terminator found
PrintDone:
			ret					; we are done, so return



loader:

	xor	ax, ax		; Setup segments to insure they are 0. Remember that
	mov	ds, ax		; we have ORG 0x7c00. This means all addresses are based
	mov	es, ax		; from 0x7c00:0. Because the data segments are within the same
				; code segment, null em.

	mov	si, msg						; our message to print
	call	Print						; call our print function

	xor	ax, ax						; clear ax
	int	0x12						; get the amount of KB from the BIOS
	
	mov ah, 0
	int 0x16
	
	xor ax, ax
	mov ds, ax
	

	mov ax, 07c0h		; set up 4k stack space after this bootloader
	mov ax, 288		; (4096 + 512) / 16 bytes per paragraph
	mov ss, ax
	mov sp, 4096

	mov ax, 07c0h		; set data segment to where we're loaded
	mov ds, ax


; this is where we setup the graphics stuff
bios_setup:
	mov ah, 00h		; tell the bios we'll be in graphics mode
	mov al, 13h
	int 10h			; call the BIOS

	mov ah, 0Ch		; set video mode
	mov bh, 0		; set output vga
	mov al, 2		; set initial color
	mov cx, 0		; x = 0
	mov dx, 0		; y = 0
	mov bx, 1
	
; call the BIOS to draw
draw:
	int 10h

next:
	; cx register holds x coord and dx holds y coord
	cmp dx, 200		; if y is at 200, jump to done (200 is the max height)
	inc cx
	inc bx
	cmp cx, bx		; if x is at 320, jump to new_xy
	je new_xy
	inc cx			; else increment cx by 1
	jmp draw		; call the BIOS to draw it out

; here is where we increment y coord and reset x coord
new_xy:
	mov cx, 0		; reset x coord
	inc dx			; increment y coord

; after each line is drawn, a new color is set
new_color:
	cmp al, 100		; check current color val
	jg reset_color		; if color val is over 100, reset color
	inc al			; else increment color val
	jmp draw		; draw

reset_color:
	mov al, 2		; reset color val
	jmp draw		; draw

done:
	jmp $			; jump to the current line until the end of time

times 510 - ($-$$) db 0						; We have to be 512 bytes. Clear the rest of the bytes with 0

dw 0xAA55