[bits 16]
[org 0x7c00]    ;BIOS loads this code at 0x7c00
xor ax, ax
mov ds, ax  ;Initialize data segment register
mov ah, 0x0e    ;For Using BIOS to print a character
mov cl, len ;Used as counter inside the loop, so load with length
inc cl
mov si, msg
loop:
mov al, [si]    ;get the character in al
int 0x10    ;Print the character
inc si
dec cl
jnz loop    ;Keep printing until you reach end of the welcome message
jmp $       ;Loop forever

msg: db "WELCOME TO PURGATORY...THERE IS NO GOING BACK NOW."
len equ $-msg
times 510 - ($-$$) db 0     ;Put 0s till 510
dw 0xaa55