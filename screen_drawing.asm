; ==============================================================================
; FILE:           screen_drawing.asm
; PROGETTO:       Binary Playground (Binary_Playground.c64)
; TARGET:         ACME Assembler / MOS 6510 (Commodore 64)
; DESCRIZIONE:    Utilità per disegnare: le schermate del titolo e dell'aiuto,
;                 l'intestazione comune, le etichette della pagina corrente e le
;                 righe con l'immagine di un byte in tutti i formati.
; CONTENUTO:      PRINT_TITLE         Stampa la schermata del titolo
;                 PRINT_HELP          Stampa la schermata di aiuto
;                 PRINT_PAGE_HEADER   Disegna l'intestazione comune delle pagine
;                 PRINT_PAGE          Disegna intestazione ed etichette
;                 PRINT_A             Stampa la riga di .A
;                 PRINT_M             Stampa la riga della memoria
;                 PRINT_CARRY         Stampa il valore del flag di Carry
;                 PRINT_RES           Stampa la riga di un risultato
;                 PRINT_LINE          Stampa un byte in tutti i formati
;                 PRINT_TESTS         Ridisegna i risultati dei test
;                 PRINT_BINARY        Stampa .A in binario
;                 PRINT_HEX_OR_BCD    Stampa .A in esadecimale o BCD
;                 PRINT_UNSIGNED      Stampa .A in decimale senza segno
;                 PRINT_SIGNED        Stampa .A in decimale con segno
;                 PRINT_FLAGS         Stampa lo stato dei flag N, V, Z e C
;                 PRINT_FLAG_CHAR     Stampa il carattere di un flag
; DIPENDENZE:     Nessuna
; REQUISITI ZP:   __BG_COL
; ==============================================================================

; ==============================================================================
; SUBROUTINE: PRINT_TITLE
; ------------------------------------------------------------------------------
; Descrizione:  Cancella lo schermo, stampa la schermata del titolo (tavola
;               TITLE_SCREEN) e attende la pressione di un tasto.
;
; Input:
;   - Nessuno
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .Y, .P (Negative, oVerflow, Zero, Carry),
;                       ZP_1 (2 byte)
; Dipendenze Esterne:   <c64/kernal.asm>
;                       <c64/symbols.asm>
;                       <system/print_tools.asm>
;                       "data_tables.asm"
; ==============================================================================
!zone Print_Title

  PRINT_TITLE:
    jsr CLRSCR                      ; Cancella lo schermo.

    lda #<TITLE_SCREEN              ; Punta ZP_1 alla tabella dei messaggi
    sta ZP_1                        ; del titolo.
    lda #>TITLE_SCREEN
    sta ZP_1+1

  .Loop_Print_Title:
    lda #ZP_1                       ; REPEAT
    jsr PRINT_MSG                   ; Stampa il messaggio.

  .Loop_Check_Title:
    bcc .Loop_Print_Title           ; REPEAT UNTIL: la tabella è finita

  .Loop_Read_Key:
    jsr GETIN                       ; REPEAT

  .Loop_Check_Key:
    beq .Loop_Read_Key              ; REPEAT UNTIL: è stato premuto un tasto

  .Exit_PRINT_TITLE:
    rts

!zone

; ==============================================================================
; SUBROUTINE: PRINT_HELP
; ------------------------------------------------------------------------------
; Descrizione:  Cancella lo schermo, stampa la schermata di aiuto (tavola
;               HELP_SCREEN) e attende la pressione di un tasto.
;
; Input:
;   - Nessuno
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .Y, .P (Negative, oVerflow, Zero, Carry),
;                       ZP_1 (2 byte)
; Dipendenze Esterne:   <c64/kernal.asm>
;                       <c64/symbols.asm>
;                       <system/print_tools.asm>
;                       "data_tables.asm"
; ==============================================================================
!zone Print_Help

  PRINT_HELP:
    jsr CLRSCR                      ; Cancella lo schermo.

    lda #<HELP_SCREEN               ; Punta ZP_1 alla tabella dei messaggi
    sta ZP_1                        ; della schermata di aiuto.
    lda #>HELP_SCREEN
    sta ZP_1+1

  .Loop_Print_Help:
    lda #ZP_1                       ; REPEAT
    jsr PRINT_MSG                   ; Stampa il messaggio.

  .Loop_Check_Help:
    bcc .Loop_Print_Help            ; REPEAT UNTIL: la tabella è finita

  .Loop_Read_Key:
    jsr GETIN                       ; REPEAT

  .Loop_Check_Key:
    beq .Loop_Read_Key              ; REPEAT UNTIL: è stato premuto un tasto

  .Exit_PRINT_HELP:
    rts

