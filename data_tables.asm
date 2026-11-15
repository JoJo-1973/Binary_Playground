; ==============================================================================
; FILE:           data_tables.asm
; PROGETTO:       Binary Playground (Binary_Playground.c64)
; TARGET:         ACME Assembler / MOS 6510 (Commodore 64)
; DESCRIZIONE:    Tabelle dati: le palette dei colori, le strutture delle cinque
;                 pagine (dati ed etichette) con la tabella dei loro indirizzi,
;                 l'intestazione comune e le schermate del titolo e dell'aiuto.
; DIPENDENZE:     Nessuna
; ==============================================================================

; Colori per EXTCOL, BGCOL0-BGCOL3, SPMC0, SPMC1 e COLOR,
; nell'ordine in cui li legge VIC_PALETTE.

; Palette usata dal programma
PALETTE:
  !byte VIC_BLACK, VIC_GREEN, VIC_LIGHT_GREY, VIC_YELLOW, VIC_BLACK, VIC_TRANSPARENT, VIC_TRANSPARENT, VIC_BLACK

; Palette standard del Commodore 64
PALETTE_STD:
  !byte VIC_LIGHT_BLUE, VIC_BLUE, VIC_WHITE, VIC_RED, VIC_CYAN, VIC_PURPLE, VIC_BLACK, VIC_LIGHT_BLUE

