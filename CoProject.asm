.data
##### Essam Data  ############################################
	options: .asciiz "Please enter your option number:\n"
	optionsdetails: .asciiz " 1-Insert a new value\n 2-Update execting value\n 3-Delete execting value\n 4-Search for a specefic value\n 5-Sort the list\n 6-Print the list\n 7-Exit\n"
	errormessage: .asciiz "Incorrect number please enter a valid number"	
	
	case1M: .asciiz "Please enter the data: \n"
	case11M: .asciiz "Please enter the position from 0 : \n"
	
	case2M: .asciiz "Please enter the new value you want to update : \n"
	case22M: .asciiz "Please enter the old value: \n"
	
	case3M: .asciiz "Please enter the value you want to delete : \n"
	
	case4M: .asciiz "Please enter the value you want to search : \n"
	case44M: .asciiz "The value is in the list. \n"
	case444M: .asciiz "The value isn't at this list. \n"
	newline:.asciiz "\n"
#####   Hazem Data   ##########################################
	
	
     	errorMassage1:  .asciiz "Please enter a number from 0 to. \n"
     	errorMassage2:  .asciiz "The list is empty.\n"
     	errorMassage3:  .asciiz "Please enter a number 0.\n"
     	errorMassage4:  .asciiz "The list is smaller than the position.\n"
     	errorMassage5:  .asciiz "Please enter a number from 0 to. \n"
     	First:          .word   0
     	ListPointer:    .word   0
     	m: .asciiz "Hello"
     	sep:   .asciiz "  "
	
	lerror:         .asciiz  "List is empty.\n"
.text

jal CreateList

          

do:
	#print intro
	la $a0,options
	jal displayMessage
	#print optionsdetails
	la $a0,optionsdetails
	jal displayMessage
	#read
	li $v0,5
	syscall
	add $s7,$v0,$0
	
	beq $s7,1,case1		#Insert
	beq $s7,2,case2		#Update
	beq $s7,3,case3		#Delete
	beq $s7,4,case4		#Search
	beq $s7,5,case5		#Sort
	beq $s7,6,case6     #print
	beq $s7,7,exit		#Exit
	beq $s7,8,error
	bgt $s7,8,error
	
while:
	beq $v0,7,exit
	j do 
	
case1:
	# print case1M
	la $a0,case1M
	jal displayMessage
	#get data
	li $v0,5
	syscall
	move $a2,$v0
	#print case11M
	la $a0,case11M
	jal displayMessage
	#get Position
	li $v0,5
	syscall
	move $a3,$v0
	
	
	jal Insert

	j do
	
case2:
	#print case2M
	la $a0,case2M
	jal displayMessage
	#get Old Key
	li $v0,5
	syscall
	move $a2,$v0
	#print case22M
	la $a0,case22M
	jal displayMessage
	#get new value
	li $v0,5
	syscall
	move $a3,$v0
	
	jal Update
	j do
	
case3:
	#print case3M
	la $a0,case3M
	jal displayMessage
	#get data
	li $v0,5
	syscall
	move $a2,$v0
	
	jal Delete

	j do
case4:
	#print case4M
	la $a0,case4M
	jal displayMessage
	#get data
	li $v0,5
	syscall
	move $a1,$v0
	
	#search return in $t4 or $s0 and you could change it
	jal search

	beq $t4,1,case44
	beq $t4,0,case444
	
	j do
case44:
	#print case44M
	la $a0,case44M
	jal displayMessage
	la $a1, First #head
	j  do
case444:	
	#print case444M
	la $a0,case444M
	jal displayMessage
	la $a1, First #head
	j  do
case5:
	la $a1, First
 	jal Sort
	j do

		
error:
	
	la $a0,errormessage
	jal displayMessage
	j do
	
exit:	
	#exit
	li $v0 ,10
	syscall	
	
displayMessage:
	li $v0,4
	syscall
	jr $ra

#############       Hazem procedure    #################

     
############ CreateList procedure ###############
CreateList:
               la $s0, First
               la $a1,First
               sw $s0, ListPointer
     jr $ra               
############ Insert procedure #################
Insert:
            addi  $t0, $zero, 0    # the Size of the list
            
            lw $s0, ($a1)  # s0 = &(header)
            
            # While Loop to get the size of the list
            while1:
                 # exit while loop
                 beqz $s0, exit1
                 # loop body
                 addi $t0, $t0, 1  # Size++
                 lw   $s0, 4($s0)
                 b    while1
            exit1:
            
            bltz  $a3, printFError  # first if statement
            beqz  $t0, printSError  # Seconed if statement
            exitSE:            
            bgt   $a3, $t0, printTError  # Third if statement
            
            ######## Create new node ##########
            li $v0, 9   # allocate memory
            li $a0, 8   # 8 bytes struct
            syscall
            beqz  $a3,      createTheFirstNode   # If pos == 0  create the first node
            
            ####### Create any node except the first node ########
            lw $s0, ($a1)   # previous node                        
            li $t3, 0
            subi $t4, $a3, 1 # position - 1            
            for:
                bge  $t3, $t4, exitFor
                lw   $s0, 4($s0)
                addi $t3, $t3, 1
                b    for
            exitFor:
            lw   $t5, 4($s0)
            sw   $v0, 4($s0)
            move $s0, $v0
            sw   $a2, 0($s0)
            sw   $t5, 4($s0)
            
            
     # End of Insert procedure
     jr $ra
     
