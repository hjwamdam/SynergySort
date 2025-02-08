# File: utils.asm
# Purpose: To define utilities which will be used in MIPS programs.
# Author: Henry Warmerdam
#
# Subprograms Index:
# Exit - Call syscall with a server 10 to exit the program
# NewLine - Print a new line character (\n) to the console
# PrintInt - Print a string with an integer to the console
# PrintString - Print a string to the console
# PromptInt - Prompt the user to enter an integer, and return
# it to the calling program.
#
# Modification History
# 3/26/2024 - Initial release


# subprogram: 5.11 part a) NOR subprogram
# author: Henry Warmerdam
# purpose: to take two input parameters, and return the NOR operation on those two parameter
.text
NORsubprogram:
 nor $v0, $a0, $a1
 jr $ra


# subprogram: 5.11 part b) NAND
# author: Henry Warmerdam
# purpose: take two input parameters, and return the NAND operation on those two parameter
.text
NANDsubprogram:
 and $v0, $a0, $a1
 not $v0, $v0
 jr $ra


# subprogram: 5.11 part c) NOT
# author: Henry Warmerdam
# purpose: take one input parameters, and return the NOT operation on that parameter
.text
NOTsubprogram:
 not $v0, $v0
 jr $ra


# subprogram: 5.11 part d) Mult4
# author: Henry Warmerdam
# purpose: take an input parameter, and return that parameter multiplied by 4 using only shift and add operations
.text
Mult4:
 # SLL (shift left logical) operator
 sll $v0, $a0, 2
 jr $ra


# subprogram: 5.11 part e) Mult10
# author: Henry Warmerdam
# purpose: take an input parameter, and return that parameter multiplied by 10 using only shift and add operations
.text
Mult10:
 # SLL (shift left logical) operator
 sll $v0, $a0, 3
 sll $t0, $a0, 1
 add $v0, $v0, $t0
 jr $ra


# subprogram: 5.11 part f) Swap
# author: Henry Warmerdam
# purpose: take two input parameters, swap them using only the XOR operation
.text
Swap1:
 xor $t0, $a0, $a1
 xor $a0, $t0, $a0
 xor $a1, $t0, $a1
 jr $ra


# subprogram: 5.11 part g) RightCircularShift
# author: Henry Warmerdam
# purpose: take an input parameter, and return two values. The first
# is the value that has been shifted 1 bit using a right circular shift, and the second is
# the value of the bit which has been shifted.
.text
RightCircularShift:
 # 0110
 # 0011
 # 1001
 #rem $v1, $a0, 2
 ror $v0, $a0, 1
 andi $v1, $a0, 1
 jr $ra


# subprogram: 5.11 part h) LeftCircularShift
# author: Henry Warmerdam
# purpose: take an input parameter, and return two values. The first
# is the value that has been shifted 1 bit using a left circular shift, and the second is
# the value of the bit which has been shifted.
.text
LeftCircularShift:
 rol $v0, $a0, 1
 andi $v1, $v0, 1
 jr $ra


# subprogram: 5.11 part i) ToUpper
# author: Henry Warmerdam
# purpose: take a 32 bit input which is 3 characters and a null, or a 3 character
# string. Convert the 3 characters to upper case if they are lower case, or do nothing
# if they are already upper case.
.text
ToUpper:
 # 00000000 01100011 01100010 01100001
 # and      11011111
 # 00000000 01000011 01000010 01000001
 # 00000000 11011111 11011111 11011111
 andi $v0, $a0, 0xDFDFDF
 jr $ra


# subprogram: 5.11 part j) ToLower
# author: Henry Warmerdam
# purpose: take a 32 bit input which is 3 characters and a null, or a 3 character
# string. Convert the 3 characters to lower case if they are upper case, or do nothing
# if they are already lower case.
.text
ToLower:
 # 00000000 01000011 01000010 01000001
 # or       00100000 00100000 00100000
 # 00000000 01100011 01100010 01100001
 ori $v0, $a0, 0x202020
 jr $ra


