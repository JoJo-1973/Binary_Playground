; ==============================================================================
; FILE:           opcode_tests.asm
; PROGETTO:       Binary Playground (Binary_Playground.c64)
; TARGET:         ACME Assembler / MOS 6510 (Commodore 64)
; DESCRIZIONE:    Esegue le istruzioni mostrate da Binary Playground sui valori
;                 correnti. Per ognuna riporta il risultato, il registro di
;                 stato, la maschera dei flag che interessano e la riga di
;                 schermo dove stampare il risultato.
; CONTENUTO:      TEST_INC      INX sul valore della memoria
;                 TEST_DEC      DEX sul valore della memoria
;                 TEST_CMP      CMP tra .A e la memoria
;                 TEST_SBC      SBC tra .A e la memoria
;                 TEST_BIT      BIT tra .A e la memoria
;                 TEST_AND      AND tra .A e la memoria
;                 TEST_ORA      ORA tra .A e la memoria
;                 TEST_EOR      EOR tra .A e la memoria
;                 TEST_ADC_HEX  ADC binario tra .A e la memoria
;                 TEST_SBC_HEX  SBC binario tra .A e la memoria
;                 TEST_ADC_BCD  ADC decimale tra .A e la memoria
;                 TEST_SBC_BCD  SBC decimale tra .A e la memoria
;                 TEST_ASL1     ASL su .A, 1 volta
;                 TEST_ASL2     ASL su .A, 2 volte
;                 TEST_ASL3     ASL su .A, 3 volte
;                 TEST_ASL4     ASL su .A, 4 volte
;                 TEST_LSR1     LSR su .A, 1 volta
;                 TEST_LSR2     LSR su .A, 2 volte
;                 TEST_LSR3     LSR su .A, 3 volte
;                 TEST_LSR4     LSR su .A, 4 volte
;                 TEST_ROL1     ROL su .A, 1 volta
;                 TEST_ROL2     ROL su .A, 2 volte
;                 TEST_ROL3     ROL su .A, 3 volte
;                 TEST_ROL4     ROL su .A, 4 volte
;                 TEST_ROR1     ROR su .A, 1 volta
;                 TEST_ROR2     ROR su .A, 2 volte
;                 TEST_ROR3     ROR su .A, 3 volte
;                 TEST_ROR4     ROR su .A, 4 volte
; DIPENDENZE:     Nessuna
; REQUISITI ZP:   Nessuno
; ==============================================================================

; ==============================================================================
; SUBROUTINE: TEST_INC
; ------------------------------------------------------------------------------
; Descrizione:  Esegue INX sul valore della memoria. Lascia il risultato in
;               _RES_IMAGE, il registro di stato in _P_IMAGE, i flag da mostrare
;               in _FLAG_MASK, la riga in .X.
;
; Input:
;   - _M_IMAGE (1 byte, RAM)   : Valore della cella di memoria
;
; Output:
;   - _RES_IMAGE (1 byte, RAM) : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)   : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM) : Maschera dei flag che interessano
;   - .X (1 byte, CPU)         : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Inc

  TEST_INC:
    ldx _M_IMAGE                ; Esegue l'istruzione.
    inx
    stx _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%10000010              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #11                     ; Imposta la riga dove stampare.

  .Exit_TEST_INC:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_DEC
; ------------------------------------------------------------------------------
; Descrizione:  Esegue DEX sul valore della memoria. Lascia il risultato in
;               _RES_IMAGE, il registro di stato in _P_IMAGE, i flag da mostrare
;               in _FLAG_MASK, la riga in .X.
;
; Input:
;   - _M_IMAGE (1 byte, RAM)   : Valore della cella di memoria
;
; Output:
;   - _RES_IMAGE (1 byte, RAM) : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)   : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM) : Maschera dei flag che interessano
;   - .X (1 byte, CPU)         : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Dec

  TEST_DEC:
    ldx _M_IMAGE                ; Esegue l'istruzione.
    dex
    stx _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%10000010              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #16                     ; Imposta la riga dove stampare.

  .Exit_TEST_DEC:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_CMP
