.section .data
.section .text

.globl _start
_start:

# First, we need the list that we'll pass.
list1:
.long 12,1,29,9

# Then we push it into memory I guess?
pushl list1
# And we call our function
call maximum

.type maximum, @function
maximum:
# Standard ebp and esp altering
pushl %ebp
movl %esp, %ebp
movl $0, %edi   # Set our index to 0

# Move list into ebx?
movl 8(%ebp), %ebx

# For testing, let's move 29 into eax and return it
movl %ebx(,$2,4), %eax

# Standard function ending
movl %ebp, %esp
popl %ebp
ret