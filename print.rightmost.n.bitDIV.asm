######################################################################
# The codes provided here are meant to be used as a start program. 
# You do not have to use any codes here.
######################################################################

.data
	SEPARATOR:  .asciiz 	"      "
.text
.globl display.bitsDiv

#########################################################################
# display the rightmost n bits of the number x in a0, where n is     	#
# specified in $a2     													#
#########################################################################
display.bitsDiv:     
    addi  $sp,	$sp,  -12
    sw    $ra,  ($sp)
    sw    $t2,  4($sp)
    sw    $t3, 	8($sp)

    li    $t2,  32
    sub   $t2,  $t2,    $a2       # t2 = 32 - n
    sllv  $t3,  $a0,    $t2       # t3 = x << (32-n)

    move  $t2,  $a2               # xxx t2 = n
L1:
    move  $a0,  $t3               #   a0 = t3
    srl   $a0,  $t3,    31        #   a0 = t3 >> 31
    li    $v0,	1               #   print MSB as an integer
    sysCall

    sll   $t3,  $t3,    1         #   t3 = x << 1
    addi  $t2,  $t2,    -1        #   n--
    beq   $t2,  $0,     return    #
    j     L1
return:
    la    $a0,  SEPARATOR
    li    $v0,  4
    sysCall

  	lw    $ra,  ($sp)
    lw    $t2,  4($sp)
    lw    $t3, 	8($sp)
  	addi  $sp,  $sp,   12

    jr    $ra