; ------------------------------------------------------------------------------
; Descrizione:  Porta il Carry al valore di _CARRY_IMAGE ed esegue CMP tra .A e
;               la memoria. Il risultato è .A, perché l'istruzione non lo
;               modifica. Lascia il risultato in _RES_IMAGE, il registro di
;               stato in _P_IMAGE, i flag che interessano in _FLAG_MASK e la
;               riga nel registro X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)     : Valore di .A
;   - _M_IMAGE (1 byte, RAM)     : Valore della cella di memoria
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _RES_IMAGE (1 byte, RAM)   : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)     : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM)   : Maschera dei flag che interessano
;   - .X (1 byte, CPU)           : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Cmp

  TEST_CMP:
    lda _CARRY_IMAGE            ; Porta il Carry al valore richiesto.
    ror a

    lda _A_IMAGE                ; Esegue l'istruzione.
    cmp _M_IMAGE
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%10000011              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #12                     ; Imposta la riga dove stampare.

  .Exit_TEST_CMP:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_SBC
; ------------------------------------------------------------------------------
; Descrizione:  Porta il Carry al valore di _CARRY_IMAGE ed esegue SBC tra .A e
;               la memoria. Lascia il risultato in _RES_IMAGE, il registro di
;               stato in _P_IMAGE, i flag che interessano in _FLAG_MASK e la
;               riga nel registro X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)     : Valore di .A
;   - _M_IMAGE (1 byte, RAM)     : Valore della cella di memoria
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _RES_IMAGE (1 byte, RAM)   : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)     : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM)   : Maschera dei flag che interessano
;   - .X (1 byte, CPU)           : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, oVerflow, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Sbc

  TEST_SBC:
    lda _CARRY_IMAGE            ; Porta il Carry al valore richiesto.
    ror a

    lda _A_IMAGE                ; Esegue l'istruzione.
    sbc _M_IMAGE
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%11000011              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #17                     ; Imposta la riga dove stampare.

  .Exit_TEST_SBC:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_BIT
; ------------------------------------------------------------------------------
; Descrizione:  Esegue BIT tra .A e la memoria. Il risultato è .A, perché
;               l'istruzione non lo modifica. Lascia il risultato in _RES_IMAGE,
;               il registro di stato in _P_IMAGE, i flag che interessano in
;               _FLAG_MASK e la riga nel registro X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)   : Valore di .A
;   - _M_IMAGE (1 byte, RAM)   : Valore della cella di memoria
;
; Output:
;   - _RES_IMAGE (1 byte, RAM) : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)   : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM) : Maschera dei flag che interessano
;   - .X (1 byte, CPU)         : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, oVerflow, Zero)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Bit

  TEST_BIT:
    lda _A_IMAGE                ; Esegue l'istruzione.
    bit _M_IMAGE
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%11000010              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #22                     ; Imposta la riga dove stampare.

  .Exit_TEST_BIT:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_AND
; ------------------------------------------------------------------------------
; Descrizione:  Esegue AND tra .A e la memoria. Lascia il risultato in
;               _RES_IMAGE, il registro di stato in _P_IMAGE, i flag da mostrare
;               in _FLAG_MASK, la riga in .X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)   : Valore di .A
;   - _M_IMAGE (1 byte, RAM)   : Valore della cella di memoria
;
; Output:
;   - _RES_IMAGE (1 byte, RAM) : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)   : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM) : Maschera dei flag che interessano
;   - .X (1 byte, CPU)         : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_And

  TEST_AND:
    lda _A_IMAGE                ; Esegue l'istruzione.
    and _M_IMAGE
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%10000010              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #12                     ; Imposta la riga dove stampare.

  .Exit_TEST_AND:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_ORA
; ------------------------------------------------------------------------------
; Descrizione:  Esegue ORA tra .A e la memoria. Lascia il risultato in
;               _RES_IMAGE, il registro di stato in _P_IMAGE, i flag da mostrare
;               in _FLAG_MASK, la riga in .X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)   : Valore di .A
;   - _M_IMAGE (1 byte, RAM)   : Valore della cella di memoria
;
; Output:
;   - _RES_IMAGE (1 byte, RAM) : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)   : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM) : Maschera dei flag che interessano
;   - .X (1 byte, CPU)         : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Ora

  TEST_ORA:
    lda _A_IMAGE                ; Esegue l'istruzione.
    ora _M_IMAGE
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%10000010              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #17                     ; Imposta la riga dove stampare.

  .Exit_TEST_ORA:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_EOR
