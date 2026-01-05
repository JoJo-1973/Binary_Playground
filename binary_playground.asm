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
  +VIC_Ext_Color_On

  jsr PRINT_SCREEN

- jsr GETIN
  beq -

.Exit_MAIN:
  rts

; Save contents of .P in P_IMAGE
SAVE_FLAGS:
  php
  pla
  sta P_IMAGE

.Exit_SAVE_FLAGS:
  rts

; Global variables
A_IMAGE:
  !byte 0

M_IMAGE:
  !byte 0

CARRY_IMAGE:
  !byte 0

P_IMAGE:
  !byte 0

P_IMAGE_2:
  !byte 0

FLAG_MASK:
  !byte 0

CURR_SCREEN:
  !byte 4

PALETTE:
  !byte VIC_BLACK, VIC_GREEN, VIC_LIGHT_GREY, VIC_YELLOW, VIC_BLACK, VIC_BLACK

; Install VIC-II macros
  +Vic_Palette
  +Compute_Cell
  +Get_Screen_Cell

; Install print macros
  +Put_ECM_Char
  rts
__PUTCHAR         = PUT_ECM_CHAR

  +Print_Msg
  +Print_Nth
  +Print_Imm

!source "print_images.asm"
!source "draw_screen.asm"
!source "screen_layouts.asm"