#PUROSE: -  Given a number, this program computes the factorial.
#           For example, the factorial of 3 is 3 * 2 * 1 = 6.
#           The factorial of 4 is 4 * 3 * 2 * 1 = 24, and so on.

# This program shows how to call a function recursively.
.section .data
# This program has no global data.

.section .text

.globl _start
.globl factorial    # Why do we store the function label globally?

_start:
pushl $4            # First item on the stack will be our value whose exponent we're calculating.

call factorial      # Call the function right away
addl $4, %esp       # Once we're out of recursion we make it back here. As per ush, we move our stack pointer back however many params we passed in, 
                    #   so they may be overwritten with any future operations.

movl %eax, %ebx     # Store our final value into %ebx 

movl $1, %eax       # Store exit instruction into %eax
int $0x80           # Beg lord Linux for freedom from this prison.

#PURPOSE:   This function will calculate the factorial of a number.
#
#INPUT:     A single int.
#
#VARIABLES:
#           %eax    -   Holds our value within function frame.
#
# This is the actual function definition
.type factorial, @function  # Define the label as a function
factorial:
pushl %ebp          # Save the original ebp as per ush

movl %esp, %ebp     # Move current esp (pointing at old ebp) and store it in our ebp to use as our function frame
movl 8(%ebp), %eax  # Why do we move 2 words back from ebp? Ooooh because calling a function automatically pushes the return address onto the stack
                    #   So 1 word (4 bytes) back = return address. 2 word (8 bytes) back we have our value and we store it onto %eax.

cmpl $1, %eax       # This is our base case. How we know we've reached the end of recursion. 
je end_factorial    # if our local variable = 1 end.
                    # else
decl %eax           # lower our value by 1
pushl %eax          # push it onto the stack, which is the equivalent of addint it as a function parameter in asm
call factorial      # and call our function again.
movl 8(%ebp), %ebx  # Whatever function frame we'll be in, our passed in parameter will always be 2 words behind our frame.
                    # So we get the value passed in to this frame from the stack.
imull %ebx, %eax    # And we multiply it by the returned value that'll be in %eax - effectively overwriting our previously saved value.
                    # This basically means that once we get to 1, it will be returned and we go back up by a layer.
                    # so 8(%ebp) will now hold 2, and %eax will hold 1. 1 * 2 gets returned and up by a layer
                    # where 8(%ebp) now holds 3, and %eax holds 2. 2 * 3 gets calculated and stored in %eax and we go up by a layers and so on.
                    # Just have to make sure our result is stored in eax.

end_factorial:      
movl %ebp, %esp     # Usual destructor. Return stored esp to the %esp.
popl %ebp           # Return saved ebp to %ebp.
ret                 # call ret.