; ------------------------------------------------------------------------------
; Descrizione:  Esegue EOR tra .A e la memoria. Lascia il risultato in
;               _RES_IMAGE, il registro di stato in _P_IMAGE, i flag da mostrare
;               in _FLAG_MASK, la riga in .X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)   : Valore di .A
;   - _M_IMAGE (1 byte, RAM)   : Valore della cella di memoria
;
; Output:
;   - _RES_IMAGE (1 byte, RAM) : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)   : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM) : Maschera dei flag che interessano
;   - .X (1 byte, CPU)         : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Eor

  TEST_EOR:
    lda _A_IMAGE                ; Esegue l'istruzione.
    eor _M_IMAGE
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%10000010              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #22                     ; Imposta la riga dove stampare.

  .Exit_TEST_EOR:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_ADC_HEX
; ------------------------------------------------------------------------------
; Descrizione:  Porta il Carry al valore di _CARRY_IMAGE ed esegue ADC binario
;               tra .A e la memoria. Lascia il risultato in _RES_IMAGE, il
;               registro di stato in _P_IMAGE, i flag che interessano in
;               _FLAG_MASK e la riga nel registro X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)     : Valore di .A
;   - _M_IMAGE (1 byte, RAM)     : Valore della cella di memoria
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _RES_IMAGE (1 byte, RAM)   : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)     : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM)   : Maschera dei flag che interessano
;   - .X (1 byte, CPU)           : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, oVerflow, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Adc_Hex

  TEST_ADC_HEX:
    lda _CARRY_IMAGE            ; Porta il Carry al valore richiesto.
    ror a

    lda _A_IMAGE                ; Esegue l'istruzione.
    adc _M_IMAGE
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%11000011              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #12                     ; Imposta la riga dove stampare.

  .Exit_TEST_ADC_HEX:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_SBC_HEX
; ------------------------------------------------------------------------------
; Descrizione:  Porta il Carry al valore di _CARRY_IMAGE ed esegue SBC binario
;               tra .A e la memoria. Lascia il risultato in _RES_IMAGE, il
;               registro di stato in _P_IMAGE, i flag che interessano in
;               _FLAG_MASK e la riga nel registro X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)     : Valore di .A
;   - _M_IMAGE (1 byte, RAM)     : Valore della cella di memoria
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _RES_IMAGE (1 byte, RAM)   : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)     : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM)   : Maschera dei flag che interessano
;   - .X (1 byte, CPU)           : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, oVerflow, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Sbc_Hex

  TEST_SBC_HEX:
    lda _CARRY_IMAGE            ; Porta il Carry al valore richiesto.
    ror a

    lda _A_IMAGE                ; Esegue l'istruzione.
    sbc _M_IMAGE
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%11000011              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #13                     ; Imposta la riga dove stampare.

  .Exit_TEST_SBC_HEX:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_ADC_BCD
; ------------------------------------------------------------------------------
; Descrizione:  Porta il Carry al valore di _CARRY_IMAGE ed esegue ADC decimale
;               tra .A e la memoria. Lascia il risultato in _RES_IMAGE, il
;               registro di stato in _P_IMAGE, i flag che interessano in
;               _FLAG_MASK e la riga nel registro X. Disattiva gli IRQ durante
;               il modo decimale e li lascia attivi in uscita.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)     : Valore di .A
;   - _M_IMAGE (1 byte, RAM)     : Valore della cella di memoria
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _RES_IMAGE (1 byte, RAM)   : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)     : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM)   : Maschera dei flag che interessano
;   - .X (1 byte, CPU)           : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, oVerflow, Decimal, Interrupt, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Adc_BCD

  TEST_ADC_BCD:
    lda _CARRY_IMAGE            ; Porta il Carry al valore richiesto.
    ror a

    sei                         ; Disattiva gli IRQ: D attivo li altera.
    sed                         ; Attiva il modo decimale.

    lda _A_IMAGE                ; Esegue l'istruzione.
    adc _M_IMAGE
    sta _RES_IMAGE              ; Salva il risultato.

    cld                         ; Torna al modo binario.
    cli                         ; Riattiva gli IRQ.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%11000011              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #19                     ; Imposta la riga dove stampare.

  .Exit_TEST_ADC_BCD:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_SBC_BCD
