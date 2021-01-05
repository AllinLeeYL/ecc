	.data
string11:
	.string "%d"
string15:
	.string "%d"
string25:
	.string "Success\n"
string28:
	.string "Failed\n"
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
	pushl $string28
	call printf
	addl $4, %esp
	jmp label1
label0:
	pushl $string25
	call printf
	addl $4, %esp
	jmp label1
label1:
