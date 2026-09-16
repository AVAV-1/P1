# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start IIR Biquad Filter Test")

    # ---------------------------------------------------------
    # Set the clock period to 10 us (100 KHz)
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
    # IIR Biquad Impulse Response Test
    #
    # Input:
    #       100, 0, 0, 0, 0, 0, ...
    #
    # The output should continue to respond after
    # the input becomes zero because of feedback.
    # ---------------------------------------------------------

    dut._log.info("Applying impulse input")

    # Apply impulse
    dut.ui_in.value = 100

    await ClockCycles(dut.clk, 1)

    output_0 = dut.uo_out.value.signed_integer

    dut._log.info(
        f"Input = 100, Output = {output_0}"
    )

    # ---------------------------------------------------------
    # Set input to zero
    # ---------------------------------------------------------

    dut.ui_in.value = 0

    await ClockCycles(dut.clk, 1)

    output_1 = dut.uo_out.value.signed_integer

    dut._log.info(
        f"Input = 0, Output = {output_1}"
    )

    await ClockCycles(dut.clk, 1)

    output_2 = dut.uo_out.value.signed_integer

    dut._log.info(
        f"Input = 0, Output = {output_2}"
    )

    await ClockCycles(dut.clk, 1)

    output_3 = dut.uo_out.value.signed_integer

    dut._log.info(
        f"Input = 0, Output = {output_3}"
    )

    await ClockCycles(dut.clk, 1)

    output_4 = dut.uo_out.value.signed_integer

    dut._log.info(
        f"Input = 0, Output = {output_4}"
    )

    # ---------------------------------------------------------
    # Check that the filter has a response
    # ---------------------------------------------------------

    assert output_0 != 0, "Filter produced zero output for impulse"

    # For an IIR filter, previous output affects
    # subsequent output samples.
    assert (
        output_1 != 0 or
        output_2 != 0 or
        output_3 != 0 or
        output_4 != 0
    ), "No feedback response detected"

    dut._log.info("IIR Biquad impulse response test passed")


@cocotb.test()
async def test_step_response(dut):
    dut._log.info("Start IIR Biquad Step Response Test")

    # ---------------------------------------------------------
    # Clock
    # ---------------------------------------------------------

    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # ---------------------------------------------------------
    # Reset
    # ---------------------------------------------------------

    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    await ClockCycles(dut.clk, 10)

    dut.rst_n.value = 1

    # ---------------------------------------------------------
    # Step input
    # ---------------------------------------------------------

    dut._log.info("Applying step input")

    dut.ui_in.value = 50

    # Collect output samples
    outputs = []

    for i in range(20):

        await ClockCycles(dut.clk, 1)

        output = dut.uo_out.value.signed_integer

        outputs.append(output)

        dut._log.info(
            f"Sample {i}: Input = 50, Output = {output}"
        )

    # ---------------------------------------------------------
    # Basic check
    # ---------------------------------------------------------

    assert outputs[0] != 0, "No output generated"

    dut._log.info("Step response test completed")
