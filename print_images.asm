; Output routines to print contents of .A, Memory and .P

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

; Print .A in hexadecimal format
!zone Print_Hex
PRINT_HEX:
  pha                           ; Save .A on the stack.

  lda #"$"
  jsr __PUTCHAR

  pla                           ; Restore .A and copy to .X.
  tax

  lsr a                         ; Print upper nibble.
  lsr a
  lsr a
  lsr a
  tay
  lda .HEX_DIGITS,y
  jsr __PUTCHAR

  txa                           ; Print lower nibble.
  and #%00001111
  tay
  lda .HEX_DIGITS,y
  jsr __PUTCHAR

.Exit_PRINT_HEX:
  rts

.HEX_DIGITS:
  !text "0123456789ABCDEF"
!zone

; Print .A in Binary Coded Decimal format
!zone Print_BCD
PRINT_BCD:
  pha                           ; Save .A on the stack.

  lda #"$"
  jsr __PUTCHAR

  pla                           ; Restore .A and copy to .X.
  tax

  lsr a                         ; Print upper nibble.
  lsr a
  lsr a
  lsr a
  tay
  lda .BCD_DIGITS,y
  jsr __PUTCHAR

  txa                           ; Print lower nibble.
  and #%00001111
  tay
  lda .BCD_DIGITS,y
  jsr __PUTCHAR

.Exit_PRINT_BCD:
  rts

.BCD_DIGITS:
  !text "0123456789??????"
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

; Print flags, but only the selected ones
!zone Print_Flags
PRINT_FLAGS:
  ldy #"-"                      ; If a flag's status is unaffected print "-", otherwise print "1" or "0".
  ldx #VIC_BG0                  ; By default, flag info is printed with back ground color BGCOL0.
  stx __BGCOL

.Test_N:
  lda #%10000000                ; Check if N must be printed:
  bit FLAG_MASK                 ; FLAG_MASK has its bits set if the corresponding flag must be printed.
  beq .Print_N                  ; If FLAG_MASK's bit #7 is off, go to print "-"

  ldy #"0"                      ; Prepare .Y with ASCII code of "0"
  bit P_IMAGE                   ; and test N.
  beq .Set_N_Color              ; If N is clear, change the printing color and print it
  iny                           ; otherwise change the ASCII code in .Y to "1"'s.

.Set_N_Color:
  ldx #VIC_BG3                  ; Active flags are printed in BGCOL3 background color.
  stx __BGCOL

.Print_N:
  jsr .Print_Flag_Char

.Test_V:
  lda #%01000000                ; Check if V must be printed:
  bit FLAG_MASK
  beq .Print_V                  ; If FLAG_MASK's bit #6 is off, go to print "-"

  ldy #"0"                      ; Prepare .Y with ASCII code of "0"
  bit P_IMAGE                   ; and test V.
  beq .Set_V_Color              ; If V is clear, change the printing color and print it
  iny                           ; otherwise change the ASCII code in .Y to "1"'s.

.Set_V_Color:
  ldx #VIC_BG3                  ; Active flags are printed in BGCOL3 background color.
  stx __BGCOL

.Print_V:
  jsr .Print_Flag_Char

.Test_Z:
  lda #%00000010                ; Check if Z must be printed:
  bit FLAG_MASK
  beq .Print_Z                  ; If FLAG_MASK's bit #1 is off, go to print "-"

  ldy #"0"                      ; Prepare .Y with ASCII code of "0"
  bit P_IMAGE                   ; and test Z.
  beq .Set_Z_Color              ; If Z is clear, change the printing color and print it
  iny                           ; otherwise change the ASCII code in .Y to "1"'s.

.Set_Z_Color:
  ldx #VIC_BG3                  ; Active flags are printed in BGCOL3 background color.
  stx __BGCOL

.Print_Z:
  jsr .Print_Flag_Char

.Test_C:
  lda #%00000001                ; Check if C must be printed:
  bit FLAG_MASK
  beq .Print_C                  ; If FLAG_MASK's bit #0 is off, go to print "-"

  ldy #"0"                      ; Prepare .Y with ASCII code of "0"
  bit P_IMAGE                   ; and test C.
  beq .Set_C_Color              ; If C is clear, change the printing color and print it
  iny                           ; otherwise change the ASCII code in .Y to "1"'s.

.Set_C_Color:
  ldx #VIC_BG3                  ; Active flags are printed in BGCOL3 background color.
  stx __BGCOL

.Print_C:
.Print_Flag_Char:
  tya                           ; Copy .Y to .A and print the character
  jsr __PUTCHAR

  ldy #"-"                      ; then restore .X and .Y for the next flag.
  ldx #VIC_BG0
  stx __BGCOL

.Exit_Print_Flag_Char:
  rts
!zone
