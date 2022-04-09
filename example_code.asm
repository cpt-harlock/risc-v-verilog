begin:
add x3, x2, x2
sub x5, x1, x2
lb x3, 128(x0)
lh x3, 0(x2)
lw x3, 0(x2)
lbu x3, 128(x0)
lhu x3, 128(x0)
addi x3, x2, 3
slli x3, x2, 3
slti x3, x2, -1
sltiu x3, x2, -1
xori x3, x2, 2
srli x3, x2, 1
# in order to have a msb of 1
lui x2, 1048575
srai x3, x2, 1
ori x3, x2, 1
andi x3, x2, 0
auipc x3, 4
sb x5, 0(x0)
sh x5, 0(x0)
sw x5, 0(x0)
sll x3, x5, x1 
slt x3, x5, x1 
sltu x3, x5, x1 
xor x3, x5, x1 
srl x3, x5, x1 
sra x3, x5, x1 
or x3, x5, x1 
and x3, x5, x1 
# branch eq section
xor x2, x2, x2
xor x1, x1, x1
addi x1, x1, 8
addi x2, x2, 7
branch_eq:
addi x2, x2, 1
beq x1, x2, branch_eq
# branch neq section
addi x1, x0, 8
addi x2, x0, 6
branch_neq:
addi x2, x2, 1
bne x1, x2, branch_neq
# branch lt section
addi x1, x0, 8
addi x2, x0, 6
branch_lt:
addi x2, x2, 1
blt x2, x1, branch_lt
# branch gte section 
addi x1, x0, 8
addi x2, x0, 6
branch_gte:
addi x2, x2, 1
bge x1, x2, branch_gte
# branch ltu section
addi x1, x0, 8
addi x2, x0, -1
branch_ltu:
#should skip branch 
bltu x2, x1, branch_ltu
# branch gtu section 
addi x1, x0, -1
addi x2, x0, -3
branch_gteu:
addi x1, x1, -1
bgeu x1, x2, branch_gteu
#jalr x3, x0, 0 
jal x3, begin
nop
