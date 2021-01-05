	.data
string27:
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
	movl $15, %eax
	pushl %eax
	popl %eax
	movl $a0, %ebx
	movl a0, %ecx
	addl %ecx, %eax
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	jmp label1
label0:
	movl $20, %eax
	pushl %eax
	popl %eax
	movl $a0, %ebx
	movl a0, %ecx
	subl %eax, %ecx
	movl %ecx, (%ebx)
	movl %ecx, %eax
	pushl %eax
	addl $4, %esp
	jmp label1
label1:
	movl a0, %eax
	pushl %eax
	pushl $string27
	call printf
	addl $8, %esp
