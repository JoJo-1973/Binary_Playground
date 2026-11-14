; ==============================================================================
; FILE:           print_images.asm
; PROGETTO:       Binary Playground (Binary_Playground.c64)
; TARGET:         ACME Assembler / MOS 6510 (Commodore 64)
; DESCRIZIONE:    Utilità per stampare l'immagine di un byte (in binario, in
;                 esadecimale o BCD, in decimale senza e con segno), il flag di
;                 Carry e lo stato dei flag NVZC.
; CONTENUTO:      PRINT_CARRY       Stampa il valore del flag di Carry
;                 PRINT_BINARY      Stampa .A in binario
;                 PRINT_HEX_OR_BCD  Stampa .A in esadecimale o in BCD
;                 PRINT_UNSIGNED    Stampa .A in decimale senza segno
;                 PRINT_SIGNED      Stampa .A in decimale con segno
;                 PRINT_FLAGS       Stampa lo stato dei flag selezionati
;                 PRINT_FLAG_CHAR   Stampa il carattere di un flag
; DIPENDENZE:     Nessuna
; REQUISITI ZP:   __BG_COL, ZP_2
; ==============================================================================


; ==============================================================================
; SUBROUTINE: PRINT_BINARY
; ------------------------------------------------------------------------------
; Descrizione:  Stampa .A in binario, dal bit #7 al bit #0, lasciando una
;               posizione vuota tra il nibble superiore e quello inferiore.
;
;               Il driver __PUT_CHAR altera proprie celle di lavoro, il cui
;               contenuto non è garantito dopo la chiamata.
;
; Input:
;   - .A (1 byte, CPU) : Byte da stampare
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .Y, .P (Negative, oVerflow, Zero, Carry)
; Dipendenze Esterne:   Nessuna
; ==============================================================================
!zone Print_Binary

  PRINT_BINARY:
    ldx #8                          ; FOR (Inizializzazione)

  .Loop_Print_Bit:
    cpx #4                          ; FOR (Corpo)
    bne .No_Nibble_Space            ; Se sono già stati stampati 4 bit,

    tay                             ; sposta il cursore di una posizione a
    lda #$1D                        ; destra.
    jsr __PUT_CHAR
    tya

  .No_Nibble_Space:
    rol a                           ; Sposta il bit più significativo nel Carry,
    pha

    lda #0
    adc #"0"                        ; aggiunge il codice ASCII di "0"
    jsr __PUT_CHAR                  ; e stampa il risultato.

    pla

  .Next_Print_Bit:
    dex                             ; NEXT: passa al bit successivo
    bne .Loop_Print_Bit             ; NEXT: ripete finché .X non vale 0

  .Exit_PRINT_BINARY:
    rts

!zone

