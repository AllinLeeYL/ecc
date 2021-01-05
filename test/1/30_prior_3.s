	.data
string44:
	.string "%d\n"
string63:
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
t4:
	.zero 4
	.text
	.global main
	.type main, @function
main:
	movl $1, %eax
	pushl %eax
	popl %eax
	movl $a1, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl $4, %eax
	pushl %eax
	popl %eax
	movl $b2, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl $28, %eax
	pushl %eax
	popl %eax
	movl $c3, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl c3, %eax
	pushl %eax
	movl a1, %eax
	pushl %eax
	popl %ebx
	popl %eax
	addl %ebx, %eax
	pushl %eax
	movl b2, %eax
	pushl %eax
	popl %ebx
	popl %eax
	cmpl %ebx, %eax
	jne label2
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
	movl c3, %eax
	pushl %eax
	movl b2, %eax
	pushl %eax
	popl %eax
	movl $0, %ebx
	subl %eax, %ebx
	pushl %ebx
	popl %ebx
	popl %eax
	cltd
	idivl %ebx
	movl %edx, %eax
	pushl %eax
	popl %eax
	movl $t4, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl t4, %eax
	pushl %eax
	pushl $string44
	call printf
	addl $8, %esp
	jmp label1
label1:
	movl b2, %eax
	pushl %eax
	movl c3, %eax
	pushl %eax
	popl %ebx
	popl %eax
	subl %ebx, %eax
	pushl %eax
	movl a1, %eax
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
	jmp label5
label4:
	movl c3, %eax
	pushl %eax
	movl b2, %eax
	pushl %eax
	popl %ebx
	popl %eax
	cltd
	idivl %ebx
	movl %edx, %eax
	pushl %eax
	movl b2, %eax
	pushl %eax
	popl %ebx
	popl %eax
	addl %ebx, %eax
	pushl %eax
	popl %eax
	movl $t4, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl t4, %eax
	pushl %eax
	pushl $string63
	call printf
	addl $8, %esp
	jmp label5
label5:
