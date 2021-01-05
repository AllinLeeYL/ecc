	.data
string14:
	.string "%d"
string18:
	.string "%d"
string28:
	.string "test:%d\n"
	.bss
	.align 4
a0:
	.zero 4
	.align 4
b1:
	.zero 4
	.align 4
c2:
	.zero 4
	.text
	.global main
	.type main, @function
main:
	pushl $a0
	pushl $string14
	call scanf
	addl $8, %esp
	pushl $b1
	pushl $string18
	call scanf
	addl $8, %esp
	movl a0, %eax
	pushl %eax
	movl b1, %eax
	pushl %eax
	popl %ebx
	popl %eax
	imull %ebx
	pushl %eax
	popl %eax
	movl $c2, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl c2, %eax
	pushl %eax
	pushl $string28
	call printf
	addl $8, %esp
