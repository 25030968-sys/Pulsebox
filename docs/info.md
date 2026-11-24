<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements a 4-player quiz buzzer system using digital logic gates. When any player presses their button (`ui[0]` to `ui[3]`), the circuit latches their corresponding LED (`uo[0]` to `uo[3]`) and immediately locks out the remaining players. Once a player is locked in, the host can evaluate the answer using the True (`ui[4]`) or False (`ui[5]`) buttons, lighting up either the Correct (`uo[4]`) or Incorrect (`uo[5]`) LED until the system is reset via `rst_n`.

## How to test

1. Apply a clock signal (`clk`) and pulse `rst_n` low to ensure all output LEDs start off.
2. Press any player button (`ui[0]` to `ui[3]`) and confirm that only the corresponding player LED (`uo[0]` to `uo[3]`) latches on.
3. Press any other player button while latched to verify that the priority lockout prevents other LEDs from turning on.
4. Press the True button (`ui[4]`) or False button (`ui[5]`) to verify that the Correct (`uo[4]`) or Incorrect (`uo[5]`) LED turns on.
5. Pulse `rst_n` low to reset all LEDs for the next round.

## External hardware

6 pushbuttons (4 for players and 2 for True/False host evaluation) and 6 LEDs with current-limiting resistors.
