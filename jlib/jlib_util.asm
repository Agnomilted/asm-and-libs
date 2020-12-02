global strcpy
global input
global print
global strlen
global longtostring
global strcmp
section .bss
__jlib_longtostringbuf1 resb 128
__jlib_longtostringbuf2 resb 128
__jlib_longtostringptr resb 8
section .text

strcpy: ; void strcpy(char*, char*);
	mov rdx, 0
	mov dl, byte [rsi]
	mov byte [rdi], dl
	cmp dl, 0
	je __jlib_strcpyquit
	inc rdi
	inc rsi
	jmp strcpy
__jlib_strcpyquit:
	ret
strcmp: ; long strcmp(char*, char*); returns 1 if the two null-terminates strings are the same, 0 if not.
    mov dl, byte [rdi]
    cmp dl, byte [rsi]
    jne __jlib_strcmpquit0
    cmp dl, 0
    je __jlib_strcmpquit
    mov rax, 1
    inc rdi
    inc rsi
    jmp strcmp
__jlib_strcmpquit:
    ret
__jlib_strcmpquit0:
    mov rax, 0
    ret
longtostring: ; char* longtostring(long); returns the string version of the input number
        push rbx
        push r12
        mov rcx, __jlib_longtostringbuf1
        mov qword [__jlib_longtostringptr], rcx
        mov rax, rdi
__jlib_longtostringl1:
	mov rdx, 0
        mov rbx, 10
        div rbx
        push rax
        add rdx, 48
        mov rcx, [__jlib_longtostringptr]
        mov [rcx], dl
        inc rcx
        mov [__jlib_longtostringptr], rcx
        pop rax
        cmp rax, 0
        jne __jlib_longtostringl1
        mov r12, __jlib_longtostringbuf2
__jlib_longtostringl2:
	mov rax, [__jlib_longtostringptr]
        mov rax, [rax]
        mov [r12], rax
        inc r12
        mov rcx, [__jlib_longtostringptr]
        dec rcx
        mov [__jlib_longtostringptr], rcx
        cmp rcx, __jlib_longtostringbuf1
        jge __jlib_longtostringl2
        mov qword [r12], 0
        mov rax, __jlib_longtostringbuf2
        pop r12
        pop rbx
        ret

input: ; void input(char*, long); reads the second argument's length from stdin
	mov rdx, rsi
	mov rsi, rdi
	mov rax, 0
	mov rdi, 0
	syscall
	ret

	
print: ; void print(char*); writes the null-terminated argument to stdout
	mov rsi, rdi
	call strlen
	mov rdx, rax
	mov rax, 1
	mov rdi, 1
	syscall
	ret

strlen: ; long strlen(char*); returns the null-terminated argument's length
	mov rax, 0
__jlib_strlenloop:
	cmp byte [rdi], 0
	je __jlib_strlenquit
	inc rdi
	inc rax
	jmp __jlib_strlenloop
__jlib_strlenquit:
	ret
	
