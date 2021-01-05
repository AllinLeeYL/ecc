	.data
string11:
	.string "%d"
string15:
	.string "%d"
string29:
	.string "Failed\n"
string32:
	.string "Success\n"
	.bss
	.align 4
a0:
	.zero 4
	.align 4
b1:
	.zero 4
	.text
	.global main
	.type main, @function
main:
	pushl $a0
	pushl $string11
	call scanf
	addl $8, %esp
	pushl $b1
	pushl $string15
	call scanf
	addl $8, %esp
	movl a0, %eax
	pushl %eax
	movl b1, %eax
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
	movl a0, %eax
	pushl %eax
	movl b1, %eax
	pushl %eax
	popl %ebx
	popl %eax
	cmpl %ebx, %eax
	jg label4
	movl $0, %eax
	jmp label5
label4:
	movl $1, %eax
	jmp label5
label5:
	pushl %eax
	popl %ebx
	popl %eax
	andl %ebx, %eax
	pushl %eax
	popl %eax
	cmp $1, %eax
	je label0
	pushl $string32
	call printf
	addl $4, %esp
	jmp label1
label0:
	pushl $string29
	call printf
	addl $4, %esp
	jmp label1
label1:
