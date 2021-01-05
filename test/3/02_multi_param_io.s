	.data
string10:
	.string "%d %d %d"
string18:
	.string "%d %d %d\n"
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
	pushl $c3
	pushl $b2
	pushl $a1
	pushl $string10
	call scanf
	addl $16, %esp
	movl c3, %eax
	pushl %eax
	movl b2, %eax
	pushl %eax
	movl a1, %eax
	pushl %eax
	pushl $string18
	call printf
	addl $16, %esp
