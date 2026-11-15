; ==============================================================================
; SUBROUTINE: TOGGLE_CARRY
; ------------------------------------------------------------------------------
; Descrizione:  Inverte il valore del Carry mostrato e lo ristampa, se la pagina
;               corrente lo mostra (byte 7 della struttura diverso da $FF).
;
; Input:
;   - _CURR_PAGE (1 byte, RAM)   : Indice della pagina corrente (0-4)
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _CARRY_IMAGE (1 byte, RAM) : Nuovo valore del Carry (0 o 1)
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .Y, .P (Negative, oVerflow, Zero, Carry),
;                       _CARRY_IMAGE
; Dipendenze Esterne:   "screen_drawing.asm"
; ==============================================================================
!zone Toggle_Carry

  TOGGLE_CARRY:
    lda _CURR_PAGE              ; Controlla se il Carry è richiesto dal layout corrente.
    ldy #LAYOUT_CARRY
    jsr GET_LAYOUT_ITEM

    cmp #$FF
    beq .Exit_TOGGLE_CARRY

    sec                         ; Se sì, inverti il suo stato.
    lda #1
    sbc _CARRY_IMAGE
    sta _CARRY_IMAGE
    jsr PRINT_CARRY

  .Exit_TOGGLE_CARRY:
    rts

!zone
