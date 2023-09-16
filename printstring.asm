print_string:
	;move character into al
	mov al, [si]
	;check if we reached end of string
	cmp al, 0x0
	;if end of string jump to end_print
	je end_print
	;else continue printing
	int 0x10    ;Print the character
	;increment the index
	inc si
	;jump to beginning of label
	jmp print_string

end_print:
	;bios interrupt for await key press
	mov ah, 0x0 
	int 0x16
	