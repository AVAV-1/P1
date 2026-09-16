# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):

    dut._log.info("Start IIR Biquad Filter Test")

    # ---------------------------------------------------------
    # Clock
    # ---------------------------------------------------------

    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # ---------------------------------------------------------
    # Reset
    # ---------------------------------------------------------

    dut._log.info("Reset")

    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    await ClockCycles(dut.clk, 10)

    dut.rst_n.value = 1

    await ClockCycles(dut.clk, 1)

    # ---------------------------------------------------------
    # IMPULSE INPUT
    # ---------------------------------------------------------

    dut._log.info("Applying impulse input")

    dut.ui_in.value = 100

    await ClockCycles(dut.clk, 1)

    output = dut.uo_out.value.signed_integer

    dut._log.info(
        f"Sample 0: Input = 100, Output = {output}"
    )

    # ---------------------------------------------------------
    # Set input to zero
    # ---------------------------------------------------------

    dut.ui_in.value = 0

    # Collect several output samples
    outputs = []

    for i in range(10):

        await ClockCycles(dut.clk, 1)

        output = dut.uo_out.value.signed_integer

        outputs.append(output)

        dut._log.info(
            f"Sample {i+1}: Input = 0, Output = {output}"
        )

    # ---------------------------------------------------------
    # Check filter response
    # ---------------------------------------------------------

    # The impulse should produce a non-zero response
    assert outputs[0] != 0 or output != 0, \
        "IIR filter produced no response"

    dut._log.info("IIR Biquad test completed successfully")
