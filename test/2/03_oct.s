	.data
string17:
	.string "True!\n"
string20:
	.string "False!\n"
	.bss
	.align 4
a1:
	.zero 4
	.text
	.global main
	.type main, @function
main:
	movl $-876927887, %eax
	pushl %eax
	popl %eax
	movl $a1, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl a1, %eax
	pushl %eax
	movl $1, %eax
	pushl %eax
	popl %eax
	movl $0, %ebx
	subl %eax, %ebx
	pushl %ebx
	popl %ebx
	popl %eax
	cmpl %ebx, %eax
	je label2
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
	pushl $string20
	call printf
	addl $4, %esp
	jmp label1
label0:
	pushl $string17
	call printf
	addl $4, %esp
	jmp label1
label1:
