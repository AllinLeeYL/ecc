	.data
string39:
	.string "test:%d %d\n"
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
	movl $100020, %eax
	pushl %eax
	popl %eax
	movl $0, %ebx
	subl %eax, %ebx
	pushl %ebx
	popl %eax
	movl $a1, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl $3, %eax
	pushl %eax
	popl %eax
	movl $0, %ebx
	subl %eax, %ebx
	pushl %ebx
	popl %eax
	movl $b2, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl a1, %eax
	pushl %eax
	movl b2, %eax
	pushl %eax
	popl %ebx
	popl %eax
	cltd
	idivl %ebx
	pushl %eax
	popl %eax
	movl $c3, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl a1, %eax
	pushl %eax
	movl b2, %eax
	pushl %eax
	popl %ebx
	popl %eax
	cltd
	idivl %ebx
	movl %edx, %eax
	pushl %eax
	popl %eax
	movl $d4, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl d4, %eax
	pushl %eax
	movl c3, %eax
	pushl %eax
	pushl $string39
	call printf
	addl $12, %esp
