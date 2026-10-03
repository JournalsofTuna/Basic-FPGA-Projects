## Overview
This project implements a 5-to-32 line address decoder targeted for the Digilent Basys 3 FPGA development board (Xilinx Artix-7 XC7A35T). It translates a 5-bit input address (`sw_adr[4:0]`) into an active-high 32-bit one-hot output.

## Hardware Architecture & Bank Switching
* **One-Hot Address Decoding:** The core logic computes `32'b1 << sw_adr`, translating the 5-bit binary address into a 32-bit one-hot vector with single-cycle combinatorial propagation. Vivado maps this structure efficiently across Artix-7 6-input Look-Up Tables (LUT6).
* **I/O Resource Constraint:** The Digilent Basys 3 board features only 16 user LEDs (`LD0`–`LD15`), preventing the simultaneous display of all 32 output lines.
* **Bank Switching Multiplexer:** An auxiliary slide switch (`sw_bank`, mapped to `SW15`) acts as a 2-to-1 multiplexer selector to page the output lines across the 16 available LEDs:
  * `sw_bank = 0` (Lower Bank): Routes `dec_out[15:0]` to `led[15:0]` (covers addresses `0` to `15`).
  * `sw_bank = 1` (Upper Bank): Routes `dec_out[31:16]` to `led[15:0]` (covers addresses `16` to `31`, where address `16` maps to `LD0` and `31` maps to `LD15`).

## Verification & Simulation
* **Self-Checking Testbench:** The behavioral testbench (`tb_decoder_5to32.v`) sweeps through all 32 address combinations (`0` to `31`) across both bank selector states, asserting expected output vectors against `(1 << i)` shifts.
* **Waveform Validation:** Verified glitch-free transitions and one-hot walking bit sequences during behavioral simulation in Vivado Simulator.
* **Hardware In-the-Loop Test:** Synthesized, implemented, and programmed onto hardware via JTAG. Verified physical switch toggles and corresponding LED illuminations.

## Repository Structure
* `rtl/decoder_5to32_basys3.v`: Synthesizable top-level Verilog RTL module.
* `tb/tb_decoder_5to32.v`: Automated self-checking simulation testbench.
* `constr/basys3_pins.xdc`: Physical pin constraints and I/O standard mappings for the Basys 3 board.
* And Here is a view from Simulation:
* <img width="937" height="275" alt="image" src="https://github.com/user-attachments/assets/bfea80ec-69b1-41b0-8833-3fde6bbe69ab" />