!zone

; ==============================================================================
; SUBROUTINE: PRINT_PAGE_HEADER
; ------------------------------------------------------------------------------
; Descrizione:  Cancella lo schermo e disegna l'intestazione comune a tutte le
;               pagine (tabella PAGE_HEADER), poi stampa il numero della pagina
;               corrente con il colore di sfondo 2.
;
;               Le subroutine CLRSCR e PLOT del Kernal e il driver __PUT_CHAR
;               alterano proprie celle di lavoro, il cui contenuto non è
;               garantito dopo la chiamata.
;
; Input:
;   - _CURR_PAGE (1 byte, RAM) : Numero della pagina corrente (0-4)
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .Y, .P (Negative, oVerflow, Zero, Carry),
;                       ZP_1 (2 byte), __BG_COL
; Dipendenze Esterne:   <c64/kernal.asm>
;                       <c64/symbols.asm>
;                       <chip/vic_ii.asm>
;                       <system/print_tools.asm>
;                       "binary_playground.asm"
;                       "data_tables.asm"
; ==============================================================================
!zone Print_Page_Header

  PRINT_PAGE_HEADER:
    jsr CLRSCR                      ; Cancella lo schermo.

    lda #<PAGE_HEADER               ; Punta ZP_1 alla tabella dei messaggi
    sta ZP_1                        ; dell'intestazione.
    lda #>PAGE_HEADER
    sta ZP_1+1

  .Loop_Print_Header:
    lda #ZP_1                       ; REPEAT
    jsr PRINT_MSG                   ; Stampa il messaggio.

  .Loop_Check_Header:
    bcc .Loop_Print_Header          ; REPEAT UNTIL: la tabella è finita

    lda #VIC_BG2                    ; Stampa il numero della pagina.
    sta __BG_COL
    +m_At 1, 7
    lda _CURR_PAGE
    clc
    adc #"1"
    jsr __PUT_CHAR

  .Exit_PRINT_PAGE_HEADER:
    rts

!zone

; ==============================================================================
; SUBROUTINE: PRINT_PAGE
; ------------------------------------------------------------------------------
; Descrizione:  Disegna la pagina corrente: l'intestazione comune
;               (PRINT_PAGE_HEADER) e le etichette della pagina, cioè la tabella
;               dei messaggi che nella struttura della pagina segue i 10 byte
;               dei dati.
;
;               Le subroutine CLRSCR e PLOT del Kernal e il driver __PUT_CHAR
;               alterano proprie celle di lavoro, il cui contenuto non è
;               garantito dopo la chiamata.
;
; Input:
;   - _CURR_PAGE (1 byte, RAM) : Numero della pagina corrente (0-4)
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .Y, .P (Negative, oVerflow, Zero, Carry),
;                       ZP_1 (2 byte)
; Dipendenze Esterne:   <c64/symbols.asm>
;                       <system/print_tools.asm>
;                       "binary_playground.asm"
; ==============================================================================
!zone Print_Page

  PRINT_PAGE:
    jsr PRINT_PAGE_HEADER           ; Disegna l'intestazione.

    lda _CURR_PAGE                  ; Punta ZP_1 alla struttura della pagina, poi aggiunge lo
    ldy #LAYOUT_ACC                 ; scostamento della tabella dei messaggi.
    jsr GET_LAYOUT_ITEM

    clc
    lda ZP_1
    adc #LAYOUT_TEXT
    sta ZP_1

    lda ZP_1+1
    adc #0
    sta ZP_1+1

  .Loop_Print_Msg_Table:
    lda #ZP_1                       ; REPEAT
    jsr PRINT_MSG                   ; Stampa le altre etichette della pagina.

  .Loop_Check_Msg_Table:
    bcc .Loop_Print_Msg_Table       ; REPEAT UNTIL: la tabella è finita

  .Exit_PRINT_PAGE:
    rts

!zone

; ==============================================================================
; SUBROUTINE: PRINT_A
; ------------------------------------------------------------------------------
; Descrizione:  Stampa la riga di .A (_A_IMAGE) alla riga indicata dal byte 0
;               della struttura della pagina corrente; se il byte vale $FF la
;               pagina non mostra .A e non stampa nulla. Come flag mostra N e Z,
;               gli unici che un caricamento altera. Prosegue in PRINT_LINE.
;
;               La subroutine PLOT del Kernal e il driver __PUT_CHAR alterano
;               proprie celle di lavoro, il cui contenuto non è garantito dopo
;               la chiamata.
;
; Input:
;   - _CURR_PAGE (1 byte, RAM) : Numero della pagina corrente (0-4)
;   - _A_IMAGE (1 byte, RAM)   : Valore di .A
;
; Output:
;   - _P_IMAGE (1 byte, RAM)   : Flag dopo il caricamento di _A_IMAGE
;   - _FLAG_MASK (1 byte, RAM) : %10000010 (N e Z)
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .Y, .P (Negative, oVerflow, Zero, Carry),
;                       _P_IMAGE, _FLAG_MASK
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Print_A

  PRINT_A:
    lda _CURR_PAGE                  ; La riga in cui si stampa .A è nel byte 0
    ldy #LAYOUT_ACC                 ; della struttura della pagina.
    jsr GET_LAYOUT_ITEM

    cmp #$FF                        ; Se la riga vale $FF non si stampa nulla.
    beq .Exit_PRINT_A_No_Row

    tax                             ; Copia il numero di riga in .X.

    ; Controlla _A_IMAGE caricandolo in .Y e registra i flag
    ; in _P_IMAGE.
    ldy _A_IMAGE

    php
    pla

    sta _P_IMAGE

    lda #%10000010                  ; I caricamenti alterano solo i flag N e Z.
    sta _FLAG_MASK

    tya                             ; Mette sullo stack il byte da stampare
    pha

  .Exit_PRINT_A:
    jmp PRINT_LINE                  ; e passa alla stampa vera e propria.

  .Exit_PRINT_A_No_Row:
    rts

!zone

; ==============================================================================
; SUBROUTINE: PRINT_M
; ------------------------------------------------------------------------------
; Descrizione:  Stampa la riga della memoria (_M_IMAGE) alla riga indicata dal
;               byte 1 della struttura della pagina corrente; se il byte vale
;               $FF la pagina non mostra la memoria e non stampa nulla. Come
;               flag mostra N e Z, gli unici che un caricamento altera. Prosegue
;               in PRINT_LINE.
;
;               La subroutine PLOT del Kernal e il driver __PUT_CHAR alterano
;               proprie celle di lavoro, il cui contenuto non è garantito dopo
;               la chiamata.
;
; Input:
;   - _CURR_PAGE (1 byte, RAM) : Numero della pagina corrente (0-4)
;   - _M_IMAGE (1 byte, RAM)   : Valore della cella di memoria
;
; Output:
;   - _P_IMAGE (1 byte, RAM)   : Flag dopo il caricamento di _M_IMAGE
;   - _FLAG_MASK (1 byte, RAM) : %10000010 (N e Z)
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .Y, .P (Negative, oVerflow, Zero, Carry),
;                       _P_IMAGE, _FLAG_MASK
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Print_M

  PRINT_M:
    lda _CURR_PAGE                  ; La riga in cui si stampa la memoria è nel
    ldy #LAYOUT_MEM                 ; byte 1 della struttura della pagina.
    jsr GET_LAYOUT_ITEM

    cmp #$FF                        ; Se la riga vale $FF non si stampa nulla.
    beq .Exit_PRINT_M_No_Row

    tax                             ; Copia il numero di riga in .X.

    ; Controlla _M_IMAGE caricandolo in .Y e registra i flag
    ; in _P_IMAGE.
    ldy _M_IMAGE

    php
    pla

    sta _P_IMAGE

    lda #%10000010                  ; I caricamenti alterano solo i flag N e Z.
    sta _FLAG_MASK

    tya                             ; Mette sullo stack il byte da stampare
    pha

  .Exit_PRINT_M:
    jmp PRINT_LINE                  ; e passa alla stampa vera e propria.

  .Exit_PRINT_M_No_Row:
    rts

!zone

; ==============================================================================
; SUBROUTINE: PRINT_CARRY
; ------------------------------------------------------------------------------
; Descrizione:  Stampa il valore del flag di Carry (_CARRY_IMAGE), "0" o "1",
;               alla colonna 38 della riga indicata dal byte 7 della struttura
;               della pagina corrente. Se il byte 7 vale $FF la pagina non
;               mostra il Carry e non stampa nulla.
;
;               La subroutine PLOT del Kernal e il driver __PUT_CHAR alterano
;               proprie celle di lavoro, il cui contenuto non è garantito dopo
;               la chiamata.
;
; Input:
;   - _CURR_PAGE (1 byte, RAM)   : Numero della pagina corrente (0-4)
;   - _CARRY_IMAGE (1 byte, RAM) : Valore del flag di Carry (0 o 1)
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .Y, .P (Negative, oVerflow, Zero, Carry)
; Dipendenze Esterne:   <c64/kernal.asm>
;                       "binary_playground.asm"
; ==============================================================================
!zone Print_Carry

  PRINT_CARRY:
    lda _CURR_PAGE                  ; Recupera la riga in cui stampare il flag di
    ldy #LAYOUT_CARRY               ; Carry.
    jsr GET_LAYOUT_ITEM

    cmp #$FF                        ; Se la riga vale $FF non si stampa nulla.
    beq .Exit_PRINT_CARRY

    tax                             ; Posiziona il cursore.
    ldy #38
    clc
    jsr PLOT

    lda #"0"                        ; Calcola il carattere del Carry e lo stampa.
    clc
    adc _CARRY_IMAGE
    jsr __PUT_CHAR

  .Exit_PRINT_CARRY:
    rts

!zone

; ==============================================================================
; SUBROUTINE: PRINT_RES
; ------------------------------------------------------------------------------
; Descrizione:  Stampa la riga del risultato di un test (_RES_IMAGE), con i flag
;               registrati dal test. Prosegue in PRINT_LINE.
;
;               La subroutine PLOT del Kernal e il driver __PUT_CHAR alterano
;               proprie celle di lavoro, il cui contenuto non è garantito dopo
;               la chiamata.
;
; Input:
;   - .X (1 byte, CPU)         : Riga dello schermo
;   - _RES_IMAGE (1 byte, RAM) : Risultato del test
;   - _P_IMAGE (1 byte, RAM)   : Flag dopo il test
;   - _FLAG_MASK (1 byte, RAM) : Flag che il test altera
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .Y, .P (Negative, oVerflow, Zero, Carry)
; Dipendenze Esterne:   "binary_playground.asm"
; ==============================================================================
!zone Print_Res

  PRINT_RES:
    lda _RES_IMAGE                  ; Mette sullo stack il byte da stampare
    pha

  .Exit_PRINT_RES:
    jmp PRINT_LINE                  ; e passa alla stampa vera e propria.

!zone

; ==============================================================================
; SUBROUTINE: PRINT_LINE
; ------------------------------------------------------------------------------
; Descrizione:  Stampa sulla riga indicata da .X un byte in binario (dalla
;               colonna 9), in esadecimale o BCD (dalla 20), in decimale senza
;               segno (dalla 25) e con segno (dalla 29), e i flag selezionati
;               (dalla 35). Il byte è in cima allo stack: la subroutine si
;               raggiunge con jmp, dopo aver messo il byte sullo stack con pha,
;               e lo toglie prima di ritornare.
;
;               La subroutine PLOT del Kernal e il driver __PUT_CHAR alterano
;               proprie celle di lavoro, il cui contenuto non è garantito dopo
;               la chiamata.
;
; Input:
;   - .X (1 byte, CPU)         : Riga dello schermo
;   - STACK (1 byte, RAM)      : Byte da stampare, in cima allo stack
;   - _P_IMAGE (1 byte, RAM)   : Immagine dei flag
;   - _FLAG_MASK (1 byte, RAM) : Flag da stampare
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Incrementato di 1 byte
;
; Registri Modificati:  .A, .X, .Y, .P (Negative, oVerflow, Zero, Carry)
; Dipendenze Esterne:   <c64/kernal.asm>
;                       "binary_playground.asm"
; ==============================================================================
!zone Print_Line

  PRINT_LINE:
    stx ._ROW
    ldy #9
    clc
    jsr PLOT

    pla                             ; Stampa il byte in binario.
    pha

    jsr PRINT_BINARY

    ldx ._ROW                       ; Stampa il byte in esadecimale.
    ldy #20
    clc
    jsr PLOT

    pla
    pha

    jsr PRINT_HEX_OR_BCD

    ldx ._ROW                       ; Stampa il byte in decimale senza segno.
    ldy #25
    clc
    jsr PLOT

    pla
    pha

    jsr PRINT_UNSIGNED

    ldx ._ROW                       ; Stampa il byte in decimale con segno.
    ldy #29
    clc
    jsr PLOT

    pla
    pha

    jsr PRINT_SIGNED

    ldx ._ROW                       ; Stampa i flag.
    ldy #35
    clc
    jsr PLOT
    lda _P_IMAGE
    jsr PRINT_FLAGS

  .Exit_PRINT_LINE:
    pla                             ; Toglie il byte dallo stack ed esce.
    rts

  ._ROW:
    !byte 0

!zone

; ==============================================================================
; SUBROUTINE: PRINT_TESTS
; ------------------------------------------------------------------------------
; Descrizione:  Salta alla routine che ridisegna i risultati dei test della
;               pagina corrente: ne legge l'indirizzo dalla struttura della
;               pagina (byte 8-9), lo salva in _TESTS_VECTOR e lo esegue.
;               L'RTS della routine di ridisegno riporta al chiamante
;               di PRINT_TESTS.
;
; Input:
;   - _CURR_PAGE (1 byte, RAM)    : Numero della pagina corrente (0-4)
;
; Output:
;   - _TESTS_VECTOR (2 byte, RAM) : Indirizzo della routine di ridisegno
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .Y, .P (Negative, oVerflow, Decimal,
;                       Interrupt, Zero, Carry), ZP_1 (2 byte),
;                       _TESTS_VECTOR
; Dipendenze Esterne:   "binary_playground.asm"
;                       "opcode_tests.asm"
; ==============================================================================
!zone Print_Tests

  PRINT_TESTS:
    lda _CURR_PAGE                  ; Legge il byte basso dell'indirizzo
    ldy #LAYOUT_TESTS               ; della routine di ridisegno
    jsr GET_LAYOUT_ITEM             ; dei risultati.
    sta _TESTS_VECTOR

    lda _CURR_PAGE                  ; Legge il byte alto dell'indirizzo
    ldy #LAYOUT_TESTS+1             ; della routine di ridisegno
    jsr GET_LAYOUT_ITEM             ; dei risultati.
    sta _TESTS_VECTOR+1

  .Exit_PRINT_TESTS:
    jmp (_TESTS_VECTOR)             ; Esegue la routine di ridisegno, che ritorna al chiamante.

!zone

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
; Dipendenze Esterne:   <c64/petscii.asm>
; ==============================================================================
!zone Print_Binary

  PRINT_BINARY:
    ldx #8                          ; FOR (Inizializzazione)

  .Loop_Print_Bit:
    cpx #4                          ; FOR (Corpo)
    bne .No_Nibble_Space            ; IF: sono già stati stampati 4 bit

    tay                             ; Sposta il cursore di una posizione a destra.
    lda #PETSCII_CURSOR_RIGHT
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

    lda #%00001000                  ; Controlla il flag di Decimal.

    bit _P_IMAGE
    bne .Else_BCD_Digits            ; IF: il flag di Decimal è a 0

    lda #<.HEX_DIGITS               ; Punta ZP_2 alla tabella delle cifre esadecimali.
    sta ZP_2
    lda #>.HEX_DIGITS
    sta ZP_2+1
    jmp .Print_Dollar

  .Else_BCD_Digits:
    lda #<.BCD_DIGITS               ; ELSE
    sta ZP_2                        ; Punta ZP_2 alla tabella delle cifre BCD.
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
    bmi .Else_Negative              ; IF: il valore è positivo

    lda #"+"                        ; Carica in .A il codice ASCII di "+"
    +m_Skip2                        ; e salta l'istruzione seguente.

  .Else_Negative:
    lda #"-"                        ; ELSE
    jsr __PUT_CHAR                  ; Stampa il segno, che è in .A.

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
    lda #%10000000                  ; Controlla se N va stampato.

    bit _FLAG_MASK
    beq .No_N_Selected              ; IF: N è tra i flag da stampare

    ldy #"0"                        ; Prepara in .Y il codice ASCII di "0".

    bit _P_IMAGE
    beq .No_N_Set                   ; IF: N è a 1

    iny                             ; Cambia il codice in .Y in "1".

  .No_N_Set:
    ldx #VIC_BG1                    ; I flag interessati si stampano con il colore
    stx __BG_COL                    ; di sfondo 1.

  .No_N_Selected:
    jsr PRINT_FLAG_CHAR

  .Test_V:
    lda #%01000000                  ; Controlla se V va stampato.

    bit _FLAG_MASK
    beq .No_V_Selected              ; IF: V è tra i flag da stampare

    ldy #"0"                        ; Prepara in .Y il codice ASCII di "0".

    bit _P_IMAGE
    beq .No_V_Set                   ; IF: V è a 1

    iny                             ; Cambia il codice in .Y in "1".

  .No_V_Set:
    ldx #VIC_BG1                    ; I flag interessati si stampano con il colore
    stx __BG_COL                    ; di sfondo 1.

  .No_V_Selected:
    jsr PRINT_FLAG_CHAR

  .Test_Z:
    lda #%00000010                  ; Controlla se Z va stampato.

    bit _FLAG_MASK
    beq .No_Z_Selected              ; IF: Z è tra i flag da stampare

    ldy #"0"                        ; Prepara in .Y il codice ASCII di "0".

    bit _P_IMAGE
    beq .No_Z_Set                   ; IF: Z è a 1

    iny                             ; Cambia il codice in .Y in "1".

  .No_Z_Set:
    ldx #VIC_BG1                    ; I flag interessati si stampano con il colore
    stx __BG_COL                    ; di sfondo 1.

  .No_Z_Selected:
    jsr PRINT_FLAG_CHAR

  .Test_C:
    lda #%00000001                  ; Controlla se C va stampato.

    bit _FLAG_MASK
    beq .Exit_PRINT_FLAGS

    ldy #"0"                        ; Prepara in .Y il codice ASCII di "0".

    bit _P_IMAGE
    beq .No_C_Set                   ; IF: C è a 1

    iny                             ; Cambia il codice in .Y in "1".

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
