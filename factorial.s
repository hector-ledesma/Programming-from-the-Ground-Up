#PUROSE: -  Given a number, this program computes the factorial.
#           For example, the factorial of 3 is 3 * 2 * 1 = 6.
#           The factorial of 4 is 4 * 3 * 2 * 1 = 24, and so on.

# This program shows how to call a function recursively.
.section .data
# This program has no global data.

.section .text

.globl _start
.globl factorial

_start:
pushl $4

call factorial
addl $4, %esp

movl %eax, %ebx

movl $1, %eax
int $0x80

# This is the actual function definition
.type factorial, @function
factorial:
pushl %ebp

movl %esp, %ebp
movl 8(%ebp), %eax
 
cmpl $1, %eax
je end_factorial
decl %eax
pushl %eax
call factorial
movl 8(%ebp), %ebx
imull %ebx, %eax

end_factorial:
movl %ebp, %esp
popl %ebp
ret