; ------------------------------------------------------------------------------
; Descrizione:  Porta il Carry al valore di _CARRY_IMAGE ed esegue SBC decimale
;               tra .A e la memoria. Lascia il risultato in _RES_IMAGE, il
;               registro di stato in _P_IMAGE, i flag che interessano in
;               _FLAG_MASK e la riga nel registro X. Disattiva gli IRQ durante
;               il modo decimale e li lascia attivi in uscita.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)     : Valore di .A
;   - _M_IMAGE (1 byte, RAM)     : Valore della cella di memoria
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _RES_IMAGE (1 byte, RAM)   : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)     : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM)   : Maschera dei flag che interessano
;   - .X (1 byte, CPU)           : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, oVerflow, Decimal, Interrupt, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Sbc_BCD

  TEST_SBC_BCD:
    lda _CARRY_IMAGE            ; Porta il Carry al valore richiesto.
    ror a

    sei                         ; Disattiva gli IRQ: D attivo li altera.
    sed                         ; Attiva il modo decimale.

    lda _A_IMAGE                ; Esegue l'istruzione.
    sbc _M_IMAGE
    sta _RES_IMAGE              ; Salva il risultato.

    cld                         ; Torna al modo binario.
    cli                         ; Riattiva gli IRQ.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%11000011              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #20                     ; Imposta la riga dove stampare.

  .Exit_TEST_SBC_BCD:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_ASL1
; ------------------------------------------------------------------------------
; Descrizione:  Porta il Carry al valore di _CARRY_IMAGE ed esegue ASL su .A, 1
;               volta. Lascia il risultato in _RES_IMAGE, il registro di stato
;               in _P_IMAGE, i flag che interessano in _FLAG_MASK e la riga nel
;               registro X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)     : Valore di .A
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _RES_IMAGE (1 byte, RAM)   : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)     : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM)   : Maschera dei flag che interessano
;   - .X (1 byte, CPU)           : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Asl1

  TEST_ASL1:
    lda _CARRY_IMAGE            ; Porta il Carry al valore richiesto.
    ror a

    lda _A_IMAGE                ; Esegue l'istruzione.
    asl a
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%10000011              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #6                      ; Imposta la riga dove stampare.

  .Exit_TEST_ASL1:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_ASL2
; ------------------------------------------------------------------------------
; Descrizione:  Porta il Carry al valore di _CARRY_IMAGE ed esegue ASL su .A, 2
;               volte. Lascia il risultato in _RES_IMAGE, il registro di stato
;               in _P_IMAGE, i flag che interessano in _FLAG_MASK e la riga nel
;               registro X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)     : Valore di .A
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _RES_IMAGE (1 byte, RAM)   : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)     : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM)   : Maschera dei flag che interessano
;   - .X (1 byte, CPU)           : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Asl2

  TEST_ASL2:
    lda _CARRY_IMAGE            ; Porta il Carry al valore richiesto.
    ror a

    lda _A_IMAGE                ; Esegue l'istruzione.
    asl a
    asl a
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%10000011              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #7                      ; Imposta la riga dove stampare.

  .Exit_TEST_ASL2:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_ASL3
; ------------------------------------------------------------------------------
; Descrizione:  Porta il Carry al valore di _CARRY_IMAGE ed esegue ASL su .A, 3
;               volte. Lascia il risultato in _RES_IMAGE, il registro di stato
;               in _P_IMAGE, i flag che interessano in _FLAG_MASK e la riga nel
;               registro X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)     : Valore di .A
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _RES_IMAGE (1 byte, RAM)   : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)     : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM)   : Maschera dei flag che interessano
;   - .X (1 byte, CPU)           : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Asl3

  TEST_ASL3:
    lda _CARRY_IMAGE            ; Porta il Carry al valore richiesto.
    ror a

    lda _A_IMAGE                ; Esegue l'istruzione.
    asl a
    asl a
    asl a
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%10000011              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #8                      ; Imposta la riga dove stampare.

  .Exit_TEST_ASL3:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_ASL4
