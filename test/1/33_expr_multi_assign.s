	.data
string17:
	.string "%d"
string20:
	.string "%d"
	.bss
	.align 4
a1:
	.zero 4
	.align 4
b2:
	.zero 4
	.text
	.global main
	.type main, @function
main:
	movl $3, %eax
	pushl %eax
	popl %eax
	movl $b2, %ebx
	movl %eax, (%ebx)
	pushl %eax
	popl %eax
	movl $a1, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl a1, %eax
	pushl %eax
	pushl $string17
	call printf
	addl $8, %esp
	movl b2, %eax
	pushl %eax
	pushl $string20
	call printf
	addl $8, %esp
