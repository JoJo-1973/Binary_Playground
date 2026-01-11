; Routines to test opcodes

; Results storage area
RESULTS:
  !byte $00, $00                ; Result #1: first byte is actual result, second byte is associated flags.
  !byte $00, $00                ; Result #2
  !byte $00, $00                ; Result #3
  !byte $00, $00                ; Result #4
  !byte $00, $00                ; Result #5
  !byte $00, $00                ; Result #6
  !byte $00, $00                ; Result #7
  !byte $00, $00                ; Result #8
  !byte $00, $00                ; Result #9
  !byte $00, $00                ; Result #10
  !byte $00, $00                ; Result #11
  !byte $00, $00                ; Result #12
  !byte $00, $00                ; Result #13
  !byte $00, $00                ; Result #14
  !byte $00, $00                ; Result #15
  !byte $00, $00                ; Result #16

!zone Test_INC
TEST_INC:
  ldx M_IMAGE                   ; Opcode test.
  inx
  stx RES_IMAGE                 ; Save result.

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%10000010                ; Only N and Z matter.
  sta FLAG_MASK

  ldx #11                       ; Row location.

.Exit_TEST_INC
  rts
!zone

!zone Test_DEC
TEST_DEC:
  ldx M_IMAGE                   ; Opcode test.
  dex
  stx RES_IMAGE                 ; Save result.

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%10000010                ; Only N and Z matter.
  sta FLAG_MASK

  ldx #16                       ; Row location.

.Exit_TEST_DEC
  rts
!zone

!zone Test_CMP
TEST_CMP:
  lda CARRY_IMAGE               ; Set C accordingly.
  ror a

  lda A_IMAGE                   ; Test opcode.
  cmp M_IMAGE
  sta RES_IMAGE                 ; Save result.

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%10000011                ; Only N, Z and C matter.
  sta FLAG_MASK

  ldx #12                       ; Row location.

.Exit_TEST_CMP:
  rts
!zone

!zone Test_SBC
TEST_SBC:
  lda CARRY_IMAGE               ; Set C accordingly.
  ror a

  lda A_IMAGE                   ; Test opcode.
  sbc M_IMAGE
  sta RES_IMAGE                 ; Save result.

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%11000011                ; All flags matter.
  sta FLAG_MASK

  ldx #17                       ; Row location.

.Exit_TEST_SBC:
  rts
!zone

!zone Test_BIT
TEST_BIT:
  lda A_IMAGE                   ; Test opcode.
  bit M_IMAGE
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%11000010                ; Only N, V and Z matter.
  sta FLAG_MASK

  ldx #22                       ; Row location.

.Exit_TEST_BIT:
  rts
!zone

!zone Test_AND
TEST_AND:
  lda A_IMAGE                   ; Test opcode.
  and M_IMAGE
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%10000010                ; Only N and Z matter.
  sta FLAG_MASK

  ldx #12                       ; Row location.

.Exit_TEST_AND:
  rts
!zone

!zone Test_ORA
TEST_ORA:
  lda A_IMAGE                   ; Test opcode.
  ora M_IMAGE
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%10000010                ; Only N and Z matter.
  sta FLAG_MASK

  ldx #17                       ; Row location.

.Exit_TEST_ORA:
  rts
!zone

!zone Test_EOR
TEST_EOR:
  lda A_IMAGE                   ; Test opcode.
  eor M_IMAGE
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%10000010                ; Only N and Z matter.
  sta FLAG_MASK

  ldx #22                       ; Row location.

.Exit_TEST_EOR:
  rts
!zone

!zone Test_ADC_Hex
TEST_ADC_HEX:
  lda CARRY_IMAGE               ; Set C accordingly.
  ror a

  lda A_IMAGE                   ; Test opcode.
  adc M_IMAGE
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%11000011                ; All flags matter.
  sta FLAG_MASK

  ldx #12                       ; Row location.

.Exit_TEST_ADC_HEX:
  rts
!zone

!zone Test_SBC_Hex
TEST_SBC_HEX:
  lda CARRY_IMAGE               ; Set C accordingly.
  ror a

  lda A_IMAGE                   ; Test opcode.
  sbc M_IMAGE
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%11000011                ; All flags matter.
  sta FLAG_MASK

  ldx #13                       ; Row location.

.Exit_TEST_SBC_HEX:
  rts
!zone

!zone Test_ADC_BCD
TEST_ADC_BCD:
  lda CARRY_IMAGE               ; Set C accordingly.
  ror a

  sed
  lda A_IMAGE                   ; Test opcode.
  adc M_IMAGE
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE
  cld

  lda #%11000011                ; All flags matter.
  sta FLAG_MASK

  ldx #19                       ; Row location.

.Exit_TEST_ADC_BCD:
  rts
!zone

!zone Test_SBC_BCD
TEST_SBC_BCD:
  lda CARRY_IMAGE               ; Set C accordingly.
  ror a

  sed
  lda A_IMAGE                   ; Test opcode.
  sbc M_IMAGE
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE
  cld

  lda #%11000011                ; All flags matter.
  sta FLAG_MASK

  ldx #20                       ; Row location.

.Exit_TEST_SBC_BCD:
  rts
!zone

!zone Test_ASL1
TEST_ASL1:
  lda CARRY_IMAGE               ; Set C accordingly.
  ror a

  lda A_IMAGE                   ; Test opcode.
  asl a
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%10000011                ; Only N, Z and C matter.
  sta FLAG_MASK

  ldx #6                        ; Row location.

.Exit_TEST_ASL1:
  rts
!zone

!zone Test_ASL2
TEST_ASL2:
  lda CARRY_IMAGE               ; Set C accordingly.
  ror a

  lda A_IMAGE                   ; Test opcode.
  asl a
  asl a
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%10000011                ; Only N, Z and C matter.
  sta FLAG_MASK

  ldx #7                        ; Row location.

.Exit_TEST_ASL2:
  rts
!zone

!zone Test_ASL3
TEST_ASL3:
  lda CARRY_IMAGE               ; Set C accordingly.
  ror a

  lda A_IMAGE                   ; Test opcode.
  asl a
  asl a
  asl a
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%10000011                ; Only N, Z and C matter.
  sta FLAG_MASK

  ldx #8                        ; Row location.

.Exit_TEST_ASL3:
  rts
!zone

!zone Test_ASL4
TEST_ASL4:
  lda CARRY_IMAGE               ; Set C accordingly.
  ror a

  lda A_IMAGE                   ; Test opcode.
  asl a
  asl a
  asl a
  asl a
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%10000011                ; Only N, Z and C matter.
  sta FLAG_MASK

  ldx #9                        ; Row location.

.Exit_TEST_ASL4:
  rts
!zone

!zone Test_LSR1
TEST_LSR1:
  lda CARRY_IMAGE               ; Set C accordingly.
  ror a

  lda A_IMAGE                   ; Test opcode.
  lsr a
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%10000011                ; Only N, Z and C matter.
  sta FLAG_MASK

  ldx #11                        ; Row location.

.Exit_TEST_LSR1:
  rts
!zone

!zone Test_LSR2
TEST_LSR2:
  lda CARRY_IMAGE               ; Set C accordingly.
  ror a

  lda A_IMAGE                   ; Test opcode.
  lsr a
  lsr a
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%10000011                ; Only N, Z and C matter.
  sta FLAG_MASK

  ldx #12                        ; Row location.

.Exit_TEST_LSR2:
  rts
!zone

!zone Test_LSR3
TEST_LSR3:
  lda CARRY_IMAGE               ; Set C accordingly.
  ror a

  lda A_IMAGE                   ; Test opcode.
  lsr a
  lsr a
  lsr a
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%10000011                ; Only N, Z and C matter.
  sta FLAG_MASK

  ldx #13                        ; Row location.

.Exit_TEST_LSR3:
  rts
!zone

!zone Test_LSR4
TEST_LSR4:
  lda CARRY_IMAGE               ; Set C accordingly.
  ror a

  lda A_IMAGE                   ; Test opcode.
  lsr a
  lsr a
  lsr a
  lsr a
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%10000011                ; Only N, Z and C matter.
  sta FLAG_MASK

  ldx #14                        ; Row location.

.Exit_TEST_LSR4:
  rts
!zone

!zone Test_ROL1
TEST_ROL1:
  lda CARRY_IMAGE               ; Set C accordingly.
  ror a

  lda A_IMAGE                   ; Test opcode.
  rol a
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%10000011                ; Only N, Z and C matter.
  sta FLAG_MASK

  ldx #16                        ; Row location.

.Exit_TEST_ROL1:
  rts
!zone

!zone Test_ROL2
TEST_ROL2:
  lda CARRY_IMAGE               ; Set C accordingly.
  ror a

  lda A_IMAGE                   ; Test opcode.
  rol a
  rol a
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%10000011                ; Only N, Z and C matter.
  sta FLAG_MASK

  ldx #17                        ; Row location.

.Exit_TEST_ROL2:
  rts
!zone

!zone Test_ROL3
TEST_ROL3:
  lda CARRY_IMAGE               ; Set C accordingly.
  ror a

  lda A_IMAGE                   ; Test opcode.
  rol a
  rol a
  rol a
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%10000011                ; Only N, Z and C matter.
  sta FLAG_MASK

  ldx #18                        ; Row location.

.Exit_TEST_ROL3:
  rts
!zone

!zone Test_ROL4
TEST_ROL4:
  lda CARRY_IMAGE               ; Set C accordingly.
  ror a

  lda A_IMAGE                   ; Test opcode.
  rol a
  rol a
  rol a
  rol a
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%10000011                ; Only N, Z and C matter.
  sta FLAG_MASK

  ldx #19                        ; Row location.

.Exit_TEST_ROL4:
  rts
!zone

!zone Test_ROR1
TEST_ROR1:
  lda CARRY_IMAGE               ; Set C accordingly.
  ror a

  lda A_IMAGE                   ; Test opcode.
  ror a
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%10000011                ; Only N, Z and C matter.
  sta FLAG_MASK

  ldx #21                        ; Row location.

.Exit_TEST_ROR1:
  rts
!zone

!zone Test_ROR2
TEST_ROR2:
  lda CARRY_IMAGE               ; Set C accordingly.
  ror a

  lda A_IMAGE                   ; Test opcode.
  ror a
  ror a
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%10000011                ; Only N, Z and C matter.
  sta FLAG_MASK

  ldx #22                        ; Row location.

.Exit_TEST_ROR2:
  rts
!zone

!zone Test_ROR3
TEST_ROR3:
  lda CARRY_IMAGE               ; Set C accordingly.
  ror a

  lda A_IMAGE                   ; Test opcode.
  ror a
  ror a
  ror a
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%10000011                ; Only N, Z and C matter.
  sta FLAG_MASK

  ldx #23                        ; Row location.

.Exit_TEST_ROR3:
  rts
!zone

!zone Test_ROR4
TEST_ROR4:
  lda CARRY_IMAGE               ; Set C accordingly.
  ror a

  lda A_IMAGE                   ; Test opcode.
  ror a
  ror a
  ror a
  ror a
  sta RES_IMAGE

  php                           ; Save flags.
  pla
  sta P_IMAGE

  lda #%10000011                ; Only N, Z and C matter.
  sta FLAG_MASK

  ldx #24                        ; Row location.

.Exit_TEST_ROR4:
  rts
!zone
