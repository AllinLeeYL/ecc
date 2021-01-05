	.data
string50:
	.string "%d"
	.bss
	.align 4
a1:
	.zero 4
	.align 4
b2:
	.zero 4
	.align 4
c3:
	.zero 4
	.align 4
d4:
	.zero 4
	.text
	.global main
	.type main, @function
main:
	movl $20, %eax
	pushl %eax
	popl %eax
	movl $a1, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl $5, %eax
	pushl %eax
	popl %eax
	movl $b2, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl $6, %eax
	pushl %eax
	popl %eax
	movl $c3, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl $4, %eax
	pushl %eax
	popl %eax
	movl $0, %ebx
	subl %eax, %ebx
	pushl %ebx
	popl %eax
	movl $d4, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl a1, %eax
	pushl %eax
	movl c3, %eax
	pushl %eax
	movl d4, %eax
	pushl %eax
	popl %ebx
	popl %eax
	imull %ebx
	pushl %eax
	popl %ebx
	popl %eax
	addl %ebx, %eax
	pushl %eax
	movl b2, %eax
	pushl %eax
	movl a1, %eax
	pushl %eax
	movl d4, %eax
	pushl %eax
	popl %ebx
	popl %eax
	addl %ebx, %eax
	pushl %eax
	popl %ebx
	popl %eax
	cltd
	idivl %ebx
	movl %edx, %eax
	pushl %eax
	movl a1, %eax
	pushl %eax
	popl %ebx
	popl %eax
	cltd
	idivl %ebx
	pushl %eax
	popl %ebx
	popl %eax
	subl %ebx, %eax
	pushl %eax
	popl %eax
	movl $a1, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl a1, %eax
	pushl %eax
	pushl $string50
	call printf
	addl $8, %esp
