# 02 - Variable Duty Cycle PWM Generator

This project implements a parameterizable Pulse Width Modulation (PWM) generator on the Digilent Basys 3 FPGA development board (Xilinx Artix-7 XC7A35T). The design features 8-bit duty cycle resolution, asynchronous reset handling, multi-stage debouncing with clock-domain synchronization, and edge-detected dynamic duty control via physical push buttons.

---

## 1. Architectural Overview

Driving physical loads (such as LEDs or power switching circuits) directly from raw high-frequency FPGA clock divisions (e.g., 10 MHz) causes signal integrity degradation due to parasitic pin capacitance, PCB track trace inductance, and diode slew constraints. 

To overcome this, the architecture utilizes a dual-counter structure:
1. **Prescaler Counter:** Divides the 100 MHz primary clock down to run the base PWM period at **~1.001 kHz**, an optimal switching frequency for human persistence of vision and transient-free LED driving.
2. **Duty-Cycle Comparator:** An 8-bit digital comparator evaluating the active cycle counter against the current target register (`duty_reg`).

## Simulation Analysis from Testbench
<img width="1162" height="667" alt="62755f1d-6b6b-4a0d-add7-273ad4b120bd" src="https://github.com/user-attachments/assets/7d2795e6-8a46-4290-8bf9-44cd6f724116" />



### Mathematical Model

$$\text{Prescaler Ratio} = 390$$
$$\text{Counter Resolution} = 2^8 = 256 \text{ levels}$$
$$f_{\text{PWM}} = \frac{f_{\text{clk}}}{\text{Prescaler} \times 256} = \frac{100\text{ MHz}}{390 \times 256} \approx 1001.6\text{ Hz}$$
$$\text{Step Size} = \frac{16}{256} \times 100\% = 6.25\%$$

---

## 2. Block Diagram

```text
                                  +------------------------------------------------------+
                                  |                 pwm_controller_top                   |
                                  |                                                      |
   btn_up (T18)   --------------->| [button_debounce_edge] ---> inc_pulse                |
                                  |                                   \                  |
   btn_down (U17) --------------->| [button_debounce_edge] ---> dec_pulse\               |
                                  |                                        v             |
   rst (U18)      --------------->|                                   [duty_reg]         |
                                  |                                    (8-bit)           |
                                  |                                       |              |
                                  |   +-------------------------------+   |              |
                                  |   | Prescaler Counter (0..389)    |   |              |
                                  |   +---------------+---------------+   v              |
   clk 100MHz (W5) --------------->|                   v                 [CMP] ---------> pwm_out (LD0)
                                  |   | 8-Bit PWM Counter (0..255)    |                  |
                                  |   +-------------------------------+                  |
                                  |                                                      |
                                  |   duty_reg [7:0] -----------------------------------> duty_leds (LD7..LD0)
                                  +------------------------------------------------------+

