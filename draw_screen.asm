; Screen drawing routines

; Print screen header
!zone Print_Screen_Header
PRINT_SCREEN_HEADER:
  jsr CLRSCR                    ; Clear the screen.

  lda #<SCREEN_HEADER           ; Point ZP_1 to header message table
  sta ZP_1
  lda #>SCREEN_HEADER
  sta ZP_1+1

.Loop_Print_Header:
  lda #ZP_1                     ; and print it.
  jsr PRINT_MSG
  bcc .Loop_Print_Header

  lda #VIC_BG2                  ; Print screen number.
  sta __BGCOL
  +At 1,7
  lda CURR_SCREEN
  clc
  adc #"1"
  jsr __PUTCHAR

  ;lda #<SCREEN_TITLES           ; Print screen title.
  ;sta ZP_1
  ;lda #>SCREEN_TITLES
  ;sta ZP_1+1
  ;lda #ZP_1
  ;ldy CURR_SCREEN
  ;jsr PRINT_NTH

.Exit_PRINT_SCREEN_HEADER:
  rts
!zone

; Print full screen
!zone Print_Screen
PRINT_SCREEN:
  jsr PRINT_SCREEN_HEADER       ; Print the header.

  lda CURR_SCREEN               ; Turn current screen number into an index
  asl a
  tay

  lda SCREEN_LAYOUTS,y          ; Low byte of layout's message table address:
  clc                           ; it starts at 8th byte of the layout.
  adc #8
  sta ZP_1

  lda SCREEN_LAYOUTS+1,y        ; High byte of layout's message table address.
  adc #0
  sta ZP_1+1

.Loop_Print_Msg_Table:
  lda #ZP_1                     ; Print the rest of the on-screen labels.
  jsr PRINT_MSG
  bcc .Loop_Print_Msg_Table

.Exit_PRINT_SCREEN:
  rts
!zone
