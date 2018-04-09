.data 
	welcomeMessage: .asciiz "This is an Assembly Program that convert Octal Number to Decimal!\n"
	octalMessage:	.asciiz "Enter the value of the octal number: "
	warningMessage: .asciiz "The input is not an octal number. Enter the value of the octal number: "
	decimalMessage: .asciiz "The decimal value of your octal number is: "
	numberSpace:	.space 80
	newLine: .asciiz "\n"
.text
	
_start:	
	#Print the welcome message
	la $a0, welcomeMessage
	li $v0, 4
	syscall
	
	#Call interactWithUser Function
	jal interactWithUser
	
	#Save the return value into register #s1
	move $s1, $v0
	
	#Print the result message
	la $a0, decimalMessage
	li $v0, 4
	syscall
	
	#Print the value in decimal
	move $a0, $s1
	li $v0,1
	syscall
	
	#Show the assemble the program is done
	li $v0,10
	syscall
	
interactWithUser:
	
	#Prompt user to enter the octal Number
	la $a0, octalMessage
	li $v0, 4
	syscall
	
	askOctal:
		add $t2, $zero, $zero
		#Save the input take from user into a String space
		li $v0, 8
		la $a0, numberSpace
		la $a1, 20
		syscall
		
		#Save the initial address and the first value
		la $s0, ($a0)
		lbu $t0, ($s0)
		move $t3, $s0
	checkValue:
		#Check the end of the string
		beq $t0, 10, octalConverter
		#Decrement 48 to change it to integer
		subi $t1, $t0, 48
		#Check if number is smaller than zero and bigger than seven
		blt $t1, $0, notOctal
		bgt $t1, 7, notOctal
		
		#Save the length of the octal code
		addi $t2, $t2, 1
		#Increment the address by 1
		addi $t3, $t3, 1
		#Load the new value into register $t0
		lbu $t0, ($t3)
		j checkValue
		
	octalConverter:
		subi $t2, $t2, 1
		move $t3, $s0
		add $t1, $zero, $0
		
		additionLoop:
			blt $t2,$zero, loopFinished
			lbu $t0, ($t3)
			subi $t1, $t0, 48
			#Power result
			addi $t4, $zero, 1
			#Index 
			add $t5, $zero, $0
			
			powerAddition:
				beq  $t5, $t2,oneLess
				sll $t4, $t4, 3
				addi $t5, $t5,1
				j powerAddition
				
			oneLess: 
				mul $t6, $t1, $t4
				add $t7, $t7, $t6
				addi $t3, $t3, 1
				subi $t2, $t2, 1
				j additionLoop
		loopFinished:
			add $v0, $zero, $t7
			j octalConverted
	notOctal:
		#Print the message and ask user for number again
		la $a0, warningMessage
		li $v0, 4
		syscall 
		j askOctal
	
	octalConverted:
		jr $ra
	
	
	
