; ==============================================================================
; FILE:           binary_playground.asm
; PROGETTO:       Binary Playground (Binary_Playground.c64)
; VERSIONE:       0.9
; AUTORE:         Stefano Priore
; TARGET:         ACME Assembler / MOS 6510 (Commodore 64)
; DESCRIZIONE:    Sorgente principale: configurazione, inclusione dei moduli e
;                 programma principale. Binary Playground è un programma
;                 didattico che mostra, su cinque schermate, l'effetto delle
;                 operazioni aritmetiche, logiche e di scorrimento su un byte:
;                 in alto gli operandi (A, M se serve, e il Carry), in basso i
;                 risultati e i flag NVZC dopo l'operazione.
; CONTENUTO:      MAIN              Disegna la pagina corrente e attende un tasto
;                 REFRESH_PAGE      Disegna la pagina scelta con un tasto
;                 TOGGLE_CARRY      Inverte il flag di Carry e lo ridisegna
;                 GET_LAYOUT_ITEM   Legge un byte della struttura di una pagina
;                 PUT_CHAR_ECM      Stampa un carattere in modo ECM
; DIPENDENZE:     "config.asm"
;                 <c64/kernal.asm>
;                 <c64/petscii.asm>
;                 <c64/symbols.asm>
;                 <chip/vic_ii.asm>
;                 <system/branch.asm>
;                 <system/standard.asm>
;                 <io/chars.asm>
;                 <system/vic_ii_tools.asm>
;                 <system/print_tools.asm>
;                 "screen_drawing.asm"
;                 "opcode_tests.asm"
;                 "data_tables.asm"
; REQUISITI ZP:   __BG_COL
; ==============================================================================

; ------------------------------------------------------------------------------
; Uscita e processore
; ------------------------------------------------------------------------------

!to "binary playgrnd", cbm
!sl "binary_playground.lbl"

; ------------------------------------------------------------------------------
; Configurazione
; ------------------------------------------------------------------------------

; PROVA TEMPORANEA: once sospeso (LIB-01).
!source "config.asm"

; ------------------------------------------------------------------------------
; Simboli
; ------------------------------------------------------------------------------

!source <c64/kernal.asm>
!source <c64/petscii.asm>
!source <c64/symbols.asm>
!source <chip/vic_ii.asm>

; ------------------------------------------------------------------------------
; Mappa di memoria
; ------------------------------------------------------------------------------

BASIC_START         = BASTXT    ; Inizio del programma BASIC

; ($0801-$0832) Preambolo BASIC
; ($0833-$0835) Avvio
; ($0836-$089D) Moduli di libreria
; ($089E-$0E56) Moduli del programma
; ($0E57-$13BD) Tabelle dati
; ($13BE-$13C6) Variabili globali
; ($13C7-$142B) Codice principale
; ($142C-$14D2) Subroutine del codice

; ------------------------------------------------------------------------------
; Macro
; ------------------------------------------------------------------------------

!source <system/branch.asm>
!source <system/standard.asm>

; ------------------------------------------------------------------------------
; Costanti globali
; ------------------------------------------------------------------------------

LAYOUT_ACC          = 0         ; Offset della posizione di .A nella struttura che descrive la pagina da visualizzare.
LAYOUT_MEM          = 1         ; Offset della posizione di .M nella struttura che descrive la pagina da visualizzare.
LAYOUT_CARRY        = 2         ; Offset della posizione di C nella struttura che descrive la pagina da visualizzare.
LAYOUT_TESTS        = 3         ; Offset dell'indirizzo della batteria di test nella struttura che descrive la pagina da visualizzare.
LAYOUT_LABELS       = 5         ; Offset dell'indirizzo della tabella di messaggi di testo nella struttura che descrive la pagina da visualizzare.

; ------------------------------------------------------------------------------
; Inizio del codice
; ------------------------------------------------------------------------------

; [MAPPA: Preambolo BASIC]
*= BASIC_START
  +m_BASIC_Preamble 10, START, "BINARY PLAYGROUND (C) 2026 JOJO1973"

; [MAPPA: Avvio]
START:
  jmp MAIN

; ------------------------------------------------------------------------------
; Moduli di libreria
; ------------------------------------------------------------------------------

; [MAPPA: Moduli di libreria]
!source <io/chars.asm>
!source <system/vic_ii_tools.asm>
!source <system/print_tools.asm>

; ------------------------------------------------------------------------------
; Moduli del programma
; ------------------------------------------------------------------------------

