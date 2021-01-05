	.data
string5:
	.string "test\n"
	.bss
	.text
	.global main
	.type main, @function
main:
	pushl $string5
	call printf
	addl $4, %esp
