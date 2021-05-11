.section .data
# First, we need the list that we'll pass.
list1:
.long 12,1,29,9

.section .text
.globl _start
_start:

# Then we push it into memory I guess?
pushl $list1
# And we call our function
call maximum
addl $4, %esp

movl %eax, %ebx
movl $1, %eax
int $0x80

.type maximum, @function
maximum:
# Standard ebp and esp altering
pushl %ebp
movl %esp, %ebp
movl $8, %edi   # Set our index to 2

# Move list address into ebx?
movl 8(%ebp), %ebx

# And then try to offset the address?
# LETS GOOOOOOOOOOOOOOOOOOOOOOOOOO
movl %edi(%ebx), %eax

# Standard function ending
movl %ebp, %esp
popl %ebp
ret