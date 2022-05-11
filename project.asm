#----------Title: Parcel Delivery Alert System----------#

.data
	#MAIN PAGE
	hello: 		.asciiz "\nWelcome to Group A Parcel Delivery System\n\t[1]Recipient \n\t[2]Delivery Man\n"

	#RECIPIENT
	inputmsg:	.asciiz "Please enter you personal details"
	namemsg:	.asciiz "\nName: "
	name:		.space 50
	phonenomsg:	.asciiz "Phone Number (E.g: 0123456789): "
	addressmsg:	.asciiz "Address: "
	address:	.space 100
	QRmsg:		.asciiz "QR serial num: "
	serialmsg:	.asciiz "Tracking number: "
	confirm:	.asciiz "------------CONFIRMATION OF DETAILS------------"
	continue: 	.space 2			
	homeprompt:	.asciiz "\nBack to System Main page?(Y/N)" 
	
	#DELIVERY MAN
	scanQR:		.asciiz "Please scan QR serial number: "
	scanTracking:	.asciiz "Please scan tracking number: "
	newLine:	.asciiz "\n" 
	validating:     .asciiz "\nValidating the Parcel"
	droppingalert:  .asciiz "\n\nAlert has been sent :Someone is dropping the Parcel"
	thumbprintalert:  .asciiz "\n\nAlert has been sent :I'm here, I need your thumprint"
	inputThumbprint: .asciiz "\n\t [0] No Thumbprint \n\t [1]Do Have Thumbprint\n"
	thumbprint:	.space 2
	wrongHouse: 	.asciiz "\nWrong house"
	status:		.asciiz "\nParcel has been delivered"
	error:		.asciiz "\nNo data to track!"
	
	#HOUSE
	inputMotion:    .asciiz "\n\t [0] No Motion\n\t [1]Do Have Motion\n"
	motion:         .space 2
	
.text
#----------MAIN PAGE----------#
main: 
	#USER INPUT  1: Recipient, 2:Delivery Man
	la $a0, hello					#address of hello to print	
	jal PrintString
	li $v0, 5
	syscall
	move $t0, $v0					#User input
	sgt $s1, $t0, 2					#set flag true=1, if t0 > 2, else flag false=0
	slt $s2, $t0, $zero				#set flag true=1, if t0 < 0, else flag false=0
	or $s1, $s1, $s2				
	beq $s1, 1, main				#invalid input(other than 1 or 2), return main
	beq $t0, 1, Recipient				#if(input==1) {goto Receipient}
	beq $t0, 2, scanQRCode				#if(input==2) {goto Delivery}
	j main
			
#----------RECIPIENT---------#
Recipient:
	#USER INPUT - NAME, PHONE NUM, ADDRESS, QR CODE SERIAL NUM	
	la $a0, inputmsg				#address of inputmsg to print	
	jal PrintString	
	
	#NAME - t0		
	la $a0, namemsg					#address of namemsg to print	
	jal PrintString	
	
	li $v0, 8					#system call code for read_str
  	li $a1, 50					#maximum number to be read is 50
    	la $a0, name					#address of name
    	syscall						#read the string
    	move $t0, $v0					#store the name in register
    	
    	#PHONE NUM - t1	
	la $a0, phonenomsg				#address of phonemsg to print	
	jal PrintString	
	
	li $v0, 5					#system call code for read_int
    	syscall						#read the integer
    	move $t1, $v0					#store the phone no in register
    	
    	#ADDRESS - addressmsg	t2
	la $a0, addressmsg				#address of addressmsg to print		
	jal PrintString
    	
    	li $v0, 8					#system call code for read_str
  	li $a1, 100					#maximum number to be read is 100
    	la $a0, address					#address of address
    	syscall						#read the string
    	move $t2, $v0					#store the address in register

    	li $t3, 0
    	
    	#QR CODE SERIAL NUM - t3
	la $a0, QRmsg					#address of QRmsg to print	
	jal PrintString	
    	
    	li $v0, 5					#system call code for read_int
    	syscall						#read the integer
    	move $t3, $v0					#store the qr serial num in register
    	
    	#CREATING TRACKING NUM - PHONE NUM + 1
    	#TRACKING NUM - t4
    	addi $t4, $t1, 1
    	
    	#PRINT CONFIRMATION DETAILS PAGE
    	#CONFIRM DETAILS 	
	la $a0, confirm 				#address of inputmsg to print		
	jal PrintString
	
	#new line	
	#jal NewLine
	
    	#NAME
    	la $a0, namemsg					#address of namemsg to print	
    	jal PrintString
    	move $a0, $t0					#move the second integer to the argument
	la $a0, name					#address of name to print	
	jal PrintString					#print the name
	
	#PHONE NUM
	la $a0, phonenomsg				#address of phonemsg to print	
	jal PrintString	
	li $v0, 1					#system call code for print_int
	move $a0, $t1					#move the second integer to the argument							
	syscall						#print the phone number
	
	#new line
	jal NewLine
	
	#ADDRESS
	la $a0, addressmsg				#address of addressmsg to print		
	jal PrintString
	move $a0, $t2					#move the second integer to the argument
	la $a0, address					#address of address to print	
	jal PrintString					#print the address
	
	#QR SERIAL NUM
	la $a0, QRmsg					#address of QRmsg to print	
	jal PrintString	
	li $v0, 1					#system call code for print_int
	move $a0, $t3					#move the second integer to the argument							
	syscall						#print the QR serial number
	
	#new line
	jal NewLine
	
	#TRACKING NUM		
	la $a0, serialmsg				#address of serialmsg to print	
	jal PrintString					#print serialmsg
					
	li $v0, 1					#system call code for print_int
	move $a0, $t4					#move the second integer to the argument
	syscall						#print the tracking number

	#new line
	jal NewLine
	
