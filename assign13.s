# Tom Chiapete
# CSCI 355 
# 2/14/06
# Assignment 1.3
#
# Write a MIPS program to calculate the sum of odd integers 1 .. 20. 
# Store each partial sum in an array in memory:1 3 6 10 15 ... 
# Call this program a13.s. 
#
#######################################################

	.data
	
				# Declare a list of odd positive integers <= 19
OddArr:	.word	1,3,5,7,9,11,13,15,17,19

	.text
#	.align 2
#	.globl main
	
main:

				# Load address of odd array into $s0 register
	la $s0,OddArr
	
				# Load value of $s0 (array) position 0 at temp $t0
	lw $t0,0($s0)
				# Load value of $s0 position 4 at temp register $t1
	lw $t1,4($s0)
	
				# Take the sum of $t1 and $t0 and put it in $t1.
	add $t1,$t1,$t0
				
				# Store $t1 to address $s0 position 4.
				# As the direction say, place results back in array.
	sw $t1,4($s0)
	
				# Load value of $s0 postion 8 into $t0.
	lw $t0,8($s0)
				# Add $t1 and $t0 - store back in $t1
	add $t1,$t1,$t0
				# Store $t1 to address $s0 position 8.
	sw $t1,8($s0)
	
				# Repeat same instructions for when array value equals 7
	lw $t0,12($s0)
	add $t1,$t1,$t0
	sw $t1,12($s0)
	
				# Repeat same instructions for when array value equals 9
	lw $t0,16($s0)
	add $t1,$t1,$t0
	sw $t1,16($s0)
	
				# Repeat same instructions for when array value equals 11
	lw $t0,20($s0)
	add $t1,$t1,$t0
	sw $t1,20($s0)
	
				# Repeat same instructions for when array value equals 13
	lw $t0,24($s0)
	add $t1,$t1,$t0
	sw $t1,24($s0)
	
				# Repeat same instructions for when array value equals 15
	lw $t0,28($s0)
	add $t1,$t1,$t0
	sw $t1,28($s0)
	
				# Repeat same instructions for when array value equals 17
	lw $t0,32($s0)
	add $t1,$t1,$t0
	sw $t1,32($s0)
	
				# Repeat same instructions for when array value equals 19
	lw $t0,36($s0)
	add $t1,$t1,$t0
	sw $t1,36($s0)

				# Done with array
				# Jump to return address
	jr $ra
