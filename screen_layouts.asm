; ==============================================================================
; FILE:           screen_layouts.asm
; PROGETTO:       Binary Playground (Binary_Playground.c64)
; TARGET:         ACME Assembler / MOS 6510 (Commodore 64)
; DESCRIZIONE:    Strutture che descrivono le cinque pagine (dati e etichette),
;                 l'intestazione comune, la schermata del titolo e l'utilità per
;                 leggere le strutture.
; CONTENUTO:      GET_LAYOUT_ITEM   Legge un byte della struttura di una pagina
; DIPENDENZE:     Nessuna
; REQUISITI ZP:   ZP_1
; ==============================================================================

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
    sta ZP_1
    lda PAGE_LAYOUTS+1,x
    sta ZP_1+1

    lda (ZP_1),y                ; Legge il byte della struttura.

  .Exit_GET_LAYOUT_ITEM:
    rts

!zone

; Indirizzi delle strutture delle pagine, in ordine di numero
; di pagina (0-4).
PAGE_LAYOUTS:
  !word PAGE_LAYOUT_1
  !word PAGE_LAYOUT_2
  !word PAGE_LAYOUT_3
  !word PAGE_LAYOUT_4
  !word PAGE_LAYOUT_5

TITLE_SCREEN:
  !text 6, 9, "**********************", $00
  !text 7, 9, "*                    *", $00
  !text 8, 9, "* BINARY  PLAYGROUND *", $00
  !text 9, 9, "*                    *", $00
  !text 10, 9, "**********************", $00
  !text 14, 9, "PRESS ANY KEY TO START", $00
  !text $FF, $FF

