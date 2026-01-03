; Routines per stampare i contenuti delle immagini di A, M e P

; Stampa il contenute di .A in formato binario
!zone Print_Binary
PRINT_BINARY:
  ldx #8                        ; Un byte contiene 8 bit.

.Loop_Print_Bit:
  cpx #4                        ; Controlla se sono state stampate già 4 cifre.
  bne .Print_Bit
  tay                           ; Dopo aver stampato il 4° bit lascia uno spazio.
  lda #29
  jsr CHROUT
  tya

.Print_Bit:
  rol a                         ; Sposta il bit più significativo in C,
  pha

  lda #0
  adc #"0"                      ; aggiungi il codice ASCII della cifra 0
  jsr __PUTCHAR                 ; e stampalo.

  pla
  dex
  bne .Loop_Print_Bit

.Exit_PRINT_BINARY:
  rts
!zone

; Stampa il contenuto di .A come decimale senza segno
!zone Print_Unsigned
PRINT_UNSIGNED:
  ldx #2                        ; In un byte il valore massimo è dell'ordine delle centinaia.
  ldy #0                        ; .Y conterrà la cifra calcolata.

.Loop_Calc_Digit:
  sec                           ; Sottrai una potenza di 10
  sbc .DEC_POWERS,x
  iny                           ; ed incrementa la cifra calcolata:
  bcs .Loop_Calc_Digit          ; se la sottrazione non ha causato un prestito allora ripeti.

  adc .DEC_POWERS,x             ; Il ciclo termina quando si esegue una sottrazione di troppo
  dey                           ; quindi si riaggiunge quanto sottratto.

.Print_Digit:
  pha                           ; Salvia .A sullo stack e sovrascrivilo con .Y
  tya
  clc                           ; poi aggiungi il codice ASCII di "0" e stampalo.
  adc #"0"
  jsr __PUTCHAR

.Next_Calc_Digit:
  pla                           ; Infine ripristina .A,
  ldy #0                        ; prepara .Y al calcolo della cifra successiva
  dex                           ; e, se ce ne sono ancora,
  bpl .Loop_Calc_Digit          ; passa alla successiva potenza di 10.

.Exit_PRINT_UNSIGNED
  rts

.DEC_POWERS:
  !byte 1,10,100
!zone

; Stampa il contenuto di .A come decimale con segno
!zone Print_Signed
PRINT_SIGNED:
  tay                           ; Salva una copia di .A,
  bmi .Negative                 ; Se il numero è negativo, salta avanti
  lda #"+"                      ; altrimenti carica .A col codice ASCII del segno +
  +Skip2                        ; ed ignora la prossoma istruzione.

.Negative:
  lda #"-"                      ; Carica .A col codice ASCII del segno -
  jsr __PUTCHAR                 ; e stampa il segno.

  tya                           ; Riprendi .A
  bpl .Exit_PRINT_SIGNED        ; e se è positivo stampalo ed esci,
  eor #$FF                      ; altrimenti prima complementalo a 2.
  clc
  adc #1

.Exit_PRINT_SIGNED:
  jmp PRINT_UNSIGNED
