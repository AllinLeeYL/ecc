	.data
string11:
	.string "%d"
string20:
	.string "test:%d\n"
	.bss
	.align 4
a0:
	.zero 4
	.align 4
c1:
	.zero 4
	.text
	.global main
	.type main, @function
main:
	pushl $a0
	pushl $string11
	call scanf
	addl $8, %esp
	movl a0, %eax
	pushl %eax
	popl %eax
	movl $0, %ebx
	subl %eax, %ebx
	pushl %ebx
	popl %eax
	movl $c1, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl c1, %eax
	pushl %eax
	pushl $string20
	call printf
	addl $8, %esp
