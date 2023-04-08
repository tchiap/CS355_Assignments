########################################################
# Tom Chiapete
# Disassembles R type instruction
########################################################
.data
                # Store the parsed opcode/registers in parsed
parsed: .word	0,0,0,0,0,0
                # Store the instruction in instr


####################################
### INSTRUCTION - INPUT ############
####################################				

				# 0x00c23021 
				
instr:  .word 0x00041080

   

space:    .asciiz "  "

notZero:.asciiz "XXX" 


########################################################
# Function Code Tranlation spacele
########################################################
FCxlat:             
    .asciiz    "sll "    # 0
    .asciiz    "??? "
    .asciiz    "srl "
    .asciiz    "sra "
    .asciiz    "sllv"    # 4
    .asciiz    "??? "    
    .asciiz    "srlv"
    .asciiz    "srav"
    .asciiz    "jr  "    # 8
    .asciiz    "jalr"
    .asciiz    "movz"
    .asciiz    "movn"
    .asciiz    "sysc"    # 12
    .asciiz    "brea"
    .asciiz    "??? "
    .asciiz    "sync"    
    .asciiz    "mfhi"    # 16
    .asciiz    "mthi"
    .asciiz    "mflo"
    .asciiz    "mtlo"
    .asciiz    "??? "    # 20
    .asciiz    "??? "
    .asciiz    "??? "
    .asciiz    "??? "
    .asciiz    "mult"    # 24
    .asciiz    "mulu"
    .asciiz    "div "
    .asciiz    "divu"
    .asciiz    "??? "    # 28
    .asciiz    "??? "
    .asciiz    "??? "
    .asciiz    "??? "
    .asciiz    "add "    # 32
    .asciiz    "addu"
    .asciiz    "sub "
    .asciiz    "subu"
    .asciiz    "and "    # 36
    .asciiz    "or  "
    .asciiz    "xor "
    .asciiz    "nor "
    .asciiz    "??? "    # 40
    .asciiz    "??? "

    .asciiz    "slt "
    .asciiz    "sltu"    

#############################################################


Register:                     # register name translation

    .asciiz    "$r0 "    # 0
    .asciiz    "$at "
    .asciiz    "$v0 "
    .asciiz    "$v1 "  	 
    .asciiz    "$a0 "    # 4
    .asciiz    "$a1 "    
    .asciiz    "$a2 "
    .asciiz    "$a3 "
    .asciiz    "$t0 "    # 8
    .asciiz    "$t1 "
    .asciiz    "$t2 "
    .asciiz    "$t3 "
    .asciiz    "$t4 "    # 12
    .asciiz    "$t5 "
    .asciiz    "$t6 "
    .asciiz    "$t7 "    
    .asciiz    "$s6 "    # 16
    .asciiz    "$s1 "
    .asciiz    "$s2 "
    .asciiz    "$s3 "
    .asciiz    "$s4 "    # 20
    .asciiz    "$s5 "
    .asciiz    "$s6 "
    .asciiz    "$s7 "
    .asciiz    "$t8 "    # 24
    .asciiz    "$t9 "
    .asciiz    "$k0 " 
    .asciiz    "$k1 "    
    .asciiz    "$gp "	 # 28
    .asciiz    "$sp "
    .asciiz    "$s8 "
    .asciiz    "$ra "    # 31

    
########################### Program ######################
# This program disassembles an R-type instruction
#
# Pseudocode:
#    Get the instruction stored in 'instruct'
#    Parse the instruction into the 'parsed' array
#    Print translated opcode and space
#    Switch parsed.opcode
#    Case 0..3:  // Shift Instruction
#        print rd, rt, shamt
#    Case 16..18:  // mfhi/mflo
#        print rd
#    Case 24..27: // multiply or divide
#        print rs, rt
#    Default: 
#        print rd, rs, rt
#    Endswitch
########################################################
    .text
    .align 2
    .globl main
main:

# 							Stores the address of the array
    la    $s6,parsed
# 							Store the instruction
    lw    $s1,instr	

#							Store off the return address
    sw    $ra,-12($sp)
#							Store off the instruction
    sw    $s1,-4($sp)
# 							Store the parsing array
    sw    $s6,-8($sp)    

#							Jump to ParseR
    jal    ParseR
    
