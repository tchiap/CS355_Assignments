# Tom Chiapete
# CSCI 355 
# 2/14/06
# Assignment 1.2
#
# Write a MIPS program to read an integer 'n' from the keyboard, 
# calculate n to the nth power (n^n). Put this logic in an # #infinite loop, 
# prompting for another integer. Call this program a12.s. (Test with small numbers!) 
#
#######################################################

	.data
	
				# Ascii data - put in prompt variable.
prompt:	.asciiz "Enter a small number:  "

	.text
#	.align 2
#	.globl main
	
main:

				# Simulate infinite loop.  Start here.
infinite:

				# Show prompt variable (ascii).  The 4 in the 
				# li instruction returns a string.
	li $v0,4
	la $a0, prompt
	syscall
	
				# Read in int - mode 5.
	li $v0,5
	syscall
	
				# Load immediate 1 into the temp $t1
	li $t1,1
	
				# Copy $v0 to $t2
	move $t2,$v0
				# Also, copy $v0 to $t3 -- cleans it up for me later.
	move $t3,$v0
	
				# Simulate while loop when the input is greater than 0
Loop: 

				# Multiply $t1 and $t2 -- Store back to $t1 temp
	mul $t1,$t1,$t2
				# $t3 added to minus 1.  Store to $t3 temp. 
	addi $t3,$t3,-1
	
				# A branch not equal.
				# If $t3 != 0, run Loop again.
	bne $zero,$t3,Loop
	
				# We have to load 1 for the $v0.  $v0 contains number of system calls.
				# Copy $t1 to $a0 then.
	li $v0,1
	move $a0,$t1
	syscall
	
				# Branch.  In this case, infinitely
	b infinite
