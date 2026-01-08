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
