#--------------------------------------------------------------
#@author: Aurel Hoxha 21503529
#Date: 07/03/2017
#Program: Creates an array and make different operation with it
#--------------------------------------------------------------
.data
promptArray: 		.asciiz "Enter the size of the array you want: "
promptArrayValues:	.asciiz "Enter the number: "
newLine:		.asciiz "\n"
minMessage:		.asciiz "The minimum value in the array is: "
maxMessage:		.asciiz "The maximum value of the array is: "
medianMessage:		.asciiz "The median value of the array is: "
space:			.asciiz " "
bubbleSorted:		.asciiz "Array is Bubble Sorted! \n"
messageForSorted:	.asciiz "Array is already sorted!\n"
arrayElements: 		.asciiz "The elements in the array are: "
correctInput:		.asciiz "Enter a valid choice! \n"
endMessage:		.asciiz "Thank You for using our Program! \n"
promptMenu:		.asciiz "1.Sort the array using Bubble Sort!\n2.Print the maximum and the minimum value of the array!\n3.Find the median of the array!\n4.Quit\nEnter your choice: "

.text

#Begin the Program
_start:
	
	jal readArray
	#Save the result into Register a0 and a1
	move $a0,$v0
	move $a1,$v1
	move $s1, $a0
	
	add $s2, $zero, $zero
	
	add $s4, $0, 0
	add $s5, $0, 0
	add $s6, $0, 0
	
monitor:
	
	li $v0,4
	la $a0, promptMenu
	syscall
	
	li $v0, 5
	syscall

	beq $v0, 1, callBubbleSort
	beq $v0, 2, callMinMax
	beq $v0, 3, callMedian
	beq $v0, 4, callQuit
	
	li $v0, 4
	la $a0, correctInput
	syscall
	j monitor
	callBubbleSort:
		beq $s2, 1, jumpMonitor
		move $a0, $s1
		jal bubbleSort
		add $s2, $s2,1
		j monitor
	jumpMonitor:
		li $v0,4
		la $a0, messageForSorted
		syscall
		j monitor
	callMinMax:
		beq $s6, 1, printMinMax
		move $a0, $s1
		jal minMax
		addi $s6, $s6, 1
		move $a0, $s1
		
		move $s4, $v0
		move $s5, $v1
		#Print the min and max on the array
		
	printMinMax:
		li $v0,4
		la $a0, minMessage
		syscall
		
		li $v0,1
		move $a0, $s4
		syscall
		
		li $v0, 4
		la $a0, newLine
		syscall
		
		li $v0,4
		la $a0, maxMessage
		syscall
		
		li $v0,1
		move $a0, $s5
		syscall
		
		li $v0,4
		la $a0,newLine
		syscall
		j monitor
	callMedian:
		move $a0, $s1
		jal median
		j monitor
	callQuit:
		#Print the end Message
		li $v0,4
		la $a0, endMessage
		syscall
		#Tell the software the program ends here
		li $v0,10
		syscall

#-----------------------------------------------------------
# BEGINNING OF READ ARRAY METHOD
#-----------------------------------------------------------
readArray:
	
	addi $sp, $sp, -16 #Make space on stack to store three register
	sw $s0, 12($sp)	   #Save $t0 on stack
	sw $s1, 8($sp)     #Save $t1 on stack
	sw $t0, 4($sp)     #Save $t2 on stack
	sw $t3, 0($sp)     #Save $t3 on stack
	
	#First prompt the user to enter the size of the array
	la $a0, promptArray
	li $v0, 4
	syscall
	
	#Take the input from user and save it into a register ($t0)
	li $v0, 5
	syscall
	
	#Move the array Size to Register $s0
	move $s0, $v0
	
	#Convert it to byte by multiplying by 4
	sll $s0, $s0, 2
	
	#Allocate space for our numbers
	move $a0, $s0
	li $v0, 9
	syscall 
	
	#Save the address of the first element of the array
	move $s1, $v0
	
	#Register t2 will go through the array
	move $t0, $s1
	
	#Loop for adding numbers to the array
	loop:	beq $t3, $s0, readArrayFinish
	
		#Prompt user to enter a number
		la $a0, promptArrayValues
		li $v0, 4
		syscall
	
		#Read the number from the user
		li $v0, 5
		syscall
	
		#Save the element to the first position of the array
		sw $v0, ($t0)
	
		#Increment the address by 4
		addi $t0, $t0, 4
		addi $t3, $t3, 4
		j loop
	
	#Save the final result and return to the saved address
	readArrayFinish:
		move $v0,$s1
		div $v1, $s0, 4

		lw $t3, 0($sp)   #Restore $t3 from stack
		lw $t0, 4($sp)   #Restore $t2 from stack
		lw $s1, 8($sp)   #Restore $t1 from stack
		lw $s0, 12($sp)  #Restore $t0 from stack
		add $sp, $sp,16  #Deallocate stack space
		jr $ra