printFError :
	la $a0, errorMassage1
	jal displayMessage
	jr $ra

printSError :
                bgtz $a3, printFoError
     		j  exitSE 
printTError :
                  
                  la $a0, errorMassage4
                  jal displayMessage
                  
                  
                  la $a0, errorMassage5
                  jal displayMessage
     jr $ra
printFoError :
                  
                  la $a0, errorMassage2
                  jal displayMessage
                  
                  la $a0, errorMassage3
                  jal displayMessage
     jr $ra 
createTheFirstNode :
                        move $s1, $v0  #  s1 = &(new first node)
                        lw $t3, ($a1)
                        sw $t3, 4($s1)
                        la $t4, ($s1)
                        sw $t4, First
                        
                        # store the value
                        move $t1, $a2
                        sw $t1, 0($s1)
                        
	
     	    jr $ra
################ Sandra Procedure ##################
################ Sort procedure ##################
      Sort :
          lw $s0, ($a1) # previous
          
          beqz $s0, listerror
          while4:
                 beqz  $s0, exit4
                 lw    $s1, ($a1)
                 while5:
                        lw   $t4, 4($s1)
                        beqz $t4, exit5
                        lw   $t1, 0($s1) # Current value
                        lw   $s3, 4($s1)
                        lw   $t2, 0($s3) # next value
                        bgt  $t1, $t2, swap
                        exitswap:
                        lw   $s1, 4($s1)
                        b while5
                 exit5:
                 lw    $s0, 4($s0)
                 b while4
          exit4:
          
     jr $ra
     
     listerror :
                li $v0, 4
                la $a0, lerror
                syscall
     jr $ra
     
     swap :
           lw $t6, 0($s1)
           lw $t7, 0($s3)
           sw $t7, 0($s1)
           sw $t6, 0($s3)
     b exitswap
     
     
     
case6:
jal printList
b do
printList :
                lw $s0,($a1)              
                while2:
                      beqz  $s0, exit2
                      li $v0, 1
                      lw $a0, 0($s0)
                      syscall
                      la     $a0,sep            #   print separator
       		      li     $v0,4              #
        	      syscall              
                      lw $s0, 4($s0)
                      b  while2
                exit2: 
                     li $v0,4
                     la $a0,newline
                     syscall          
     jr $ra
########   Adib   ###########33    
################# Adib procedure  ####################
search:
#searched value will be in a1
sw $ra, 8($sp)
lw $s4,First
beqz $s4,EndOfList
lw $a0,0($s4)

jal  Access 

while3:

lw $a0,0($s4)

beq  $a1,$a0,found

lw $a0,4($s4) 
jal  Access 
beqz $v0,EndOfList


lw   $s4,4($s4)

j    while3

EndOfList:

li $t4,0
lw $ra, 8($sp)
jr $ra

found:

li $t4,1
lw $ra, 8($sp)
jr $ra                
	
			
#Access
Access:
beq $a0,$0,Return
li $v0,1
j Exit
        

Return: 
li $v0,0
jr $ra
                
Exit:
jr $ra

####################################################
 ############ Delete procedure ###################
     Delete :
            lw $s1, ($a1)
            
            bnez $s1, delfirst  # first if statement
            exitdel:            
            whilee:         # the while loop
                  bnez $s1, Nnode
                  exitNnode:
                  la $s2, ($s1)
                  lw $s1, 4($s1)
                  b whilee
            exite:
            beqz $s1, return
            lw $t9, 4($s1)
            sw $t9, 4($s2)
            
            li $v1, 1
     jr $ra
     
     delfirst:
              lw  $t7, 0($s1)
              beq $a2, $t7, dell              
     b exitdel
     
     dell:
          lw $t8, 4($s1)
          sw $t8, First
          li $v1, 0
     jr $ra
     
     Nnode:
           lw $t8, 0($s1)
           bne $a2, $t8, exitNnode
     b exite
     
     return:
     jr $ra
     
      ############ Update procedure ###################
     Update :
             lw $s0, ($a1)#header
             
             whileee:
                   beqz $s0, exitee
                   lw   $t6, 0($s0)
                   beq  $a3, $t6, renew
                   lw   $s0, 4($s0)
                   b    whileee
             exitee:
             li $v1, 0
     jr $ra
     
     renew:
           sw $a2, 0($s0)
           li $v1, 1
     jr $ra
     
     
     
     
