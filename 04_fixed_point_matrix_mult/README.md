# 04 - 4x4 Fixed-Point Matrix Multiplier

OverviewThis project implements a fully synthesizable 4x4 matrix multiplication hardware accelerator core targeted for FPGA architectures (Digilent Basys 3 / Xilinx Artix-7 XC7A35T). 
It computes matrix multiplication over signed fixed-point representations using inferable synchronous Block RAMs (BRAM) and a fully parallelized arithmetic reduction tree.

 ## Hardware Architecture & Logic Implementation
 Numerical Representation (Q8.8 Format): The arithmetic engine employs a 16-bit signed two's complement fixed-point format with an 8-bit fractional part:
 
Bit Slicing: Bit [15] acts as the sign bit, bits [14:8] represent the 7-bit integer range (-128 to +127), and bits [7:0] form the fractional precision.

Multiplication & Normalization: The product of two Q8.8 inputs produces a 32-bit Q16.16 intermediate wire. The normalized Q8.8 output is extracted from bit indices [23:8].Overflow Detection: Monitored via (temp[31:23] != 9'b0) && (temp[31:23] != 9'b1) to ensure sign-extension integrity.

### Parallel Compute Fabric & Reduction Tree:
Multiplier Grid: 64 concurrent q8_8_mult cores instantiated via two-dimensional Verilog generate loops.
Adder Tree: Two-stage tree topology (q8_8_add) summing 4 products per cell ($((p_0 + p_1) + (p_2 + p_3))$) to minimize combinational path delay and maintain timing closure.

### Inferable Synchronous Storage: Implements vendor-neutral memory instances (generic_ram.v) with single-cycle read latency that naturally infer FPGA Block RAM primitives (RAMB18E1/RAMB36E1) without Xilinx IP Core Generator dependencies

### Finite State Machine (FSM): A 4-state synchronous controller coordinates the pipeline:

IDLE: Clears registers and holds active-high reset conditions.

LOAD: Sequentially loads input matrix entries into internal register banks.

CALC: Single-cycle barrier ensuring data stabilization across the combinational array.

WRITE: Incrementally bursts calculated values into the output BRAM (ram_Out) and asserts done.


## Verification & Simulation
=============================================
   4x4 MATRIX MULTIPLICATION RESULT (C = A x B)
=======================================================

  [0x0200]   [0x0200]   [0x0200]   [0x0200]
  [0x0200]   [0x0200]   [0x0200]   [0x0200]
  [0x0200]   [0x0200]   [0x0200]   [0x0200]
  [0x0200]   [0x0200]   [0x0200]   [0x0200]
  
============================================
============================================

And Here a view from Simulation:

<img width="847" height="476" alt="image" src="https://github.com/user-attachments/assets/ed707621-190c-4b90-9017-e427bb1d4964" />