; [MAPPA: Moduli del programma]
!source "screen_drawing.asm"
!source "opcode_tests.asm"

; [MAPPA: Tabelle dati]
!source "data_tables.asm"

; ------------------------------------------------------------------------------
; Variabili globali
; ------------------------------------------------------------------------------

; [MAPPA: Variabili globali]
_A_IMAGE:
  !byte %10001111               ; Valore dell'accumulatore .A nei test.

_M_IMAGE:
  !byte %10000001               ; Valore della memoria M nei test.

_P_IMAGE:
  !byte 0                       ; Valore del registro di stato .P dopo i test.

_RES_IMAGE:
  !byte 0                       ; Valore del risultato dell'operazione dopo i test.

_CARRY_IMAGE:
  !byte 0                       ; Stato del flag di Carry prima del test.

_FLAG_MASK:
  !byte 0                       ; Maschera di selezione dei flag rilevanti per ciascun test.

_CURR_PAGE:
  !byte 0                       ; Indice della pagina di test attualmente visualizzata.

_CURR_DIGIT:
  !byte 0                       ; Cifra di .A (0-7) o di M (8-15) attualmente selezionata.

_TESTS_VECTOR:
  !word $0000                   ; Vettore che punta alla batteria di test da eseguire.

; ------------------------------------------------------------------------------
; Codice principale
; ------------------------------------------------------------------------------

; [MAPPA: Codice principale]
; ==============================================================================
; SUBROUTINE: MAIN
; ------------------------------------------------------------------------------
; Descrizione:  Programma principale: imposta i colori del VIC-II con la tabella
;               PALETTE e attiva il modo Colore di Sfondo Esteso, disegna la
;               pagina corrente (_CURR_PAGE) con le righe di .A, della memoria e
;               del Carry e con i risultati dei test, poi attende la pressione
;               di un tasto e ritorna al BASIC.
;
;               Le subroutine CLRSCR e GETIN del Kernal alterano proprie celle
;               di lavoro, il cui contenuto non è garantito dopo la chiamata.
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
; Registri Modificati:  .A, .X, .Y, .P (Negative, oVerflow, Decimal,
;                       Interrupt, Zero, Carry), SCROLY, _CURR_PAGE, __BG_COL
; Dipendenze Esterne:   <c64/kernal.asm>
;                       <c64/symbols.asm>
;                       <chip/vic_ii.asm>
;                       <system/vic_ii_tools.asm>
;                       "data_tables.asm"
;                       "screen_drawing.asm"
; ==============================================================================
!zone Main

  MAIN:
    jsr CLRSCR                  ; Cancella lo schermo e imposta il modo video.

    lda #<PALETTE               ; Imposta i colori del VIC-II
    ldx #>PALETTE
    jsr VIC_PALETTE
    +m_VIC_Ext_Color_On         ; e attiva il modo Colore di Sfondo Esteso.

    jsr PRINT_TITLE             ; Stampa il titolo del programma.

    lda #0                      ; Inizializza l'indice della pagina da visualizzare.
    sta _CURR_PAGE
    jsr REFRESH_PAGE

  .Loop_Read_Key:
    jsr GETIN                   ; FOREVER

    cmp #"1"
    bcc .Read_Next_Key

    cmp #"6"
    bcc .Case_1_5               ; CASE: tasti da "1" a "5"

    cmp #"C"
    beq .Case_C                 ; CASE: tasto "C"

    cmp #"?"
    beq .Case_Help              ; CASE: tasto "?"

    cmp #"X"
    beq .Exit_MAIN

    +m_Bra .Read_Next_Key

  .Case_1_5:
    sec                         ; Trasforma il codice PETSCII del tasto premuto
    sbc #"1"                    ; in un indice alla pagina da visualizzare.
    sta _CURR_PAGE
    jsr REFRESH_PAGE
    +m_Bra .Read_Next_Key

  .Case_C:
    jsr TOGGLE_CARRY            ; Inverti il valore del Carry (0/1).
    +m_Bra .Read_Next_Key

  .Case_Help:
    jsr PRINT_HELP              ; Mostra una schermata di aiuto.
    jsr REFRESH_PAGE

  .Read_Next_Key:
    +m_Bra .Loop_Read_Key       ; FOREVER: legge il tasto successivo

  .Exit_MAIN:
    jsr CLRSCR                  ; Pulisci lo schermo.

    lda #<PALETTE_STD           ; Imposta i colori del VIC-II
    ldx #>PALETTE_STD
    jsr VIC_PALETTE
    +m_VIC_Ext_Color_Off        ; e disattiva il modo Colore di Sfondo Esteso, poi esci.

    rts

