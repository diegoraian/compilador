.data

.text

_f_println:
	lw $a0, 4($sp)
	li $v0, 1
	syscall
	li $v0, 11
	li $a0, 0x0a
	syscall
	addiu $sp, $sp, 4
	li $a0, 0
	j $ra
_f_main:
	move $fp $sp
	sw $ra 0($sp)
	addiu $sp $sp -4
	addiu $sp, $sp, -4
	addiu $sp, $sp, -4
	addiu $sp, $sp, -4
	
	#INICIO chamada de input
	li $v0, 5
	syscall
	move $a0, $v0
	#FIM chamada de input

	sw $a0, -4($fp)
	
	#INICIO chamada de input
	li $v0, 5
	syscall
	move $a0, $v0
	#FIM chamada de input

	sw $a0, -8($fp)
	
	#INICIO chamada de input
	li $v0, 5
	syscall
	move $a0, $v0
	#FIM chamada de input

	sw $a0, -12($fp)
	#INICIO CONDICIONAL
	
	lw $a0, -4($fp)
	sw $a0, 0($sp)
	addiu $sp, $sp, -4
	
	
	lw $a0, -8($fp)
	lw $t1 4($sp)
	addiu $sp, $sp, 4
	
	beq $a0 $t1 true1
	#FIM CONDICIONAL
false1:
	li $a0 2
	sw $a0, 0($sp)
	addiu $sp, $sp, -4
	jal _f_println
	b end_if1
true1:
	li $a0 1
	sw $a0, 0($sp)
	addiu $sp, $sp, -4
	jal _f_println
end_if1:
	li $a0 3
	sw $a0, 0($sp)
	addiu $sp, $sp, -4
	jal _f_println
	#INICIO CONDICIONAL
	
	lw $a0, -4($fp)
	sw $a0, 0($sp)
	addiu $sp, $sp, -4
	
	
	lw $a0, -8($fp)
	lw $t1 4($sp)
	addiu $sp, $sp, 4
	
	bne $a0 $t1 true2
	#FIM CONDICIONAL
false2:
	li $a0 5
	sw $a0, 0($sp)
	addiu $sp, $sp, -4
	jal _f_println
	b end_if2
true2:
	li $a0 4
	sw $a0, 0($sp)
	addiu $sp, $sp, -4
	jal _f_println
end_if2:
	li $a0 6
	sw $a0, 0($sp)
	addiu $sp, $sp, -4
	jal _f_println
	#INICIO CONDICIONAL
	
	lw $a0, -4($fp)
	sw $a0, 0($sp)
	addiu $sp, $sp, -4
	
	
	lw $a0, -8($fp)
	lw $t1 4($sp)
	addiu $sp, $sp, 4
	
	beq $a0 $t1 true3
	#FIM CONDICIONAL
false3:
	b end_if3
true3:
	li $a0 7
	sw $a0, 0($sp)
	addiu $sp, $sp, -4
	jal _f_println
end_if3:
	li $a0 8
	sw $a0, 0($sp)
	addiu $sp, $sp, -4
	jal _f_println
	#INICIO CONDICIONAL
	
	lw $a0, -4($fp)
	sw $a0, 0($sp)
	addiu $sp, $sp, -4
	
	
	lw $a0, -8($fp)
	lw $t1 4($sp)
	addiu $sp, $sp, 4
	
	bne $a0 $t1 true4
	#FIM CONDICIONAL
false4:
	b end_if4
true4:
	li $a0 9
	sw $a0, 0($sp)
	addiu $sp, $sp, -4
	jal _f_println
end_if4:
	li $a0 10
	sw $a0, 0($sp)
	addiu $sp, $sp, -4
	jal _f_println
addiu $sp $sp 	12
	lw $ra 4($sp)
addiu $sp $sp 	12
	lw $fp 0($sp)
	jr $ra 
main:
	jal _f_main
	li $v0, 10
	syscall