# Author: Henry Warmerdam
# Input: $a0 - the number of items in the array
# $a1 - the size of each item
# Output: $v0 - Address of the array allocated
AllocateArray:
 addi $sp, $sp, -4
 sw $ra, 0($sp)

 mul $a0, $a0, $a1
 li $v0, 9
 syscall

 lw $ra, 0($sp)
 addi $sp, $sp, 4
 jr $ra


# subprogram: PrintIntArray
# author: Henry Warmerdam
# purpose: print an array of ints
# inputs: $a0 - the base address of the array
# $a1 - the size of the array
.text
PrintIntArrayForwards:
 addi $sp, $sp, -16 # Stack record
 sw $ra, 0($sp)
 sw $s0, 4($sp)
 sw $s1, 8($sp)
 sw $s2, 12($sp)

 move $s0, $a0 # save the base of the array to $s0
 
 # initialization for counter loop
 # $s1 is the ending index of the loop
 # $s2 is the loop counter
 move $s1, $a1
 li $s2, 0
 la $a0 open_bracket # print open bracket
 jal PrintString

loop:
 # check ending condition
 sge $t0, $s2, $s1
 bnez $t0, end_loop

 sll $t0, $s2, 2 # Multiply the loop counter by
 # by 4 to get offset (each element # is 4 big).
 
 add $t0, $t0, $s0  # address of next array element
 lw $a1, 0($t0)     # Next array element
 la $a0, comma
 jal PrintInt       # print the integer from array

 addi $s2, $s2, 1   # decrement $s2
 b loop
 
end_loop:
 li $v0, 4 # print close bracket
 la $a0, close_bracket
 syscall
 
 lw $ra, 0($sp)
 lw $s0, 4($sp)
 lw $s1, 8($sp)
 lw $s2, 12($sp) # restore stack and return
 addi $sp, $sp, 16
 
 jr $ra
 
.data
 open_bracket: .asciiz "["
 close_bracket: .asciiz "]"
 comma: .asciiz ","


# subprogram: PrintIntArray
# author: Henry Warmerdam
# purpose: print an array of ints
# inputs: $a0 - the base address of the array
# $a1 - the size of the array
.text
PrintIntArrayBackwards:
 addi $sp, $sp, -16 # Stack record
 sw $ra, 0($sp)
 sw $s0, 4($sp)
 sw $s1, 8($sp)
 sw $s2, 12($sp)

 move $s0, $a0 # save the base of the array to $s0

 # initialization for counter loop
 # $s1 is the ending index of the loop
 # $s2 is the loop counter
 subi $s2, $a1, 1
 la $a0 open_bracket # print open bracket
 jal PrintString

loop1:
 # check ending condition
 slt  $t0, $s2, $zero
 bnez $t0, end_loop1

 sll $t0, $s2, 2 # Multiply the loop counter by
 # by 4 to get offset (each element # is 4 big).
 
 add $t0, $t0, $s0  # address of next array element
 lw $a1, 0($t0)     # Next array element
 la $a0, comma
 jal PrintInt       # print the integer from array

 addi $s2, $s2, -1   # decrement $s2
 b loop1
 
end_loop1:
 li $v0, 4 # print close bracket
 la $a0, close_bracket
 syscall
 
 lw $ra, 0($sp)
 lw $s0, 4($sp)
 lw $s1, 8($sp)
 lw $s2, 12($sp) # restore stack and return
 addi $sp, $sp, 16
 
 jr $ra
 
 
