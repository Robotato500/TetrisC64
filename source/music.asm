Music_Init = $1800
Music_Play = $1806


Sid_Init_1
    lda #$00
    tax
    tay
    jsr Music_Init
    rts

Sid_Init_2
    lda #$01
    ldx #$00
    ldy #$00
    jsr Music_Init
    rts