!to "main.prg", cbm




PRA = $dc00         ;registros de la cia 1
DDRA = $dc02

PRB = $dc01
DDRB = $dc03



Irq_Timer = $9010
Irq_Timer_2 = $9011

Music_Playing = $9012

Score_4 = $9020
Score_3 = $9021
Score_2 = $9022
Score_1 = $9023

Lines_2 = $9025
Lines_1 = $9026

Level_2 = $9027
Level_1 = $9028
Current_Level = $9029


Current_Color = $9048
Current_Piece_Rot = $9049
Current_Piece_Type = $9060
Next_Piece_Type = $9061

Del_Pivot_X = $9062
Del_Pivot_Y = $9063

Linea_Llena_1 = $9064
Linea_Llena_2 = $9065
Linea_Llena_3 = $9066
Linea_Llena_4 = $9067
Num_Linea_Llena = $9068
Timing_Actual = $9069
Lines_Offset = $906a

Rand_Pointer = $906b

Aux1 = $60

Pivot_X = $9050
Pivot_Y = $9054
Next_Pivot_X = $9058
Next_Pivot_Y = $905c

CursorL = $61
CursorH = $62

Coord_Trabajo_X = $9013
Coord_Trabajo_Y = $9014

Virtual_Space = $9500



* = $0801

!basic Main


* = $0850
Main
    cld
    lda #$00
    sta Music_Playing
    jsr Sid_Init_1
    jsr Irq_Init
    jsr Bitmap_Init
    lda #$01
    sta Music_Playing
    jsr Wait_For_CR
    lda #$00
    sta Music_Playing
    jsr Screen_Init
    

New_Game
    jsr Screen_Init
    lda #$24
    sta Timing_Actual
    lda #$00
    sta Irq_Timer
    sta Score_1
    sta Score_2
    sta Score_3
    sta Score_4
    sta Lines_1
    sta Lines_2
    sta Level_1
    sta Level_2
    sta Current_Level
    sta Lines_Offset
    
    jsr Virtual_Init
    jsr Screen_Refresh
    jsr Draw_Score
    lda #$01
    sta Music_Playing
    jsr Sid_Init_2
    
    jsr Get_RandNum
    sta Next_Piece_Type
    jsr New_Piece
    
    
Game_Loop_1
    jsr Process_Inputs
    lda Irq_Timer
    cmp Timing_Actual
    bcc Game_Loop_1
Game_Loop_2
    lda #$00
    sta Irq_Timer
    lda #$ff
    sta Del_Pivot_Y
    clc
    jsr Ref_Piece
    bcc Game_Loop_1
    clc
Game_Loop_Collision
    jsr Fix_Current
    jsr Check_Lines   ;Chequea si hay que quitar lineas, y si es así actualiza los puntos, la velocidad y 
                      ;la pantalla
    jsr New_Piece
    jmp Game_Loop_1

Game_Over
    pla
    lda #$00
    sta Music_Playing
    jsr Virtual_Fill
    jsr Write_Game_Over
    jsr Sid_Init_1
    lda #$01
    sta Music_Playing
    jsr Wait_For_CR
    lda #$00
    sta Music_Playing
    jmp New_Game
       
!source "spaces.asm"
!source "rng.asm"
!source "screen.asm"
!source "interrupts.asm"
!source "music.asm"
!source "pieces.asm"
!source "inputs.asm"
!source "board.asm"
!source "score.asm"
    

* = $1800
!bin "../media/music.sid",, $7e


!source "data.asm"
