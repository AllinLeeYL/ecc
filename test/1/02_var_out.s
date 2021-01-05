	.data
string12:
	.string "test:%d\n"
	.bss
	.align 4
a0:
	.zero 4
	.text
	.global main
	.type main, @function
main:
	movl $10, %eax
	pushl %eax
	popl %eax
	movl $a0, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl a0, %eax
	pushl %eax
	pushl $string12
	call printf
	addl $8, %esp