#GOING BACK TO MAIN FOR DELIVERY MAIN SYSTEM
backToMain:
	la $a0, homeprompt				#address of homeprompt to print	
	jal PrintString
						
	li $a1, 2					#read 2 char max
	la $a0, continue				#load continue
	li $v0, 8					#command for read string
	syscall						#execute command
	
	lb $s3, 0($a0)					#load user input $a0 to $s3	
	beq $s3, 'y', main				#if equal to either y or Y return to main
	beq $s3, 'Y', main
	bne $s3, 'y', exit				#if other than y or Y exit the program
	bne $s3, 'Y', exit

#----------DELIVERY MAN---------#	  	
#SCAN QR CODE AND COMPARE - t5
scanQRCode:	
	la $a0, scanQR					#address of scanQR to print	
	jal PrintString					#print scanQR message
	
	li $v0, 5					#system call code for read_int
    	syscall						#read the integer
    	move $t5, $v0					#store the QR code in register
    	sle $s5, $t5, $zero
    	beq $s5, 1, printError
    	
    	beq $t3, $t5, scanTrackingNum			#if QR code by delivery man matches QR by recipient,
    							#jump to scanTrackingNum procedure
    	bne $t3, $t5, scanQRCode			#if not equal prompt scanQRCode again

printError:
	la $a0, error
	jal PrintString
	jal main
	
#SCAN TRACKING CODE AND COMPARE - t6
scanTrackingNum:	
	la $a0, scanTracking				#address of scanTracking to print
	jal PrintString					#print scanQR message
	
	li $v0, 5					#system call code for read_int
    	syscall						#read the integer
    	move $t6, $v0					#store the QR code in register
    					
#CHECKING THE INPUT OF TRACKING CODE AND COMPARE -t6
flag4TrackingScanner:
	beqz $t6, exit					#if Tracking Number is 0 / empty
							#jump to exit procedure
	bgtz $t6, motionDetector			#if Tracking Number is greater than 0 / not empty
							#jump to motionDetector procedure	
							
#DETECT MOTION AND COMPARE - t7
motionDetector:
		
	li $v0, 4					#system call code for print_str			
	la $a0, inputMotion				#address of inputMotion to print		
	syscall
	
	li $v0, 5					#system call code for read_int
    	la $a0, motion					#address of motion
    	syscall						#read the string
    	move $t7, $v0					#store the motion in register
	beq $t7, 0, exit				#if motion is 0 / no motion
							#jump to exit procedure
	bgtz $t7, parcelValidation			#if motion is 1 / there is motion
							#jump to parcelValidation procedure
    	
#VALIDATE PARCEL AND COMPARE - t4,t6	
parcelValidation:
	
	
	la $a0, validating			        #address of validating to print		
	jal PrintString
	
	beq $t4,$t6, biometric				#if Tracking Number by delivery man matches Tracking Number by recipient
							#jump to biometric procedure					
	bne $t4,$t6, wrongAddress			#if Tracking Number by delivery man does not match Tracking Number by recipient
							#jump to wrongAddress procedure
	
#DETECT THUMBPRINT AND COMPARE	
biometric:
		
	la $a0, droppingalert
	jal PrintString
	la $a0, thumbprintalert
	jal PrintString
	
	li $v0, 4					#system call code for print_str			
	la $a0, inputThumbprint				#address of inputThumbprint to print		
	syscall
	
	li $v0, 5					#system call code for read_int
    	la $a0, thumbprint				#address of thumbprint
    	syscall						#read the string
    	move $t9, $v0					#store the thumbprint in register
 	
 	beqz $t9, exit					#if thumbprint is 0 / no thumbprint
							#jump to exit procedure
	bgtz $t9, deliveryStatus			#if thumbprint is 1 / there is thumbprint
							#jump to deliveryStatus procedure     

#PROMPT MESSAGE TO RECIPIENT		
deliveryStatus:
			
	la $a0, status					#address of status to print	
	jal PrintString	
	
	jal exit
	
#PROMPT MESSAGE TO DELIVERY MAN	 	 	
wrongAddress:
	la $a0, wrongHouse				#address of wrongHouse to print
	jal PrintString
	
	jal backToMain 

#----------PROCEDURES---------#		
#PROCEDURE END PROGRAM
exit:
	li $v0, 10					#system call code to exit program
	syscall
	jr $ra
	
#PROCEDURE PRINT STRING
PrintString:
	li $v0, 4					#system call code for print_str				
	syscall						#print inputmsg
	jr $ra
	
#PROCEDURE NEW LINE
NewLine:
	li $v0, 4					#system call code for print_str		
	la $a0, newLine					#address of newLine to print			
	syscall						#print newline
	jr $ra

		
