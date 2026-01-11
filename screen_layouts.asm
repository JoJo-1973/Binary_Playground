; Page layouts data structure

; Return in .A item from layout
; Layout number is in .A, offset into structure is in .Y.
; At exit ZP_1 points to offset 0 of the selected layout.
!zone Get_Item
GET_ITEM:
  asl a                         ; Turn .A into index.
  tax

  lda PAGE_LAYOUTS,x            ; Point ZP_1 to address of the layout structure.
  sta ZP_1
  lda PAGE_LAYOUTS+1,x
  sta ZP_1+1

  lda (ZP_1),y                  ; Return item from structure.

.Exit_GET_ITEM:
  rts
!zone

; Page layouts table
PAGE_LAYOUTS:
  !word PAGE_LAYOUT_1
  !word PAGE_LAYOUT_2
  !word PAGE_LAYOUT_3
  !word PAGE_LAYOUT_4
  !word PAGE_LAYOUT_5

; Common header for all pages
PAGE_HEADER:
  !text 0,1,ECM_BG1," BINARY PLAYGROUND ",0
  !text 0,29,ECM_BG2,"?",ECM_BG0," FOR HELP",0
  !text 1,1,ECM_BG2,"PAGE #",0
  !text 3,1,ECM_BG1," LOAD ",0
  !text 3,9,ECM_BG2,"7654",0
  !text 3,14,ECM_BG2,"3210",0
  !text 3,20,ECM_BG2,"HEX",0
  !text 3,25,ECM_BG2,"UNS",0
  !text 3,30,ECM_BG2,"SIG",0
  !text 3,35,ECM_BG2,"NVZC",0
  !text $FF,$FF

; Page layouts
PAGE_LAYOUT_1:
  !byte $FF                     ;  0: Is accumulator row active? $FF = No, others = Row #.
  !byte $05                     ;  1: Is memory row active? $FF = No, others = Row #.
  !byte %10000010               ;  2: Flag mask for accumulator / memory contents.
  !byte %10000010               ;  3: Flag mask for result #1.
  !byte %10000010               ;  4: Flag mask for result #2.
  !byte %10000010               ;  5: Flag mask for result #3.
  !byte %11000011               ;  6: Flag mask for result #4.
  !byte $FF                     ;  7: Can Carry flag be modified before operation? $FF = No, others = Row #.
  !word REDRAW_1                ;  8: Address of screen redraw routine.

  !text 1,16,ECM_BG3,5," INCREMENT & DECREMENT ",144,0
  !text 5,6,ECM_BG2,"M:",ECM_BG0,0
  !text 9,1,ECM_BG1," INCREMENT ",0
  !text 11,4,ECM_BG2,"INC:",0
  !text 14,1,ECM_BG1," DECREMENT ",0
  !text 16,4,ECM_BG2,"DEC:",0
  !text $FF,$FF

PAGE_LAYOUT_2:
  !byte $05                     ;  0: Is accumulator row active? $FF = No, others = Row #.
  !byte $06                     ;  1: Is memory row active? $FF = No, others = Row #.
  !byte %10000010               ;  2: Flag mask for accumulator / memory contents.
  !byte %10000011               ;  3: Flag mask for result #1.
  !byte %11000011               ;  4: Flag mask for result #2.
  !byte %11000010               ;  5: Flag mask for result #3.
  !byte %11000011               ;  6: Flag mask for result #4.
  !byte $08                     ;  7: Can Carry flag be modified before operation? $FF = No, others = Row #.
  !word REDRAW_2                ;  8: Address of screen redraw routine.

  !text 1,18,ECM_BG3,5," TESTS & COMPARISONS ",144,0
  !text 5,6,ECM_BG2,"A:",ECM_BG0,0
  !text 6,6,ECM_BG2,"M:",ECM_BG0,0
  !text 8,21,ECM_BG2,"CARRY BEFORE OP:",0
  !text 10,1,ECM_BG1," UNSIGNED COMPARISON ",0
  !text 12,4,ECM_BG2,"CMP:",0
  !text 15,1,ECM_BG1," SIGNED COMPARISON ",0
  !text 17,4,ECM_BG2,"SBC:",0
  !text 20,1,ECM_BG1," BIT TEST ",0
  !text 22,4,ECM_BG2,"BIT:",0
  !text $FF,$FF

PAGE_LAYOUT_3:
  !byte $05                     ;  0: Is accumulator row active? $FF = No, others = Row #.
  !byte $06                     ;  1: Is memory row active? $FF = No, others = Row #.
  !byte %10000010               ;  2: Flag mask for accumulator / memory contents.
  !byte %10000010               ;  3: Flag mask for result #1.
  !byte %10000010               ;  4: Flag mask for result #2.
  !byte %10000010               ;  5: Flag mask for result #3.
  !byte %10000010               ;  6: Flag mask for result #4.
  !byte $FF                     ;  7: Can Carry flag be modified before operation? $FF = No, others = Row #.
  !word REDRAW_3                ;  8: Address of screen redraw routine.

  !text 1,20,ECM_BG3,5," BOOLEAN OPERATORS ",144,0
  !text 5,6,ECM_BG2,"A:",ECM_BG0,0
  !text 6,6,ECM_BG2,"M:",ECM_BG0,0
  !text 10,1,ECM_BG1," BITWISE AND ",0
  !text 12,4,ECM_BG2,"AND:",0
  !text 15,1,ECM_BG1," BITWISE OR ",0
  !text 17,4,ECM_BG2,"ORA:",0
  !text 20,1,ECM_BG1," BITWISE EXCLUSIVE OR ",0
  !text 22,4,ECM_BG2,"EOR:",0
  !text $FF,$FF

