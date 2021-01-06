Bitmap_Init
    lda $dd00
    ora #%00000011
    and #%11111110
    sta $dd00
    
    lda #$00
    sta $d020
    
    lda $d011
    and #%10011111
    ora #%00100000
    sta $d011
    
    lda $d018
    and #%00000111
    ora #%00011000
    sta $d018
    
    ldx #$00
    
Bitmap_Init_1
    lda #$10      ;fondo negro y foreground blanco
    sta $4400,x
    sta $4500,x
    sta $4600,x
    sta $46e8,x
    
    dex
    bne Bitmap_Init_1
    
    rts
    
    
    
Screen_Init    
    lda #$00        ;hace negro el borde y gris oscuro el fondo 1 y negro el fondo 2 y el fondo 3
    sta $d020
    sta $d022
    lda #$0b
    sta $d021
    lda #$00
    sta $d023
    
    lda $d011
    and #%10011111
    ora #%01000000
    sta $d011
    
    lda $d018
    and #%00000001
    ora #%00010100
    sta $d018
    
    
    
    
    ldx #$00
Clr_Scrn            ;los colores de la pantalla
    lda $8000,x
    sta $d800,x
    lda $8100,x
    sta $d900,x
    lda $8200,x
    sta $da00,x
    lda $82e8,x
    sta $dae8,x
    
    lda $8400,x
    sta $4400,x
    lda $8500,x
    sta $4500,x
    lda $8600,x
    sta $4600,x
    lda $86e8,x
    sta $46e8,x
    
    dex
    bne Clr_Scrn
    
    rts
    


    
    
    
Draw_Current                  ;dibuja la pieza activa en la pantalla
    ldx #$04                  ;vamos a tener que repetir esto 4 veces
Draw_Loop_1                   
    dex                       ;decrementa el x
    lda Pivot_X,x             ;carga la coordenada x del bloque x de la pieza (están el pivot y 3 mas)
    sta Coord_Trabajo_X       ;y la guardas en la coordenada de trabajo x
    lda Pivot_Y,x             ;lo mismo pero con la coordenada y del mismo bloque
    sta Coord_Trabajo_Y
    lda Current_Piece_Type    ;vamos a calcular el color que tendrá la pieza, el código del color (hay 16,
                              ;ver una tabla en internet) se calcula sumado 2 al tipo de pieza (para que
                              ;cada una tenga uno distinto pero no sean si blanco ni negro, que son los
                              ;primeros)
    clc
    adc #$02
    cmp #$06                  ;ahora bien, si es 6 (azul oscuro) sustituyelo por 0a (10 en hexadecimal,
                              ;es rosa) porque se ve muy feo
    bne Draw_2
    lda #$0a
Draw_2
    sta Current_Color         ;y pues ese es el color actual
    jsr Set_Video             ;salta a la subrutina de dibujar un bloque
    inx
    dex
    bne Draw_Loop_1           ;si el registro x todavía no es 0 quedan bloques de la pieza por dibujar
    rts
    
    
Erase_Current                 ;borra la pieza actual, funciona igual que la anterior pero sin lo de los
                              ;colores y llama a la de borrar bloque en vez de a la de dibujar
    ldx #$04
Erase_Loop_1
    dex
    lda Pivot_X,x
    sta Coord_Trabajo_X
    lda Pivot_Y,x
    sta Coord_Trabajo_Y
    jsr Clear_Video
    inx
    dex
    bne Erase_Loop_1
    rts
    
    
    
Screen_Refresh
    lda #$14
    sta Coord_Trabajo_Y
    lda #$0a
    sta Coord_Trabajo_X
    
Screen_Refresh_1
    dec Coord_Trabajo_X
Screen_Refresh_2
    dec Coord_Trabajo_Y
    jsr Get_Block
    tax
    bne Screen_Refresh_Clear
    lda #$01
    sta Current_Color
    jsr Set_Video
    jmp Screen_Refresh_Set
Screen_Refresh_Clear
    jsr Clear_Video
Screen_Refresh_Set
    dec Coord_Trabajo_Y
    inc Coord_Trabajo_Y
    bne Screen_Refresh_2
    lda #$14
    sta Coord_Trabajo_Y
    inc Coord_Trabajo_X
    dec Coord_Trabajo_X
    bne Screen_Refresh_1
    rts

Write_Game_Over
    ldx #$06
Write_Game_Over_1
    dex
    lda Mensaje_Game_Over_1,x
    sta $45f1,x
    inx
    dex
    bne Write_Game_Over_1
    ldx #$06
Write_Game_Over_2
    dex
    lda Mensaje_Game_Over_2,x
    sta $4619,x
    inx
    dex
    bne Write_Game_Over_2
    ldx #$06
Write_Game_Over_3
    dex
    lda Mensaje_Game_Over_3,x
    sta $45c9,x
    inx
    dex
    bne Write_Game_Over_3
    ldx #$06
Write_Game_Over_4
    dex
    lda Mensaje_Game_Over_3,x
    sta $4641,x
    inx
    dex
    bne Write_Game_Over_4
    rts
    
Erease_Next
    lda #$27
    ldx #$07
Erease_Next_1
    dex
    sta $46ef,x
    inx
    dex
    bne Erease_Next_1
    ldx #$07
Erease_Next_2
    dex
    sta $4717,x
    inx
    dex
    bne Erease_Next_2
    ldx #$07
Erease_Next_3
    dex
    sta $473f,x
    inx
    dex
    bne Erease_Next_3
    ldx #$07
Erease_Next_4
    dex
    sta $46c7,x
    inx
    dex
    bne Erease_Next_4
    
    rts
    
    
    
    
    
    