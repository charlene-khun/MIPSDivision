
.data
    # labels for display at the end
    result:  .asciiz "Result of A/B by the refined iterative subtraction --> "
    prompt:  .asciiz "Enter a number: "
    newline: .asciiz	 "\n"
    space: .asciiz "  "
    
    # Remainder and quotient label that goes along with the result
    REMAINDER: .asciiz "Remainder = "
    QUOTIENT: .asciiz ", Quotient = "
    
    # labels for the top of the table
    STEP: .asciiz "  Step  "
    ACTION: "Action  "
    DIVISOR: "      Divisor"
    RQLABEL: "     Remainder,Quotient"
    
    # labels for each intermediate step
    STEPA: "     Initial Vals  "
    STEPB: "     (Rem,Q)<<     "
    STEPC: "     Rem=Rem-Div   "
    STEPD: "     Rem<0,R+D,Q<< "
    STEPE: "     Reme>=0, q0=1 "
    
    
 .text
.globl ex.3.19

ex.3.19:
        # same two lines from ex 3.12
	addi	$sp,	$sp,	-4   # xxx 
	sw		$ra,	($sp)   # xxx
	
	# A = Remainder/Quotient and is stored in register t6
  	move 	$t6, 	$a0
  	#  B = Divisor, and is stored in register t1
  	move 	$t1, 	$a1
  	
  	#  N = number of bits for display, assume N <= 16 and is stored
  	# in register t7
  	#don't need to alter t7 anymore
  	# the number of bits controls the loop this time    
  	move 	$t7,	$a2    
  	
  	# store the original number of bits in register s0
  	move $s0, $t7
  	
  	# store double the number of bits in register s1
  	add $s1, $t7, $t7
  	
  	# similar to ex 3.18, but this time shift the divisor 
  	#interally without actually changing the value of the 
  	# divisor
  	# store it in register s4 
  	sllv    $s4, $t1, $s0
  	
  	#initialize the counter and store it in s7
  	li $s7, 0 
  	
  	# call displayDiv.asm
  	jal displayDIV
  	
  	# print the top part of the table
  	la    	$a0,   STEP
	li    	$v0,  4
	sysCall
	
	la    	$a0,   ACTION
	li    	$v0,  4
	sysCall
	
	la    	$a0,   DIVISOR
	li    	$v0,  4
	sysCall
	
	la    	$a0,   RQLABEL
	li    	$v0,  4
	sysCall
	
	# print a new line
	la    	$a0,   newline
	li    	$v0,  4
	sysCall
	
	# print a space
	la    	$a0,   space
	li    	$v0,  4
	sysCall
	
	# print the counter
	move $a0, $s7
	li $v0, 1
	sysCall
	
	# print the initial vals step
	la    	$a0,   STEPA
	li    	$v0,  4
	sysCall
	
	# print the divisor
  	move $a0, $t1
  	jal display.bitsDiv
  	
  	# print the Remainder/Quotient
  	move $a2, $s1
  	move $a0, $t6
  	jal display.bitsDiv
  	
  	la    	$a0,   newline
	li    	$v0,  4
	sysCall
	
	la    	$a0,   newline
	li    	$v0,  4
	sysCall
 
loop:
        #  if $t7==0 quit loop
	beq	$t7, $0,  done	 
	
	# increment the counter by 1
	addi $s7, $s7, 1
	
	#Right shift Remainder/Quotient by 1
	sll   $t6, $t6, 1
	
	# print out a space
	la    	$a0,   space
	li    	$v0,  4
	sysCall
	
	# print out the counter
	move $a0, $s7
	li $v0, 1
	sysCall
	
	# print out (Rem, Q) <<
	la    	$a0,   STEPB
	li    	$v0,  4
	sysCall
	
	# print out the divisor
	move $a2, $s0
	move $a0, $t1
  	jal display.bitsDiv
  	
  	# print out the Remainder/Quotient
  	move $a2, $s1
  	move $a0, $t6
  	jal display.bitsDiv
  	
  	# print a new line
  	la    	$a0,   newline
	li    	$v0,  4
	sysCall
	
	# Rem = Rem - Div
	# use the altered (shifted) version of the Div
	subu $t6, $t6, $s4
	
	# print a space
	la    	$a0,   space
	li    	$v0,  4
	sysCall
	
	# print the counter
	move $a0, $s7
	li $v0, 1
	sysCall
	
	# print out the label Rem = Rem - Div
	la    	$a0,   STEPC
	li    	$v0,  4
	sysCall
	
	# print the divisor
	move $a2, $s0
	move $a0, $t1
  	jal display.bitsDiv
  	
  	# print the Remainder/Quotient
  	move $a2, $s1
  	move $a0, $t6
  	jal display.bitsDiv
  	
  	# print out a new line
  	la    	$a0,   newline
	li    	$v0,  4
	sysCall
	
	# check if Remainder is less than 0
	# 1 if less than, 0 if greater than or equal to
	slti	$t4, $t6, 0
	
	# if t4 == 0, then branch to the less than 0 part of the code
	beq	$t4, 1,  LTZERO

