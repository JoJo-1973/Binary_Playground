; Screen drawing routines

; Print page header
!zone Print_Page_Header
PRINT_PAGE_HEADER:
  jsr CLRSCR                    ; Clear the screen.

  lda #<PAGE_HEADER             ; Point ZP_1 to header message table
  sta ZP_1
  lda #>PAGE_HEADER
  sta ZP_1+1

.Loop_Print_Header:
  lda #ZP_1                     ; and print it.
  jsr PRINT_MSG
  bcc .Loop_Print_Header

  lda #VIC_BG2                  ; Print page number.
  sta __BGCOL
  +At 1,7
  lda CURR_PAGE
  clc
  adc #"1"
  jsr __PUTCHAR

.Exit_PRINT_PAGE_HEADER:
  rts
!zone

; Print full page
!zone Print_Page
PRINT_PAGE:
  jsr PRINT_PAGE_HEADER         ; Print the header.

  lda CURR_PAGE                 ; Load ZP_1 with the address of the page layout
  ldy #0                        ; then add the proper offset so that ZP_1 points to the
  jsr GET_ITEM                  ; beginning of the page-specific message table.

  clc
  lda ZP_1
  adc #10
  sta ZP_1

  lda ZP_1+1
  adc #0
  sta ZP_1+1

.Loop_Print_Msg_Table:
  lda #ZP_1                     ; Print the rest of the on-screen labels.
  jsr PRINT_MSG
  bcc .Loop_Print_Msg_Table

.Exit_PRINT_PAGE:
  rts
!zone

; Print .A data
!zone Print_A
PRINT_A:
  lda CURR_PAGE                 ; The row where .A data is printed
  ldy #0                        ; is located in byte #0 of the page layout structure.
  jsr GET_ITEM

  cmp #$FF                      ; If row = $FF nothing must be printed.
  beq .Exit_PRINT_A

  tax                           ; Copy line number to .X.

  ldy A_IMAGE                   ; Test A_IMAGE by loading it into .Y
  php                           ; and save related flags in P_IMAGE.
  pla
  sta P_IMAGE

  lda #%10000010                ; "Load" opcodes affect only N and Z flags.
  sta FLAG_MASK

  tya                           ; Now push data to be printed on stack
  pha
  jmp PRINT_LINE                ; and go to the actual printing routine.

.Exit_PRINT_A:
  rts
!zone

; Print Memory data
!zone Print_M
PRINT_M:
  lda CURR_PAGE                 ; The row where Memory data is printed
  ldy #1                        ; is located in byte #1 of the page layout structure.
  jsr GET_ITEM

  cmp #$FF                      ; If row = $FF nothing must be printed.
  beq .Exit_PRINT_M

  tax                           ; Copy line number to .X.

  ldy M_IMAGE                   ; Test M_IMAGE by loading it into .Y
  php                           ; and save related flags in P_IMAGE.
  pla
  sta P_IMAGE

  lda #%10000010                ; "Load" opcodes affect only N and Z flags.
  sta FLAG_MASK

  tya                           ; Now push data to be printed on stack
  pha
  jmp PRINT_LINE                ; and go to the actual printing routine.

.Exit_PRINT_M:
  rts
!zone

; Print generic result indexed by .A
!zone Print_Res
PRINT_RES:
  lda RES_IMAGE
  pha
!zone

!zone Print_Line
PRINT_LINE:
  stx ._ROW
  ldy #9
  clc
  jsr PLOT

  pla                           ; Print the byte in binary format.
  pha
  jsr PRINT_BINARY

  ldx ._ROW                     ; Print byte in hexadecimal format.
  ldy #20
  clc
  jsr PLOT
  pla
  pha
  jsr PRINT_HEX

  ldx ._ROW                     ; Print byte in unsigned decimal format.
  ldy #25
  clc
  jsr PLOT
  pla
  pha
  jsr PRINT_UNSIGNED

  ldx ._ROW                     ; Print byte in signed decimal format.
  ldy #29
  clc
  jsr PLOT
  pla
  pha
  jsr PRINT_SIGNED

  ldx ._ROW                     ; Print flags.
  ldy #35
  clc
  jsr PLOT
  lda P_IMAGE
  jsr PRINT_FLAGS

.Exit_PRINT_LINE:
  pla                           ; Restore stack and exit.
  rts

._ROW:
  !byte 0
!zone
