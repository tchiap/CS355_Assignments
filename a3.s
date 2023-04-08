#############################################################
#
# Tom Chiapete
# April 6, 2006
# Assignment 3
#
##############################################################
#       DATA SECTION
##############################################################
.data

#									Temperature value that stops inputs
exitVal: .double -1000.0

#									Message that appears when high < low
error:  .asciiz "High is lower than the low.\n"

#									Message when not enough information
error1:  .asciiz "Not enough information.\n"

#									Variables holding enter high/low prompt text
enterLow: .asciiz "Enter Low:  "
enterHigh: .asciiz "Enter High:  "

#									Variable holding text "Statistics For Period:"
statsForPeriod: .asciiz "Statistics For Period:\n"

#									Variable holding text "Daily Extremes"
dailyExtremes: .asciiz "Daily Extremes:      "

#									Holds a carriage return. 
lineBreak:  .asciiz  "\n"

#									Doubles holding max/min highs and lows
dblMaxLow:  .double 0.0
dblMaxHigh:  .double 0.0
dblMinLow:  .double 0.0
dblMinHigh:  .double 0.0

#									Maximum Low and High text
maxLow: .asciiz "          Max Low: "
maxHigh: .asciiz "Max High: "

#									Minimum Low and High text
minLow: .asciiz " Min Low: "
minHigh: .asciiz " Min High: " 

#									Variable holding "Averages" text
averages: .asciiz "Averages:         "

#									Variable holding average highs and lows
averageLow: .asciiz " Average Low: "
averageHigh: .asciiz " Average High: "

#									Holds "Difference (High-Low):" text
difference: .asciiz "Difference (High-Low):   "

#									Variables Holding the max and min ascii text
max: .asciiz "  Max:  "
min: .asciiz "  Min:  "

#									Variable holding "average differences" text
averageDiff: .asciiz " Average Difference: "

#									Two doubles containing 0 and 1 values
#									Used in a couple places in the project
one:	.double	1.0
zero:	.double 0.0

##############################################################
	.text
	.align 2
	.globl main
##############################################################
	
# Register values	
# $f0 - Predefined - Input
# $f2 - Low running total	
# $f4 - High running total	
# $f6 - Temporary low	
# $f8 - Temporary high	
# $f12 - Predefined - Output
# $f14 - Average Low
# $f16 - Average High
# $f20 - Load to pass register
# $f26 - Exit Value
# $f28 - Counter
	
#									Start of code
################################################################

		
################################################################
# IniValues - Set initial values for a few variables
################################################################		

main:

IniValues:

#									Set counter to 0
		l.d 	$f28,zero
				
#									Set the low running total to 0
		l.d		$f2,zero
		
#									Set the high running total to 0		
		l.d	    $f4,zero

#################################################################
# ReadStats0 - A ReadStats that is only going to be executed once.
# This will ensure our max/min low/high are outputed correctly 
# in the terminal
#################################################################
ReadStats0: 

#									Output low value text
		li		$v0,4
		la		$a0,enterLow
		syscall
		
#									Read in low value.
		li		$v0,7
		syscall
		
#									Copy input to temporary low
		mov.d	$f6,$f0
		
#									Load the exit value -1000 into 
#									my defined exit value register
		l.d		$f26,exitVal
		
#									Check to see if they entered a -1000, 
#									if so, quit and process.
		c.eq.d 	$f0,$f26
#									-1000 was entered.  Goto stop to compute
		bc1t	ErrorMsg1
		
#									Output high value text		
		li		$v0,4
		la		$a0,enterHigh
		syscall

#									Enter in high value
		li		$v0,7
		syscall
		
		mov.d	$f8,$f0
#									Check to see if the high < low
		c.lt.d	$f6,$f8
#									When high < low, output an error message
		bc1f	ErrorMsg
		
#									Load a 1 in input register
		l.d		$f0,one
		
#									Increment the counter
		add.d	$f28,$f28,$f0
		
#									Add the temp low to the low running total 		
		add.d	$f2,$f6,$f2
#									Add the temp high to the high running total
		add.d	$f4,$f8,$f4
		
#									Find averages
#									Divide the low running total by the counter 
		div.d	$f14,$f2,$f28
#									Divide the high running total by the counter
		div.d	$f16,$f4,$f28
		
#									Branch to initializer to intialize our 4 variables
		b	Initializer	

		