!zone

; ------------------------------------------------------------------------------
; Subroutine del codice
; ------------------------------------------------------------------------------

; [MAPPA: Subroutine del codice]
; ==============================================================================
; SUBROUTINE: REFRESH_PAGE
; ------------------------------------------------------------------------------
; Descrizione:  Ridisegna lo schermo con la pagina corrente (_CURR_PAGE):
;               intestazione ed etichette della pagina, operandi A e M, Carry e
;               risultati dei test.
;
; Input:
;   - _CURR_PAGE (1 byte, RAM) : Indice della pagina corrente (0-4)
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .Y, .P (Negative, oVerflow, Decimal, Interrupt,
;                       Zero, Carry), __BG_COL
; Dipendenze Esterne:   <chip/vic_ii.asm>
;                       "screen_drawing.asm"
; ==============================================================================
!zone Refresh_Page

  REFRESH_PAGE:
    jsr PRINT_PAGE              ; Disegna la pagina corrente ed imposta il colore di sfondo.
    lda #VIC_BG0
    sta __BG_COL

    jsr PRINT_A                 ; Stampa .A, se serve.
    jsr PRINT_M                 ; Stampa M, se serve.
    jsr PRINT_CARRY             ; Stampa C, se serve.

    jsr PRINT_TESTS             ; Aggiorna lo schermo con i risultati dei test.

  .Exit_REFRESH_PAGE:
    rts

!zone

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

; ==============================================================================
; SUBROUTINE: GET_LAYOUT_ITEM
; ------------------------------------------------------------------------------
; Descrizione:  Legge il byte di indice .Y della struttura della pagina .A e
;               lascia ZP_1 puntato all'inizio della struttura.
;
; Input:
;   - .A (1 byte, CPU)   : Numero della pagina (0-4)
;   - .Y (1 byte, CPU)   : Indice del byte nella struttura
;
; Output:
;   - .A (1 byte, CPU)   : Byte letto
;   - ZP_1 (2 byte, ZP)  : Indirizzo della struttura della pagina
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .P (Negative, Zero, Carry), ZP_1 (2 byte)
; Dipendenze Esterne:   <c64/symbols.asm>
; ==============================================================================
!zone Get_Layout_Item

  GET_LAYOUT_ITEM:
    asl a                       ; Trasforma .A in un indice della tabella.
    tax

    lda PAGE_LAYOUTS,x          ; Punta ZP_1 alla struttura della pagina.
    sta ZP_2
    lda PAGE_LAYOUTS+1,x
    sta ZP_2+1

    lda (ZP_2),y                ; Legge il byte della struttura.

  .Exit_GET_LAYOUT_ITEM:
    rts

!zone

; ==============================================================================
; SUBROUTINE: PUT_CHAR_ECM
; ------------------------------------------------------------------------------
; Descrizione:  Driver di stampa del programma, usato dalle subroutine PRINT_*
;               attraverso il punto di personalizzazione __PUT_CHAR: stampa in
;               modo Colore di Sfondo Esteso il carattere PETSCII in .A, con il
;               colore di sfondo scelto da __BG_COL, e restituisce .A, .X e .Y
;               invariati. I codici ECM_BG0-ECM_BG3 cambiano il colore di sfondo
;               senza stampare nulla. Il lavoro lo fa la macro m_Put_ECM_Char
;               [NOTA #02 in <system/print_tools.asm>].
;
; Input:
;   - .A (1 byte, CPU)      : Codice PETSCII da stampare
;   - __BG_COL (1 byte, ZP) : Selettore del colore di sfondo (0-3)
;
; Output:
;   - __BG_COL (1 byte, ZP) : Nuovo selettore (se il codice è ECM_BG0-ECM_BG3)
;   - RVS (1 byte, ZP)      : Modo reverse (bit #1 di __BG_COL), se il codice è
;                             stampabile
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .P (Negative, oVerflow, Zero, Carry), __BG_COL, RVS
; Dipendenze Esterne:   <c64/kernal.asm>
;                       <c64/symbols.asm>
;                       <io/chars.asm>
;                       <system/branch.asm>
;                       <system/print_tools.asm>
; ==============================================================================
!zone Put_Char_ECM

  PUT_CHAR_ECM:
    +m_Put_ECM_Char

  .Exit_PUT_CHAR_ECM:
    rts

!zone
