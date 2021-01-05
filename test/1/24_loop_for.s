	.data
string25:
	.string "In Loop\n"
string27:
	.string "End Loop\n"
	.bss
	.align 4
a0:
	.zero 4
	.text
	.global main
	.type main, @function
main:
	movl $0, %eax
	pushl %eax
	popl %eax
	movl $a0, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
label0:
	movl a0, %eax
	pushl %eax
	movl $200, %eax
	pushl %eax
	popl %ebx
	popl %eax
	cmpl %ebx, %eax
	jl label2
	movl $0, %eax
	jmp label3
label2:
	movl $1, %eax
	jmp label3
label3:
	pushl %eax
	popl %eax
	cmp $0, %eax
	je label1
	pushl $string25
	call printf
	addl $4, %esp
	movl a0, %eax
	pushl %eax
	movl $1, %eax
	pushl %eax
	popl %ebx
	popl %eax
	addl %ebx, %eax
	pushl %eax
	popl %eax
	movl $a0, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	jmp label0
label1:
	pushl $string27
	call printf
	addl $4, %esp
