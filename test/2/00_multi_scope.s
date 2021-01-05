	.data
string46:
	.string "Test %d %d\n"
string50:
	.string "Test %d\n"
	.bss
	.align 4
a0:
	.zero 4
	.align 4
a2:
	.zero 4
	.align 4
i3:
	.zero 4
	.align 4
a4:
	.zero 4
	.text
	.global main
	.type main, @function
	movl $10, %eax
	pushl %eax
	popl %eax
	movl $a0, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
main:
	movl $1, %eax
	pushl %eax
	popl %eax
	movl $a2, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl $0, %eax
	pushl %eax
	popl %eax
	movl $i3, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
label0:
	movl i3, %eax
	pushl %eax
	movl $10, %eax
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
	movl i3, %eax
	pushl %eax
	movl $10, %eax
	pushl %eax
	popl %ebx
	popl %eax
	imull %ebx
	pushl %eax
	movl i3, %eax
	pushl %eax
	movl $3, %eax
	pushl %eax
	popl %ebx
	popl %eax
	cltd
	idivl %ebx
	movl %edx, %eax
	pushl %eax
	popl %ebx
	popl %eax
	addl %ebx, %eax
	pushl %eax
	popl %eax
	movl $a4, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl a4, %eax
	pushl %eax
	movl i3, %eax
	pushl %eax
	pushl $string46
	call printf
	addl $12, %esp
	movl i3, %eax
	pushl %eax
	movl $1, %eax
	pushl %eax
	popl %ebx
	popl %eax
	addl %ebx, %eax
	pushl %eax
	popl %eax
	movl $i3, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	jmp label0
label1:
	movl a2, %eax
	pushl %eax
	pushl $string50
	call printf
	addl $8, %esp
