	.data
string37:
	.string "%c"
string40:
	.string "%c"
string43:
	.string "%c"
string46:
	.string "%c"
string49:
	.string "%c"
	.bss
	.align 4
s0:
	.zero 1
	.align 4
t1:
	.zero 1
	.align 4
a2:
	.zero 1
	.align 4
r3:
	.zero 1
	.text
	.global main
	.type main, @function
main:
	movb $57, %al
	pushl %eax
	popl %eax
	movl $s0, %ebx
	movb %al, (%ebx)
	pushl %eax
	addl $4, %esp
	movb $9, %al
	pushl %eax
	popl %eax
	movl $t1, %ebx
	movb %al, (%ebx)
	pushl %eax
	addl $4, %esp
	movb $116, %al
	pushl %eax
	popl %eax
	movl $a2, %ebx
	movb %al, (%ebx)
	pushl %eax
	addl $4, %esp
	movb $10, %al
	pushl %eax
	popl %eax
	movl $r3, %ebx
	movb %al, (%ebx)
	pushl %eax
	addl $4, %esp
	movb $97, %al
	pushl %eax
	popl %eax
	movl $t1, %ebx
	movb %al, (%ebx)
	pushl %eax
	addl $4, %esp
	movb s0, %al
	pushl %eax
	pushl $string37
	call printf
	addl $8, %esp
	movb t1, %al
	pushl %eax
	pushl $string40
	call printf
	addl $8, %esp
	movb a2, %al
	pushl %eax
	pushl $string43
	call printf
	addl $8, %esp
	movb r3, %al
	pushl %eax
	pushl $string46
	call printf
	addl $8, %esp
	movb t1, %al
	pushl %eax
	pushl $string49
	call printf
	addl $8, %esp
