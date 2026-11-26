
# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0


import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test_project(dut):

    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    dut.ena.value = 1
    dut.rst_n.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    await Timer(1, unit="us")

    # Escribir 50 en el registro 0
    dut.ui_in.value = 50
    dut.uio_in.value = 0b00001000

    await RisingEdge(dut.clk)
    await Timer(1, unit="us")

    # Leer el registro 0
    dut.uio_in.value = 0b00000000

    await Timer(1, unit="us")

    resultado = int(dut.uo_out.value)

    dut._log.info(f"Resultado: {resultado}")

    assert resultado == 50, (
        f"Error: esperado 50, obtenido {resultado}"
    )

    dut._log.info("TEST PASSED")