; Intestazione comune a tutte le pagine, nel formato dei
; messaggi di PRINT_MSG [NOTA #01 in print_tools.asm].
PAGE_HEADER:
  !text 0, 1, ECM_BG1, " BINARY PLAYGROUND ", $00
  !text 0, 29, ECM_BG2, "?", ECM_BG0, " FOR HELP", $00
  !text 1, 1, ECM_BG2, "PAGE #", $00
  !text 3, 1, ECM_BG1, " LOAD ", $00
  !text 3, 9, ECM_BG2, "7654", $00
  !text 3, 14, ECM_BG2, "3210", $00
  !text 3, 20, ECM_BG2, "HEX", $00
  !text 3, 25, ECM_BG2, "UNS", $00
  !text 3, 30, ECM_BG2, "SIG", $00
  !text 3, 35, ECM_BG2, "NVZC", $00
  !text $FF, $FF

; ------------------------------------------------------------------------------
; Strutture delle pagine. Ogni struttura comincia con 10 byte:
;
;   byte 0    Riga di .A ($FF se la pagina non mostra .A)
;   byte 1    Riga della memoria ($FF se non è mostrata)
;   byte 2    Maschera dei flag per .A e per la memoria
;   byte 3-6  Maschere dei flag dei risultati da 1 a 4
;   byte 7    Riga del Carry ($FF se non è mostrato)
;   byte 8-9  Indirizzo della subroutine TESTS_n
;
; Seguono le etichette della pagina, nel formato dei messaggi
; di PRINT_MSG [NOTA #01 in print_tools.asm]. Nel titolo, $05
; e $90 sono i codici PETSCII di bianco e nero.
; ------------------------------------------------------------------------------

PAGE_LAYOUT_1:
  !byte $FF
  !byte 5
  !byte %10000010
  !byte %10000010
  !byte %10000010
  !byte %10000010
  !byte %11000011
  !byte $FF
  !word TESTS_1

  !text 1, 16, ECM_BG3, $05, " INCREMENT & DECREMENT ", $90, $00
  !text 5, 6, ECM_BG2, "M:", ECM_BG0, $00
  !text 9, 1, ECM_BG1, " INCREMENT ", $00
  !text 11, 4, ECM_BG2, "INC:", $00
  !text 14, 1, ECM_BG1, " DECREMENT ", $00
  !text 16, 4, ECM_BG2, "DEC:", $00
  !text $FF, $FF

PAGE_LAYOUT_2:
  !byte 5
  !byte 6
  !byte %10000010
  !byte %10000011
  !byte %11000011
  !byte %11000010
  !byte %11000011
  !byte 8
  !word TESTS_2

  !text 1, 18, ECM_BG3, $05, " TESTS & COMPARISONS ", $90, $00
  !text 5, 6, ECM_BG2, "A:", ECM_BG0, $00
  !text 6, 6, ECM_BG2, "M:", ECM_BG0, $00
  !text 8, 21, ECM_BG2, "CARRY BEFORE OP:", $00
  !text 10, 1, ECM_BG1, " UNSIGNED COMPARISON ", $00
  !text 12, 4, ECM_BG2, "CMP:", $00
  !text 15, 1, ECM_BG1, " SIGNED COMPARISON ", $00
  !text 17, 4, ECM_BG2, "SBC:", $00
  !text 20, 1, ECM_BG1, " BIT TEST ", $00
  !text 22, 4, ECM_BG2, "BIT:", $00
  !text $FF, $FF

PAGE_LAYOUT_3:
  !byte 5
  !byte 6
  !byte %10000010
  !byte %10000010
  !byte %10000010
  !byte %10000010
  !byte %10000010
  !byte $FF
  !word TESTS_3

  !text 1, 20, ECM_BG3, $05, " BOOLEAN OPERATORS ", $90, $00
  !text 5, 6, ECM_BG2, "A:", ECM_BG0, $00
  !text 6, 6, ECM_BG2, "M:", ECM_BG0, $00
  !text 10, 1, ECM_BG1, " BITWISE AND ", $00
  !text 12, 4, ECM_BG2, "AND:", $00
  !text 15, 1, ECM_BG1, " BITWISE OR ", $00
  !text 17, 4, ECM_BG2, "ORA:", $00
  !text 20, 1, ECM_BG1, " BITWISE EXCLUSIVE OR ", $00
  !text 22, 4, ECM_BG2, "EOR:", $00
  !text $FF, $FF

PAGE_LAYOUT_4:
  !byte 4
  !byte $FF
  !byte %10000010
  !byte %10000011
  !byte %10000011
  !byte %10000011
  !byte %10000011
  !byte 5
  !word TESTS_4

  !text 1, 19, ECM_BG3, $05, " SHIFTS & ROTATIONS ", $90, $00
  !text 4, 6, ECM_BG2, "A:", ECM_BG0, $00
  !text 5, 1, ECM_BG1, " SHIFT LEFT ", $00
  !text 5, 21, ECM_BG2, "CARRY BEFORE OP:", $00
  !text 6, 3, ECM_BG2, "ASL1:", $00
  !text 7, 3, ECM_BG2, "ASL2:", $00
  !text 8, 3, ECM_BG2, "ASL3:", $00
  !text 9, 3, ECM_BG2, "ASL4:", $00
  !text 10, 1, ECM_BG1, " SHIFT RIGHT ", $00
  !text 11, 3, ECM_BG2, "LSR1:", $00
  !text 12, 3, ECM_BG2, "LSR2:", $00
  !text 13, 3, ECM_BG2, "LSR3:", $00
  !text 14, 3, ECM_BG2, "LSR4:", $00
  !text 15, 1, ECM_BG1, " ROTATE LEFT ", $00
  !text 16, 3, ECM_BG2, "ROL1:", $00
  !text 17, 3, ECM_BG2, "ROL2:", $00
  !text 18, 3, ECM_BG2, "ROL3:", $00
  !text 19, 3, ECM_BG2, "ROL4:", $00
  !text 20, 1, ECM_BG1, " ROTATE RIGHT ", $00
  !text 21, 3, ECM_BG2, "ROR1:", $00
  !text 22, 3, ECM_BG2, "ROR2:", $00
  !text 23, 3, ECM_BG2, "ROR3:", $00
  !text 24, 3, ECM_BG2, "ROR4:", $00
  !text $FF, $FF

PAGE_LAYOUT_5:
  !byte 5
  !byte 6
  !byte %10000010
  !byte %11000011
  !byte %11000011
  !byte %11000011
  !byte %11000011
  !byte 8
  !word TESTS_5

  !text 1, 27, ECM_BG3, $05, " ARITHMETIC ", $90, $00
  !text 5, 6, ECM_BG2, "A:", ECM_BG0, $00
  !text 6, 6, ECM_BG2, "M:", ECM_BG0, $00
  !text 8, 21, ECM_BG2, "CARRY BEFORE OP:", $00
  !text 10, 1, ECM_BG1, " BINARY ARITHMETIC ", $00
  !text 12, 4, ECM_BG2, "ADC:", $00
  !text 13, 4, ECM_BG2, "SBC:", $00
  !text 16, 1, ECM_BG1, " BINARY CODED DECIMAL ARITHMETIC ", $00
  !text 18, 20, ECM_BG2, "BCD", $00
  !text 19, 4, ECM_BG2, "ADC:", $00
  !text 20, 4, ECM_BG2, "SBC:", $00
  !text $FF, $FF
