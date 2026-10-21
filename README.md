# Smart I2C/SPI Peripheral Subsystem & RISC-V SoC Verification

## Overview
This repository contains the top-level integration and co-verification environment for a 32-bit RISC-V (PicoRV32) System-on-Chip (SoC)[cite: 7]. The SoC is integrated with MMIO-mapped Smart I2C/SPI masters, TinyML delta-variance predictors, and autonomous clock gaters[cite: 7].

## Hardware/Software Co-Verification
Functional validation was performed using a combination of RTL simulation and software-driven tests:
* Developed bare-metal C and assembly co-verification suites[cite: 7].
* Validated register read/write access and interrupt assertions[cite: 7].
* Verified glitch-free clock gating transitions across different power states[cite: 7].

## Post-Layout Signoff
The design was taken through a full implementation flow targeting an Artix-7 FPGA[cite: 7]:
* Validated post-layout gate-level netlists in Cadence SimVision to ensure functional equivalency with the RTL[cite: 7].
* Achieved timing signoff at 66.67 MHz with 0 timing violations[cite: 7].

## Tech Stack
* **Languages:** Verilog HDL, C (Bare-metal), RISC-V Assembly[cite: 7]
* **Core:** 32-bit RISC-V (PicoRV32)[cite: 7]
* **Tools/Flow:** Cadence Flow (SimVision), AMD Xilinx Artix-7 FPGA[cite: 7]
