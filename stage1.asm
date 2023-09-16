;16 bit mode
BITS 16
;load into memory at 0x7c00
org 0x7c00

;initialize data segment
xor ax, ax
mov ds, ax  
print:
;for bios interrupt print char
mov ah, 0x0e    
;move string into si
mov si, String

%include "printstring.asm"	
call print_string

;set up ES:BX to load next sector
mov bx, 0x1000
mov es, bx
mov bx, 0x0

read_disk:
	;read 1 sector
	mov al, 0x01
	;cylinder 0 
	mov ch, 0x0
	;read sector 2
	mov cl, 0x02 
	;head 0
	mov dh, 0x0
	;drive 0
	mov dl, 0x0
	
	;bios interrupt for drive read
	mov ah, 0x02
	int 0x13
	jc read_disk

;reset data segment
mov ax, 0
mov ds, ax
mov si, ax

;jump to memory loaded with second sector
jmp 0x1000:0x0

;0xA 0xD = \n
;0 marks end of string
String: db "Bootloader initialized. Ready to read next drive sector", 0xA, 0xD, 0 

;padding till 510 bytes
times 510-($-$$) db 0
;remaining 2 bytes (boot signature)
dw 0xaa55
