# 03 - 2-Bit Magnitude Comparator

---

## Overview

This project implements a 2-bit unsigned magnitude comparator targeted for the Digilent Basys 3 FPGA development board (Xilinx Artix-7 XC7A35T). It evaluates two 2-bit binary inputs (`A[1:0]` and `B[1:0]`) and drives three mutually exclusive active-high outputs indicating relational conditions: `A < B`, `A = B`, and `A > B`.

---

## Hardware Architecture & Logic Implementation

- **Relational Boolean Logic:** The core comparison is realized through minimized sum-of-products (SOP) and equivalence formulations derived from Karnaugh maps (K-Maps):
  - **Equality (`A = B`):** Evaluated using bitwise `XNOR` gates followed by an `AND` stage (`~A[1]^B[1] & ~A[0]^B[0]`).
  - **Less Than (`A < B`):** Evaluated as `(~A[1] & B[1]) | (~A[1] & ~A[0] & B[0]) | (~A[0] & B[1] & B[0])`.
  - **Greater Than (`A > B`):** Evaluated as `(A[1] & ~B[1]) | (A[1] & A[0] & ~B[0]) | (A[0] & ~B[1] & ~B[0])`.
- **LUT Mapping & Timing:** Vivado maps the pure combinational logic into Artix-7 6-input Look-Up Tables (LUT6) with minimal propagation delay, fitting the complete multi-output logic into a single CLB slice.
- **I/O Peripheral Mapping:** 
  - Inputs `A[1:0]` are mapped to slide switches `SW1` and `SW0`.
  - Inputs `B[1:0]` are mapped to slide switches `SW3` and `SW2`.
  - Relational flags drive dedicated onboard LEDs: `A_less_B` (`LD0`), `A_equal_B` (`LD1`), and `A_greater_B` (`LD2`).

---

## Verification & Simulation

- **Exhaustive Testbench:** The behavioral testbench (`tb_comparator_2bit.v`) sweeps through all 16 possible input permutations ($2^2 \times 2^2$ input space), asserting correct output states across the full numeric range.
- **Waveform Validation:** Verified glitch-free transitions and mutually exclusive flag activations across all edge states ($A = B$, $A < B$, $A > B$) in Vivado Simulator.
- **Hardware In-the-Loop Test:** Synthesized, implemented, and programmed onto the Basys 3 board via JTAG. Verified physical switch combinations against expected real-time LED responses.

---

## Repository Structure

- `rtl/comparator_2bit.v`: Synthesizable gate-level/combinational Verilog RTL module.
- `tb/tb_comparator_2bit.v`: Exhaustive functional simulation testbench.
- `constrs/basys3_pins.xdc`: Physical pin constraints and LVCMOS33 I/O standard mappings for the Basys 3 board.
