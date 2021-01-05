	.data
string14:
	.string "%d"
string18:
	.string "Test:%d"
string21:
	.string " %d"
string24:
	.string " %d\n"
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
	.text
	.global main
	.type main, @function
main:
	movl $20, %eax
	pushl %eax
	popl %eax
	movl $a1, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	movl $16, %eax
	pushl %eax
	popl %eax
	movl $c3, %ebx
	movl %eax, (%ebx)
	pushl %eax
	addl $4, %esp
	pushl $b2
	pushl $string14
	call scanf
	addl $8, %esp
	movl a1, %eax
	pushl %eax
	pushl $string18
	call printf
	addl $8, %esp
	movl b2, %eax
	pushl %eax
	pushl $string21
	call printf
	addl $8, %esp
	movl c3, %eax
	pushl %eax
	pushl $string24
	call printf
	addl $8, %esp