##################################################################
#  Read Stats
#  Performs a loop of prompts until user enters -1000
##################################################################
ReadStats: 

#									Output low value text
		li		$v0,4
		la		$a0,enterLow
		syscall
		
#									Read in low value.
		li		$v0,7
		syscall
		
#									Copy input to temporary low
		mov.d	$f6,$f0
		
#									Load the exit value -1000 into 
#									my defined exit value register
		l.d		$f26,exitVal
		
#									Check to see if they entered a -1000, 
#									if so, quit and process.
		c.eq.d 	$f0,$f26
#									-1000 was entered.  Goto stop to compute
		bc1t	Stop
		
#									Output high value text		
		li		$v0,4
		la		$a0,enterHigh
		syscall

#									Enter in high value
		li		$v0,7
		syscall
		
		mov.d	$f8,$f0
#									Check to see if the high < low
		c.lt.d	$f6,$f8
#									When high < low, output an error message
		bc1f	ErrorMsg
		
#									Load a 1 in input register
		l.d		$f0,one
		
#									Increment the counter
		add.d	$f28,$f28,$f0
		
#									Add the temp low to the low running total 		
		add.d	$f2,$f6,$f2
#									Add the temp high to the high running total
		add.d	$f4,$f8,$f4
		
#									Find averages
#									Divide the low running total by the counter 
		div.d	$f14,$f2,$f28
#									Divide the high running total by the counter
		div.d	$f16,$f4,$f28
		
#									Go to compare method
		b		Compare
		
#									When temp low is greater than temp high, 
#									loop again to ReadStats
		c.lt.d	$f6,$f8
		bc1t	ReadStats

###################################################################
# Stop -
# Outputs all the information we'll need
##################################################################
Stop:

#									Output "\n" - Line Break
		li		$v0,4
		la		$a0,lineBreak
		syscall	
		
#									Output "Stats for period" text
		li		$v0,4
		la		$a0,statsForPeriod
		syscall
		
#									Output "Daily Extremes" text
		li		$v0,4
		la		$a0,dailyExtremes
		syscall

#									Output "Max High" text
		li		$v0,4
		la		$a0,maxHigh
		syscall		
		
#									Output "Max High" value
		l.d		$f12,dblMaxHigh
		li		$v0,3
		syscall
	
#									Output "Min High" text
		li		$v0,4
		la		$a0,minHigh
		syscall	
		
#									Output "Min High" value
		l.d		$f12,dblMinHigh
		li		$v0,3
		syscall
		
#									Output "\n" - Line Break
		li		$v0,4
		la		$a0,lineBreak
		syscall	
		
#									Output "Max Low" text
		li		$v0,4
		la		$a0,maxLow
		syscall		
		
#									Output the dblMaxLow variable value
		l.d		$f12,dblMaxLow
		li		$v0,3
		syscall
#									"Min Low" text
		li		$v0,4
		la		$a0,minLow
		syscall	
		
#									Output the dblMinLow variable value
		l.d		$f12,dblMinLow
		li		$v0,3
		syscall
#									Output "\n" - Line Break
		li		$v0,4
		la		$a0,lineBreak
		syscall	
		
#									Output "Averages" text
		li		$v0,4
		la		$a0,averages
		syscall		

#									"Average Low" text
		li		$v0,4
		la		$a0,averageLow
		syscall

# 									Copy the average low into the output
#									syscall to output
		mov.d	$f12,$f14
		li		$v0,3
		syscall
#									Output "Average High" text
		li		$v0,4
		la		$a0,averageHigh
		syscall					

#									Copy average high into output register
		mov.d		$f12,$f16
		li		$v0,3
		syscall
		
#									Output "\n" - Line Break
		li		$v0,4
		la		$a0,lineBreak
		syscall	

#									Output "Difference (High-low)" text
		li		$v0,4
		la		$a0,difference
		syscall	
		
#									Output "Max" text
		li		$v0,4
		la		$a0,max
		syscall	
		
#									Load the high average into dblMaxHigh variable
		l.d 	$f16, dblMaxHigh
		
#									Load the low average into dblMinLow variable
		l.d		$f14, dblMinLow
		
#									Subtract the high average by the low average 
#									and store it in a temporary register
		sub.d	$f24,$f16,$f14
#									Move value from the temp register to the
#									output register
#									Syscall to output
		mov.d	$f12,$f24
		li		$v0,3
		syscall
