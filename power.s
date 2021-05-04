#PURPOSE:	Program to illustrate how functions work
#			This program will compute the value of
#			2^3 + 5^2
#

#Everything in the main program is stored in registers,
#so the data section doesn't have anything.
.section .data

.section .text

.globl _start
_start:
pushl $8		#
pushl $2		# Puts the function parameters onto the stack.
call power		
addl $8, %esp	# After function is over, move the stack pointer back as many words as parameters take so they will be overwritten.

pushl %eax		# Function return value is in %eax. So that's what we're pushing to the stack in order to add it to 5^2.

pushl $6		# 
pushl $2		# Push function params onto stack.
call power		#
addl $8, %esp	# Same thing. Move stack pointer back so params can be overwritten.

popl %ebx		# What this? Second function return, but how? Is %eax 8 byters before function call? 
				# oooh. Stack points AT the last value. So $5 after function call, so moving back 8 bytes, puts us directly behind $5. And at this address, we have %eax

subl %eax, %ebx # %eax holds value of 2^5, %ebx holds value of 2^8. Params are pushed in reverse. So you can read from last pushed to first, as left to right. so power(base, exponent)
				# %ebx holds the exit status, so now we know that addl saves result in second register.

pushl %ebx		# So it looks like when I call power, %ebx gets altered and not returned to its original state. 
				# This is what the book meant by always assume your registers will be destroyed and so you should store values onto the stack.

# Since %ebx holds the result of the last operation, I can just run another function call.
# The return will be stored in %eax, so I can just do the same process of operating against %ebx
pushl $0
pushl $2
call power
addl $8, %esp

popl %ebx		# move our previous value back onto %ebx

addl %eax, %ebx # add our new function returned value back onto our previous result

movl $1, %eax	# load 1 as our exit status? Then how do we see it in echo? oh no, this is the kernel instruction, %ebx is the exit status.
int $0x80

#PURPOSE:	This function is used to compute
#			the value of a number raise to
#			a power.
#
#INPUT:		First argument - the base number
#			Second argument - the power to raise it to
#
#OUTPUT:	Will give the result as a return value
#
#NOTES:		The power  must be 1 or greater
#
#VARIABLES:
#			%ebx - holds the base number
#			%ecx - holds the power
#
#			-4(%ebp) - holds the current result
#
#			%eax is used for temporary storage
#
.type power, @function
power:
pushl %ebp				# Save old ebp.
movl %esp, %ebp			# Set up ebp to use as our basis by making it point to the same address in which we saved the old %ebp.
						# Damn, do we actually have to handle this manually?
subl $4, %esp			# oooh subtract pushes the stack down. We move down one word so we have 1 word of reserved space on the stack for our result.

movl 8(%ebp), %ebx		# we adjust ebp 2 words back to get our first param, as directly behind it we have the return address (done automatically by call instruction).
movl 12(%ebp), %ecx		# 3 words back for second. Remember, closest to further = bottom to top = first to last

# I think this is where we should check if the power is 0. That way we can call end_power before doing anything else.
cmpl $0, %ecx			# compare if our power - which we're storing in %ecx - is equals to 0
je zero_power

movl %ebx, -4(%ebp)		# One word under the ebp we have an empty memory slot from our earlier reservation. We'll copy our ebx/first param/base in there.

power_loop_start:
cmpl $1, %ecx			# Compare that our exponent isn't 1.
je end_power			# If it is, exit.
movl -4(%ebp), %eax		# Move the value from our local variable memory into eax for calculations.
imull %ebx, %eax		# Multiply our copy of our local variable by our base.

movl %eax, -4(%ebp)		# Store our result back into our reserved memory slot, so that next loop may use it.

decl %ecx				# Subtract 1 from our exponent.
jmp power_loop_start	# Go back to loop beginning.

# If we ever receive a power of 0 execute this portion.
zero_power:
movl $1, -4(%ebp)		# Store one in our local variable memory slot so end_power can extract it to be returned.
jmp end_power			# Go straight to end of function.

end_power:				# Is this like, mandatory? end_$FUNCNAME? Like a C++ class destructor?
movl -4(%ebp), %eax		# Move our local variable into %eax, which is where return value is stored.
movl %ebp, %esp			# Make stack pointer point back to where it was before funciton call.
popl %ebp				# Bring back our previously saved ebp into %ebp again.
ret