#							Save off the $a1 register
    sw    $a1,-16($sp)
#							Save off the $a2 register 
    sw    $a2,-20($sp)

#							Run a load byte to load in the function code
    lb    $t0,0($s6)	 
#							Run a load byte to load in the opcode
    lb    $t1,5($s6)	 

#							$t0 to be passed
    sb    $t0,0($a1)     
#							$t1 to be passed
    sb    $t1,0($a2)     

# 							Jump to translate
    jal   TranslateR     

#							Store back the value of $a1 into sp
    lw    $a1,-16($sp)
#							Store back the value of $a2 into sp	
    lw    $a2,-20($sp)
	
#							Load byte and store off the opcode.
    lb    $t0,5($s6)
	
#####################################	

#							When the opcode is <= 3, branch to LabelLt3
    ble    $t0,3,LabelLt3   


#							Execute when opcode is > 15 and < 20
    slti   $t1,$t0,19  
	
    slti   $t2,$t0,16   

#							When the two above shifted amounts = 1, go to check16Thru18	
    add    $t2,$t2,$t1  
    beq    $t2,1,check16Thru18  
	
	
#							Execute when opcode is > 23 and < 29
    slti   $t1,$t0,28    
    slti   $t2,$t0,24   

#							If the two above shifted amounts = 1, then go to check24Thru27	
    add    $t2,$t2,$t1   
    beq    $t2,1,check24Thru27 
	
	
#							For the other numbers, retrieve the following

#							Retrieve the destination register name
    lb    $s2,3($s6)     
#							Retrieve the first source register
    lb    $s3,1($s6)     
#							Retrieve the second source register
    lb    $s4,2($s6)  

# 							Store off $a1 into the sp
    sw    $a1,-4($sp)
	
	
#							Output destination register
	sw    $s2,0($a1)
    jal    PrintReg      
     

#							Output the first source register	
    sw    $s3,0($a1) 
	jal    PrintReg      
	
#							Output the second source register
    sw    $s4,0($a1)     
    jal    PrintReg      

#################################################################	
#							Do a replacement of the $a1 register
    lw    $a1,-4($sp)    
# 							Reset and go back to the original frame pointer
    lw    $ra,-12($sp)   
    jr    $ra

#							For when 16-18
check16Thru18:

#							Store and save off $a1 in the sp
    sw    $a1,-4($sp)                
    lb    $s2,3($s6)     

#							Print out the destination register
    sw    $s2,0($a1)    
    jal    PrintReg     
    
#							Revert back to $a1
    lw    $a1,-4($sp)    
	
#							Reset the frame pointer
    lw    $ra,-12($sp)   
	
#							Jump return
    jr    $ra

#							For when 24-27
check24Thru27:

#							Store $a1 to the stack pointer
    sw    $a1,-4($sp)    
    
# 							Save off first source register
    lb    $s2,1($s6)     
	
#							Save off the second source register
    lb    $s3,2($s6)    
    
#							Print off the first source register
    sw    $s2,0($a1)     
    jal    PrintReg      
	
#							Print off the second source register
    sw    $s3,0($a1)     
    jal    PrintReg    

#							Save off $a1
    lw    $a1,-4($sp)
	
#							Reset the frame pointer
    lw    $ra,-12($sp)  
	
#							Jump return
    jr    $ra

LabelLt3:
    
#							Retrieve destination register
    lb    $s2,3($s6)     
#							Retrieve source register
    lb    $s3,2($s6)     
	
#							Retrieve the r type shift amount
    lb    $s4,4($s6)     
    
#							Save off $a1 to the stack pointer
    sw    $a1,-4($sp) 
	
#							Print out destination register	
    sw    $s2,0($a1)     
    jal    PrintReg
	
#							Print out source register
    sw    $s3,0($a1)     
    jal    PrintReg      
    
#							Print out shift amount

#							Setup for output..output $s4
    li    $v0,1
    move    $a0,$s4      
	
#							Syscall to output
    syscall
    
#							Replace $a1
    lw    $a1,-4($sp)    
	
#							Reset out frame pointer
    lw    $ra,-12($sp)   
	
#							Jump return
    jr    $ra	
	
	
