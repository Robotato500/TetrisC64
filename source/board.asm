Check_Lines
    lda #$ff
    sta Coord_Trabajo_Y
    sta Coord_Trabajo_X
    sta Linea_Llena_1
    sta Linea_Llena_2
    sta Linea_Llena_3
    sta Linea_Llena_4
    lda #$00
    tax
    sta Aux1
    sta Num_Linea_Llena
    
Check_Lines_1

    lda #$ff
    sta Coord_Trabajo_X
    inc Coord_Trabajo_Y
Check_Lines_2
    inc Coord_Trabajo_X
    jsr Get_Block
    tay
    bne Check_Lines_Last
    
    lda Coord_Trabajo_X
    cmp #$09
    bne Check_Lines_2
    
    lda Coord_Trabajo_Y
    sta Linea_Llena_1,x
    inx
Check_Lines_Last
    lda Coord_Trabajo_Y
    cmp #$13
    bne Check_Lines_1       ;en el registro x llevas cuantas lineas están llenas
    stx Num_Linea_Llena
    
    
Borrar_Lineas
    ldx Num_Linea_Llena
    bne Borrar_Lineas_1
    rts
Borrar_Lineas_1
    dex
    lda Linea_Llena_1,x
    sta Coord_Trabajo_Y

Borrar_Lineas_2    
    inc Coord_Trabajo_Y
    lda #$09
    sta Coord_Trabajo_X
    
Borrar_Lineas_3
    jsr Get_Block
    dec Coord_Trabajo_Y
    tay
    bne Borrar_Lineas_Clear
    
    jsr Set_Block
    jmp Borrar_Lineas_Set
Borrar_Lineas_Clear
    jsr Clear_Block
Borrar_Lineas_Set
    inc Coord_Trabajo_Y
    dec Coord_Trabajo_X
    bpl Borrar_Lineas_3
    
    lda Coord_Trabajo_Y
    cmp #$14
    bne Borrar_Lineas_2
    
    txa
    bne Borrar_Lineas_1
    
    jsr Add_Score
    jsr Draw_Score
    jsr Screen_Refresh
    
    rts   
