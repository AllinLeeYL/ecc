# ecc-zh

 简单的编译器。编译原理实验，目标语言AT&T x86格式的汇编代码。

## 本仓库做了什么

利用flex和bison，实现了一个简单的编译器，将C代码翻译成汇编代码，目前仅支持单前端（C）单后端（AT&T格式的x86汇编）。

## 展示

源代码

```c
int main(){
    printf("test\n");
    return 0;
}
```

翻译结果

```assembly
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

```