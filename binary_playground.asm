!source <system/standard.asm>
!source <c64/symbols.asm>
!source <c64/kernal.asm>
!source <chip/vic_ii.asm>
!source <system/print.asm>
!source <system/vic_ii_tools.asm>

!to "binary playgrnd",cbm

+BASIC_Preamble 10,MAIN,"BINARY PLAYGROUND"

MAIN:
  jsr CLRSCR                    ; Clear screen and set video mode.
  lda #<PALETTE
  ldx #>PALETTE
  jsr VIC_PALETTE
  +Vic_Ext_Color_On

  lda #<MOCK_SCREEN
  sta ZP_1
  lda #>MOCK_SCREEN
  sta ZP_1+1

.Loop_Print_Screen:
  lda #ZP_1
  jsr PRINT_MSG
  bcc .Loop_Print_Screen

  +At 4,10
  lda #%10001000
  sta A_IMAGE
  jsr PRINT_BINARY

  +At 5,10
  lda #%10000000
  sta M_IMAGE
  jsr PRINT_BINARY

  +At 4,22
  lda A_IMAGE
  jsr PRINT_SIGNED

  +At 5,22
  lda M_IMAGE
  jsr PRINT_SIGNED

  +At 4,28
  lda A_IMAGE
  jsr PRINT_UNSIGNED

  +At 5,28
  lda M_IMAGE
  jsr PRINT_UNSIGNED

.Exit_MAIN:
  rts

A_IMAGE:
  !byte 0

M_IMAGE:
  !byte 0

P_IMAGE:
  !byte 0

PALETTE:
  !byte VIC_BLACK, VIC_GREEN, VIC_BLACK, VIC_YELLOW, VIC_LIGHT_GREY, VIC_BLACK

MOCK_SCREEN:
  !text 0,10,ECM_BG3," BINARY  PLAYGROUND ",0
  !text 1,8,ECM_BG0,"PRESS ",ECM_BG2,"?",ECM_BG0," FOR INSTRUCTIONS",0
  !text 3,10,ECM_BG2,"7654",0
  !text 3,15,ECM_BG2,"3210",0
  !text 3,23,ECM_BG2,"SIG",0
  !text 3,28,ECM_BG2,"UNS",0
  !text 3,35,ECM_BG2,"NVZC",0
  !text 4,7,ECM_BG2,"A:",ECM_BG0,0
  !text 5,7,ECM_BG3,"M:",ECM_BG0,0
  !text $FF,$FF

; Install VIC-II macros
  +Vic_Palette

; Install print macros
  +Put_ECM_Char
  rts
__PUTCHAR         = PUT_ECM_CHAR

  +Print_Msg
  +Print_Nth
  +Print_Imm

!source "print_images.asm"