########################################################
# ParseR: This procedure parses an R-instruction into an array.
#
# Calling Sequence:
#   -4(SP)=Instruction
#   -8(SP)=Address of array to parse into
#
# Returns:  In the output array, the following is stored:
#   Word 0: Opcode
#   Word 1: Register Src1
#   Word 2: Register Src2
#   Word 3: Register Dest
#   Word 4: Shift Amount
#   Word 5: Function Code
########################################################
ParseR:
    
#							First load in paramaters
    lw    $s6,-8($sp)
    lw    $s1,-4($sp)    
    sw    $ra,-8($sp)
       
#							Retrieve and store off the opcode
    srl   $t2,$s1,26     
    sb    $t2,0($s6)     

#							Store off the first source register
    srl   $t2,$s1,21     
    andi  $t2,$t2,0x1f   
    sb    $t2,1($s6)    

#							Store off the second source register
    srl   $t2,$s1,16
    andi  $t2,$t2,0x1f 
    sb    $t2,2($s6)     

#							Store the destination register
    srl   $t2,$s1,11
    andi  $t2,$t2,0x1f   
    sb    $t2,3($s6)     

#							Store the shift amount
    srl   $t2,$s1,6
    andi  $t2,$t2,0x1f   
    sb    $t2,4($s6)	

#							Store the function code
    srl   $t2,$s1,0
    andi  $t2,$t2,0x3f  
    sb    $t2,5($s6)	 

#							Save off the return address
    lw    $ra,-8($sp)	 
	
#							Return
    jr    $ra        


###############################################
# opCodeIsZero - a condition for when = 0
#################################################

	
opCodeIsZero:

#							Load the function code
    lb    $t4,5($s6)     
    lb    $t4,0($a2)     

#							Load in the FCxlat	
    la    $t6,FCxlat    

#							Multiply by 5	
    mul   $t4,$t4,5     
    add   $t6,$t6,$t4
	
#							Set for output
    li    $v0,4
	
#							Print out the function code
    move  $a0,$t6    
#							Syscall to output    
    syscall
	
#							Set to print out space
    la    $a0,space        
#							Syscall to output space
    syscall
    
#							Load in the return address
    lw    $ra,-8($sp)	
	
#							Return
    jr    $ra
    
########################################################
# PrintReg: Prints a register passed as a parameter
#   A register number (0-32) is passed as a parameter and
#   the register mnemonic is printed (e.g., $t1 or $a0)
#   Finally, a space is printed after the register.
#
# Calling Sequence:
#   $a1 = Register number to print
########################################################
PrintReg:
    sw    $ra,-8($sp)
    lw    $t1,0($a1)
    
#							Load in address of register
    la    $t6,Register   
	
#							Locate register by incrementing + 5 bits
    mul   $t4,$t1,5      
    add   $t6,$t6,$t4    
	
#							Set for output
    li    $v0,4
	
#							Copy register
    move    $a0,$t6    

#							Syscall to output	
    syscall
    
#							Load the return address
    lw    $ra,-8($sp)  
	
#							Return
    jr    $ra       


###############################################
# opCodeIsNotZero - a condition for when != 0
#################################################


opCodeIsNotZero:

#							Set for output - string
    li    $v0,4
    la    $a0,notZero    
	
#							Syscall to output "XXX"
    syscall

#							Print out the space characters
    la    $a0,space        
    syscall
    
#							Load in the return address
    lw    $ra,-8($sp)	 	
	
#							Return
    jr    $ra    	
	
	
	
	
	
########################################################
# TranslateR: Prints an opcode/function code mnemonic 
#   for an R-type Instruction
#   Translates an opcode/function code into an instruction type.
#   Prints the instruction mnemonic (e.g., lw) and a space.
#   Prints an instruction XXX if wrong type of opcode (not equal to 0).
#   Prints ??? if unrecognized function code.
#   Uses the FCxlate spacele to achieve this.
#
# Calling Sequence:
#   $a1 = Opcode
#   $a2 = Function Code
#
# Returns: Nothing
########################################################
# The call to syscall has the following parameters:
#   $a0: thing to be printed
#   $v0: Mode
#       1=integer
#       4=null-terminated string
########################################################
TranslateR:
    sw    $ra,-8($sp)

						 
#							When the opcode = 0 go to opCodeIsZero
    lb    $t3,0($a1)
    lb    $t3,0($s6)   
#							Branch if equal	
    beq   $t3,0,opCodeIsZero
