# Tom Chiapete
# CSCI 355 
# 2/14/06
# Assignment 1.1
#
# Write a MIPS program to calculate 10 - 4 + 3
# 
#######################################################

	.data

				# Declare some ascii variables.
				# I'll need to output them later.
equals:	.asciiz " = "
plus:	.asciiz " + "
	
	.text
#	.align 2
#	.globl main
	
main:
				# Load immediate 10 into $t5.
	li $t5,10

				# Load immediate -4 into $t1
	li $t1,-4
	
				# Load immediate 3 into $t2.
	li $t2,3
	
				# If you're wondering, I used $t5 instead of $t0 in debugging.  
				# It works right now, and I don't want to change it back
				
				# Simply take the sum of $t5 (10) and $t1 (-4) and store the 
				# answer (-6) in $t3.
	add $t3,$t5,$t1
	
				# Take $t3 and add $t2 (3) to it.  So:  6 + 3   Final answer: 9
	add $t3,$t3,$t2
	
				# Load immediate 1 to $v0 register.  $v_ are return registers.
	li $v0,1
	
				# Copy the value of $t5 (10) into $a0.  
				# Call syscall to print 10
	move $a0,$t5
	syscall
	
				# Load $v0 mode to 4 - (returns string).  Load address of ascii 
				# plus to $a0. 
				# Syscall to print
	li $v0,4
	la $a0,plus
	syscall
	
				# Load $v0 mode to 1 - returns int.  Move value of $t1 (-4)
				# to $a0 and call syscall to print.
	li $v0,1
	move $a0,$t1
	syscall
	
				# Load $v0 to 4 - (string).  
				# Output plus variable.
	li $v0,4
	la $a0,plus
	syscall
	
				# Load $v0 to 1 - int
				# Copy $t2 (3) to $a0 and syscall for output.
	li $v0,1
	move $a0,$t2
	syscall
	
				# Load $v0 to 4 - (string).  
				# Output equals variable.
	li $v0,4
	la $a0,equals
	syscall
	
				# Load $v0 to 1 - int
				# Copy the answer variable to $a0.  Output that.
	li $v0,1
	move $a0,$t3
	syscall
	
				# Jump and return.
	jr $ra
