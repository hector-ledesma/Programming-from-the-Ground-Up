.section .data
# First, we need the list that we ll pass.
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
movl $3, %edi   # Set our index to 2

# Move list address into ebx?
movl 8(%ebp), %ebx


# Ok so the way the godbolt compiler handles dynamically indexing is:
#   1. Store index on a register so we may use the register for different types of accessing modes.
#   2. Use said register to calculate the offset, and store the result on another register.
#   3. Store the start address of our array onto its own register.
#   4. Add our offset to our array address to access the data at that offset.

# Currently we have:
#   -   %edi: index
#   -   %ebx: array start address

# First hurdle, how do we calculate the offset and add it to the register
imull $4, %edi  # Multiply the size of our data, by our index and store it at index register

addl %edi, %ebx # Add it to our array variable address?

movl (%ebx), %eax # Move what would currently be at index 0 after offset to be returned
#    LETS GOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO ^

# Standard function ending
movl %ebp, %esp
popl %ebp
ret