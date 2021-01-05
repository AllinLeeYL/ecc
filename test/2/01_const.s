	.data
string10:
	.string "Test:%d\n"
	.bss
	.align 4
at0:
	.zero 4
	.text
	.global main
	.type main, @function
	movl $10, %eax
	pushl %eax
	popl %eax
	movl $at0, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
main:
	movl at0, %eax
	pushl %eax
	pushl $string10
	call printf
	addl $8, %esp
