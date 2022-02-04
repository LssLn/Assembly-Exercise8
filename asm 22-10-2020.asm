.data
ST: .space 32 ;#ST[32]
stack: .space 32

msg1: .asciiz "Inserisci una str di soli numeri"
msg2: .asciiz "Valore= %d\n" ;# ris 1° arg msg2

p1sys5: .space 8
ris: .space 8 ;#1° arg msg2

p1sys3: .word 0 ;# fd null
ind: .space 8
dim: .word 32 ;# numbyte da leggere (<= ST)

.code
;# inizializzazione stack
daddi $sp,$0,stack
daddi $sp,$sp,32

daddi $s0,$0,0 ;# i=0 per il do while
do: 
    slti $t0,$s0,3 ;#i di for multiplo di 1 (3 cicli while)
    beq $t0,$0,end ;# $t0=0 -->end quando $s0 >= 3

    ;#printf msg1
    daddi $t0,$0,msg1
    sd $t0,p1sys5($0)
    daddi r14,$0,p1sys5
    syscall 5
    ;# scanf %s ST
    daddi $t0,$0,ST
    sd $t0,ind($0)
    daddi r14,$0,p1sys3
    syscall 3
    ;# passaggio parametri per elabora
    move $a1,r1         ;# $a1 = strlen(ST)
    daddi $a0,$0,ST         ;# $a0 = ST
    
    jal elabora
    sd r1, ris($0) ;# metto il return function in ris 

    ;# printf msg2
    daddi $t0,$0,msg2
    sd $t0,p1sys5($0)
    daddi r14,$0,p1sys5
    syscall 5

    ;# i++
    daddi $s0,$s0,1 ;# i++
    j do

elabora: ;# $a0 = ST, $a1 = strlen
    daddi $sp,$sp,-16
    sd $s1,0($sp) ;# i
    sd $s2,8($sp) ;# conta
    daddi $s1,$0,0 ;# i=0
    daddi $s2,$0,0 ;# count = 0

for:    
    slt $t0,$s1,$a1 ;# $t0=0 se $s1 (i) >= strlen(=d)
    beq $t0,$0,return ;# quando i>=strlen c'è return

    ;# if(st[i] -48 <5)
    dadd $t0,$a0,$s1  ;#$t0= &st[i] = $ao (st) + $s1 (i)
    lbu $t1,0($t0) ;# $t1 = st[i]
    daddi $t1,$t1,-48 ;# st[i] -48
    slti $t0,$t1,5 ;# if (st[i]-48 <5) $t0 = 1, quando >= $t0=1
    beq $t0,$0, falso ;# $t0 = 0 --> else, non if
    ;# cnt++, avviene solo se st[i]-48<5 ($t0=1) e poi passa comunque al falso
    daddi $s2,$s2,1 ;# cnt++
falso:
    daddi $s1,$s1,1 ;# i++
    j for

return: ;# da for, ho finito il for e c'è return count
    move r1,$s2 ;# r1=$s2=count

    ld $s1,0($sp)
    ld $s2,8($sp)

    daddi $sp,$sp,16
    jr $ra

end: 
    syscall 0
