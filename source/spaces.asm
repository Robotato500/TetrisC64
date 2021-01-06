Virtual_Init
    lda #$16
    sta Coord_Trabajo_Y
    lda #$0a
    sta Coord_Trabajo_X
Virtual_Init_1
    dec Coord_Trabajo_X
Virtual_Init_2
    dec Coord_Trabajo_Y
    jsr Clear_Block
    dec Coord_Trabajo_Y
    inc Coord_Trabajo_Y
    bne Virtual_Init_2
    lda #$16
    sta Coord_Trabajo_Y
    inc Coord_Trabajo_X
    dec Coord_Trabajo_X
    bne Virtual_Init_1
    rts
    
    
Virtual_Fill
    lda #$14
    sta Coord_Trabajo_Y
    lda #$0a
    sta Coord_Trabajo_X
Virtual_Fill_1
    dec Coord_Trabajo_X
Virtual_Fill_2
    dec Coord_Trabajo_Y
    jsr Set_Block
    ;lda #$01
    ;jsr Wait
    lda Current_Color
    pha
    lda #$01
    sta Current_Color
    jsr Set_Video
    lda #01
    jsr Wait
    pla
    sta Current_Color
    dec Coord_Trabajo_Y
    inc Coord_Trabajo_Y
    bne Virtual_Fill_2
    lda #$14
    sta Coord_Trabajo_Y
    inc Coord_Trabajo_X
    dec Coord_Trabajo_X
    bne Virtual_Fill_1
    rts




Get_Block         ;devuelve (en A) el valor del espacio virtual de las coor. de trabajo
    lda Coord_Trabajo_Y
    clc
    adc #<Virtual_Space
    sta CursorL
    lda Coord_Trabajo_X
    clc
    adc #>Virtual_Space
    sta CursorH
    sty Aux1
    ldy #$00
    lda (CursorL),y
    ldy Aux1
    rts
    
    
Clear_Block         ;quita bloque (guarda 1) en el valor del espacio virtual de las coord. de trabajo
    lda Coord_Trabajo_Y
    clc
    adc #<Virtual_Space
    sta CursorL
    lda Coord_Trabajo_X
    clc
    adc #>Virtual_Space
    sta CursorH
    sty Aux1
    ldy #$00
    lda #$01
    sta (CursorL),y
    ldy Aux1
    rts
 
Set_Block         ;pone bloque (guarda 0) en el valor del espacio virtual de las coord. de trabajo
    lda Coord_Trabajo_Y
    clc
    adc #<Virtual_Space
    sta CursorL
    lda Coord_Trabajo_X
    clc
    adc #>Virtual_Space
    sta CursorH
    sty Aux1
    ldy #$00
    tya
    sta (CursorL),y
    ldy Aux1   
    rts

    
Find_Video              ;pone bloque en la dirección de vídeo correspondiente y del color en Current_Color

    lda #$47            ;la direccion inicial
    sta CursorH
    lda #$7f
    sta CursorL
    ldy Coord_Trabajo_Y ;carga la coordenada y
    iny                 ;incrementa para que el decremento de despues no cuente la primera vez   
Find_Vid_1             ;resta 40 a el numero de 16 bits en CursorL y CursorH tantas veces como haya coordenada y
    dey                 ;decrementa
    beq Find_Vid_2       ;si es 0 has terminado esta parte
    lda CursorL
    sec                 ;pon el carry para
    sbc #$28            ;restar 40 (cada linea tiene 40 caracteres)
    sta CursorL         ;lo guardas
    lda CursorH         ;y ahora restas solo el carry al byte alto
    sbc #$00
    sta CursorH
    jmp Find_Vid_1     ;loop
Find_Vid_2
    rts
 
    
Set_Video

    lda Coord_Trabajo_Y
    cmp #$14
    bcs Set_Video_Rts
    jsr Find_Video      ;ya tenemos la direccion del comienzo de la linea, asi que
    ldy Coord_Trabajo_X ;cargamos la coordenada x al registro Y
    lda #$a6            ;y guardamos el caracter del bloque
    sta (CursorL),y     ;registro Y (coordenada x) más lejos del comienzo de la linea
    lda CursorH         ;y ahora cambiamos el byte alto para hacer lo mismo pero en la memoria de color
    clc
    adc #$94
    sta CursorH
    lda Current_Color   ;con el color actual
    sta (CursorL),y
Set_Video_Rts
    rts

    
Clear_Video
    lda Coord_Trabajo_Y
    cmp #$14
    bcs Clear_Video_Rts
    jsr Find_Video
    ldy Coord_Trabajo_X
    lda #$67
    sta (CursorL),y
Clear_Video_Rts
    rts

    
Fix_Current
    ldy #$04
Fix_Current_1
    dey
    lda Pivot_X,y
    sta Coord_Trabajo_X
    lda Pivot_Y,y
    sta Coord_Trabajo_Y
    jsr Set_Block
    iny
    dey
    bne Fix_Current_1
    lda #$ff
    sta Current_Piece_Type
    jsr Draw_Current
    rts
    