PAGE_LAYOUT_4:
  !byte $04                     ;  0: Is accumulator row active? $FF = No, others = Row #.
  !byte $FF                     ;  1: Is memory row active? $FF = No, others = Row #.
  !byte %10000010               ;  2: Flag mask for accumulator / memory contents.
  !byte %10000011               ;  3: Flag mask for result #1.
  !byte %10000011               ;  4: Flag mask for result #2.
  !byte %10000011               ;  5: Flag mask for result #3.
  !byte %10000011               ;  6: Flag mask for result #4.
  !byte $05                     ;  7: Can Carry flag be modified before operation? $FF = No, others = Row #.
  !word REDRAW_4                ;  8: Address of screen redraw routine.

  !text 1,23,ECM_BG3,5," SHIFT & ROTATE ",144,0
  !text 4,6,ECM_BG2,"A:",ECM_BG0,0
  !text 5,1,ECM_BG1," SHIFT LEFT ",0
  !text 5,21,ECM_BG2,"CARRY BEFORE OP:",0
  !text 6,3,ECM_BG2,"ASL1:",0
  !text 7,3,ECM_BG2,"ASL2:",0
  !text 8,3,ECM_BG2,"ASL3:",0
  !text 9,3,ECM_BG2,"ASL4:",0
  !text 10,1,ECM_BG1," SHIFT RIGHT ",0
  !text 11,3,ECM_BG2,"LSR1:",0
  !text 12,3,ECM_BG2,"LSR2:",0
  !text 13,3,ECM_BG2,"LSR3:",0
  !text 14,3,ECM_BG2,"LSR4:",0
  !text 15,1,ECM_BG1," ROTATE LEFT ",0
  !text 16,3,ECM_BG2,"ROL1:",0
  !text 17,3,ECM_BG2,"ROL2:",0
  !text 18,3,ECM_BG2,"ROL3:",0
  !text 19,3,ECM_BG2,"ROL4:",0
  !text 20,1,ECM_BG1," ROTATE RIGHT ",0
  !text 21,3,ECM_BG2,"ROR1:",0
  !text 22,3,ECM_BG2,"ROR2:",0
  !text 23,3,ECM_BG2,"ROR3:",0
  !text 24,3,ECM_BG2,"ROR4:",0
  !text $FF,$FF

PAGE_LAYOUT_5:
  !byte $05                     ;  0: Is accumulator row active? $FF = No, others = Row #.
  !byte $06                     ;  1: Is memory row active? $FF = No, others = Row #.
  !byte %10000010               ;  2: Flag mask for accumulator / memory contents.
  !byte %11000011               ;  3: Flag mask for result #1.
  !byte %11000011               ;  4: Flag mask for result #2.
  !byte %11000011               ;  5: Flag mask for result #3.
  !byte %11000011               ;  6: Flag mask for result #4.
  !byte $08                     ;  7: Can Carry flag be modified before operation? $FF = No, others = Row #.
  !word REDRAW_5                ;  8: Address of page redraw routine.

  !text 1,27,ECM_BG3,5," ARITHMETIC ",144,0
  !text 5,6,ECM_BG2,"A:",ECM_BG0,0
  !text 6,6,ECM_BG2,"M:",ECM_BG0,0
  !text 8,21,ECM_BG2,"CARRY BEFORE OP:",0
  !text 10,1,ECM_BG1," BINARY ARITHMETIC ",0
  !text 12,4,ECM_BG2,"ADC:",0
  !text 13,4,ECM_BG2,"SBC:",0
  !text 16,1,ECM_BG1," BINARY CODED DECIMAL ARITHMETIC ",0
  !text 18,20,ECM_BG2,"BCD",0
  !text 19,4,ECM_BG2,"ADC:",0
  !text 20,4,ECM_BG2,"SBC:",0
  !text $FF,$FF

REDRAW_1:
  jsr TEST_INC
  jsr PRINT_RES

  jsr TEST_DEC
  jsr PRINT_RES

.Exit_REDRAW_1:
  rts

REDRAW_2:
  jsr TEST_CMP
  jsr PRINT_RES

  jsr TEST_SBC
  jsr PRINT_RES

  jsr TEST_BIT
  jsr PRINT_RES

.Exit_REDRAW_2:
  rts

REDRAW_3:
  jsr TEST_AND
  jsr PRINT_RES

  jsr TEST_ORA
  jsr PRINT_RES

  jsr TEST_EOR
  jsr PRINT_RES

.Exit_REDRAW_3:
  rts

REDRAW_4:

.Exit_REDRAW_4:
  rts

REDRAW_5:
  jsr TEST_ADC_HEX
  jsr PRINT_RES

  jsr TEST_SBC_HEX
  jsr PRINT_RES

  jsr TEST_ADC_BCD
  jsr PRINT_RES

  jsr TEST_SBC_BCD
  jsr PRINT_RES

.Exit_REDRAW_5:
  rts
