.text
TEST3:									# 

	 li		$a0, 	60        # A: 
	 li		$a1, 	17        # B:
	 li		$a2, 	6     # n: number of bits 
   jal 	ex.3.18

	 li		$a0,    12       # A: 12 
	 li		$a1,    5       # B: 5
	 li		$a2,    4         # n: number of bits 
   jal 	ex.3.18


TEST4:									# 

	 li		$a0, 	60    	# A: 
	 li		$a1, 	17      # B: 
	 li		$a2, 	6         # n: number of bits 
   jal 	ex.3.19

	 li		$a0, 	12    # A: 
	 li		$a1, 	5      # B:
	 li		$a2, 	4         # n: number of bits 
   jal 	ex.3.19


exit:
	li	$v0, 10
	syscall


