	.data
string10:
	.string "%d"
string14:
	.string "%d"
string18:
	.string "%d"
string22:
	.string "%d "
string25:
	.string "%d "
string28:
	.string "%d\n"
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
	pushl $string10
	call scanf
	addl $8, %esp
	pushl $b1
	pushl $string14
	call scanf
	addl $8, %esp
	pushl $c2
	pushl $string18
	call scanf
	addl $8, %esp
	movl a0, %eax
	pushl %eax
	pushl $string22
	call printf
	addl $8, %esp
	movl b1, %eax
	pushl %eax
	pushl $string25
	call printf
	addl $8, %esp
	movl c2, %eax
	pushl %eax
	pushl $string28
	call printf
	addl $8, %esp
