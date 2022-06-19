# The codes below are provided as a starter 
# You revise the codes as you wish`

.globl     displayDIV

.data
	LINE:			.asciiz				"\n************************************************************\n"
	A.SPACE: 		.asciiz				  "  A="
	B.SPACE: 		.asciiz				  "  B="
	N.SPACE: 		.asciiz				  "  N="
	
.text
displayDIV:
    addi  $sp,  $sp,  -16
    sw    $a0,  ($sp) 				# A saved in Stack
    sw    $a1,  4($sp) 				# B saved in Stack
    sw    $a2,  8($sp) 				# N saved in Stack
    sw    $ra,  12($sp)

    la    $a0,   LINE
    li    $v0,  4
    sysCall

    la    $a0,  A.SPACE	# print "A=" 
    li    $v0,  4
    sysCall

	lw    $a0,	($sp)   # correction here: it was  lw    $a0,  -16($sp)
    li    $v0,  1
    sysCall

    la    $a0,  B.SPACE	# print "B="
    li    $v0,  4
    sysCall

	move  $a0,	$a1
    li    $v0,  1
    sysCall

    la    $a0,  N.SPACE	# prit "N="   
    li    $v0,  4
    sysCall

	move  $a0,	$a2
    li    $v0,  1
    sysCall

    la    $a0,   LINE
    li    $v0,  4
    sysCall

    lw    $a0,  ($sp)		# retrieve value of $a0
    lw    $a1,  4($sp)		# retrieve value of $a1
    lw    $a2,  8($sp)		# retrieve value of $a2
    lw    $ra,  12($sp)		# retrieve value of $ra
    addi  $sp,  $sp,  +16   # deallocate the memory space of the stack.

	jr		$ra

