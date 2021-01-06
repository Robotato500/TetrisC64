


Ref_Piece                       ;cambia las coordenadas de los bloques de la pieza según el tipo y
                                ;la rotación, si tiene el carry no borra la anterior. Devuelve
                                ;carry 0 si la ha podido dibujar y carry 1 si no
    php                            
    lda Current_Piece_Type      ;multiplica por 32 el tipo de pieza
    asl
    asl
    asl
    asl
    asl
    sta Aux1
    lda Current_Piece_Rot       ;y la rotacion mod 4 (porque solo hay 4 estados posibles)
    and #%00000011
    asl
    asl
    asl
    clc
    adc Aux1
    clc
    adc #$07
    tax
Ref_Piece_Increment             ;le añades los incrementos
    lda Pivot_X
    clc
    adc Del_Pivot_X
    sta Next_Pivot_X
    lda #$00
    sta Del_Pivot_X
    lda Pivot_Y
    clc
    adc Del_Pivot_Y
    sta Next_Pivot_Y
    lda #$00
    sta Del_Pivot_Y
    ldy #$04
    inx
Ref_Piece_Loop                ;calcula las coordenadas de cada bloque basandote en la tabla de desfases
                              ;de las piezas con respecto al pivote (en data.asm) y si no hay conflicto
                              ;la redibuja y devuelve Carry 0. Si hay conflicto no la redibuja y devuelve
                              ;Carry 1
    dey
    dex
    lda Piece_Table_0,x
    clc
    adc Next_Pivot_Y
    sta Next_Pivot_Y,y
    sta Coord_Trabajo_Y
    dex
    lda Piece_Table_0,x
    clc
    adc Next_Pivot_X
    sta Next_Pivot_X,y
    sta Coord_Trabajo_X
    jsr Get_Block
    sta Aux1
    lda Aux1
    beq Ref_Piece_NoGo
    dex
    dey
    inx
    iny
    bne Ref_Piece_Loop
    plp
    bcs Ref_Piece_DontEr
    jsr Erase_Current
    
Ref_Piece_DontEr
    ldx #$04
Ref_Piece_OK
    dex
    lda Next_Pivot_X,x
    sta Pivot_X,x
    lda Next_Pivot_Y,x
    sta Pivot_Y,x
    inx
    dex
    bne Ref_Piece_OK
    jsr Draw_Current
    clc
    rts
Ref_Piece_NoGo
    plp
    sec
    rts
    
    
    
    
    
New_Piece                   ;Nueva Pieza
    lda Next_Piece_Type     ;haz que el tipo de la nueva pieza sea el de la next
    sta Current_Piece_Type
    jsr Get_RandNum         ;y la siguiente next aleatoria
    sta Next_Piece_Type
    
    lda #$00
    sta Current_Piece_Rot
    
New_Piece_Draw_Next
    lda Current_Piece_Type
    pha
    lda Next_Piece_Type
    sta Current_Piece_Type
    lda #$13
    sta Pivot_X
    lda #$04
    sta Pivot_Y
    
    jsr Erease_Next
    
    sec
    jsr Ref_Piece_Next
    
    pla
    sta Current_Piece_Type
    lda #$05                ;y en el 5, 19
    sta Pivot_X
    lda #$13
    sta Pivot_Y
    sec
    jsr Ref_Piece           ;la dibujas, pero no borres la anterior picha
    bcs New_Piece_To_Game_Over  ;si estaba ocupado es que game over
    lda #$00
    sta Irq_Timer          ;y te vas a esperar un segundo para dar un respiro al jugador
New_Piece_Wait
    lda Irq_Timer
    cmp #$28
    bcc New_Piece_Wait
    rts
New_Piece_To_Game_Over
    jmp Game_Over
    
 

    
Ref_Piece_Next                  
    php                            
    lda Current_Piece_Type      ;multiplica por 32 el tipo de pieza
    asl
    asl
    asl
    asl
    asl
    sta Aux1
    lda Current_Piece_Rot       ;y la rotacion mod 4 (porque solo hay 4 estados posibles)
    and #%00000011
    asl
    asl
    asl
    clc
    adc Aux1
    clc
    adc #$07
    tax            
    lda Pivot_X
    sta Next_Pivot_X
    lda Pivot_Y
    sta Next_Pivot_Y
    ldy #$04
    inx
Ref_Piece_Next_Loop           ;calcula las coordenadas de cada bloque basandote en la tabla de desfases
                              ;de las piezas con respecto al pivote (en data.asm) y si no hay conflicto
                              ;la redibuja y devuelve Carry 0. Si hay conflicto no la redibuja y devuelve
                              ;Carry 1
    dey
    dex
    lda Piece_Table_0,x
    clc
    adc Next_Pivot_Y
    sta Next_Pivot_Y,y
    sta Coord_Trabajo_Y
    dex
    lda Piece_Table_0,x
    clc
    adc Next_Pivot_X
    sta Next_Pivot_X,y
    sta Coord_Trabajo_X
    dex
    dey
    inx
    iny
    bne Ref_Piece_Next_Loop
    plp
    bcs Ref_Piece_Next_DontEr
    jsr Erase_Current
    
Ref_Piece_Next_DontEr
    ldx #$04
Ref_Piece_Next_OK
    dex
    lda Next_Pivot_X,x
    sta Pivot_X,x
    lda Next_Pivot_Y,x
    sta Pivot_Y,x
    inx
    dex
    bne Ref_Piece_Next_OK
    jsr Draw_Current
    clc
    rts

    