# if the remainder is greater than or equal to 0
GREZERO:
        # add one to the remainder/quotient because of Step q0=1
	addi $t6, $t6, 1
	
	# print a space
	la    	$a0,   space
	li    	$v0,  4
	sysCall
	
	# print the counter
	move $a0, $s7
	li $v0, 1
	sysCall
	
	# print label Rem >=0, q0=1
	la    	$a0,   STEPE
	li    	$v0,  4
	sysCall
	
	# print the divisor
	move $a2, $s0
	move $a0, $t1
  	jal display.bitsDiv
  	
  	# print the remainder/ quotient
  	move $a2, $s1
  	move $a0, $t6
  	jal display.bitsDiv
  	
  	la    	$a0,   newline
	li    	$v0,  4
	sysCall
	
	la    	$a0,   newline
	li    	$v0,  4
	sysCall
	
	# decrement loop variable by 1
	addi $t7, $t7, -1
	
	# go back to the loop section
	j loop

# if the remainder is less than 0
LTZERO:
        # restore the remainder/quotient
	add $t6, $t6, $s4
	
	# print a space
	la    	$a0,   space
	li    	$v0,  4
	sysCall
	
	# print the counter
	move $a0, $s7
	li $v0, 1
	sysCall
	
	# print the label Rem<-, R+D, Q<<
	la    	$a0,   STEPD
	li    	$v0,  4
	sysCall
	
	# print the divisor
	move $a2, $s0
	move $a0, $t1
  	jal display.bitsDiv
  	
  	# print the Remainder/Quotient
  	move $a2, $s1
  	move $a0, $t6
  	jal display.bitsDiv
  	
  	la    	$a0,   newline
	li    	$v0,  4
	sysCall
	
	la    	$a0,   newline
	li    	$v0,  4
	sysCall
	
	# decrement the loop variable by 1
	addi $t7, $t7, -1
	
	# go back to the loop section
	j loop

# after the loop is completed
done:
        # print the result label
  	la    	$a0,   result
  	li    	$v0,  4
  	sysCall
  	
  	# shift the remainder/quotient by n bits to get the remainder
  	# store it in register s3
  	srlv $s3, $t6, $s0
  	
  	# print the remainder label
  	la    	$a0,   REMAINDER
  	li    	$v0,  4
  	sysCall
  	
  	# print the new remainder
  	move  	$a0,   $s3
  	li    	$v0,  1
  	sysCall
  	
  	#Algorithm to get the quotient
  	# extracts the right most n bits of a integer
  	
  	li $s6, 1
  	
  	sllv $s5, $s6, $s0
  	addi $s5, $s5, -1
  	
  	and $s2, $t6,$s5
  	
  	# print the quotient label
  	la    	$a0,   QUOTIENT
  	li    	$v0,  4
  	sysCall
  	
  	# the new quotient
  	move  	$a0,   $s2
  	li    	$v0,  1
  	sysCall
  	
  	# print a new line
  	la    	$a0,   newline
  	li    	$v0,  4
  	sysCall
  	
  	
# Used these last 3 lines of code from ex 3.12
RETURN:
	lw		$ra,	($sp)   		# 
	addi	$sp,	$sp,	4   # 
	jr	$ra
