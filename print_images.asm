; Output routines to print contents of A, M and P

; Print .A in binary format
!zone Print_Binary
PRINT_BINARY:
  ldx #8                        ; One byte is equal to 8 bits.

.Loop_Print_Bit:
  cpx #4                        ; Check if 4 bits have already been printed.
  bne .Print_Bit
  tay                           ; Print a space after the 4th bit.
  lda #29
  jsr __PUTCHAR
  tya

.Print_Bit:
  rol a                         ; Move the most significat bit in C,
  pha

  lda #0
  adc #"0"                      ; add the ASCII code of "0"
  jsr __PUTCHAR                 ; and print the result.

  pla
  dex
  bne .Loop_Print_Bit

.Exit_PRINT_BINARY:
  rts
!zone

; Print .A in unsigned decimal format
!zone Print_Unsigned
PRINT_UNSIGNED:
  ldx #2                        ; Largest byte value is in the order of hundreds.
  ldy #0                        ; .Y will store the computed digit.

.Loop_Calc_Digit:
  sec                           ; Subtract a power of 10
  sbc .DEC_POWERS,x
  iny                           ; and increment the computed digit:
  bcs .Loop_Calc_Digit          ; if there is no borrow keep on subtracting.

  adc .DEC_POWERS,x             ; Loop ends after one subtraction too many,
  dey                           ; so add back the amount subtracted.

.Print_Digit:
  pha                           ; Save .A on the stack and overwrite it with .Y
  tya
  clc                           ; then add the ASCII code of "0" and print the result.
  adc #"0"
  jsr __PUTCHAR

.Next_Calc_Digit:
  pla                           ; Finally restore .A,
  ldy #0                        ; prepare .Y for the computation of next digit
  dex                           ; and switch to the next power of 10
  bpl .Loop_Calc_Digit          ; if they're not finished.

.Exit_PRINT_UNSIGNED
  rts

.DEC_POWERS:
  !byte 1,10,100
!zone

; Print .A in signed decimal format
!zone Print_Signed
PRINT_SIGNED:
  tay                           ; Save a copy of .A in .Y.
  bmi .Negative                 ; If the value is negative, skip forward
  lda #"+"                      ; otherwise load .A with the ASCII code of "+"
  +Skip2                        ; and skip next instruction.

.Negative:
  lda #"-"                      ; Load .A with ASCII code of "-"
  jsr __PUTCHAR                 ; and print whatever character is in .A.

  tya                           ; Restore .A
  bpl .Exit_PRINT_SIGNED        ; and if it's positive just print it and exit
  eor #$FF                      ; otherwise 2-complement it before printing it.
  clc
  adc #1

.Exit_PRINT_SIGNED:
  jmp PRINT_UNSIGNED
