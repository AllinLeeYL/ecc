	.data
string39:
	.string "Test:%d\n"
	.bss
	.align 4
a1:
	.zero 4
	.text
	.global main
	.type main, @function
main:
	movl $10, %eax
	pushl %eax
	popl %eax
	movl $a1, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl a1, %eax
	pushl %eax
	movl $9, %eax
	pushl %eax
	popl %ebx
	popl %eax
	cmpl %ebx, %eax
	jg label2
	movl $0, %eax
	jmp label3
label2:
	movl $1, %eax
	jmp label3
label3:
	pushl %eax
	popl %eax
	cmp $1, %eax
	je label0
	movl $2, %eax
	pushl %eax
	popl %eax
	movl $a1, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl a1, %eax
	pushl %eax
	movl $30, %eax
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
	jmp label1
label0:
	movl a1, %eax
	pushl %eax
	movl $10, %eax
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
	movl $6, %eax
	pushl %eax
	popl %ebx
	popl %eax
	cltd
	idivl %ebx
	movl %edx, %eax
	pushl %eax
	popl %eax
	movl $a1, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	jmp label1
label1:
	movl a1, %eax
	pushl %eax
	pushl $string39
	call printf
	addl $8, %esp
