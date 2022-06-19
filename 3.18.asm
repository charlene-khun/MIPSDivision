
.data
    #labels for display at the end:
    result:  .asciiz " Result A\B by iterative subtraction --> "
    prompt:  .asciiz "Enter a number: "
    newline: .asciiz	 "\n"
    space: .asciiz " "
    QUOTIENT: .asciiz ", Quotient = "
    REMAINDER: .asciiz "Remainder = "
    
    #labels for the top of the table:
    STEP: .asciiz " Step "
    ACTION: .asciiz "  Action       "
    QUOTIENTLABEL: .asciiz "   Quotient "
    REMAINDERLABEL: .asciiz "     Remainder "
    DIVISORLABEL: .asciiz "   Divisor      "
    
    #labels for each intermediate step
    STEPA: .asciiz "      Initial Vals    " 
    STEPB: .asciiz "      Rem=Rem-Div     "
    STEPC: .asciiz "      Rem<0,R+D,Q<<   " 
    STEPD: .asciiz "      Rem>=0,Q<<,q0=1 "
    STEPE: .asciiz "      Rshift Div      "
    
 
.text
.globl ex.3.18

ex.3.18:	
        # these two lines of code are from ex 3.12
	addi	$sp,	$sp,	-4   # xxx 
	sw		$ra,	($sp)   # xxx
	
	#  A = Remainder, and store in register t0
  	move 	$t0, 	$a0
  	
  	#  B = Divisor, which is stored in register t1    
  	move 	$t1, 	$a1
  	
  	#  N = number of bits for display, assume N <= 16, stored in register t7    
  	move 	$t7,	$a2    
  	
  	# quotient is initialized and stored in register t6
	li		$t6, 	0 
	
	# store the original number of bits in register s1
	move $s1, $t7
	
	# store double the number of bits in register s2
	add $s2, $t7, $t7
	
	# shift the divisor left by n bits 
	sllv $t1, $t1, $s1
	
	# add one to the number of bits because
	# the sample output wants n+1 iterations
	addi $t7, $t7, 1
	
	#counter
	li $s3, 0 
	
	# call the displayDiv.asm
	jal displayDIV
	
	# Print out the top part of the table
	la $a0,  STEP
  	li    	$v0,  4
  	sysCall
  	
  	la $a0,  ACTION
  	li    	$v0,  4
  	sysCall
  	
  	la $a0,  QUOTIENTLABEL
  	li    	$v0,  4
  	sysCall
  	
  	la $a0,  DIVISORLABEL
  	li    	$v0,  4
  	sysCall
  	
  	la $a0,  REMAINDERLABEL
  	li    	$v0,  4
  	sysCall
  	
  	# print out a new line
  	la $a0,  newline
  	li    	$v0,  4
  	sysCall
  	
  	# print out a space
  	la $a0,  space
  	li    	$v0,  4
  	sysCall
  	
  	# print out the counter
  	move $a0, $s3
  	li $v0, 1
  	sysCall
  	
  	# print out the Initial vals step
	la $a0,  STEPA
  	li    	$v0,  4
  	sysCall
  	
  	#Display the quotient
	move $a0, $t6
	jal display.bitsDiv
	
	#Display the divisor
	move $a2, $s2
	move $a0, $t1
	jal display.bitsDiv
	
	#Display the remainder
	move $a0, $t0
	jal display.bitsDiv
	
	la $a0,  newline
  	li    	$v0,  4
  	sysCall
  	
  	la $a0,  newline
  	li    	$v0,  4
  	sysCall

loop:
        #  if $t7== 0 quit loop 
	beq	$t7, $0,  done	
	
	#print out a space
	la $a0,  space
  	li    	$v0,  4
  	sysCall
  	
  	# increment the counter by one
	addi $s3, $s3, 1
	
	# print out the counter
	move $a0, $s3
	li $v0, 1
	sysCall
	
	# Rem = Rem - Div
	subu $t0, $t0, $t1
	
	# print out the label for Rem = Rem - Div
	la $a0,  STEPB
  	li    	$v0,  4
  	sysCall
	
	# print out quotient, divisor, and remainder
	move $a2, $s1
	move $a0, $t6
	jal display.bitsDiv
	
	move $a2, $s2
	move $a0, $t1
	jal display.bitsDiv
	
	move $a0, $t0
	jal display.bitsDiv
	
	la $a0,  newline
  	li    	$v0,  4
  	sysCall
  	
  	# check if remainder is less than 0
  	# 1 if it's less than, 0 if greater than
	slti	$t4, $t0, 0
	
	# decrement loop variable by 1
	addi  	$t7, $t7,  -1
	
	#  if t4 == 1, then jump to ZERO (Remainder < 0)
	beq	$t4, 1,  ZERO 
	
	# Don't need this statement -> beq $t4, 0, NOTZERO

