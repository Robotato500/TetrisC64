Add_Score
    ldx Num_Linea_Llena
    jsr Inc_Lines
    txa
    clc
    adc Lines_Offset
    sta Lines_Offset
    cmp #$0a
    bcc Add_Score_Jump
    sec
    sbc #$0a
    sta Lines_Offset
    inc Current_Level
    jsr Act_Speed
Add_Score_Jump
    ldx Num_Linea_Llena
    dex
    beq Add_Score_4
    dex
    beq Add_Score_10
    dex
    beq Add_Score_30
    dex
    beq Add_Score_120
    rts

    
Add_Score_4
    sed
    lda Score_1
    clc
    adc #$04
    sta Score_1
    lda Score_2
    adc #$00
    sta Score_2
    lda Score_3
    adc #$00
    sta Score_3
    lda Score_4
    adc #$00
    sta Score_4
    cld
    rts

Add_Score_10
    sed
    lda Score_1
    clc
    adc #$10
    sta Score_1
    lda Score_2
    adc #$00
    sta Score_2
    lda Score_3
    adc #$00
    sta Score_3
    lda Score_4
    adc #$00
    sta Score_4
    cld
    rts

Add_Score_30
    sed
    lda Score_1
    clc
    adc #$30
    sta Score_1
    lda Score_2
    adc #$00
    sta Score_2
    lda Score_3
    adc #$00
    sta Score_3
    lda Score_4
    adc #$00
    sta Score_4
    cld
    rts

Add_Score_120
    sed
    lda Score_1
    clc
    adc #$20
    sta Score_1
    lda Score_2
    adc #$01
    sta Score_2
    lda Score_3
    adc #$00
    sta Score_3
    lda Score_4
    adc #$00
    sta Score_4
    cld
    rts

Draw_Score
    ldx #$03
    ldy #$06
Draw_Score_1
    lda Score_4,x
    and #%00001111
    sta $451a,y
    dey
    bmi Draw_Score_Rts
    lda Score_4,x
    lsr
    lsr
    lsr
    lsr
    sta $451a,y
    dey
    dex
    jmp Draw_Score_1
Draw_Score_Rts
    jsr Draw_Lines
    jsr Draw_Level
    lda Score_4
    and #%00001111
    sta $451a
    rts

    
Inc_Level
    sed
    lda Level_1
    clc
    adc #$01
    sta Level_1
    lda Level_2
    adc #$00
    sta Level_2
    cld
    rts

Inc_Lines
    sed
    lda Lines_1
    clc
    adc Num_Linea_Llena
    sta Lines_1
    lda Lines_2
    adc #$00
    sta Lines_2
    cld
    rts

Draw_Lines
    lda Lines_1
    and #%00001111
    sta $46fe
    lda Lines_1
    lsr
    lsr
    lsr
    lsr
    sta $46fd
    lda Lines_2
    and #%00001111
    sta $46fc
    rts
    
Draw_Level

    lda Current_Level
    pha
    SED            ; Switch to decimal mode
    LDA #0         ; Ensure the result is clear
    STA Level_1
    STA Level_2
    LDX #8          ; The number of source bits

CNVBIT
    ASL Current_Level         ; Shift out one bit
    LDA Level_1     ; And add into result
    ADC Level_1
    STA Level_1
    LDA Level_2      ; propagating any carry
    ADC Level_2
    STA Level_2
    DEX              ; And repeat for next bit
    BNE CNVBIT
    CLD               ; Back to binary
    
    lda Level_1
    and #%00001111
    sta $453b
    lda Level_1
    lsr
    lsr
    lsr
    lsr
    sta $453a
    lda Level_2
    and #%00001111
    sta $4539
    pla
    sta Current_Level
    rts

Act_Speed
    ldx Current_Level
    cmp #$13
    bcs Act_Speed_29
    lda Speed_Table,x
    sta Timing_Actual
    rts
Act_Speed_29
    lda #$01
    sta Timing_Actual
    rts