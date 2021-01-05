	.data
string8:
	.string "%d"
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
	pushl $a0
	pushl $string8
	call scanf
	addl $8, %esp
	movl a0, %eax
	pushl %eax
	pushl $string12
	call printf
	addl $8, %esp
