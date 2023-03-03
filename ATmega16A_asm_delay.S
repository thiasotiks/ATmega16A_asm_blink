/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ATmega16A_asm_delay ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   This code is under MIT License
   Copyright (c) 2023 Sayantan Sinha
*/

#define __SFR_OFFSET 0

#include "avr/io.h"

.global init_io
.global loopinf

init_io:
  sbi DDRB,0          ; Set PB0 (pin# 1) as output
  cli                 ; Disable global interrupts
  ret

loopinf:
  ldi R18,0b00000001  ; Bit pattern to toggle PB0 by XOR operation
  blink_led:
    in R19,PORTB      ; R19 = PORTB
    eor R19,R18       ; R19 = R19 XOR R18
    out PORTB,R19     ; PORTB = R19
    rcall delay100ms  ; Delay 100 ms
    rjmp blink_led    ; Goto blink_led loop
  ret

delay100ms:
  ldi R17,200          ; R17 = 200 (200 * 500 us = 100 ms)
  dly_loop2:           ; Each loop will take approx 500 us (165 * 3 + 2 = 497 T_clk)
    ldi R16,166        ; R16 = 166
    dly_loop1:         ; Each loop will take approx 3 us (3 T_clk if (R16 - 1) > 0 or 2 T_clk if (R16 - 1) = 0)
      dec R16          ; R16 = R16 - 1
      brne dly_loop1   ; If (R16 - 1) > 0 then goto dly_loop1
    dec R17            ; R17 = R17 - 1
    brne dly_loop2     ; If (R17 - 1) > 0 then goto dly_loop2
  ret
