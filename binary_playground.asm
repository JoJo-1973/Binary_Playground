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
; CONTENUTO:      MAIN          Disegna la pagina corrente e attende un tasto
;                 PUT_CHAR_ECM  Stampa un carattere in modo ECM
; DIPENDENZE:     "config.asm"
;                 <c64/kernal.asm>
;                 <c64/symbols.asm>
;                 <chip/vic_ii.asm>
;                 <system/branch.asm>
;                 <system/standard.asm>
;                 <io/chars.asm>
;                 <system/vic_ii_tools.asm>
;                 <system/print_tools.asm>
;                 "print_images.asm"
;                 "draw_screen.asm"
;                 "screen_layouts.asm"
;                 "opcode_tests.asm"
; REQUISITI ZP:   __BG_COL
; ==============================================================================

; ------------------------------------------------------------------------------
; Uscita e processore
; ------------------------------------------------------------------------------

!to "binary playgrnd", cbm

; ------------------------------------------------------------------------------
; Configurazione
; ------------------------------------------------------------------------------

; PROVA TEMPORANEA: once sospeso (LIB-01).
!source "config.asm"

; ------------------------------------------------------------------------------
; Simboli
; ------------------------------------------------------------------------------

!source <c64/kernal.asm>
!source <c64/symbols.asm>
!source <chip/vic_ii.asm>

; ------------------------------------------------------------------------------
; Macro
; ------------------------------------------------------------------------------

!source <system/branch.asm>
!source <system/standard.asm>

; ------------------------------------------------------------------------------
; Inizio del codice
; ------------------------------------------------------------------------------

*= BASTXT
  +m_BASIC_Preamble 10, START, "BINARY PLAYGROUND"

START:
  jmp MAIN

; ------------------------------------------------------------------------------
; Codice
; ------------------------------------------------------------------------------

!source <io/chars.asm>
!source <system/vic_ii_tools.asm>
!source <system/print_tools.asm>
!source "print_images.asm"
!source "draw_screen.asm"
!source "screen_layouts.asm"
!source "opcode_tests.asm"

; ------------------------------------------------------------------------------
; Subroutine
; ------------------------------------------------------------------------------

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
; Registri Modificati:  .A, .X, .Y, .P (Negative, oVerflow, Zero, Carry),
;                       SCROLY, __BG_COL
; Dipendenze Esterne:   <c64/kernal.asm>
;                       <c64/symbols.asm>
;                       <chip/vic_ii.asm>
;                       <system/vic_ii_tools.asm>
;                       "draw_screen.asm"
;                       "print_images.asm"
;                       "screen_layouts.asm"
; ==============================================================================
!zone Main

  MAIN:
    jsr CLRSCR                  ; Cancella lo schermo e imposta il modo video.

    lda #<PALETTE               ; Imposta i colori del VIC-II
    ldx #>PALETTE
    jsr VIC_PALETTE
    +m_VIC_Ext_Color_On         ; e attiva il modo Colore di Sfondo Esteso.

    jsr PRINT_PAGE              ; Disegna la pagina corrente,
    lda #VIC_BG0
    sta __BG_COL
    jsr PRINT_A                 ; le righe di .A, della memoria e del Carry
    jsr PRINT_M
    jsr PRINT_CARRY

    jsr REDRAW_4                ; e i risultati dei test.

  .Loop_Read_Key:
    jsr GETIN                   ; REPEAT

  .Loop_Check_Key:
    beq .Loop_Read_Key          ; REPEAT UNTIL: è stato premuto un tasto

  .Exit_MAIN:
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

; ------------------------------------------------------------------------------
; Dati globali
; ------------------------------------------------------------------------------

_A_IMAGE:
  !byte %10001111

_M_IMAGE:
  !byte %10000001

_P_IMAGE:
  !byte %00000000

_RES_IMAGE:
  !byte $00

_CARRY_IMAGE:
  !byte 0

_FLAG_MASK:
  !byte %00000000

_CURR_PAGE:
  !byte 3

; Colori per EXTCOL, BGCOL0-BGCOL3, SPMC0, SPMC1 e COLOR,
; nell'ordine in cui li legge VIC_PALETTE.
PALETTE:
  !byte VIC_BLACK, VIC_GREEN, VIC_LIGHT_GREY, VIC_YELLOW, VIC_BLACK, VIC_TRANSPARENT, VIC_TRANSPARENT, VIC_BLACK
