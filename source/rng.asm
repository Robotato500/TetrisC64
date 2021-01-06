
    
Get_RandNum

    txa
    pha
    ldx Rand_Pointer
    lda RNG_Table,x
    
    sec
Mod7
    sbc #$07
    bcs Mod7
    adc #$07
    
    sta Aux1
    pla
    tax
    lda Aux1
    rts