# Subproram: Bubble Sort
# Purpose: Sort data using a Bubble Sort algorithm
# Input Params: $a0 - array bas address
# $a1 - array size
# Register conventions:
# $s0 - array base
# $s1 - array size
# $s2 - outer loop counter
# $s3 - inner loop counter
.text
BubbleSort:
 addi $sp, $sp -20 # save stack information
 sw $ra, 0($sp)
 sw $s0, 4($sp) # need to keep and restore save registers
 sw $s1, 8($sp)
 sw $s2, 12($sp)
 sw $s3, 16($sp)

 move $s0, $a0
 move $s1, $a1

 addi $s2, $zero, 0 #outer loop counter
 
 OuterLoop:
 addi $t1, $s1, -1
 slt $t0, $s2, $t1
 beqz $t0, EndOuterLoop
 
 addi $s3, $zero, 0 #inner loop counter
 
 InnerLoop:
 addi $t1, $s1, -1
 sub $t1, $t1, $s2
 slt $t0, $s3, $t1
 beqz $t0, EndInnerLoop

 sll $t4, $s3, 2 # load data[j]. Note offset is 4 bytes
 add $t5, $s0, $t4
 lw $t2, 0($t5)

 addi $t6, $t5, 4 # load data[j+1]
 lw $t3, 0($t6)

 sgt $t0, $t2, $t3
 beqz $t0, NotGreater
 move $a0, $s0
 move $a1, $s3
 addi $t0, $s3, 1
 move $a2, $t0
 jal Swap # t5 is &data[j], t6 is &data[j=1]

 NotGreater:
 addi $s3, $s3, 1
 b InnerLoop
 EndInnerLoop:
 addi $s2, $s2, 1
 b OuterLoop
 EndOuterLoop:

 lw $ra, 0($sp) #restore stack information
 lw $s0, 4($sp)
 lw $s1, 8($sp)
 lw $s2, 12($sp)
 lw $s3, 16($sp)
 addi $sp, $sp 20
 jr $ra


# Subprogram: swap
# Purpose: to swap values in an array of integers
# Input parameters: $a0 - the array containing elements to swap
# $a1 - index of element 1
# $a2 - index of elelemnt 2
# Side Effects: Array is changed to swap element 1 and 2
Swap:
 sll $t0, $a1, 2    # calculate address of element 1
 add $t0, $a0, $t0
 sll $t1, $a2, 2    # calculate address of element 2
 add $t1, $a0, $t1
 lw $t2, 0($t0)     # swap elements
 lw $t3, 0($t1)
 sw $t2, 0($t1)
 sw $t3, 0($t0)
 
 jr $ra











# subprogram: PrintNewLine
# author: Henry Warmerdam
# purpose: to output a new line to the user console
# side effects: A new line character is printed to the user's console
.text
PrintNewLine:
 li $v0, 4
 la $a0, __PNL_newline
 syscall
 jr $ra
.data
 __PNL_newline: .asciiz "\n"
 
# subprogram: PrintSpace
# author: Henry Warmerdam
# purpose: to output a space to the user console
# side effects: A space character is printed to the user's console
.text
PrintSpace:
 li $v0, 4
 la $a0, __PNL_space
 syscall
 jr $ra
.data
 __PNL_space: .asciiz " "
 
# subprogram: PrintInt
# author: Henry Warmerdam
# purpose: To print a string to the console
# input: $a0 - The address of the string to print.
# $a1 - The value of the int to print
# side effects: The String is printed followed by the integer value.
.text
PrintInt:
 # Print string. The string address is already in $a0
 li $v0, 4
 syscall

 move $a0, $a1
 li $v0, 1
 syscall

 #return
 jr $ra

# subprogram: PromptInt
# author: Henry Warmerdam
# purpose: To print the user for an integer input, and
# to return that input value to the caller.
# input: $a0 - The address of the string to print.
# returns: $v0 - The value the user entered
# side effects: The String is printed followed by the integer value.
.text
PromptInt:
 # Read the integer value. Note that at the end of the
 # syscall the value is already in $v0, so there is no
 # need to move it anywhere.
 li $v0, 5
 syscall

 #return
 jr $ra

# subprogram: PrintString
# author: Henry Warmerdam
# purpose: To print a string to the console
# input: $a0 - The address of the string to print.
# side effects: The String is printed to the console.
.text
PrintString:
 addi $v0, $zero, 4
 syscall
 jr $ra

# subprogram: Exit
# author: Henry Warmerdam
# purpose: to use syscall service 10 to exit a program
# side effects: The program is exited
.text
Exit:
 li $v0, 10
 syscall