#-----------------------------------------------------------
# FINISH OF READ ARRAY METHOD
#-----------------------------------------------------------
bubbleSort:
	addi $sp, $sp, -40
	sw $ra, 36($sp)
	sw $s0, 32($sp)
	sw $s1, 28($sp)
	sw $s2, 24($sp)
	sw $t0, 20($sp)
	sw $t1, 16($sp)
	sw $t2, 12($sp)
	sw $t3, 8($sp)
	sw $s4, 4($sp)
	sw $s5, 0($sp)
	
	move $s0, $a0
	move $s1, $a1
	
	addi $t0, $t0, 1
	subi $s2, $s1, 1
	addi $t1, $t1, 0
	addi $t3, $zero, 0
	
	outerLoop:
		beq $t0, $s1, outerLoopDone
		innerLoop:
			beq $t1, $s2, innerLoopDone
			#Save j element address
			mul $t2, $t1, 4
			add $t2, $s0, $t2
			
			addi $t3, $t1, 1
			mul $t3, $t3, 4
			add $t3, $s0, $t3
			
			lw $s4, ($t2)
			lw $s5, ($t3)	
			blt $s4, $s5, swapDone
			sw $s5, ($t2)
			sw $s4, ($t3)
			
			lw $s4, ($t2)
			lw $s5, ($t3)	
			swapDone:
				addi $t1, $t1, 1
				j innerLoop
		innerLoopDone:
		add $t1, $zero, 0
		addi $t0, $t0,1
		j outerLoop
	outerLoopDone:
		jal printArray
		lw $s5, 0($sp)
		lw $s4, 4($sp)
		lw $t3, 8($sp)
		lw $t2, 12($sp)
		lw $t1, 16($sp)
		lw $t0, 20($sp)
		lw $s2, 24($sp)
		lw $s1, 28($sp)
		lw $s0, 32($sp)
		lw $ra, 36($sp)
		addi $sp, $sp, 40
		jr $ra
#-----------------------------------------------------
# PRINT FUNCTION - PRINT THE ELEMENTS OF THaE ARRAY
#-----------------------------------------------------
printArray:
	addi $sp, $sp, -20
	sw $t0, 16($sp)
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $ra  0($sp)
	
	move $s0, $a0
	move $s1, $a1
	sw $a0, 12($sp)
	mul $t0, $s1, 4
	add $t0, $s0, $t0
	
	li $v0,4
	la $a0,arrayElements
	syscall
	
	printLoop:
		beq $s0, $t0, printDone
		lw $a0, ($s0)
		jal printElement
		addi $s0, $s0, 4
		j printLoop
	printDone:
		li $v0, 4
		la $a0, newLine
		syscall
		lw $ra, 0($sp)
		lw $s1, 4($sp)
		lw $s0, 8($sp)
		lw $a0, 12($sp)
		lw $t0, 16($sp)
		addi $sp, $sp, 20
		jr $ra
	printElement:
		move $t1, $a0
		li $v0, 1
		move $a0, $t1
		syscall
		li $v0,4
		la $a0, space
		syscall
		jr $ra
minMax:
	addi $sp, $sp, -28
	sw $t3, 24($sp)
	sw $s0, 16($sp)
	sw $s1, 12($sp)
	sw $t0, 8($sp)
	sw $t1, 4($sp)
	sw $t2, 0($sp)
	
	move $s0, $a0
	move $s1, $a1	
	
	sw $a0, 20($sp)
	mul $t0, $s1, 4
	add $t0, $s0, $t0
	
	lw $t3,($s0)
	move $t1, $t3
	move $t2, $t3
	minLoop:
		addi $s0, $s0, 4
		beq $s0, $t0,minFinish
		lw $t3,($s0)
		ble $t3, $t1, updateMin
		bgt $t3, $t2, updateMax
		j minLoop
	updateMax:
		move $t2, $t3
		j goNextMin
	updateMin:
		move $t1, $t3
		j goNextMin
	goNextMin:
		j minLoop
	minFinish:
		add $v0, $zero, $t1
		add $v1, $zero, $t2
		lw $t3, 24($sp)
		lw $s0, 16($sp)
		lw $s1, 12($sp)
		lw $t0, 8($sp)
		lw $t1, 4($sp)
		lw $t2, 0($sp)
		addi $sp, $sp, 28
		

		jr $ra
		
#-----------------------------------------------------
# MEDIAN FUNCTION - CALCULATE THE MEDIAN AND PRINT IT
#-----------------------------------------------------
median:
	addi $sp, $sp, -32
	sw $t4, 28($sp)
	sw $t3, 24($sp)
	sw $t2, 20($sp)
	sw $t1, 16($sp)
	sw $s0, 12($sp)
	sw $s1, 8($sp)
	sw $ra, 4($sp)
	sw $t0, 0($sp)
	
	move $s0, $a0
	move $s1, $a1
	
	
	addi $t4, $t4, 2
	div $s1, $t4
	mfhi $t0
	
	bne $t0, $zero, oddLength
	mflo $t1
	mul $t1,$t1, 4
	add $t1, $t1, $s0
	lw $t2, ($t1)
	subi $t1, $t1, 4
	lw $t3, ($t1)
	add $t2, $t2,$t3
	div $t2,$t2,$t4
	j medianFound
	
	oddLength:
		subi $t1, $s1, 1
		div $t1, $t1, 2
		mul $t1, $t1,4
		add $t1, $s0, $t1
		lw $t2,($t1)
	medianFound:
		jal printArray
		#Print the message of the Median Value
		li $v0, 4
		la $a0, medianMessage
		syscall
		
		#Print the median value
		li $v0, 1
		move $a0, $t2
		syscall
		
		#Print a new Line
		li $v0,4
		la $a0, newLine
		syscall
		
		lw $t4, 28($sp)
		lw $t3, 24($sp)
		lw $t2, 20($sp)
		lw $t1, 16($sp)
		lw $s0, 12($sp)
		lw $s1, 8($sp)
		lw $ra, 4($sp)
		lw $t0, 0($sp)
		addi $sp, $sp, 32
		jr $ra
