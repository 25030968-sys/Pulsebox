<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements a 4-player quiz buzzer system using digital logic gates. When any player presses their button (`ui[0]` to `ui[3]`), the circuit latches their corresponding LED (`uo[0]` to `uo[3]`) and immediately locks out the remaining players. Once a player is locked in, the host can evaluate the answer using the True (`ui[4]`) or False (`ui[5]`) buttons, lighting up either the Correct (`uo[4]`) or Incorrect (`uo[5]`) LED until the system is reset via `rst_n`.

## How to test

Explain how to use your project

## External hardware

List external hardware used in your project (e.g. PMOD, LED display, etc), if any
