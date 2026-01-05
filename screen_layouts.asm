; Screen layouts data

; Screen layouts table
SCREEN_LAYOUTS:
  !word SCR_LAYOUT_1
  !word SCR_LAYOUT_2
  !word SCR_LAYOUT_3
  !word SCR_LAYOUT_4
  !word SCR_LAYOUT_5

; Common header for all screens
SCREEN_HEADER:
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

; Screen titles
SCREEN_TITLES:
  !text 1,16,ECM_BG3,5," INCREMENT & DECREMENT ",144,0
  !text 1,18,ECM_BG3,5," TESTS & COMPARISONS ",144,0
  !text 1,20,ECM_BG3,5," BOOLEAN OPERATORS ",144,0
  !text 1,23,ECM_BG3,5," SHIFT & ROTATE ",144,0
  !text 1,27,ECM_BG3,5," ARITHMETIC ",144,0
  !text $FF,$FF

; Screen layouts
SCR_LAYOUT_1:
  !byte $05                     ; Is accumulator row active? $FF = No, others = Row #.
  !byte $FF                     ; Is memory row active? $FF = No, others = Row #.
  !byte %10000010               ; Flag mask for accumulator / memory contents.
  !byte %10000010               ; Flag mask for result #1.
  !byte %10000010               ; Flag mask for result #2.
  !byte %10000010               ; Flag mask for result #3.
  !byte %11000011               ; Flag mask for result #4.
  !byte $00                     ; Can Carry flag be modified before operation? $FF = Yes, $00 = No.

  !text 5,6,ECM_BG2,"A:",ECM_BG0,0
  !text 9,1,ECM_BG1," INCREMENT ",0
  !text 11,4,ECM_BG2,"INC:",0
  !text 14,1,ECM_BG1," DECREMENT ",0
  !text 16,4,ECM_BG2,"DEC:",0
  !text $FF,$FF

SCR_LAYOUT_2:
  !byte $05                     ; Is accumulator row active? $FF = No, others = Row #.
  !byte $06                     ; Is memory row active? $FF = No, others = Row #.
  !byte %10000010               ; Flag mask for accumulator / memory contents.
  !byte %10000011               ; Flag mask for result #1.
  !byte %11000011               ; Flag mask for result #2.
  !byte %11000010               ; Flag mask for result #3.
  !byte %11000011               ; Flag mask for result #4.
  !byte $FF                     ; Can Carry flag be modified before operation? $FF = Yes, $00 = No.


  !text 5,6,ECM_BG2,"A:",ECM_BG0,0
  !text 6,6,ECM_BG2,"M:",ECM_BG0,0
  !text 8,30,ECM_BG2,"CARRY:",0
  !text 10,1,ECM_BG1," UNSIGNED COMPARISON ",0
  !text 12,4,ECM_BG2,"CMP:",0
  !text 15,1,ECM_BG1," SIGNED COMPARISON ",0
  !text 17,4,ECM_BG2,"SBC:",0
  !text 20,1,ECM_BG1," BIT TEST ",0
  !text 22,4,ECM_BG2,"BIT:",0
  !text $FF,$FF

SCR_LAYOUT_3:
  !byte $05                     ; Is accumulator row active? $FF = No, others = Row #.
  !byte $06                     ; Is memory row active? $FF = No, others = Row #.
  !byte %10000010               ; Flag mask for accumulator / memory contents.
  !byte %10000010               ; Flag mask for result #1.
  !byte %10000010               ; Flag mask for result #2.
  !byte %10000010               ; Flag mask for result #3.
  !byte %10000010               ; Flag mask for result #4.
  !byte $00                     ; Can Carry flag be modified before operation? $FF = Yes, $00 = No.

  !text 5,6,ECM_BG2,"A:",ECM_BG0,0
  !text 6,6,ECM_BG2,"M:",ECM_BG0,0
  !text 10,1,ECM_BG1," BIT-WISE AND ",0
  !text 12,4,ECM_BG2,"AND:",0
  !text 15,1,ECM_BG1," BIT-WISE OR ",0
  !text 17,4,ECM_BG2,"ORA:",0
  !text 20,1,ECM_BG1," BIT-WISE EXCLUSIVE OR ",0
  !text 22,4,ECM_BG2,"EOR:",0
  !text $FF,$FF

SCR_LAYOUT_4:
  !byte $04                     ; Is accumulator row active? $FF = No, others = Row #.
  !byte $FF                     ; Is memory row active? $FF = No, others = Row #.
  !byte %10000010               ; Flag mask for accumulator / memory contents.
  !byte %10000011               ; Flag mask for result #1.
  !byte %10000011               ; Flag mask for result #2.
  !byte %10000011               ; Flag mask for result #3.
  !byte %10000011               ; Flag mask for result #4.
  !byte $FF                     ; Can Carry flag be modified before operation? $FF = Yes, $00 = No.

  !text 4,6,ECM_BG2,"A:",ECM_BG0,0
  !text 5,1,ECM_BG1," SHIFT LEFT ",0
  !text 5,30,ECM_BG2,"CARRY:",0
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

SCR_LAYOUT_5:
  !byte $05                     ; Is accumulator row active? $FF = No, others = Row #.
  !byte $06                     ; Is memory row active? $FF = No, others = Row #.
  !byte %10000010               ; Flag mask for accumulator / memory contents.
  !byte %11000011               ; Flag mask for result #1.
  !byte %11000011               ; Flag mask for result #2.
  !byte %11000011               ; Flag mask for result #3.
  !byte %11000011               ; Flag mask for result #4.
  !byte $FF                     ; Can Carry flag be modified before operation? $FF = Yes, $00 = No.


  !text 5,6,ECM_BG2,"A:",ECM_BG0,0
  !text 6,6,ECM_BG2,"M:",ECM_BG0,0
  !text 8,30,ECM_BG2,"CARRY:",0
  !text 10,1,ECM_BG1," BINARY ARITHMETIC ",0
  !text 12,4,ECM_BG2,"ADC:",0
  !text 14,4,ECM_BG2,"SBC:",0
  !text 17,1,ECM_BG1," BINARY CODED DECIMAL ARITHMETIC ",0
  !text 19,4,ECM_BG2,"ADC:",0
  !text 21,4,ECM_BG2,"SBC:",0
  !text $FF,$FF
