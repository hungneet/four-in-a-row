.data
  rowlist: .asciiz    "  1   2   3   4   5   6   7  "
	row5: .asciiz "\n|   |   |   |   |   |   |   |\n"
	row4: .asciiz "\n|   |   |   |   |   |   |   |\n"
	row3: .asciiz "\n|   |   |   |   |   |   |   |\n"
	row2: .asciiz "\n|   |   |   |   |   |   |   |\n"
	row1: .asciiz "\n|   |   |   |   |   |   |   |\n"
	row0: .asciiz "\n|   |   |   |   |   |   |   |\n"
	floor :.asciiz "-----------------------------"
	enter: .asciiz "\n"
	empty: .byte ' '
	markX: .byte 'X'
	markO: .byte 'O'
	prompt0: .asciiz "\n==================================================================\nWelcom to Four in a Row!!!\n Do you want to read the game rules?!\n [0]: Read the rules \t [Any_num]: Play now\n"
	rules: 	 .asciiz "Four in a Row is the classic two player game where you take turns to place a counter in an upright grid\nand try to beat your opponent by placing 4 counters vertically, horizontally or diagonally in a row.\nIn this game the starting player will be choose randomly.\n\n"
	startP:  .asciiz "The starting will be Player "
	XorO:	 .asciiz "Please select your piece (X or O):\n [0]: X\t [Any_num]:O\n"
	prompt1: .asciiz "\nPlayer 1 turn: "
	prompt2: .asciiz "\nPlayer 2 turn: "
	prompt3: .asciiz "\nInvalid move! Retry\n"
	prompt4: .asciiz "\n This column is full, try another one\n"
	prompt5: .asciiz "\nGame end. Tie!"
	prompt6: .asciiz "\nGame end. The winner is Player "
	prompt7: .asciiz "\nGame end due to the a player making 3 inappropriate move.\n"
	prompt8: .asciiz "Do you to Undo your move:\n [0]:Yes\t [Any_num]:No\n"
.text
	main:
		la $s0, 0 #s0 count turns
		
		la $s4, 3	#s4,s5 hold inappropriate moves
		la $s5, 3
		
		la $s6,3	#s6,s7 hold undo turns
		la $s7, 3
		
		li $v0, 4
		la $a0, prompt0
		syscall
	#readrules:	
		li $v0 , 5
		syscall
		move $a0, $v0	
		bne $a0, 0, rand
		li $v0, 4
		la $a0, rules
		syscall	
		
	rand:
		li $a1, 10  
    		li $v0, 42 
    		syscall
    		addi $a0, $a0, 0
    		slti $a1, $a0, 5
    		li $v0, 4
		la $a0, startP
		syscall 
		addi $a0, $a1, 1
		li $v0, 1
		syscall
		
		li $v0, 4
		la $a0, enter
		syscall
		
		addi $a1, $a1, 1  #a1 remember who go first
	#chooseXO
		li $v0, 4
		la $a0, XorO
		syscall
		
		li $v0 , 5
		syscall
		move $a0, $v0
		move $t6, $a0	#t6 remember XorO
	drawboard: #============================DRAWBOARD=========================
		#t0,t1,t2,t3,t4,t5 hold rows
		la $t5, row5
		la $t4, row4
		la $t3, row3
		la $t2, row2
		la $t1, row1
		la $t0, row0
		
		la $a0 ,rowlist
		li $v0, 4
		syscall
		
		move $a0, $t5
		li $v0, 4
		syscall
		la $a0, floor
		li $v0, 4
		syscall
		
		move $a0, $t4
		li $v0, 4
		syscall
		la $a0, floor
		li $v0, 4
		syscall
		
		move $a0, $t3
		li $v0, 4
		syscall
		la $a0, floor
		li $v0, 4
		syscall
		
		move $a0, $t2
		li $v0, 4
		syscall
		la $a0, floor
		li $v0, 4
		syscall
		
		move $a0, $t1
		li $v0, 4
		syscall
		la $a0, floor
		li $v0, 4
		syscall
		
		move $a0, $t0
		li $v0, 4
		syscall
		la $a0, floor
		li $v0, 4
		syscall
	#checkwin
		j checkWin
		notWin:
	#checktie:
		beq $s0,42,gameTie
	decideturn:
		
		rem $t9, $a1, 2
		beq $t9, 0, StartP2
		#StartP1
		bne $t6,0, P1O
		#P1X
		li $v0, 4
		la $a0, prompt1
		syscall
		li $v0 , 5
		syscall
		move $a0, $v0
		move $a2, $a0
		bne $s0,0, notfirst
			#only load s1,s2 in the first turn
			lb $s1, markX	#s1,s2 hold p1,p2 mark
			lb $s2, markO	
			addi $s0, $s0,1
			j mark
		P1O:
		li $v0, 4
		la $a0, prompt1
		syscall
		li $v0 , 5
		syscall
		move $a0, $v0
		move $a2, $a0
		bne $s0,0, notfirst
			lb $s1, markO
			lb $s2, markX
			addi $s0, $s0,1
			j mark
		StartP2:
		bne $t6,0, P2O
		#P2X
		li $v0, 4
		la $a0, prompt2
		syscall
		li $v0 , 5
		syscall
		move $a0, $v0
		move $a2, $a0
		bne $s0,0, notfirst
			lb $s2, markX
			lb $s1, markO
			addi $s0, $s0,1
			j mark
		P2O:
		li $v0, 4
		la $a0, prompt2
		syscall
		li $v0 , 5
		syscall
		move $a0, $v0
		move $a2, $a0
		bne $s0,0, notfirst
			lb $s2, markO
			lb $s1, markX
			addi $s0, $s0,1
			j mark
			
		notfirst: 
			addi $s0, $s0,1
			j mark
	mark:	#============================MARKING===============================
		rem $t9, $a1, 2
		j Undo
		notUndo:
		beq $t9, $zero, P2_loadMark
		#P1_loadMark
		move $t7, $s1
		j marking
		P2_loadMark:
		move $t7, $s2
		marking:
		beq $a2, 1, col1
		beq $a2, 2, col2
		beq $a2, 3, col3
		beq $a2, 4, col4		
		beq $a2, 5, col5
		beq $a2, 6, col6
		beq $a2, 7, col7
		j Invalid
		col1:
			lb $t9, empty
			lb $t8, 3($t0)
			bne $t9, $t8, next11
			sb $t7, 3($t0)
			addi $a1,$a1,1
			j drawboard
			next11:
			lb $t9, empty
			lb $t8, 3($t1)
			bne $t9, $t8, next12
			sb $t7, 3($t1)
			addi $a1,$a1,1
			j drawboard
			next12:
			lb $t9, empty
			lb $t8, 3($t2)
			bne $t9, $t8, next13
			sb $t7, 3($t2)
			addi $a1,$a1,1
			j drawboard
			next13:
			lb $t9, empty
			lb $t8, 3($t3)
			bne $t9, $t8, next14
			sb $t7, 3($t3)
			addi $a1,$a1,1
			j drawboard
			next14:
			lb $t9, empty
			lb $t8, 3($t4)
			bne $t9, $t8, next15
			sb $t7, 3($t4)
			addi $a1,$a1,1
			j drawboard
			next15:
			lb $t9, empty
			lb $t8, 3($t5)
			bne $t9, $t8, Full
			sb $t7, 3($t5)
			addi $a1,$a1,1
			j drawboard
		col2:
			lb $t9, empty
			lb $t8, 7($t0)
			bne $t9, $t8, next21
			sb $t7, 7($t0)
			addi $a1,$a1,1
			j drawboard
			next21:
			lb $t9, empty
			lb $t8, 7($t1)
			bne $t9, $t8, next22
			sb $t7, 7($t1)
			addi $a1,$a1,1
			j drawboard
			next22:
			lb $t9, empty
			lb $t8, 7($t2)
			bne $t9, $t8, next23
			sb $t7, 7($t2)
			addi $a1,$a1,1
			j drawboard
			next23:
			lb $t9, empty
			lb $t8, 7($t3)
			bne $t9, $t8, next24
			sb $t7, 7($t3)
			addi $a1,$a1,1
			j drawboard
			next24:
			lb $t9, empty
			lb $t8, 7($t4)
			bne $t9, $t8, next25
			sb $t7, 7($t4)
			addi $a1,$a1,1
			j drawboard
			next25:
			lb $t9, empty
			lb $t8, 7($t5)
			bne $t9, $t8, Full
			sb $t7, 7($t5)
			addi $a1,$a1,1
			j drawboard
		col3:
			#0_1
			lb $t9, empty
			lb $t8, 11($t0)
			bne $t9, $t8, next31
			sb $t7, 11($t0)
			addi $a1,$a1,1
			j drawboard
			next31:
			lb $t9, empty
			lb $t8, 11($t1)
			bne $t9, $t8, next32
			sb $t7, 11($t1)
			addi $a1,$a1,1
			j drawboard
			next32:
			lb $t9, empty
			lb $t8, 11($t2)
			bne $t9, $t8, next33
			sb $t7, 11($t2)
			addi $a1,$a1,1
			j drawboard
			next33:
			lb $t9, empty
			lb $t8, 11($t3)
			bne $t9, $t8, next34
			sb $t7, 11($t3)
			addi $a1,$a1,1
			j drawboard
			next34:
			lb $t9, empty
			lb $t8, 11($t4)
			bne $t9, $t8, next35
			sb $t7, 11($t4)
			addi $a1,$a1,1
			j drawboard
			next35:
			lb $t9, empty
			lb $t8, 11($t5)
			bne $t9, $t8, Full
			sb $t7, 11($t5)
			addi $a1,$a1,1
			j drawboard
		col4:
			lb $t9, empty
			lb $t8, 15($t0)
			bne $t9, $t8, next41
			sb $t7, 15($t0)
			addi $a1,$a1,1
			j drawboard
			next41:
			lb $t9, empty
			lb $t8, 15($t1)
			bne $t9, $t8, next42
			sb $t7, 15($t1)
			addi $a1,$a1,1
			j drawboard
			next42:
			lb $t9, empty
			lb $t8, 15($t2)
			bne $t9, $t8, next43
			sb $t7, 15($t2)
			addi $a1,$a1,1
			j drawboard
			next43:
			lb $t9, empty
			lb $t8, 15($t3)
			bne $t9, $t8, next44
			sb $t7, 15($t3)
			addi $a1,$a1,1
			j drawboard
			next44:
			lb $t9, empty
			lb $t8, 15($t4)
			bne $t9, $t8, next45
			sb $t7, 15($t4)
			addi $a1,$a1,1
			j drawboard
			next45:
			lb $t9, empty
			lb $t8, 15($t5)
			bne $t9, $t8, Full
			sb $t7, 15($t5)
			addi $a1,$a1,1
			j drawboard
		col5:
			lb $t9, empty
			lb $t8, 19($t0)
			bne $t9, $t8, next51
			sb $t7, 19($t0)
			addi $a1,$a1,1
			j drawboard
			next51:
			lb $t9, empty
			lb $t8, 19($t1)
			bne $t9, $t8, next52
			sb $t7, 19($t1)
			addi $a1,$a1,1
			j drawboard
			next52:
			lb $t9, empty
			lb $t8, 19($t2)
			bne $t9, $t8, next53
			sb $t7, 19($t2)
			addi $a1,$a1,1
			j drawboard
			next53:
			lb $t9, empty
			lb $t8, 19($t3)
			bne $t9, $t8, next54
			sb $t7, 19($t3)
			addi $a1,$a1,1
			j drawboard
			next54:
			lb $t9, empty
			lb $t8, 19($t4)
			bne $t9, $t8, next55
			sb $t7, 19($t4)
			addi $a1,$a1,1
			j drawboard
			next55:
			lb $t9, empty
			lb $t8, 19($t5)
			bne $t9, $t8, Full
			sb $t7, 19($t5)
			addi $a1,$a1,1
			j drawboard
		col6:
			lb $t9, empty
			lb $t8, 23($t0)
			bne $t9, $t8, next61
			sb $t7, 23($t0)
			addi $a1,$a1,1
			j drawboard
			next61:
			lb $t9, empty
			lb $t8, 23($t1)
			bne $t9, $t8, next62
			sb $t7, 23($t1)
			addi $a1,$a1,1
			j drawboard
			next62:
			lb $t9, empty
			lb $t8, 23($t2)
			bne $t9, $t8, next63
			sb $t7, 23($t2)
			addi $a1,$a1,1
			j drawboard
			next63:
			lb $t9, empty
			lb $t8, 23($t3)
			bne $t9, $t8, next64
			sb $t7, 23($t3)
			addi $a1,$a1,1
			j drawboard
			next64:
			lb $t9, empty
			lb $t8, 23($t4)
			bne $t9, $t8, next65
			sb $t7, 23($t4)
			addi $a1,$a1,1
			j drawboard
			next65:
			lb $t9, empty
			lb $t8, 23($t5)
			bne $t9, $t8, Full
			sb $t7, 23($t5)
			addi $a1,$a1,1
			j drawboard
		col7:
			lb $t9, empty
			lb $t8, 27($t0)
			bne $t9, $t8, next71
			sb $t7, 27($t0)
			addi $a1,$a1,1
			j drawboard
			next71:
			lb $t9, empty
			lb $t8, 27($t1)
			bne $t9, $t8, next72
			sb $t7, 27($t1)
			addi $a1,$a1,1
			j drawboard
			next72:
			lb $t9, empty
			lb $t8, 27($t2)
			bne $t9, $t8, next73
			sb $t7, 27($t2)
			addi $a1,$a1,1
			j drawboard
			next73:
			lb $t9, empty
			lb $t8, 27($t3)
			bne $t9, $t8, next74
			sb $t7, 27($t3)
			addi $a1,$a1,1
			j drawboard
			next74:
			lb $t9, empty
			lb $t8, 27($t4)
			bne $t9, $t8, next75
			sb $t7, 27($t4)
			addi $a1,$a1,1
			j drawboard
			next75:
			lb $t9, empty
			lb $t8, 27($t5)
			bne $t9, $t8, Full
			sb $t7, 27($t5)
			addi $a1,$a1,1
			j drawboard
			
#==================================================CHECK WIN==================================	
	checkWin:
	#-------------------HORIZONTAL CHECK-----------------------
		#Row_0:
		#c0_1234
		lb $s3, 3($t0)
	 	lb $t9, empty
	 	beq $t9, $s3, c0_2345
	 	lb $t9, 7($t0)
	 	bne $t9, $s3, c0_2345
	 	lb $t9, 11($t0)
	 	bne $t9, $s3, c0_2345
	 	lb $t9, 15($t0)
	 	bne $t9, $s3, c0_2345
	 	j gameWin
	 	c0_2345:
	 	lb $s3, 7($t0)
	 	lb $t9, empty
	 	beq $t9, $s3, c0_3456
	 	lb $t9, 11($t0)
	 	bne $t9, $s3, c0_3456
	 	lb $t9, 15($t0)
	 	bne $t9, $s3, c0_3456
	 	lb $t9, 19($t0)
	 	bne $t9, $s3, c0_3456
	 	j gameWin
	 	c0_3456:
	 	lb $s3, 11($t0)
	 	lb $t9, empty
	 	beq $t9, $s3, c0_4567
	 	lb $t9, 15($t0)
	 	bne $t9, $s3, c0_4567
	 	lb $t9, 19($t0)
	 	bne $t9, $s3, c0_4567
	 	lb $t9, 23($t0)
	 	bne $t9, $s3, c0_4567
	 	j gameWin
	 	c0_4567:
	 	lb $s3, 15($t0)
	 	lb $t9, empty
	 	beq $t9, $s3, c1_1234
	 	lb $t9, 19($t0)
	 	bne $t9, $s3, c1_1234
	 	lb $t9, 23($t0)
	 	bne $t9, $s3, c1_1234
	 	lb $t9, 27($t0)
	 	bne $t9, $s3, c1_1234
	 	j gameWin
	 	#Row1:
	 	c1_1234:
	 	lb $s3, 3($t1)
	 	lb $t9, empty
	 	beq $t9, $s3, c1_2345
	 	lb $t9, 7($t1)
	 	bne $t9, $s3, c1_2345
	 	lb $t9, 11($t1)
	 	bne $t9, $s3, c1_2345
	 	lb $t9, 15($t1)
	 	bne $t9, $s3, c1_2345
	 	j gameWin
	 	c1_2345:
	 	lb $s3, 7($t1)
	 	lb $t9, empty
	 	beq $t9, $s3, c1_3456
	 	lb $t9, 11($t1)
	 	bne $t9, $s3, c1_3456
	 	lb $t9, 15($t1)
	 	bne $t9, $s3, c1_3456
	 	lb $t9, 19($t1)
	 	bne $t9, $s3, c1_3456
	 	j gameWin
	 	c1_3456:
	 	lb $s3, 11($t1)
	 	lb $t9, empty
	 	beq $t9, $s3, c1_4567
	 	lb $t9, 15($t1)
	 	bne $t9, $s3, c1_4567
	 	lb $t9, 19($t1)
	 	bne $t9, $s3, c1_4567
	 	lb $t9, 23($t1)
	 	bne $t9, $s3, c1_4567
	 	j gameWin
	 	c1_4567:
	 	lb $s3, 15($t1)
	 	lb $t9, empty
	 	beq $t9, $s3, c2_1234
	 	lb $t9, 19($t1)
	 	bne $t9, $s3, c2_1234
	 	lb $t9, 23($t1)
	 	bne $t9, $s3, c2_1234
	 	lb $t9, 27($t1)
	 	bne $t9, $s3, c2_1234
	 	#Row2:
	 	c2_1234:
	 	lb $s3, 3($t2)
	 	lb $t9, empty
	 	beq $t9, $s3, c2_2345
	 	lb $t9, 7($t2)
	 	bne $t9, $s3, c2_2345
	 	lb $t9, 11($t2)
	 	bne $t9, $s3, c2_2345
	 	lb $t9, 15($t2)
	 	bne $t9, $s3, c2_2345
	 	j gameWin
	 	c2_2345:
	 	lb $s3, 7($t2)
	 	lb $t9, empty
	 	beq $t9, $s3, c2_3456
	 	lb $t9, 11($t2)
	 	bne $t9, $s3, c2_3456
	 	lb $t9, 15($t2)
	 	bne $t9, $s3, c2_3456
	 	lb $t9, 19($t2)
	 	bne $t9, $s3, c2_3456
	 	j gameWin
	 	c2_3456:
	 	lb $s3, 11($t2)
	 	lb $t9, empty
	 	beq $t9, $s3, c2_4567
	 	lb $t9, 15($t2)
	 	bne $t9, $s3, c2_4567
	 	lb $t9, 19($t2)
	 	bne $t9, $s3, c2_4567
	 	lb $t9, 23($t2)
	 	bne $t9, $s3, c2_4567
	 	j gameWin
	 	c2_4567:
	 	lb $s3, 15($t2)
	 	lb $t9, empty
	 	beq $t9, $s3, c3_1234
	 	lb $t9, 19($t2)
	 	bne $t9, $s3, c3_1234
	 	lb $t9, 23($t2)
	 	bne $t9, $s3, c3_1234
	 	lb $t9, 27($t2)
	 	bne $t9, $s3, c3_1234
	 	#Row3:
	 	c3_1234:
	 	lb $s3, 3($t3)
	 	lb $t9, empty
	 	beq $t9, $s3, c3_2345
	 	lb $t9, 7($t3)
	 	bne $t9, $s3, c3_2345
	 	lb $t9, 11($t3)
	 	bne $t9, $s3, c3_2345
	 	lb $t9, 15($t3)
	 	bne $t9, $s3, c3_2345
	 	j gameWin
	 	c3_2345:
	 	lb $s3, 7($t3)
	 	lb $t9, empty
	 	beq $t9, $s3, c3_3456
	 	lb $t9, 11($t3)
	 	bne $t9, $s3, c3_3456
	 	lb $t9, 15($t3)
	 	bne $t9, $s3, c3_3456
	 	lb $t9, 19($t3)
	 	bne $t9, $s3, c3_3456
	 	j gameWin
	 	c3_3456:
	 	lb $s3, 11($t3)
	 	lb $t9, empty
	 	beq $t9, $s3, c3_4567
	 	lb $t9, 15($t3)
	 	bne $t9, $s3, c3_4567
	 	lb $t9, 19($t3)
	 	bne $t9, $s3, c3_4567
	 	lb $t9, 23($t3)
	 	bne $t9, $s3, c3_4567
	 	j gameWin
	 	c3_4567:
	 	lb $s3, 15($t3)
	 	lb $t9, empty
	 	beq $t9, $s3, c4_1234
	 	lb $t9, 19($t3)
	 	bne $t9, $s3, c4_1234
	 	lb $t9, 23($t3)
	 	bne $t9, $s3, c4_1234
	 	lb $t9, 27($t3)
	 	bne $t9, $s3, c4_1234
	 	#Row4:
	 	c4_1234:
	 	lb $s3, 3($t4)
	 	lb $t9, empty
	 	beq $t9, $s3, c4_2345
	 	lb $t9, 7($t4)
	 	bne $t9, $s3, c4_2345
	 	lb $t9, 11($t4)
	 	bne $t9, $s3, c4_2345
	 	lb $t9, 15($t4)
	 	bne $t9, $s3, c4_2345
	 	j gameWin
	 	c4_2345:
	 	lb $s3, 7($t4)
	 	lb $t9, empty
	 	beq $t9, $s3, c4_3456
	 	lb $t9, 11($t4)
	 	bne $t9, $s3, c4_3456
	 	lb $t9, 15($t4)
	 	bne $t9, $s3, c4_3456
	 	lb $t9, 19($t4)
	 	bne $t9, $s3, c4_3456
	 	j gameWin
	 	c4_3456:
	 	lb $s3, 11($t4)
	 	lb $t9, empty
	 	beq $t9, $s3, c4_4567
	 	lb $t9, 15($t4)
	 	bne $t9, $s3, c4_4567
	 	lb $t9, 19($t4)
	 	bne $t9, $s3, c4_4567
	 	lb $t9, 23($t4)
	 	bne $t9, $s3, c4_4567
	 	j gameWin
	 	c4_4567:
	 	lb $s3, 15($t4)
	 	lb $t9, empty
	 	beq $t9, $s3, c5_1234
	 	lb $t9, 19($t4)
	 	bne $t9, $s3, c5_1234
	 	lb $t9, 23($t4)
	 	bne $t9, $s3, c5_1234
	 	lb $t9, 27($t4)
	 	bne $t9, $s3, c5_1234
	 	#Row5:
	 	c5_1234:
	 	lb $s3, 3($t5)
	 	lb $t9, empty
	 	beq $t9, $s3, c5_2345
	 	lb $t9, 7($t5)
	 	bne $t9, $s3, c5_2345
	 	lb $t9, 11($t5)
	 	bne $t9, $s3, c5_2345
	 	lb $t9, 15($t5)
	 	bne $t9, $s3, c5_2345
	 	j gameWin
	 	c5_2345:
	 	lb $s3, 7($t5)
	 	lb $t9, empty
	 	beq $t9, $s3, c5_3456
	 	lb $t9, 11($t5)
	 	bne $t9, $s3, c5_3456
	 	lb $t9, 15($t5)
	 	bne $t9, $s3, c5_3456
	 	lb $t9, 19($t5)
	 	bne $t9, $s3, c5_3456
	 	j gameWin
	 	c5_3456:
	 	lb $s3, 11($t5)
	 	lb $t9, empty
	 	beq $t9, $s3, c5_4567
	 	lb $t9, 15($t5)
	 	bne $t9, $s3, c5_4567
	 	lb $t9, 19($t5)
	 	bne $t9, $s3, c5_4567
	 	lb $t9, 23($t5)
	 	bne $t9, $s3, c5_4567
	 	j gameWin
	 	c5_4567:
	 	lb $s3, 15($t5)
	 	lb $t9, empty
	 	beq $t9, $s3, c0_1
	 	lb $t9, 19($t5)
	 	bne $t9, $s3, c0_1
	 	lb $t9, 23($t5)
	 	bne $t9, $s3, c0_1
	 	lb $t9, 27($t5)
	 	bne $t9, $s3, c0_1
	 	j gameWin
	 #----------------------------------VERTICAL CHECK--------------------
	 	#Col1
	 	c0_1:
	 	lb $s3, 3($t0)
	 	lb $t9, empty
	 	beq $t9, $s3, c1_1
	 	lb $t9, 3($t1)
	 	bne $t9, $s3, c1_1
	 	lb $t9, 3($t2)
	 	bne $t9, $s3, c1_1
	 	lb $t9, 3($t3)
	 	bne $t9, $s3, c1_1
	 	j gameWin
	 	c1_1:
	 	lb $s3, 3($t1)
	 	lb $t9, empty
	 	beq $t9, $s3, c2_1
	 	lb $t9, 3($t2)
	 	bne $t9, $s3, c2_1
	 	lb $t9, 3($t3)
	 	bne $t9, $s3, c2_1
	 	lb $t9, 3($t4)
	 	bne $t9, $s3, c2_1
	 	j gameWin
	 	c2_1:
	 	lb $s3, 3($t2)
	 	lb $t9, empty
	 	beq $t9, $s3, c0_2
	 	lb $t9, 3($t3)
	 	bne $t9, $s3, c0_2
	 	lb $t9, 3($t4)
	 	bne $t9, $s3, c0_2
	 	lb $t9, 3($t5)
	 	bne $t9, $s3, c0_2
	 	j gameWin
	 	#Co2
	 	c0_2:
	 	lb $s3, 7($t0)
	 	lb $t9, empty
	 	beq $t9, $s3, c1_2
	 	lb $t9, 7($t1)
	 	bne $t9, $s3, c1_2
	 	lb $t9, 7($t2)
	 	bne $t9, $s3, c1_2
	 	lb $t9, 7($t3)
	 	bne $t9, $s3, c1_2
	 	j gameWin
	 	c1_2:
	 	lb $s3, 7($t1)
	 	lb $t9, empty
	 	beq $t9, $s3, c2_2
	 	lb $t9, 7($t2)
	 	bne $t9, $s3, c2_2
	 	lb $t9, 7($t3)
	 	bne $t9, $s3, c2_2
	 	lb $t9, 7($t4)
	 	bne $t9, $s3, c2_2
	 	j gameWin
	 	c2_2:
	 	lb $s3, 7($t2)
	 	lb $t9, empty
	 	beq $t9, $s3, c0_3
	 	lb $t9, 7($t3)
	 	bne $t9, $s3, c0_3
	 	lb $t9, 7($t4)
	 	bne $t9, $s3, c0_3
	 	lb $t9, 7($t5)
	 	bne $t9, $s3, c0_3
	 	j gameWin
	 	#Col3
	 	c0_3:
	 	lb $s3, 11($t0)
	 	lb $t9, empty
	 	beq $t9, $s3, c1_3
	 	lb $t9, 11($t1)
	 	bne $t9, $s3, c1_3
	 	lb $t9, 11($t2)
	 	bne $t9, $s3, c1_3
	 	lb $t9, 11($t3)
	 	bne $t9, $s3, c1_3
	 	j gameWin
	 	c1_3:
	 	lb $s3, 11($t1)
	 	lb $t9, empty
	 	beq $t9, $s3, c2_3
	 	lb $t9, 11($t2)
	 	bne $t9, $s3, c2_3
	 	lb $t9, 11($t3)
	 	bne $t9, $s3, c2_3
	 	lb $t9, 11($t4)
	 	bne $t9, $s3, c2_3
	 	j gameWin
	 	c2_3:
	 	lb $s3, 11($t2)
	 	lb $t9, empty
	 	beq $t9, $s3, c0_4
	 	lb $t9, 11($t3)
	 	bne $t9, $s3, c0_4
	 	lb $t9, 11($t4)
	 	bne $t9, $s3, c0_4
	 	lb $t9, 11($t5)
	 	bne $t9, $s3, c0_4
	 	j gameWin
	 	#Col4
	 	c0_4:
	 	lb $s3, 15($t0)
	 	lb $t9, empty
	 	beq $t9, $s3, c1_4
	 	lb $t9, 15($t1)
	 	bne $t9, $s3, c1_4
	 	lb $t9, 15($t2)
	 	bne $t9, $s3, c1_4
	 	lb $t9, 15($t3)
	 	bne $t9, $s3, c1_4
	 	j gameWin
	 	c1_4:
	 	lb $s3, 15($t1)
	 	lb $t9, empty
	 	beq $t9, $s3, c2_4
	 	lb $t9, 15($t2)
	 	bne $t9, $s3, c2_4
	 	lb $t9, 15($t3)
	 	bne $t9, $s3, c2_4
	 	lb $t9, 15($t4)
	 	bne $t9, $s3, c2_4
	 	j gameWin
	 	c2_4:
	 	lb $s3, 15($t2)
	 	lb $t9, empty
	 	beq $t9, $s3, c0_5
	 	lb $t9, 15($t3)
	 	bne $t9, $s3, c0_5
	 	lb $t9, 15($t4)
	 	bne $t9, $s3, c0_5
	 	lb $t9, 15($t5)
	 	bne $t9, $s3, c0_5
	 	j gameWin
	 	#Col5
	 	c0_5:
	 	lb $s3, 19($t0)
	 	lb $t9, empty
	 	beq $t9, $s3, c1_5
	 	lb $t9, 19($t1)
	 	bne $t9, $s3, c1_5
	 	lb $t9, 19($t2)
	 	bne $t9, $s3, c1_5
	 	lb $t9, 19($t3)
	 	bne $t9, $s3, c1_5
	 	j gameWin
	 	c1_5:
	 	lb $s3, 19($t1)
	 	lb $t9, empty
	 	beq $t9, $s3, c2_5
	 	lb $t9, 19($t2)
	 	bne $t9, $s3, c2_5
	 	lb $t9, 19($t3)
	 	bne $t9, $s3, c2_5
	 	lb $t9, 19($t4)
	 	bne $t9, $s3, c2_5
	 	j gameWin
	 	c2_5:
	 	lb $s3, 19($t2)
	 	lb $t9, empty
	 	beq $t9, $s3, c0_6
	 	lb $t9, 19($t3)
	 	bne $t9, $s3, c0_6
	 	lb $t9, 19($t4)
	 	bne $t9, $s3, c0_6
	 	lb $t9, 19($t5)
	 	bne $t9, $s3, c0_6
	 	j gameWin
	 	#Col6
	 	c0_6:
	 	lb $s3, 23($t0)
	 	lb $t9, empty
	 	beq $t9, $s3, c1_6
	 	lb $t9, 23($t1)
	 	bne $t9, $s3, c1_6
	 	lb $t9, 23($t2)
	 	bne $t9, $s3, c1_6
	 	lb $t9, 23($t3)
	 	bne $t9, $s3, c1_6
	 	j gameWin
	 	c1_6:
	 	lb $s3, 23($t1)
	 	lb $t9, empty
	 	beq $t9, $s3, c2_6
	 	lb $t9, 23($t2)
	 	bne $t9, $s3, c2_6
	 	lb $t9, 23($t3)
	 	bne $t9, $s3, c2_6
	 	lb $t9, 23($t4)
	 	bne $t9, $s3, c2_6
	 	j gameWin
	 	c2_6:
	 	lb $s3, 23($t2)
	 	lb $t9, empty
	 	beq $t9, $s3, c0_7
	 	lb $t9, 23($t3)
	 	bne $t9, $s3, c0_7
	 	lb $t9, 23($t4)
	 	bne $t9, $s3, c0_7
	 	lb $t9, 23($t5)
	 	bne $t9, $s3, c0_7
	 	j gameWin
	 	#Col7
	 	c0_7:
	 	lb $s3, 27($t0)
	 	lb $t9, empty
	 	beq $t9, $s3, c1_7
	 	lb $t9, 27($t1)
	 	bne $t9, $s3, c1_7
	 	lb $t9, 27($t2)
	 	bne $t9, $s3, c1_7
	 	lb $t9, 27($t3)
	 	bne $t9, $s3, c1_7
	 	j gameWin
	 	c1_7:
	 	lb $s3, 27($t1)
	 	lb $t9, empty
	 	beq $t9, $s3, c2_7
	 	lb $t9, 27($t2)
	 	bne $t9, $s3, c2_7
	 	lb $t9, 27($t3)
	 	bne $t9, $s3, c2_7
	 	lb $t9, 27($t4)
	 	bne $t9, $s3, c2_7
	 	j gameWin
	 	c2_7:
	 	lb $s3, 27($t2)
	 	lb $t9, empty
	 	beq $t9, $s3, lr01
	 	lb $t9, 27($t3)
	 	bne $t9, $s3, lr01
	 	lb $t9, 27($t4)
	 	bne $t9, $s3, lr01
	 	lb $t9, 27($t5)
	 	bne $t9, $s3, lr01
	 	j gameWin
	 #--------------------DIAGONTALLY CHECK----------------------
	 	#LefttoRight
	 	lr01:
	 	lb $s3, 3($t0)
	 	lb $t9, empty
	 	beq $t9, $s3, lr11
	 	lb $t9, 7($t1)
	 	bne $t9, $s3, lr11
	 	lb $t9, 11($t2)
	 	bne $t9, $s3, lr11
	 	lb $t9, 15($t3)
	 	bne $t9, $s3, lr11
	 	j gameWin
	 	lr11:
	 	lb $s3, 3($t1)
	 	lb $t9, empty
	 	beq $t9, $s3, lr21
	 	lb $t9, 7($t2)
	 	bne $t9, $s3, lr21
	 	lb $t9, 11($t3)
	 	bne $t9, $s3, lr21
	 	lb $t9, 15($t4)
	 	bne $t9, $s3, lr21
	 	j gameWin
	 	lr21:
	 	lb $s3, 3($t2)
	 	lb $t9, empty
	 	beq $t9, $s3, lr02
	 	lb $t9, 7($t3)
	 	bne $t9, $s3, lr02
	 	lb $t9, 11($t4)
	 	bne $t9, $s3, lr02
	 	lb $t9, 15($t5)
	 	bne $t9, $s3, lr02
	 	j gameWin
	 	lr02:
	 	lb $s3, 7($t0)
	 	lb $t9, empty
	 	beq $t9, $s3, lr12
	 	lb $t9, 11($t1)
	 	bne $t9, $s3, lr12
	 	lb $t9, 15($t2)
	 	bne $t9, $s3, lr12
	 	lb $t9, 19($t3)
	 	bne $t9, $s3, lr12
	 	j gameWin
	 	lr12:
	 	lb $s3, 7($t1)
	 	lb $t9, empty
	 	beq $t9, $s3, lr22
	 	lb $t9, 11($t2)
	 	bne $t9, $s3, lr22
	 	lb $t9, 15($t3)
	 	bne $t9, $s3, lr22
	 	lb $t9, 19($t4)
	 	bne $t9, $s3, lr22
	 	j gameWin
	 	lr22:
	 	lb $s3, 7($t2)
	 	lb $t9, empty
	 	beq $t9, $s3, lr03
	 	lb $t9, 11($t3)
	 	bne $t9, $s3, lr03
	 	lb $t9, 15($t4)
	 	bne $t9, $s3, lr03
	 	lb $t9, 19($t5)
	 	bne $t9, $s3, lr03
	 	j gameWin
	 	lr03:
	 	lb $s3, 11($t0)
	 	lb $t9, empty
	 	beq $t9, $s3, lr13
	 	lb $t9, 15($t1)
	 	bne $t9, $s3, lr13
	 	lb $t9, 19($t2)
	 	bne $t9, $s3, lr13
	 	lb $t9, 23($t3)
	 	bne $t9, $s3, lr13
	 	j gameWin
	 	lr13:
	 	lb $s3, 11($t1)
	 	lb $t9, empty
	 	beq $t9, $s3, lr23
	 	lb $t9, 15($t2)
	 	bne $t9, $s3, lr23
	 	lb $t9, 19($t3)
	 	bne $t9, $s3, lr23
	 	lb $t9, 23($t4)
	 	bne $t9, $s3, lr23
	 	j gameWin
	 	lr23:
	 	lb $s3, 11($t2)
	 	lb $t9, empty
	 	beq $t9, $s3, lr04
	 	lb $t9, 15($t3)
	 	bne $t9, $s3, lr04
	 	lb $t9, 19($t4)
	 	bne $t9, $s3, lr04
	 	lb $t9, 23($t5)
	 	bne $t9, $s3, lr04
	 	j gameWin
	 	lr04:
	 	lb $s3, 15($t0)
	 	lb $t9, empty
	 	beq $t9, $s3, lr14
	 	lb $t9, 19($t1)
	 	bne $t9, $s3, lr14
	 	lb $t9, 23($t2)
	 	bne $t9, $s3, lr14
	 	lb $t9, 27($t3)
	 	bne $t9, $s3, lr14
	 	j gameWin
	 	lr14:
	 	lb $s3, 15($t1)
	 	lb $t9, empty
	 	beq $t9, $s3, lr24
	 	lb $t9, 19($t2)
	 	bne $t9, $s3, lr24
	 	lb $t9, 23($t3)
	 	bne $t9, $s3, lr24
	 	lb $t9, 27($t4)
	 	bne $t9, $s3, lr24
	 	j gameWin
	 	lr24:
	 	lb $s3, 15($t2)
	 	lb $t9, empty
	 	beq $t9, $s3, rl01
	 	lb $t9, 19($t3)
	 	bne $t9, $s3, rl01
	 	lb $t9, 23($t4)
	 	bne $t9, $s3, rl01
	 	lb $t9, 27($t5)
	 	bne $t9, $s3, rl01
	 	j gameWin
	 	#RighttoLeft
	 	rl01:
	 	lb $s3, 27($t0)
	 	lb $t9, empty
	 	beq $t9, $s3, rl02
	 	lb $t9, 23($t1)
	 	bne $t9, $s3, rl02
	 	lb $t9, 19($t2)
	 	bne $t9, $s3, rl02
	 	lb $t9, 15($t3)
	 	bne $t9, $s3, rl02
	 	j gameWin
	 	rl02:
	 	lb $s3, 27($t1)
	 	lb $t9, empty
	 	beq $t9, $s3, rl03
	 	lb $t9, 23($t2)
	 	bne $t9, $s3, rl03
	 	lb $t9, 19($t3)
	 	bne $t9, $s3, rl03
	 	lb $t9, 15($t4)
	 	bne $t9, $s3, rl03
	 	j gameWin
	 	rl03:
	 	lb $s3, 27($t2)
	 	lb $t9, empty
	 	beq $t9, $s3, rl10
	 	lb $t9, 23($t3)
	 	bne $t9, $s3, rl10
	 	lb $t9, 19($t4)
	 	bne $t9, $s3, rl10
	 	lb $t9, 15($t5)
	 	bne $t9, $s3, rl10
	 	j gameWin
	 	rl10:
	 	lb $s3, 23($t0)
	 	lb $t9, empty
	 	beq $t9, $s3, rl11
	 	lb $t9, 19($t1)
	 	bne $t9, $s3, rl11
	 	lb $t9, 15($t2)
	 	bne $t9, $s3, rl11
	 	lb $t9, 11($t3)
	 	bne $t9, $s3, rl11
	 	j gameWin
	 	rl11:
	 	lb $s3, 23($t1)
	 	lb $t9, empty
	 	beq $t9, $s3, rl12
	 	lb $t9, 19($t2)
	 	bne $t9, $s3, rl12
	 	lb $t9, 15($t3)
	 	bne $t9, $s3, rl12
	 	lb $t9, 11($t4)
	 	bne $t9, $s3, rl12
	 	j gameWin
		rl12:
		lb $s3, 23($t2)
	 	lb $t9, empty
	 	beq $t9, $s3, rl20
	 	lb $t9, 19($t3)
	 	bne $t9, $s3, rl20
	 	lb $t9, 15($t4)
	 	bne $t9, $s3, rl20
	 	lb $t9, 11($t5)
	 	bne $t9, $s3, rl20
	 	j gameWin
	 	rl20:
	 	lb $s3, 19($t0)
	 	lb $t9, empty
	 	beq $t9, $s3, rl21
	 	lb $t9, 15($t1)
	 	bne $t9, $s3, rl21
	 	lb $t9, 11($t2)
	 	bne $t9, $s3, rl21
	 	lb $t9, 7($t3)
	 	bne $t9, $s3, rl21
	 	j gameWin
	 	rl21:
	 	lb $s3, 19($t1)
	 	lb $t9, empty
	 	beq $t9, $s3, rl22
	 	lb $t9, 15($t2)
	 	bne $t9, $s3, rl22
	 	lb $t9, 11($t3)
	 	bne $t9, $s3, rl22
	 	lb $t9, 7($t4)
	 	bne $t9, $s3, rl22
	 	j gameWin
	 	rl22:
	 	lb $s3, 19($t2)
	 	lb $t9, empty
	 	beq $t9, $s3, rl30
	 	lb $t9, 15($t3)
	 	bne $t9, $s3, rl30
	 	lb $t9, 11($t4)
	 	bne $t9, $s3, rl30
	 	lb $t9, 7($t5)
	 	bne $t9, $s3, rl30
	 	j gameWin
	 	rl30:
	 	lb $s3, 15($t0)
	 	lb $t9, empty
	 	beq $t9, $s3, rl31
	 	lb $t9, 11($t1)
	 	bne $t9, $s3, rl31
	 	lb $t9, 7($t2)
	 	bne $t9, $s3, rl31
	 	lb $t9, 3($t3)
	 	bne $t9, $s3, rl31
	 	j gameWin
	 	rl31:
	 	lb $s3, 15($t1)
	 	lb $t9, empty
	 	beq $t9, $s3, rl32
	 	lb $t9, 11($t2)
	 	bne $t9, $s3, rl32
	 	lb $t9, 7($t3)
	 	bne $t9, $s3, rl32
	 	lb $t9, 3($t4)
	 	bne $t9, $s3, rl32
	 	j gameWin
	 	rl32:
	 	lb $s3, 15($t2)
	 	lb $t9, empty
	 	beq $t9, $s3, endcase
	 	lb $t9, 11($t3)
	 	bne $t9, $s3, endcase
	 	lb $t9, 7($t4)
	 	bne $t9, $s3, endcase
	 	lb $t9, 3($t5)
	 	bne $t9, $s3, endcase
	 	j gameWin
	 	endcase:
	 	j notWin
	#------------------------------Prompt--------------------------------------------
	Invalid:
		li $v0, 4
		la $a0, prompt3
		syscall
		addi $s0, $s0,-1
		jal CheckInapp
		j decideturn
	Full:
		li $v0, 4
		la $a0, prompt4
		syscall
		addi $s0, $s0,-1
		jal CheckInapp
		j decideturn
	CheckInapp:
		rem $t9, $a1, 2
		beq $t9, 0, else
		addi $s4, $s4,-1
		j inapp
		else:
		addi $s5, $s5,-1
		inapp:
		beq $s4, 0, forcedLose
		beq $s5,0 , forcedLose
		jr $ra
	gameTie:
		li $v0, 4
		la $a0, prompt5
		syscall
		j Over
	gameWin:
		li $v0, 4
		la $a0, prompt6
		syscall
		rem $t9, $a1, 2
		addi $a0, $t9,1
		la $v0 ,1 
		syscall
		j Over
	forcedLose:
		li $v0, 4
		la $a0, prompt7
		syscall
		j gameWin
	Undo:	
		ble $s0, 2, notUndo
		beq $t9,0, undo2
		#undo1:
		beq $s6,0, notUndo
		li $v0, 4
		la $a0, prompt8
		syscall
		li $v0 , 5
		syscall
		move $a0, $v0
		bne $a0, 0, notUndo
		addi $s0,$s0,-1
		addi $s6,$s6,-1
		j decideturn
		undo2:
		beq $s7,0, notUndo
		li $v0, 4
		la $a0, prompt8
		syscall
		li $v0 , 5
		syscall
		move $a0, $v0
		bne $a0, 0, notUndo
		addi $s0,$s0,-1
		addi $s7,$s7,-1
		j decideturn
	Over:
		li $v0,10
		syscall
	
