import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge


@cocotb.test()
async def test_iir_biquad(dut):

    # Start clock
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # Enable design
    dut.ena.value = 1

    # Reset
    dut.rst_n.value = 0
    dut.ui_in.value = 0

    for _ in range(3):
        await RisingEdge(dut.clk)

    dut.rst_n.value = 1

    # -------------------------------------------------
    # Impulse input
    # -------------------------------------------------
    #
    # Input:
    # 100, 0, 0, 0, 0, ...
    #
    # This allows us to observe the impulse response
    # of the IIR filter.
    # -------------------------------------------------

    test_input = [
        100,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0
    ]

    print("\n-----------------------------")
    print(" IIR BIQUAD IMPULSE RESPONSE")
    print("-----------------------------")
    print("Input\tOutput")

    for sample in test_input:

        dut.ui_in.value = sample

        await RisingEdge(dut.clk)

        output = dut.uo_out.value.signed_integer

        print(f"{sample}\t{output}")

    print("-----------------------------")