; ------------------------------------------------------------------------------
; Descrizione:  Porta il Carry al valore di _CARRY_IMAGE ed esegue ASL su .A, 4
;               volte. Lascia il risultato in _RES_IMAGE, il registro di stato
;               in _P_IMAGE, i flag che interessano in _FLAG_MASK e la riga nel
;               registro X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)     : Valore di .A
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _RES_IMAGE (1 byte, RAM)   : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)     : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM)   : Maschera dei flag che interessano
;   - .X (1 byte, CPU)           : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Asl4

  TEST_ASL4:
    lda _CARRY_IMAGE            ; Porta il Carry al valore richiesto.
    ror a

    lda _A_IMAGE                ; Esegue l'istruzione.
    asl a
    asl a
    asl a
    asl a
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%10000011              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #9                      ; Imposta la riga dove stampare.

  .Exit_TEST_ASL4:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_LSR1
; ------------------------------------------------------------------------------
; Descrizione:  Porta il Carry al valore di _CARRY_IMAGE ed esegue LSR su .A, 1
;               volta. Lascia il risultato in _RES_IMAGE, il registro di stato
;               in _P_IMAGE, i flag che interessano in _FLAG_MASK e la riga nel
;               registro X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)     : Valore di .A
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _RES_IMAGE (1 byte, RAM)   : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)     : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM)   : Maschera dei flag che interessano
;   - .X (1 byte, CPU)           : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Lsr1

  TEST_LSR1:
    lda _CARRY_IMAGE            ; Porta il Carry al valore richiesto.
    ror a

    lda _A_IMAGE                ; Esegue l'istruzione.
    lsr a
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%10000011              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #11                     ; Imposta la riga dove stampare.

  .Exit_TEST_LSR1:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_LSR2
; ------------------------------------------------------------------------------
; Descrizione:  Porta il Carry al valore di _CARRY_IMAGE ed esegue LSR su .A, 2
;               volte. Lascia il risultato in _RES_IMAGE, il registro di stato
;               in _P_IMAGE, i flag che interessano in _FLAG_MASK e la riga nel
;               registro X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)     : Valore di .A
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _RES_IMAGE (1 byte, RAM)   : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)     : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM)   : Maschera dei flag che interessano
;   - .X (1 byte, CPU)           : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Lsr2

  TEST_LSR2:
    lda _CARRY_IMAGE            ; Porta il Carry al valore richiesto.
    ror a

    lda _A_IMAGE                ; Esegue l'istruzione.
    lsr a
    lsr a
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%10000011              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #12                     ; Imposta la riga dove stampare.

  .Exit_TEST_LSR2:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_LSR3
; ------------------------------------------------------------------------------
; Descrizione:  Porta il Carry al valore di _CARRY_IMAGE ed esegue LSR su .A, 3
;               volte. Lascia il risultato in _RES_IMAGE, il registro di stato
;               in _P_IMAGE, i flag che interessano in _FLAG_MASK e la riga nel
;               registro X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)     : Valore di .A
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _RES_IMAGE (1 byte, RAM)   : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)     : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM)   : Maschera dei flag che interessano
;   - .X (1 byte, CPU)           : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Lsr3

  TEST_LSR3:
    lda _CARRY_IMAGE            ; Porta il Carry al valore richiesto.
    ror a

    lda _A_IMAGE                ; Esegue l'istruzione.
    lsr a
    lsr a
    lsr a
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%10000011              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #13                     ; Imposta la riga dove stampare.

  .Exit_TEST_LSR3:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_LSR4
; ------------------------------------------------------------------------------
; Descrizione:  Porta il Carry al valore di _CARRY_IMAGE ed esegue LSR su .A, 4
;               volte. Lascia il risultato in _RES_IMAGE, il registro di stato
;               in _P_IMAGE, i flag che interessano in _FLAG_MASK e la riga nel
;               registro X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)     : Valore di .A
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _RES_IMAGE (1 byte, RAM)   : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)     : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM)   : Maschera dei flag che interessano
;   - .X (1 byte, CPU)           : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Lsr4

  TEST_LSR4:
    lda _CARRY_IMAGE            ; Porta il Carry al valore richiesto.
    ror a

    lda _A_IMAGE                ; Esegue l'istruzione.
    lsr a
    lsr a
    lsr a
    lsr a
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%10000011              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #14                     ; Imposta la riga dove stampare.

  .Exit_TEST_LSR4:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_ROL1
