	.data
string8:
	.string "%d"
string22:
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
	movl $0, %eax
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
	pushl $string22
	call printf
	addl $8, %esp
