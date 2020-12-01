extern main
global _start
global __jlib_starter
section .bss
	__jlib_args resb 1024
section .text
_start:
	jmp __jlib_starter
__jlib_starter:
	pop rdi
	mov rax, 0
	mov rsi, __jlib_args
__jlib_argsloop:
	cmp rax, rdi
	je __jlib_start_main
	pop rbx
	mov [rsi + rax * 8], rbx
	inc rax
	jmp __jlib_argsloop
__jlib_start_main:
	call main
__jlib_terminate:
	mov rdi, rax
	mov rax, 60
	syscall
