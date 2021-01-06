SCNKEY = $ff9f
GETKEY = $ffe4


Process_Inputs
    jsr SCNKEY
    jsr GETKEY       ;rutina del kernal para leer el teclado

Process_W
    cmp #$57
    bne Process_A
    inc Rand_Pointer
    inc Current_Piece_Rot
    clc
    jsr Ref_Piece
    bcc Process_Inputs_Rts
    dec Current_Piece_Rot
    rts
Process_A
    cmp #$41
    bne Process_D
    inc Rand_Pointer
    lda #$ff
    sta Del_Pivot_X
    clc
    jsr Ref_Piece
    clc
    rts
Process_D
    cmp #$44
    bne Process_S
    inc Rand_Pointer
    lda #$01
    sta Del_Pivot_X
    clc
    jsr Ref_Piece
    clc
    rts    
Process_S
    cmp #$53
    bne Process_Inputs_Rts
    inc Rand_Pointer
    lda #$ff
    sta Del_Pivot_Y
    clc
    jsr Ref_Piece
    bcc Process_Inputs_Rts
    clc
    jsr Game_Loop_Collision
    
Process_Inputs_Rts
    rts
 
    
    
Wait_For_CR
    jsr SCNKEY
    jsr GETKEY
    cmp #$0d
    bne Wait_For_CR
    rts
    