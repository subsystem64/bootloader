org 0x1000
mov ax, 0
mov ds, ax

mov ah, 0x0e 
;move string into si
mov si, String

%include "printstring.asm"
call print_string
	
String: db "Stage 2 initialized.", 0xA, 0xD, 0xA, 0xD, "Menu", 0xA, 0xD, "-------------------------------------------------", 0xA, 0xD, 0xA, 0xD, "F) File Viewer", 0xA, 0xD, 0
times 512-($-$$) db 0