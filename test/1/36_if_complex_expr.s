	.data
string65:
	.string "%d\n"
string96:
	.string "%d\n"
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
	.align 4
result5:
	.zero 4
	.text
	.global main
	.type main, @function
main:
	movl $5, %eax
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
	movl $1, %eax
	pushl %eax
	popl %eax
	movl $c3, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl $2, %eax
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
	movl $2, %eax
	pushl %eax
	popl %eax
	movl $result5, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl d4, %eax
	pushl %eax
	movl $1, %eax
	pushl %eax
	popl %ebx
	popl %eax
	imull %ebx
	pushl %eax
	movl $2, %eax
	pushl %eax
	popl %ebx
	popl %eax
	cltd
	idivl %ebx
	pushl %eax
	movl $0, %eax
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
	movl a1, %eax
	pushl %eax
	movl b2, %eax
	pushl %eax
	popl %ebx
	popl %eax
	subl %ebx, %eax
	pushl %eax
	movl $0, %eax
	pushl %eax
	popl %ebx
	popl %eax
	cmpl %ebx, %eax
	jne label4
	movl $0, %eax
	jmp label5
label4:
	movl $1, %eax
	jmp label5
label5:
	pushl %eax
	movl c3, %eax
	pushl %eax
	movl $3, %eax
	pushl %eax
	popl %ebx
	popl %eax
	addl %ebx, %eax
	pushl %eax
	movl $2, %eax
	pushl %eax
	popl %ebx
	popl %eax
	cltd
	idivl %ebx
	movl %edx, %eax
	pushl %eax
	movl $0, %eax
	pushl %eax
	popl %ebx
	popl %eax
	cmpl %ebx, %eax
	jne label6
	movl $0, %eax
	jmp label7
label6:
	movl $1, %eax
	jmp label7
label7:
	pushl %eax
	popl %ebx
	popl %eax
	andl %ebx, %eax
	pushl %eax
	popl %ebx
	popl %eax
	orl %ebx, %eax
	pushl %eax
	popl %eax
	cmp $1, %eax
	je label0
	jmp label1
label0:
	movl result5, %eax
	pushl %eax
	pushl $string65
	call printf
	addl $8, %esp
	jmp label1
label1:
	movl d4, %eax
	pushl %eax
	movl $2, %eax
	pushl %eax
	popl %ebx
	popl %eax
	cltd
	idivl %ebx
	movl %edx, %eax
	pushl %eax
	movl $67, %eax
	pushl %eax
	popl %ebx
	popl %eax
	addl %ebx, %eax
	pushl %eax
	movl $0, %eax
	pushl %eax
	popl %ebx
	popl %eax
	cmpl %ebx, %eax
	jl label10
	movl $0, %eax
	jmp label11
label10:
	movl $1, %eax
	jmp label11
label11:
	pushl %eax
	movl a1, %eax
	pushl %eax
	movl b2, %eax
	pushl %eax
	popl %ebx
	popl %eax
	subl %ebx, %eax
	pushl %eax
	movl $0, %eax
	pushl %eax
	popl %ebx
	popl %eax
	cmpl %ebx, %eax
	jne label12
	movl $0, %eax
	jmp label13
label12:
	movl $1, %eax
	jmp label13
label13:
	pushl %eax
	movl c3, %eax
	pushl %eax
	movl $2, %eax
	pushl %eax
	popl %ebx
	popl %eax
	addl %ebx, %eax
	pushl %eax
	movl $2, %eax
	pushl %eax
	popl %ebx
	popl %eax
	cltd
	idivl %ebx
	movl %edx, %eax
	pushl %eax
	movl $0, %eax
	pushl %eax
	popl %ebx
	popl %eax
	cmpl %ebx, %eax
	jne label14
	movl $0, %eax
	jmp label15
label14:
	movl $1, %eax
	jmp label15
label15:
	pushl %eax
	popl %ebx
	popl %eax
	andl %ebx, %eax
	pushl %eax
	popl %ebx
	popl %eax
	orl %ebx, %eax
	pushl %eax
	popl %eax
	cmp $1, %eax
	je label8
	jmp label9
label8:
	movl $4, %eax
	pushl %eax
	popl %eax
	movl $result5, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl result5, %eax
	pushl %eax
	pushl $string96
	call printf
	addl $8, %esp
	jmp label9
label9:
