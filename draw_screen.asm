; ==============================================================================
; FILE:           draw_screen.asm
; PROGETTO:       Binary Playground (Binary_Playground.c64)
; TARGET:         ACME Assembler / MOS 6510 (Commodore 64)
; DESCRIZIONE:    Utilità per disegnare le pagine: l'intestazione comune, le
;                 etichette della pagina corrente e le righe con l'immagine di
;                 un byte in tutti i formati.
; CONTENUTO:      PRINT_TITLE         Stampa la schermata del titolo
;                 PRINT_PAGE_HEADER   Disegna l'intestazione comune delle pagine
;                 PRINT_PAGE          Disegna intestazione ed etichette
;                 PRINT_A             Stampa la riga di .A
;                 PRINT_M             Stampa la riga della memoria
;                 PRINT_CARRY         Stampa il valore del flag di Carry
;                 PRINT_RES           Stampa la riga di un risultato
;                 PRINT_LINE          Stampa un byte in tutti i formati
;                 PRINT_TESTS         Ridisegna i risultati dei test
; DIPENDENZE:     Nessuna
; REQUISITI ZP:   __BG_COL, ZP_1
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
;                       "screen_layouts.asm"
; ==============================================================================
!zone Print_Title

  PRINT_TITLE:
    jsr CLRSCR                  ; Cancella lo schermo.

    lda #<TITLE_SCREEN          ; Punta ZP_1 alla tabella dei messaggi
    sta ZP_1                    ; del titolo.
    lda #>TITLE_SCREEN
    sta ZP_1+1

  .Loop_Print_Title:
    lda #ZP_1                   ; REPEAT
    jsr PRINT_MSG               ; Stampa il messaggio.

  .Loop_Check_Title:
    bcc .Loop_Print_Title       ; REPEAT UNTIL: la tabella è finita

  .Loop_Read_Key:
    jsr GETIN                   ; REPEAT

  .Loop_Check_Key:
    beq .Loop_Read_Key          ; REPEAT UNTIL: è stato premuto un tasto

  .Exit_PRINT_TITLE:
    rts

!zone

!zone Print_Help

  PRINT_HELP:
    jsr CLRSCR                  ; Cancella lo schermo.

    lda #<HELP_SCREEN          ; Punta ZP_1 alla tabella dei messaggi
    sta ZP_1                    ; della schermata di aiuto.
    lda #>HELP_SCREEN
    sta ZP_1+1

  .Loop_Print_Help:
    lda #ZP_1                   ; REPEAT
    jsr PRINT_MSG               ; Stampa il messaggio.

  .Loop_Check_Help:
    bcc .Loop_Print_Help       ; REPEAT UNTIL: la tabella è finita

  .Loop_Read_Key:
    jsr GETIN                   ; REPEAT

  .Loop_Check_Key:
    beq .Loop_Read_Key          ; REPEAT UNTIL: è stato premuto un tasto

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
;                       "screen_layouts.asm"
; ==============================================================================
!zone Print_Page_Header

  PRINT_PAGE_HEADER:
    jsr CLRSCR                  ; Cancella lo schermo.

    lda #<PAGE_HEADER           ; Punta ZP_1 alla tabella dei messaggi
    sta ZP_1                    ; dell'intestazione.
    lda #>PAGE_HEADER
    sta ZP_1+1

  .Loop_Print_Header:
    lda #ZP_1                   ; REPEAT
    jsr PRINT_MSG               ; Stampa il messaggio.

  .Loop_Check_Header:
    bcc .Loop_Print_Header      ; REPEAT UNTIL: la tabella è finita

    lda #VIC_BG2                ; Stampa il numero della pagina.
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
;                       "screen_layouts.asm"
; ==============================================================================
!zone Print_Page

  PRINT_PAGE:
    jsr PRINT_PAGE_HEADER       ; Disegna l'intestazione.

    lda _CURR_PAGE              ; Punta ZP_1 alla struttura della pagina, poi aggiunge lo
    ldy #0                      ; scostamento della tabella dei messaggi.
    jsr GET_LAYOUT_ITEM

    clc
    lda ZP_1
    adc #10
    sta ZP_1

    lda ZP_1+1
    adc #0
    sta ZP_1+1

  .Loop_Print_Msg_Table:
    lda #ZP_1                   ; REPEAT
    jsr PRINT_MSG               ; Stampa le altre etichette della pagina.

  .Loop_Check_Msg_Table:
    bcc .Loop_Print_Msg_Table   ; REPEAT UNTIL: la tabella è finita

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
;                       "screen_layouts.asm"
; ==============================================================================
!zone Print_A

  PRINT_A:
    lda _CURR_PAGE              ; La riga in cui si stampa .A è nel byte 0
    ldy #0                      ; della struttura della pagina.
    jsr GET_LAYOUT_ITEM

    cmp #$FF                    ; Se la riga vale $FF non si stampa nulla.
    beq .Exit_PRINT_A_No_Row

    tax                         ; Copia il numero di riga in .X.

    ; Controlla _A_IMAGE caricandolo in .Y e registra i flag
    ; in _P_IMAGE.
    ldy _A_IMAGE

    php
    pla

    sta _P_IMAGE

    lda #%10000010              ; I caricamenti alterano solo i flag N e Z.
    sta _FLAG_MASK

    tya                         ; Mette sullo stack il byte da stampare
    pha

  .Exit_PRINT_A:
    jmp PRINT_LINE              ; e passa alla stampa vera e propria.

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
;                       "screen_layouts.asm"
; ==============================================================================
!zone Print_M

  PRINT_M:
    lda _CURR_PAGE              ; La riga in cui si stampa la memoria è nel
    ldy #1                      ; byte 1 della struttura della pagina.
    jsr GET_LAYOUT_ITEM

    cmp #$FF                    ; Se la riga vale $FF non si stampa nulla.
    beq .Exit_PRINT_M_No_Row

    tax                         ; Copia il numero di riga in .X.

    ; Controlla _M_IMAGE caricandolo in .Y e registra i flag
    ; in _P_IMAGE.
    ldy _M_IMAGE

    php
    pla

    sta _P_IMAGE

    lda #%10000010              ; I caricamenti alterano solo i flag N e Z.
    sta _FLAG_MASK

    tya                         ; Mette sullo stack il byte da stampare
    pha

  .Exit_PRINT_M:
    jmp PRINT_LINE              ; e passa alla stampa vera e propria.

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
;                       "screen_layouts.asm"
; ==============================================================================
!zone Print_Carry

  PRINT_CARRY:
    lda _CURR_PAGE              ; Recupera la riga in cui stampare il flag di
    ldy #7                      ; Carry.
    jsr GET_LAYOUT_ITEM

    cmp #$FF                    ; Se la riga vale $FF non si stampa nulla.
    beq .Exit_PRINT_CARRY

    tax                         ; Posiziona il cursore.
    ldy #38
    clc
    jsr PLOT

    lda #"0"                    ; Calcola il carattere del Carry e lo stampa.
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
    lda _RES_IMAGE              ; Mette sullo stack il byte da stampare
    pha

  .Exit_PRINT_RES:
    jmp PRINT_LINE              ; e passa alla stampa vera e propria.

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
;                       "print_images.asm"
; ==============================================================================
!zone Print_Line

  PRINT_LINE:
    stx ._ROW
    ldy #9
    clc
    jsr PLOT

    pla                         ; Stampa il byte in binario.
    pha

    jsr PRINT_BINARY

    ldx ._ROW                   ; Stampa il byte in esadecimale.
    ldy #20
    clc
    jsr PLOT

    pla
    pha

    jsr PRINT_HEX_OR_BCD

    ldx ._ROW                   ; Stampa il byte in decimale senza segno.
    ldy #25
    clc
    jsr PLOT

    pla
    pha

    jsr PRINT_UNSIGNED

    ldx ._ROW                   ; Stampa il byte in decimale con segno.
    ldy #29
    clc
    jsr PLOT

    pla
    pha

    jsr PRINT_SIGNED

    ldx ._ROW                   ; Stampa i flag.
    ldy #35
    clc
    jsr PLOT
    lda _P_IMAGE
    jsr PRINT_FLAGS

  .Exit_PRINT_LINE:
    pla                         ; Toglie il byte dallo stack ed esce.
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
;                       "screen_layouts.asm"
; ==============================================================================
!zone Print_Tests

  PRINT_TESTS:
    lda _CURR_PAGE              ; Legge il byte basso dell'indirizzo
    ldy #8                      ; della routine di ridisegno
    jsr GET_LAYOUT_ITEM         ; dei risultati.
    sta _TESTS_VECTOR

    lda _CURR_PAGE              ; Legge il byte alto dell'indirizzo
    ldy #9                      ; della routine di ridisegno
    jsr GET_LAYOUT_ITEM         ; dei risultati.
    sta _TESTS_VECTOR+1

  .Exit_PRINT_TESTS:
    jmp (_TESTS_VECTOR)         ; Esegue la routine di ridisegno, che ritorna al chiamante.

!zone
