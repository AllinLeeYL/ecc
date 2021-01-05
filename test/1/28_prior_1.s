	.data
string37:
	.string "%d\n"
	.bss
	.align 4
a0:
	.zero 4
	.align 4
b1:
	.zero 4
	.align 4
c2:
	.zero 4
	.align 4
d4:
	.zero 4
	.text
	.global main
	.type main, @function
main:
	movl $16, %eax
	pushl %eax
	popl %eax
	movl $a0, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl $2, %eax
	pushl %eax
	popl %eax
	movl $b1, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl $30, %eax
	pushl %eax
	popl %eax
	movl $c2, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl a0, %eax
	pushl %eax
	movl b1, %eax
	pushl %eax
	movl c2, %eax
	pushl %eax
	popl %ebx
	popl %eax
	imull %ebx
	pushl %eax
	popl %ebx
	popl %eax
	addl %ebx, %eax
	pushl %eax
	popl %eax
	movl $d4, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl d4, %eax
	pushl %eax
	pushl $string37
	call printf
	addl $8, %esp
