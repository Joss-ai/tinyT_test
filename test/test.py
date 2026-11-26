
# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):

    dut._log.info("Start Register File test")

    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Inicializacion
    dut.ena.value = 1
    dut.rst_n.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    await ClockCycles(dut.clk, 2)

    # Escribir y leer los 8 registros
    for i in range(8):

        # Escritura
        dut.ui_in.value = 50 + i
        dut.uio_in.value = 0b00001000 | i

        await ClockCycles(dut.clk, 1)

        # Lectura
        dut.uio_in.value = i << 4

        await ClockCycles(dut.clk, 1)

        # Verificacion
        resultado = int(dut.uo_out.value)
        esperado = 50 + i

        dut._log.info(
            f"Registro {i}: esperado={esperado}, obtenido={resultado}"
        )

        assert resultado == esperado, (
            f"Error en registro {i}: "
            f"esperado {esperado}, obtenido {resultado}"
        )

    dut._log.info("Register File test PASSED")
