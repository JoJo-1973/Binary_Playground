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

  jsr PRINT_PAGE
  lda #VIC_BG0
  sta __BGCOL
  jsr PRINT_A
  jsr PRINT_M
  jsr PRINT_CARRY

  jsr REDRAW_4

- jsr GETIN
  beq -

.Exit_MAIN:
  rts

; Global variables
A_IMAGE:
  !byte %10001111

M_IMAGE:
  !byte %10000001

P_IMAGE:
  !byte 0

RES_IMAGE:
  !byte 0

CARRY_IMAGE:
  !byte 0

FLAG_MASK:
  !byte 0

CURR_PAGE:
  !byte 3

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
!source "opcode_tests.asm"