; ==============================================================================
; SUBROUTINE: PRINT_HEX_OR_BCD
; ------------------------------------------------------------------------------
; Descrizione:  Stampa .A in esadecimale, preceduto da "$". Se il flag di
;               Decimal dell'immagine dei flag (_P_IMAGE) vale 1, stampa le
;               cifre BCD: un nibble maggiore di 9 diventa "?".
;
;               Il driver __PUT_CHAR altera proprie celle di lavoro, il cui
;               contenuto non è garantito dopo la chiamata.
;
; Input:
;   - .A (1 byte, CPU)        : Byte da stampare
;   - _P_IMAGE (1 byte, RAM)  : Immagine dei flag (conta il bit #3, Decimal)
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .Y, .P (Negative, oVerflow, Zero, Carry),
;                       ZP_2 (2 byte)
; Dipendenze Esterne:   <c64/symbols.asm>
;                       "binary_playground.asm"
; ==============================================================================
!zone Print_Hex_Or_BCD

  PRINT_HEX_OR_BCD:
    pha                             ; Salva .A sullo stack.

    lda #%00001000                  ; Controlla il flag di Decimal: se vale 1, ZP_2
    bit _P_IMAGE                    ; punta alla tabella delle cifre BCD.
    bne .Else_BCD_Digits

    lda #<.HEX_DIGITS
    sta ZP_2
    lda #>.HEX_DIGITS
    sta ZP_2+1
    jmp .Print_Dollar

  .Else_BCD_Digits:
    lda #<.BCD_DIGITS
    sta ZP_2
    lda #>.BCD_DIGITS
    sta ZP_2+1

  .Print_Dollar:
    lda #"$"
    jsr __PUT_CHAR

    pla                             ; Recupera .A e lo copia in .X.
    tax

    lsr a                           ; Stampa il nibble superiore.
    lsr a
    lsr a
    lsr a
    tay
    lda (ZP_2),y
    jsr __PUT_CHAR

    txa                             ; Stampa il nibble inferiore.
    and #%00001111
    tay
    lda (ZP_2),y
    jsr __PUT_CHAR

  .Exit_PRINT_HEX_OR_BCD:
    rts

  .HEX_DIGITS:
    !text "0123456789ABCDEF"

  .BCD_DIGITS:
    !text "0123456789??????"

!zone

; ==============================================================================
; SUBROUTINE: PRINT_UNSIGNED
; ------------------------------------------------------------------------------
; Descrizione:  Stampa .A in decimale senza segno, sempre con tre cifre (gli
;               zeri iniziali compresi).
;
;               Il driver __PUT_CHAR altera proprie celle di lavoro, il cui
;               contenuto non è garantito dopo la chiamata.
;
; Input:
;   - .A (1 byte, CPU) : Byte da stampare
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .Y, .P (Negative, oVerflow, Zero, Carry)
; Dipendenze Esterne:   Nessuna
; ==============================================================================
!zone Print_Unsigned

  PRINT_UNSIGNED:
    ; Il valore più alto di un byte è dell'ordine delle centinaia:
    ; le cifre da calcolare sono tre.

    ldx #2                          ; FOR (Inizializzazione)
    ldy #0                          ; .Y conterà la cifra calcolata.

  .Loop_Calc_Power_And_Digit:
    sec                             ; FOR (Corpo)
    sbc .DEC_POWERS,x               ; Sottrae una potenza di 10
    iny                             ; e incrementa la cifra calcolata.

  .Loop_Check_Power:
    bcs .Loop_Calc_Power_And_Digit  ; REPEAT UNTIL: c'è un prestito

    adc .DEC_POWERS,x               ; Il ciclo finisce dopo una sottrazione di troppo,
    dey                             ; quindi riaggiunge la potenza sottratta.

  .Print_Digit:
    pha                             ; Salva .A sullo stack, lo sostituisce con .Y,
    tya
    clc                             ; aggiunge il codice ASCII di "0" e stampa il
    adc #"0"                        ; risultato.
    jsr __PUT_CHAR

    pla                             ; Infine recupera .A e prepara .Y per la cifra
    ldy #0                          ; successiva.

  .Next_Calc_Digit:
    dex                             ; NEXT: passa alla potenza di 10 successiva
    bpl .Loop_Calc_Power_And_Digit  ; NEXT: ripete finché .X non è negativo

  .Exit_PRINT_UNSIGNED:
    rts

  .DEC_POWERS:
    !byte 1, 10, 100

!zone

; ==============================================================================
; SUBROUTINE: PRINT_SIGNED
; ------------------------------------------------------------------------------
; Descrizione:  Stampa .A in decimale con segno: il segno ("+" o "-") seguito
;               dalle tre cifre del valore assoluto (PRINT_UNSIGNED).
;
;               Il driver __PUT_CHAR altera proprie celle di lavoro, il cui
;               contenuto non è garantito dopo la chiamata.
;
; Input:
;   - .A (1 byte, CPU) : Byte da stampare, in complemento a due
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .Y, .P (Negative, oVerflow, Zero, Carry)
; Dipendenze Esterne:   <system/standard.asm>
; ==============================================================================
!zone Print_Signed

  PRINT_SIGNED:
    tay                             ; Salva una copia di .A in .Y.
    bmi .Else_Negative              ; Se il valore è negativo salta avanti,

    lda #"+"                        ; altrimenti carica in .A il codice ASCII di
    +m_Skip2                        ; "+" e salta l'istruzione seguente.

  .Else_Negative:
    lda #"-"                        ; Carica in .A il codice ASCII di "-"
    jsr __PUT_CHAR                  ; e stampa il carattere che è in .A.

    tya                             ; Recupera .A: se è positivo lo stampa
    bpl .Exit_PRINT_SIGNED          ; subito,

    eor #$FF                        ; altrimenti prima ne calcola il complemento a
    clc                             ; due.
    adc #1

  .Exit_PRINT_SIGNED:
    jmp PRINT_UNSIGNED

!zone

; ==============================================================================
; SUBROUTINE: PRINT_FLAGS
; ------------------------------------------------------------------------------
; Descrizione:  Stampa lo stato dei flag N, V, Z e C dell'immagine dei flag
;               (_P_IMAGE), uno per carattere: "0" o "1" per i flag selezionati
;               da _FLAG_MASK, con il colore di sfondo 1, e "-" per gli altri,
;               con il colore di sfondo 0.
;
;               Il driver __PUT_CHAR altera proprie celle di lavoro, il cui
;               contenuto non è garantito dopo la chiamata.
;
; Input:
;   - _FLAG_MASK (1 byte, RAM) : Flag da stampare (bit a 1 nella posizione del
;                                flag in .P)
;   - _P_IMAGE (1 byte, RAM)   : Immagine dei flag
;
; Output:
;   - __BG_COL (1 byte, ZP)    : Sempre VIC_BG0
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .Y, .P (Negative, oVerflow, Zero, Carry),
;                       __BG_COL
; Dipendenze Esterne:   <chip/vic_ii.asm>
;                       "binary_playground.asm"
; ==============================================================================
!zone Print_Flags

  PRINT_FLAGS:
    ldy #"-"                        ; Un flag non interessato si stampa "-", gli
    ldx #VIC_BG0                    ; altri "0" o "1"; il colore di sfondo
    stx __BG_COL                    ; predefinito è il colore di sfondo 0.

  .Test_N:
    lda #%10000000                  ; Controlla se N va stampato: _FLAG_MASK ha a 1 i bit dei
    bit _FLAG_MASK                  ; flag da stampare, quindi se il bit #7 è a 0 salta alla
    beq .No_N_Selected              ; stampa di "-".

    ldy #"0"                        ; Prepara in .Y il codice ASCII di "0"

    bit _P_IMAGE                    ; e controlla N: se è a 0 cambia il colore e
    beq .No_N_Set                   ; lo stampa,

    iny                             ; altrimenti cambia il codice in .Y in "1".

  .No_N_Set:
    ldx #VIC_BG1                    ; I flag interessati si stampano con il colore
    stx __BG_COL                    ; di sfondo 1.

  .No_N_Selected:
    jsr PRINT_FLAG_CHAR

  .Test_V:
    lda #%01000000                  ; Controlla se V va stampato: se il bit #6 di
    bit _FLAG_MASK                  ; _FLAG_MASK è a 0, salta alla stampa di "-".
    beq .No_V_Selected

    ldy #"0"                        ; Prepara in .Y il codice ASCII di "0"

    bit _P_IMAGE                    ; e controlla V: se è a 0 cambia il colore e
    beq .No_V_Set                   ; lo stampa,

    iny                             ; altrimenti cambia il codice in .Y in "1".

  .No_V_Set:
    ldx #VIC_BG1                    ; I flag interessati si stampano con il colore
    stx __BG_COL                    ; di sfondo 1.

  .No_V_Selected:
    jsr PRINT_FLAG_CHAR

  .Test_Z:
    lda #%00000010                  ; Controlla se Z va stampato: se il bit #1 di
    bit _FLAG_MASK                  ; _FLAG_MASK è a 0, salta alla stampa di "-".
    beq .No_Z_Selected

    ldy #"0"                        ; Prepara in .Y il codice ASCII di "0"

    bit _P_IMAGE                    ; e controlla Z: se è a 0 cambia il colore e
    beq .No_Z_Set                   ; lo stampa,

    iny                             ; altrimenti cambia il codice in .Y in "1".

  .No_Z_Set:
    ldx #VIC_BG1                    ; I flag interessati si stampano con il colore
    stx __BG_COL                    ; di sfondo 1.

  .No_Z_Selected:
    jsr PRINT_FLAG_CHAR

  .Test_C:
    lda #%00000001                  ; Controlla se C va stampato: se il bit #0 di
    bit _FLAG_MASK                  ; _FLAG_MASK è a 0, salta alla stampa di "-".
    beq .Exit_PRINT_FLAGS

    ldy #"0"                        ; Prepara in .Y il codice ASCII di "0"

    bit _P_IMAGE                    ; e controlla C: se è a 0 cambia il colore e
    beq .No_C_Set                   ; lo stampa,

    iny                             ; altrimenti cambia il codice in .Y in "1".

  .No_C_Set:
    ldx #VIC_BG1                    ; I flag interessati si stampano con il colore
    stx __BG_COL                    ; di sfondo 1.

  .Exit_PRINT_FLAGS:
    jmp PRINT_FLAG_CHAR

!zone

; ==============================================================================
; SUBROUTINE: PRINT_FLAG_CHAR
; ------------------------------------------------------------------------------
; Descrizione:  Stampa il carattere di un flag, che è in .Y, poi riporta .Y a
;               "-" e il colore di sfondo al colore di sfondo 0, pronti per il
;               flag successivo.
;
;               Il driver __PUT_CHAR altera proprie celle di lavoro, il cui
;               contenuto non è garantito dopo la chiamata.
;
; Input:
;   - .Y (1 byte, CPU)      : Codice ASCII del carattere da stampare
;   - __BG_COL (1 byte, ZP) : Selettore del colore di sfondo (0-3)
;
; Output:
;   - .Y (1 byte, CPU)      : Codice ASCII di "-"
;   - __BG_COL (1 byte, ZP) : Sempre VIC_BG0
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .Y, .P (Negative, oVerflow, Zero, Carry),
;                       __BG_COL
; Dipendenze Esterne:   <chip/vic_ii.asm>
; ==============================================================================
!zone Print_Flag_Char

  PRINT_FLAG_CHAR:
    tya                             ; Copia .Y in .A e stampa il carattere,
    jsr __PUT_CHAR

    ldy #"-"                        ; poi riporta .Y e il colore di sfondo ai
    ldx #VIC_BG0                    ; valori iniziali per il flag successivo.
    stx __BG_COL

  .Exit_PRINT_FLAG_CHAR:
    rts

!zone
