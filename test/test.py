# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start Pulsebox test")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # 1. Reset inicial
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)

    # Verificar que todos los LEDs empiezan en 0
    assert dut.uo_out.value == 0, f"Expected 0 after reset, got {dut.uo_out.value}"

    # 2. Jugador 2 presiona su botón (ui_in = 1 -> 0b00000010)
    dut._log.info("Player 2 presses button")
    dut.ui_in.value = 0b00000010
    await ClockCycles(dut.clk, 2)
    dut.ui_in.value = 0  # Suelta el botón
    await ClockCycles(dut.clk, 2)
    assert dut.uo_out.value == 0b00000010, f"Expected Player 2 LED (0b00000010), got {dut.uo_out.value}"

    # 3. Jugador 1 intenta presionar después (debe quedar bloqueado)
    dut._log.info("Player 1 tries to press (should be locked out)")
    dut.ui_in.value = 0b00000001
    await ClockCycles(dut.clk, 2)
    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 2)
    assert dut.uo_out.value == 0b00000010, f"Player 1 should be locked out, got {dut.uo_out.value}"

    # 4. Presionar botón Correcto (ui_in = 1 -> 0b00010000)
    dut._log.info("Correct button pressed")
    dut.ui_in.value = 0b00010000
    await ClockCycles(dut.clk, 2)
    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 2)
    assert dut.uo_out.value == 0b00010010, f"Expected Player 2 + Correct LED (0b00010010), got {dut.uo_out.value}"

    # 5. Reset para limpiar LEDs
    dut._log.info("Reset for next round")
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)
    assert dut.uo_out.value == 0, f"Expected 0 after reset, got {dut.uo_out.value}"
