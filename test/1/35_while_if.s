	.data
string59:
	.string "%d\n"
string62:
	.string "%d\n"
	.bss
	.align 4
a1:
	.zero 4
	.align 4
b2:
	.zero 4
	.text
	.global main
	.type main, @function
main:
	movl $0, %eax
	pushl %eax
	popl %eax
	movl $a1, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl $0, %eax
	pushl %eax
	popl %eax
	movl $b2, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
label0:
	movl a1, %eax
	pushl %eax
	movl $100, %eax
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
	movl a1, %eax
	pushl %eax
	movl $5, %eax
	pushl %eax
	popl %ebx
	popl %eax
	cmpl %ebx, %eax
	je label6
	movl $0, %eax
	jmp label7
label6:
	movl $1, %eax
	jmp label7
label7:
	pushl %eax
	popl %eax
	cmp $1, %eax
	je label4
	movl a1, %eax
	pushl %eax
	movl $10, %eax
	pushl %eax
	popl %ebx
	popl %eax
	cmpl %ebx, %eax
	je label10
	movl $0, %eax
	jmp label11
label10:
	movl $1, %eax
	jmp label11
label11:
	pushl %eax
	popl %eax
	cmp $1, %eax
	je label8
	movl a1, %eax
	pushl %eax
	movl $2, %eax
	pushl %eax
	popl %ebx
	popl %eax
	imull %ebx
	pushl %eax
	popl %eax
	movl $b2, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	jmp label9
label8:
	movl $42, %eax
	pushl %eax
	popl %eax
	movl $b2, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	jmp label9
label9:
	jmp label5
label4:
	movl $25, %eax
	pushl %eax
	popl %eax
	movl $b2, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	jmp label5
label5:
	movl a1, %eax
	pushl %eax
	movl $1, %eax
	pushl %eax
	popl %ebx
	popl %eax
	addl %ebx, %eax
	pushl %eax
	popl %eax
	movl $a1, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	jmp label0
label1:
	movl a1, %eax
	pushl %eax
	pushl $string59
	call printf
	addl $8, %esp
	movl b2, %eax
	pushl %eax
	pushl $string62
	call printf
	addl $8, %esp
