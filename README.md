# Self-Contained FPGA VHDL Frequency & Period Meter

Target: Digilent Basys3 / Artix-7 XC7A35T-1CPG236C  
Tool: Xilinx Vivado  
HDL: VHDL

## Main idea

This version does NOT require an external pulse/function generator.

The Basys3 100 MHz clock is used as the reference. A programmable internal pulse generator creates the signal under test. The measurement logic then measures that internally generated pulse train.

The project is parameterized with:

- `CLK_FREQ_HZ` - FPGA reference clock
- `TEST_FREQ_HZ` - internally generated test frequency
- `GATE_TIME_MS` - frequency measurement gate

Example:

    CLK_FREQ_HZ  => 100_000_000
    TEST_FREQ_HZ => 10_000
    GATE_TIME_MS => 1000

Expected result:

    Frequency ≈ 10 kHz
    Period    ≈ 100 us

## Changing the test frequency

Edit only the generic values in `top_frequency_meter.vhd` or override them in Vivado:

    TEST_FREQ_HZ => 1000
    TEST_FREQ_HZ => 5000
    TEST_FREQ_HZ => 10000
    TEST_FREQ_HZ => 50000

The pulse generator automatically calculates its divider.

## Hardware controls

- BTNC: toggle Frequency / Period display
- BTND: reset
- 7-segment display: result

No external pulse generator is needed.

## Measurement architecture

    100 MHz FPGA clock
            |
            +------------------------+
            |                        |
            v                        v
    Internal Pulse Generator    Measurement Reference
            |
            v
    Synchronizer -> Edge Detector
            |
            v
    Frequency Counter / Period Meter
            |
            v
       7-segment display

## Important engineering note

Because the generated test signal and the reference clock originate from the same FPGA oscillator, this is a self-testable measurement system rather than an independent laboratory frequency measurement. This is intentional and makes the project completely self-contained.

For a future extension, an external pulse input can be added through a MUX without changing the measurement core.

## Frequency limitations

The generated frequency must satisfy:

    TEST_FREQ_HZ <= CLK_FREQ_HZ / 2

For exact integer division:

    CLK_FREQ_HZ mod (2 * TEST_FREQ_HZ) = 0

If the division is not exact, the generated frequency is quantized to the nearest integer-divider result.

## Vivado setup

1. Create an RTL project.
2. Select `xc7a35tcpg236-1`.
3. Add every `.vhd` file in `src/` as Design Sources.
4. Add the three files in `tb/` as Simulation Sources.
5. Add `constraints/Basys3_frequency_meter.xdc`.
6. Set `top_frequency_meter` as synthesis top.
7. Run Synthesis -> Implementation -> Generate Bitstream.
8. Program the Basys3.

## Simulation

The testbenches use reduced clock frequencies and shorter gate times so simulation finishes quickly. The hardware top-level defaults are for the real 100 MHz Basys3 clock.

## Display note

The supplied display formatter uses a simple four-digit representation. For the polished final-year version, the next improvement should be automatic unit selection and decimal formatting such as:

    10.00 kHz
    100.0 us
    1.000 kHz

This can be implemented without changing the measurement core.

## Vivado synthesis fix
The arithmetic in `frequency_meter.vhd` and `period_meter.vhd` is implemented with explicit 64-bit shift/add operations. This avoids numeric_std multiplication result-width mismatches reported by Vivado synthesis.


## Timing-closure revision

The original architecture used large combinational division operators:
- frequency count scaled by `GATE_TIME_MS`
- period ticks divided by `CLK_FREQ_HZ`
- display frequency divided by 1000

Those operators can create very long combinational paths on an Artix-7 and cause large negative setup slack.

The optimized architecture removes those paths:
- 1-second gate: frequency result is simply the pulse count.
- Period measurement uses a hardware microsecond tick counter instead of division.
- Hz-to-kHz conversion is performed sequentially by subtraction over multiple clock cycles.
- The display formatter contains only wiring/slicing.

Recommended hardware generics:

    CLK_FREQ_HZ  => 100_000_000
    TEST_FREQ_HZ => 10_000
    GATE_TIME_MS => 1000

This architecture intentionally trades a small amount of latency after each measurement for much better timing closure.