#									Output "Min" text
		li		$v0,4
		la		$a0,min
		syscall	
		
#									Load the average high in the dblMinHigh register
		l.d 	$f16, dblMinHigh
#									Load the average low in the dblMaxLow register
		l.d		$f14, dblMaxLow

#									Subtract average high by the average low 
#									and store it into the output register
#									Syscall to output
		sub.d	$f12,$f16,$f14
		li		$v0,3
		syscall
		
#									Output "Average Difference" text
		li		$v0,4
		la		$a0,averageDiff
		syscall	
		
#									Add	the temporary register from before data
#									in the output register.
#									Store it back in the output register.	
		add.d	$f12,$f24,$f12
		
#									Load a 1.0 into a new temporary register
		l.d 	$f18,one
		
#									Add the one to itself and store it in itself
		add.d	$f18,$f18,$f18
		
#									To get average difference
#									Divide the data in the f12 output register
#									by the double in the temporary register.
		div.d	$f12,$f12,$f18
		
#									Output by doing a syscall
		li		$v0,3
		syscall

#									All done, so jump return
		jr 		$ra
	
#####################################################################
# ErrorMsg - when called outputs - "High is lower than the low."
#####################################################################
ErrorMsg:
		li		$v0,4
		la		$a0,error
		syscall
#									Branch back to ReadStats
		b		ReadStats

#######################################################################
# Compare - makes the comparisons to set the max and min lows 
# for display  to the terminal
#######################################################################
Compare:
		
#									Loads to pass register 
		l.d		$f20,dblMaxLow		
#									When low is less than the register 
#									passed equals false, branch to NewMaximumLow
		c.lt.d	$f6,$f20
		bc1f	NewMaximumLow
		
#									Load to pass register again.
		l.d		$f20,dblMinLow		
#									Now when the opposite is then false, go
#									branch to NewMinimumLow
		c.lt.d	$f20,$f6
		bc1f	NewMinimumLow

#######################################################################
# Compare1 - makes the comparisons to set the max and min highs 
# for display  to the terminal
#######################################################################		
Compare1:

#									Load to pass register
		l.d		$f20,dblMaxHigh	
#									When high is less than the register passed
#									equals false, branch to NewMaximum high
		c.lt.d	$f8,$f20
		bc1f	NewMaximumHigh

#									Load to pass register		
		l.d		$f20,dblMinHigh		
#									Now when the opposite is then false, go 
#									branch to NewMinimumHigh
		c.lt.d	$f20,$f8
		bc1f	NewMinimumHigh
		
#####################################################################
# NewMinimumHigh - stores low to dblMaxLow - branch to Compare1
#####################################################################
NewMaximumLow:
		s.d		$f6,dblMaxLow
		b		Compare1

#####################################################################
# NewMinimumLow - stores low to dblMinLow - branch to Compare1
#####################################################################
NewMinimumLow:
		s.d		$f6,dblMinLow
		b		Compare1
		
#####################################################################
# NewMaximumHigh - stores high to dblMaxHigh - branch to ReadStats
#####################################################################
NewMaximumHigh:
		s.d		$f8,dblMaxHigh
		b		ReadStats

#####################################################################
# NewMinimumHigh - stores high to dlbMinHigh - branch to ReadStats
#####################################################################
NewMinimumHigh:
		s.d		$f8,dblMinHigh
		b		ReadStats

#####################################################################
# Initializer - initializes the four important variables declared
# in the .data section.  Sets the lows to the max and min lows.
# Sets the highs to the max and min highs.
#####################################################################		
Initializer:
		s.d		$f6,dblMinLow
		s.d		$f6,dblMaxLow
		s.d		$f8,dblMinHigh
		s.d		$f8,dblMaxHigh
		b		ReadStats

######################################################################
#  	ERROR MESSAGES
######################################################################

######################################################################
# ErrorMsg0 - When called, outputs "High is lower than the low."
# Branches back to ReadStats0
######################################################################		
ErrorMsg0:
		li		$v0,4
		la		$a0,error
		syscall
		b		ReadStats0

######################################################################
# ErrorMsg1 - Called when there is not enough information
# Branches back to ReadStats0.  Outputs "not enough information"
######################################################################			
ErrorMsg1:
		li		$v0,4
		la		$a0,error1
		syscall
		b		ReadStats0