.section .data
# First, we need the list that we ll pass.
list1:
.long 12,1,29,9

.section .text
.globl _start
_start:

# Then we push it into memory I guess?
pushl $list1
# Also push list size
pushl $4
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

# Ok so the way the godbolt compiler handles dynamically indexing is:
#   1. Store index on a register so we may use the register for different types of accessing modes.
#   2. Use said register to calculate the offset, and store the result on another register.
#   3. Store the start address of our array onto its own register.
#   4. Add our offset to our array address to access the data at that offset.

# Currently we have:
#   -   %edi: index
#   -   16(%ebp): array start address
#   -   %ebx: current index item 
#   -   %eax: we'll store the max value
#   -   %ecx: current list's size (which starts at 8(%ebp))

movl 12(%ebp), %ebx # Move list address into ebx
movl 8(%ebp), %ecx # Move our first list's size into ecx
movl $1, %edi # First we start with our index at 0
movl (%ebx), %eax # Our first item will be our current max

start_loop:
# First step is to increase the index, since we've already stored at index 0:
incl %edi # increase our index by one
# Second step in our loop is to check if we're out of bounds.
cmpl %edi, %ecx
# Third, we'll want to reset %ebx back to index 0
movl 12(%ebp), %ebx
je loop_exit # if our index reg is same as size of array, we've hit the end so exit

movl %edi, %edx # store our index
# Fourth, if we're still within bounds, get a hold of the next item.
imull $4, %edi  # Multiply the size of our data, by our index and store it at index register
addl %edi, %ebx # Offset the address at register ebx, effectively now holding the address of the next item
movl %edx, %edi # move index back into edi

# Fifth, we want to compare our new item to our previous max
cmpl %eax, (%ebx)
jle start_loop # And if our new item is lower or equals, do nothing.

# else
movl (%ebx), %eax # Move our new largest into eax
jmp start_loop

loop_exit:
# Standard function ending
movl %ebp, %esp
popl %ebp
ret