; ------------------------------------------------------------------------------
; Descrizione:  Porta il Carry al valore di _CARRY_IMAGE ed esegue ROL su .A, 1
;               volta. Lascia il risultato in _RES_IMAGE, il registro di stato
;               in _P_IMAGE, i flag che interessano in _FLAG_MASK e la riga nel
;               registro X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)     : Valore di .A
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _RES_IMAGE (1 byte, RAM)   : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)     : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM)   : Maschera dei flag che interessano
;   - .X (1 byte, CPU)           : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Rol1

  TEST_ROL1:
    lda _CARRY_IMAGE            ; Porta il Carry al valore richiesto.
    ror a

    lda _A_IMAGE                ; Esegue l'istruzione.
    rol a
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%10000011              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #16                     ; Imposta la riga dove stampare.

  .Exit_TEST_ROL1:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_ROL2
; ------------------------------------------------------------------------------
; Descrizione:  Porta il Carry al valore di _CARRY_IMAGE ed esegue ROL su .A, 2
;               volte. Lascia il risultato in _RES_IMAGE, il registro di stato
;               in _P_IMAGE, i flag che interessano in _FLAG_MASK e la riga nel
;               registro X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)     : Valore di .A
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _RES_IMAGE (1 byte, RAM)   : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)     : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM)   : Maschera dei flag che interessano
;   - .X (1 byte, CPU)           : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Rol2

  TEST_ROL2:
    lda _CARRY_IMAGE            ; Porta il Carry al valore richiesto.
    ror a

    lda _A_IMAGE                ; Esegue l'istruzione.
    rol a
    rol a
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%10000011              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #17                     ; Imposta la riga dove stampare.

  .Exit_TEST_ROL2:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_ROL3
; ------------------------------------------------------------------------------
; Descrizione:  Porta il Carry al valore di _CARRY_IMAGE ed esegue ROL su .A, 3
;               volte. Lascia il risultato in _RES_IMAGE, il registro di stato
;               in _P_IMAGE, i flag che interessano in _FLAG_MASK e la riga nel
;               registro X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)     : Valore di .A
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _RES_IMAGE (1 byte, RAM)   : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)     : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM)   : Maschera dei flag che interessano
;   - .X (1 byte, CPU)           : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Rol3

  TEST_ROL3:
    lda _CARRY_IMAGE            ; Porta il Carry al valore richiesto.
    ror a

    lda _A_IMAGE                ; Esegue l'istruzione.
    rol a
    rol a
    rol a
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%10000011              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #18                     ; Imposta la riga dove stampare.

  .Exit_TEST_ROL3:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_ROL4
; ------------------------------------------------------------------------------
; Descrizione:  Porta il Carry al valore di _CARRY_IMAGE ed esegue ROL su .A, 4
;               volte. Lascia il risultato in _RES_IMAGE, il registro di stato
;               in _P_IMAGE, i flag che interessano in _FLAG_MASK e la riga nel
;               registro X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)     : Valore di .A
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _RES_IMAGE (1 byte, RAM)   : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)     : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM)   : Maschera dei flag che interessano
;   - .X (1 byte, CPU)           : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Rol4

  TEST_ROL4:
    lda _CARRY_IMAGE            ; Porta il Carry al valore richiesto.
    ror a

    lda _A_IMAGE                ; Esegue l'istruzione.
    rol a
    rol a
    rol a
    rol a
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%10000011              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #19                     ; Imposta la riga dove stampare.

  .Exit_TEST_ROL4:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_ROR1
; ------------------------------------------------------------------------------
; Descrizione:  Porta il Carry al valore di _CARRY_IMAGE ed esegue ROR su .A, 1
;               volta. Lascia il risultato in _RES_IMAGE, il registro di stato
;               in _P_IMAGE, i flag che interessano in _FLAG_MASK e la riga nel
;               registro X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)     : Valore di .A
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _RES_IMAGE (1 byte, RAM)   : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)     : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM)   : Maschera dei flag che interessano
;   - .X (1 byte, CPU)           : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Ror1

  TEST_ROR1:
    lda _CARRY_IMAGE            ; Porta il Carry al valore richiesto.
    ror a

    lda _A_IMAGE                ; Esegue l'istruzione.
    ror a
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%10000011              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #21                     ; Imposta la riga dove stampare.

  .Exit_TEST_ROR1:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_ROR2