; Schermata del titolo nel formato dei
; messaggi di PRINT_MSG [NOTA #01 in print_tools.asm].
TITLE_SCREEN:
  !text 6, 9, ECM_BG3, PETSCII_WHITE, "**********************", $00
  !text 7, 9, "*                    *", $00
  !text 8, 9, "* BINARY  PLAYGROUND *", $00
  !text 9, 9, "*                    *", $00
  !text 10, 9, "**********************", $00
  !text 14, 8, ECM_BG2, PETSCII_BLACK, " PRESS ANY KEY TO START ", ECM_BG0, $00
  !text $FF, $FF

; Schermata di aiuto nel formato dei
; messaggi di PRINT_MSG [NOTA #01 in print_tools.asm].
HELP_SCREEN:
  !text 2, 1, ECM_BG1, " 1 ", ECM_BG0, PETSCII_WHITE, " INCREMENT & DECREMENT", PETSCII_BLACK, $00
  !text 4, 1, ECM_BG1, " 2 ", ECM_BG0, PETSCII_WHITE, " TESTS & COMPARISONS", PETSCII_BLACK, $00
  !text 6, 1, ECM_BG1, " 3 ", ECM_BG0, PETSCII_WHITE, " BOOLEAN OPERATORS", PETSCII_BLACK, $00
  !text 8, 1, ECM_BG1, " 4 ", ECM_BG0, PETSCII_WHITE, " SHIFTS & ROTATIONS", PETSCII_BLACK, $00
  !text 10, 1, ECM_BG1, " 5 ", ECM_BG0, PETSCII_WHITE, " ARITHMETIC", PETSCII_BLACK, $00
  !text 14, 1, ECM_BG0, PETSCII_WHITE, "USE ", PETSCII_BLACK, ECM_BG1, " CRSR ", ECM_BG0, PETSCII_WHITE, " TO SELECT BIT", PETSCII_BLACK, $00
  !text 16, 5, ECM_BG1, " RETURN ", ECM_BG0, PETSCII_WHITE, " TO TOGGLE BIT", PETSCII_BLACK, $00
  !text 18, 5, ECM_BG1, " C ", ECM_BG0, PETSCII_WHITE, " TO TOGGLE CARRY BEFORE OP", PETSCII_BLACK, $00
  !text 20, 5, ECM_BG1, " X ", ECM_BG0, PETSCII_WHITE, " TO QUIT", PETSCII_BLACK, $00
  !text 23, 6, ECM_BG2, " PRESS ANY KEY  TO CONTINUE ", $00
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

; Etichette da visualizzare in ciascuna pagina nel formato dei
; messaggi di PRINT_MSG [NOTA #01 in print_tools.asm].
PAGE_1:
  !text 1, 16, ECM_BG3, PETSCII_WHITE, " INCREMENT & DECREMENT ", PETSCII_BLACK, $00
  !text 5, 6, ECM_BG2, "M:", ECM_BG0, $00
  !text 9, 1, ECM_BG1, " INCREMENT ", $00
  !text 11, 4, ECM_BG2, "INC:", $00
  !text 14, 1, ECM_BG1, " DECREMENT ", $00
  !text 16, 4, ECM_BG2, "DEC:", $00
  !text $FF, $FF

PAGE_2:
  !text 1, 18, ECM_BG3, PETSCII_WHITE, " TESTS & COMPARISONS ", PETSCII_BLACK, $00
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

PAGE_3:
  !text 1, 20, ECM_BG3, PETSCII_WHITE, " BOOLEAN OPERATORS ", PETSCII_BLACK, $00
  !text 5, 6, ECM_BG2, "A:", ECM_BG0, $00
  !text 6, 6, ECM_BG2, "M:", ECM_BG0, $00
  !text 10, 1, ECM_BG1, " BITWISE AND ", $00
  !text 12, 4, ECM_BG2, "AND:", $00
  !text 15, 1, ECM_BG1, " BITWISE OR ", $00
  !text 17, 4, ECM_BG2, "ORA:", $00
  !text 20, 1, ECM_BG1, " BITWISE EXCLUSIVE OR ", $00
  !text 22, 4, ECM_BG2, "EOR:", $00
  !text $FF, $FF

PAGE_4:
  !text 1, 19, ECM_BG3, PETSCII_WHITE, " SHIFTS & ROTATIONS ", PETSCII_BLACK, $00
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

PAGE_5:
  !text 1, 27, ECM_BG3, PETSCII_WHITE, " ARITHMETIC ", PETSCII_BLACK, $00
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

; ------------------------------------------------------------------------------
; Strutture delle pagine. Ogni struttura comincia con 10 byte:
;
;   byte 0    Riga di .A ($FF se la pagina non mostra .A)
;   byte 1    Riga della memoria ($FF se non è mostrata)
;   byte 2    Riga del Carry ($FF se non è mostrato)
;   byte 3-4  Indirizzo della subroutine TESTS_n
;   byte 5-6  Indirizzo della tabella che descrive le etichette della pagina.
;
; La tabella delle etichette della pagina segue il formato dei messaggi
; di PRINT_MSG [NOTA #01 in print_tools.asm]. Nel titolo, i
; codici PETSCII_WHITE e PETSCII_BLACK portano il testo in
; bianco e poi di nuovo in nero.
; ------------------------------------------------------------------------------

; Indirizzi delle strutture delle pagine, in ordine di numero
; di pagina (0-4).
PAGE_LAYOUTS:
  !word PAGE_LAYOUT_1
  !word PAGE_LAYOUT_2
  !word PAGE_LAYOUT_3
  !word PAGE_LAYOUT_4
  !word PAGE_LAYOUT_5

PAGE_LAYOUT_1:
  !byte $FF
  !byte 5
  !byte $FF
  !word TESTS_1
  !word PAGE_1

PAGE_LAYOUT_2:
  !byte 5
  !byte 6
  !byte 8
  !word TESTS_2
  !word PAGE_2

PAGE_LAYOUT_3:
  !byte 5
  !byte 6
  !byte $FF
  !word TESTS_3
  !word PAGE_3

PAGE_LAYOUT_4:
  !byte 4
  !byte $FF
  !byte 5
  !word TESTS_4
  !word PAGE_4

PAGE_LAYOUT_5:
  !byte 5
  !byte 6
  !byte 8
  !word TESTS_5
  !word PAGE_5