# if Remainder is greater than or equal to 0	
NOTZERO: 
        # shift the quotient to the left by 1
	sll  $t6, $t6, 1
	
	# add 1 to the quotient after shifting  Step: q0=1
	addi $t6, $t6, 1 
	
	la $a0,  space
  	li    	$v0,  4
  	sysCall
  	
  	# print the counter
	move $a0, $s3
	li $v0, 1
	sysCall
	
	# Print Rem >=0, Q<<, q0 = 1
	la $a0,  STEPD
  	li    	$v0,  4
  	sysCall
  	
  	# print out the quotient
	move $a2, $s1
	move $a0, $t6
	jal display.bitsDiv
	
	# print the divisor
	move $a2, $s2
	move $a0, $t1
	jal display.bitsDiv
	
	# print the remainder
	move $a0, $t0
	jal display.bitsDiv
	
	la $a0,  newline
  	li    	$v0,  4
  	sysCall
	
	# Rshift Divisor by 1
	srl $t1, $t1, 1
	
	la $a0,  space
  	li    	$v0,  4
  	sysCall
  	
  	# print the counter
	move $a0, $s3
	li $v0, 1
	sysCall
	
	# print the label that corresponds with Rshift Div
	la $a0,  STEPE
  	li    	$v0,  4
  	sysCall
	
	# print the quotient
	move $a2, $s1
	move $a0, $t6
	jal display.bitsDiv
	
	# print the divisor
	move $a2, $s2
	move $a0, $t1
	jal display.bitsDiv
	
	# print the remainder
	move $a0, $t0
	jal display.bitsDiv
	
	la $a0,  newline
  	li    	$v0,  4
  	sysCall
  	
  	la $a0,  newline
  	li    	$v0,  4
  	sysCall
	
	# jump back to the loop section
	j loop 

# if Remainder is less than 0
ZERO:	
        #restore the original value of the remainder
        add $t0, $t0, $t1
        
        #shift the quotient left by 1
	sll $t6, $t6, 1
	
	la $a0,  space
  	li    	$v0,  4
  	sysCall
  	
  	# print out counter
	move $a0, $s3
	li $v0, 1
	sysCall
	
	# print Rem < 0, R+D, Q<< label
	la $a0,  STEPC
  	li  $v0,  4
  	sysCall
  	
  	# print the quotient
	move $a2, $s1
	move $a0, $t6
	jal display.bitsDiv
	
	# print the divisor 
	move $a2, $s2
	move $a0, $t1
	jal display.bitsDiv
	
	# print the remainder
	move $a0, $t0
	jal display.bitsDiv
	
	la $a0,  newline
  	li    	$v0,  4
  	sysCall
  	
  	#Rshift the Divisor
	srl  $t1, $t1, 1
	
	la $a0,  space
  	li    	$v0,  4
  	sysCall
  	
  	# print counter
	move $a0, $s3
	li $v0, 1
	sysCall
	
	# print Rshift Div label
	la $a0,  STEPE
  	li  $v0,  4
  	sysCall
  	
  	# print quotient
	move $a2, $s1
	move $a0, $t6
	jal display.bitsDiv
	
	# print divisor
	move $a2, $s2
	move $a0, $t1
	jal display.bitsDiv
	
	# print remainder
	move $a0, $t0
	jal display.bitsDiv
	
	la $a0,  newline
  	li    	$v0,  4
  	sysCall
  	
  	la $a0,  newline
  	li    	$v0,  4
  	sysCall
  	
  	# jump back to the loop section
	j loop

# after the loop is finished
done:
        # print out the result label
  	la  $a0, result
  	li    	$v0,  4
  	sysCall
  	
  	# print out the remainder label
  	la $a0, REMAINDER
  	li    	$v0,  4
  	sysCall
  	
  	# print the remainder
  	move  	$a0,   $t0
  	li    	$v0,  1
  	sysCall
  	
  	# print the quotient label
  	la $a0,  QUOTIENT
  	li    	$v0,  4
  	sysCall
  	
  	# print the quotient
  	move  	$a0,   $t6
  	li    	$v0,  1
  	sysCall
  	
  	la    	$a0,   newline
  	li    	$v0,  4
  	sysCall

# Used these last 3 lines of code from ex 3.12
RETURN:
	lw		$ra,	($sp)   		#
	addi	$sp,	$sp,	4   # 
	jr	$ra
	