; ------------------------------------------------------------------------------
; Descrizione:  Porta il Carry al valore di _CARRY_IMAGE ed esegue ROR su .A, 2
;               volte. Lascia il risultato in _RES_IMAGE, il registro di stato
;               in _P_IMAGE, i flag che interessano in _FLAG_MASK e la riga nel
;               registro X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)     : Valore di .A
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _RES_IMAGE (1 byte, RAM)   : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)     : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM)   : Maschera dei flag che interessano
;   - .X (1 byte, CPU)           : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Ror2

  TEST_ROR2:
    lda _CARRY_IMAGE            ; Porta il Carry al valore richiesto.
    ror a

    lda _A_IMAGE                ; Esegue l'istruzione.
    ror a
    ror a
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%10000011              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #22                     ; Imposta la riga dove stampare.

  .Exit_TEST_ROR2:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_ROR3
; ------------------------------------------------------------------------------
; Descrizione:  Porta il Carry al valore di _CARRY_IMAGE ed esegue ROR su .A, 3
;               volte. Lascia il risultato in _RES_IMAGE, il registro di stato
;               in _P_IMAGE, i flag che interessano in _FLAG_MASK e la riga nel
;               registro X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)     : Valore di .A
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _RES_IMAGE (1 byte, RAM)   : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)     : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM)   : Maschera dei flag che interessano
;   - .X (1 byte, CPU)           : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Ror3

  TEST_ROR3:
    lda _CARRY_IMAGE            ; Porta il Carry al valore richiesto.
    ror a

    lda _A_IMAGE                ; Esegue l'istruzione.
    ror a
    ror a
    ror a
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%10000011              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #23                     ; Imposta la riga dove stampare.

  .Exit_TEST_ROR3:
    rts

!zone

; ==============================================================================
; SUBROUTINE: TEST_ROR4
; ------------------------------------------------------------------------------
; Descrizione:  Porta il Carry al valore di _CARRY_IMAGE ed esegue ROR su .A, 4
;               volte. Lascia il risultato in _RES_IMAGE, il registro di stato
;               in _P_IMAGE, i flag che interessano in _FLAG_MASK e la riga nel
;               registro X.
;
; Input:
;   - _A_IMAGE (1 byte, RAM)     : Valore di .A
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del Carry (0 o 1)
;
; Output:
;   - _RES_IMAGE (1 byte, RAM)   : Risultato dell'istruzione
;   - _P_IMAGE (1 byte, RAM)     : Registro di stato dopo l'istruzione
;   - _FLAG_MASK (1 byte, RAM)   : Maschera dei flag che interessano
;   - .X (1 byte, CPU)           : Riga dove stampare il risultato
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Test_Ror4

  TEST_ROR4:
    lda _CARRY_IMAGE            ; Porta il Carry al valore richiesto.
    ror a

    lda _A_IMAGE                ; Esegue l'istruzione.
    ror a
    ror a
    ror a
    ror a
    sta _RES_IMAGE              ; Salva il risultato.

    php                         ; Salva il registro di stato.
    pla

    sta _P_IMAGE

    lda #%10000011              ; Imposta la maschera dei flag.
    sta _FLAG_MASK

    ldx #24                     ; Imposta la riga dove stampare.

  .Exit_TEST_ROR4:
    rts

!zone

; ------------------------------------------------------------------------------
; Risultati dei test
; ------------------------------------------------------------------------------

; Area dati variabile, non ancora scritta da nessun test.
; Per ogni risultato: il byte del risultato e quello dei
; flag associati.
RESULTS:
  !byte $00, $00
  !byte $00, $00
  !byte $00, $00
  !byte $00, $00
  !byte $00, $00
  !byte $00, $00
  !byte $00, $00
  !byte $00, $00
  !byte $00, $00
  !byte $00, $00
  !byte $00, $00
  !byte $00, $00
  !byte $00, $00
  !byte $00, $00
  !byte $00, $00
  !byte $00, $00
