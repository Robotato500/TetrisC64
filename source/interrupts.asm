Irq_Init
    sei             ;desactiva los interrupts
    ldy #$7f        ; $7f = %01111111
    sty $dc0d       ; Turn off CIAs Timer interrupts
    sty $dd0d       ; Turn off CIAs Timer interrupts
    lda $dc0d       ; cancel all CIA-IRQs in queue/unprocessed
    lda $dd0d       ; cancel all CIA-IRQs in queue/unprocessed
    
    lda #%00000001  ;queremos interrupts por el raster
    sta $d01a
    
    lda #<Irq_Routine ;ahora la rutina de los interrupts es la que yo me he inventado, guardando
    ldx #>Irq_Routine ;su direccion en el vector
    sta $0314
    stx $0315
    
    lda #$00        ;que el interrupt ocurra en la primera línea del raster
    sta $d012
    lda $d011
    and #$7f        ;teniendo en cuenta que el bit 0 de esta hace del bit 9 en el numero de linea de raster
    sta $d011       
    
    cli             ;y ya hemos terminado de configurar los interrupts por lo que podemos volver
                    ;a activar los interrupt
    rts

Irq_Routine
    dec $d019     ;vale me he enterado del interrupt puedes relajarte
    inc Irq_Timer
    inc Rand_Pointer
    lda Music_Playing
    beq Irq_End
    jsr Music_Play
Irq_End
    jmp $ea81


    
Wait
    sta Aux1
    lda #$00
    sta Irq_Timer
Wait_1
    lda Irq_Timer
    cmp Aux1
    bcc Wait_1
    rts